/* Contains parts of cpuminer-rminerd from gatra (https://github.com/gatra/cpuminer-rminerd), a fork of pooler's cpuminer. License for these parts is GPL2.
(c) 2011-2013 pooler (pooler@litecoinpool.org)
(c) 2013 gatra (gatra@riecoin.org)
(c) 2017 Pttn (https://github.com/Pttn/rieMiner) */

#include "global.h"
#include <cstring>

std::string bin2hex(const void* p, uint32_t len) {
	std::ostringstream oss;
	for (uint32_t i(0) ; i < len ; i++)
		oss << std::setfill('0') << std::setw(2) << std::hex << (uint32_t) ((uint8_t*) p)[i];
	return oss.str();
}

bool hex2bin(unsigned char *p, const char *hexstr, size_t len) {
	char hex_byte[3];
	char *ep;
	
	hex_byte[2] = '\0';
	
	while (*hexstr && len) {
		if (!hexstr[1]) {
			return false;
		}
		hex_byte[0] = hexstr[0];
		hex_byte[1] = hexstr[1];
		std::ostringstream oss;
		
		*p = (unsigned char) strtol(hex_byte, &ep, 16);
		if (*ep) {
			return false;
		}
		p++;
		hexstr += 2;
		len--;
	}

	return len == 0 && *hexstr == 0;
}

#define unlikely(expr) (__builtin_expect(!!(expr), 0))
#define likely(expr) (__builtin_expect(!!(expr), 1))

static bool jobj_binary(const json_t *obj, const char *key, void *buf, size_t buflen) {
	const char *hexstr;
	json_t *tmp;
	
	tmp = json_object_get(obj, key);
	if (tmp == NULL) {
		std::cerr << "JSON key '" << key << "' not found" << std::endl;
		return false;
	}
	hexstr = json_string_value(tmp);
	if (hexstr == NULL) {
		std::cerr << "JSON key '" << key << "' is not a string" << std::endl;
		return false;
	}
	if (!hex2bin((unsigned char*) buf, hexstr, buflen))
		return false;
	
	return true;
}

struct data_buffer {
	void		*buf;
	size_t		len;
	
	data_buffer() {
		buf = NULL;
		len = 0;
	}
};

struct upload_buffer {
	const void	*buf;
	size_t		len;
	size_t		pos;
};

static void databuf_free(struct data_buffer *db) {
	if (db) {
		free(db->buf);
		memset(db, 0, sizeof(*db));
	}
}

static size_t all_data_cb(const void *ptr, size_t size, size_t nmemb, void *user_data) {
	struct data_buffer *db = (struct data_buffer*) user_data;
	size_t len = size * nmemb;
	size_t oldlen, newlen;
	void *newmem;
	static const unsigned char zero = 0;

	oldlen = db->len;
	newlen = oldlen + len;

	newmem = realloc(db->buf, newlen + 1);
	if (!newmem) return 0;

	db->buf = newmem;
	db->len = newlen;
	memcpy((uint8_t*) db->buf + oldlen, ptr, len);
	memcpy((uint8_t*) db->buf + newlen, &zero, 1);	/* null terminate */

	return len;
}

static size_t upload_data_cb(void *ptr, size_t size, size_t nmemb, void *user_data) {
	struct upload_buffer *ub = (struct upload_buffer*) user_data;
	uint32_t len = size * nmemb;

	if (len > ub->len - ub->pos)
		len = ub->len - ub->pos;

	if (len) {
		memcpy(ptr, (uint8_t*) ub->buf + ub->pos, len);
		ub->pos += len;
	}

	return len;
}

#if LIBCURL_VERSION_NUM >= 0x071200
static int seek_data_cb(void *user_data, curl_off_t offset, int origin) {
	struct upload_buffer *ub = (struct upload_buffer*) user_data;
	
	switch (origin) {
	case SEEK_SET:
		ub->pos = offset;
		break;
	case SEEK_CUR:
		ub->pos += offset;
		break;
	case SEEK_END:
		ub->pos = ub->len + offset;
		break;
	default:
		return 1; /* CURL_SEEKFUNC_FAIL */
	}

	return 0; /* CURL_SEEKFUNC_OK */
}
#endif

#define JSON_LOADS(str, err_ptr) json_loads((str), 0, (err_ptr))

json_t *json_rpc_call(CURL *curl, const std::string& url, const std::string& userpass, const std::string& rpc_req, int *curl_err) {
	json_t *val = NULL, *err_val = NULL, *res_val = NULL;
	int rc;
	struct data_buffer all_data;
	struct upload_buffer upload_data;
	json_error_t err;
	struct curl_slist *headers = NULL;
	char len_hdr[64];
	char curl_err_str[CURL_ERROR_SIZE];
	long timeout = 15;
	
	// it is assumed that 'curl' is freshly [re]initialized at this pt
	curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
	curl_easy_setopt(curl, CURLOPT_USERPWD, userpass.c_str());
	curl_easy_setopt(curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
	curl_easy_setopt(curl, CURLOPT_ENCODING, "");
	curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1);
	curl_easy_setopt(curl, CURLOPT_NOSIGNAL, 1);
	curl_easy_setopt(curl, CURLOPT_TCP_NODELAY, 1);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, all_data_cb);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, &all_data);
	curl_easy_setopt(curl, CURLOPT_READFUNCTION, upload_data_cb);
	curl_easy_setopt(curl, CURLOPT_READDATA, &upload_data);
	curl_easy_setopt(curl, CURLOPT_SEEKFUNCTION, &seek_data_cb);
	curl_easy_setopt(curl, CURLOPT_SEEKDATA, &upload_data);
	curl_easy_setopt(curl, CURLOPT_ERRORBUFFER, curl_err_str);
	curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
	curl_easy_setopt(curl, CURLOPT_TIMEOUT, timeout);
	curl_easy_setopt(curl, CURLOPT_POST, 1);
	
	upload_data.buf = rpc_req.c_str();
	upload_data.len = rpc_req.size();
	upload_data.pos = 0;
	sprintf(len_hdr, "Content-Length: %lu", (unsigned long) upload_data.len);
	headers = curl_slist_append(headers, "Content-Type: application/json");
	headers = curl_slist_append(headers, len_hdr);
	headers = curl_slist_append(headers, "Accept:"); //disable Accept hdr
	headers = curl_slist_append(headers, "Expect:"); //disable Expect hdr
	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

	rc = curl_easy_perform(curl);
	
	if (curl_err != NULL)
		*curl_err = rc;
	if (rc) {
		if (!(rc == CURLE_OPERATION_TIMEDOUT))
			std::cerr << "HTTP request failed: " << curl_err_str << std::endl;
		goto err_out;
	}

	if (!all_data.buf) {
		std::cerr << "Empty data received in json_rpc_call." << std::endl;
		goto err_out;
	}

	val = JSON_LOADS((char*) all_data.buf, &err);
	if (!val) {
		std::cerr << "JSON decode failed(" << err.line << ") : " << err.text << std::endl;
		goto err_out;
	}

	// JSON-RPC valid response returns a non-null 'result', and a null 'error'.
	res_val = json_object_get(val, "result");
	err_val = json_object_get(val, "error");

	if (!res_val || json_is_null(res_val) ||
	    (err_val && !json_is_null(err_val))) {
		char *s;

		if (err_val)
			s = json_dumps(err_val, JSON_INDENT(3));
		else
			s = strdup("(unknown reason)");

		std::cerr << "JSON-RPC call failed: " << s << std::endl;
		free(s);
		goto err_out;
	}
	
	databuf_free(&all_data);
	curl_slist_free_all(headers);
	curl_easy_reset(curl);
	return val;
err_out:
	databuf_free(&all_data);
	curl_slist_free_all(headers);
	curl_easy_reset(curl);
	return NULL;
}

Client::Client() {
	user = "";
	pass = "";
	host = "127.0.0.1";
	port = 28332;
	_connected = false;
	pendingSubmissions = std::vector<std::pair<GetWorkData, uint8_t>>();
	curl = curl_easy_init();
	pthread_mutex_init(&submitMutex, NULL);
}

// Returns false on error or if already connected
bool Client::connect(const std::string& user0, const std::string& pass0, const std::string& host0, uint16_t port0) {
	if (_connected) return false;
	user = user0;
	pass = pass0;
	host = host0;
	port = port0;
	if (!getWork()) return false;
	gwd = GetWorkData();
	_connected = true;
	return true;
}

bool Client::getWork() {
	std::string s = "{\"method\": \"getwork\", \"params\": [], \"id\": 0}\n";
	json_t *val = json_rpc_call(curl, getHostPort(), getUserPass(), s, NULL);
	if (!val) return false;
	
	json_t *tmp = json_object_get(val, "result");
	if (unlikely(!jobj_binary(tmp, "data", (uint32_t*) &gwd, GWDSIZE/8))) {
		std::cerr << "JSON inval data" << std::endl;
		return false;
	}
	
	for (uint32_t i = 0; i < GWDSIZE/32 ; i++)
		((uint32_t*) &gwd)[i] = le32dec((uint32_t*) &gwd + i);
	
	/*json_t *diff = json_object_get(val, "diff");
	if (diff == NULL) {
		std::cerr << "Could not get difficulty" << std::endl;
		stats.difficulty = 1;
	}
	else stats.difficulty = json_integer_value(diff);*/
	
	if (tmp != NULL) json_decref(tmp);
	if (val != NULL) json_decref(val);
	workInfo.gwd = gwd;
	return true;
}


void Client::sendWork(const std::pair<GetWorkData, uint8_t>& share) const {
	GetWorkData gwdToSend;
	memcpy((uint8_t*) &gwdToSend, ((uint8_t*) &share.first), GWDSIZE/8);
	
	// Revert back endianness
	gwdToSend.version = swab32(gwdToSend.version);
	for (uint8_t i = 0; i < 8; i++) {
		gwdToSend.prevBlockHash[i] = be32dec(&gwdToSend.prevBlockHash[i]);
		gwdToSend.merkleRoot[i] = be32dec(&gwdToSend.merkleRoot[i]);
		gwdToSend.nOffset[i] = be32dec(&gwdToSend.nOffset[i]);
	}
	gwdToSend.nBits = swab32(gwdToSend.nBits);
	gwdToSend.nTime = swab32(gwdToSend.nTime);
	
	json_t *val, *res, *reason;
	
	std::ostringstream oss;
	std::string str;
	oss << "{\"method\": \"getwork\", \"params\": [\"" << bin2hex(&gwdToSend, GWDSIZE/8) << "\"], \"id\": 1}\n";
	str = oss.str();
	val = json_rpc_call(curl, getHostPort(), getUserPass(), str, NULL);
	
	uint8_t k = share.second;
	if (k >= 4) {
		stats.printTime();
		std::cout << " 4-tuple found";
		if (k == 4) std::cout << std::endl;
	}
	if (k >= 5) {
		std::cout << "... Actually it was a 5-tuple";
		if (k == 5) std::cout << std::endl;
	}
	if (k >= 6) {
		std::cout << "... No, no... A 6-tuple = BLOCK!!!!!!" << std::endl;
		std::cout << "Sent: " << str;
		if (val == NULL)
			std::cerr << "Failure submiting block :|" << std::endl;
		else {
			res = json_object_get(val, "result");
			reason = json_object_get(val, "reject-reason");
			if (!json_is_true(res)) {
				std::cout << "Submission rejected :| ! ";
				if (reason == NULL) std::cout << "No reason given" << std::endl;
				else std::cout << "Reason: " << reason << std::endl;
			}
			else std::cout << "Submission accepted :D !" << std::endl;
		}
	}
	
	if (val != NULL) json_decref(val);
}

uint32_t getCompact(uint32_t nCompact) {
	uint32_t p;
	unsigned int nSize = nCompact >> 24;
	//bool fNegative     =(nCompact & 0x00800000) != 0;
	unsigned int nWord = nCompact & 0x007fffff;
	if (nSize <= 3) {
		nWord >>= 8*(3 - nSize);
		p = nWord;
	}
	else {
		p = nWord;
		p <<= 8*(nSize - 3); // warning: this has problems if difficulty (uncompacted) ever goes past the 2^32 boundary
	}
	return p;
}

bool Client::process() {
	// are there shares to submit?
	pthread_mutex_lock(&submitMutex);
	if (pendingSubmissions.size() > 0) {
		for (uint32 i(0) ; i < pendingSubmissions.size() ; i++) {
			std::pair<GetWorkData, uint8_t> share(pendingSubmissions[i]);
			sendWork(share);
		}
		pendingSubmissions.clear();
	}
	pthread_mutex_unlock(&submitMutex);
	
	uint32_t prevBlockHashOld[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	memcpy(prevBlockHashOld, gwd.prevBlockHash, 32);
	if (getWork()) {
		if (memcmp(gwd.prevBlockHash, prevBlockHashOld, 32) != 0) {
			if (workInfo.height != 0) {
				std::cout << "New block found by the network (" << workInfo.height << " since start), average "
				          << timeSince(stats.lastDifficultyChange)/(workInfo.height + 1 - stats.blockHeightAtDifficultyChange) << " s" << std::endl;
			}
			workInfo.height++;
		}
		
		// Change endianness for mining (will revert back when submit share)
		workInfo.gwd.version = swab32(workInfo.gwd.version);
		for (uint8_t i = 0; i < 8; i++) {
			workInfo.gwd.prevBlockHash[i] = be32dec(&workInfo.gwd.prevBlockHash[i]);
			workInfo.gwd.merkleRoot[i] = be32dec(&workInfo.gwd.merkleRoot[i]);
		}
		workInfo.gwd.nBits = swab32(workInfo.gwd.nBits);
		workInfo.gwd.nTime = swab32(workInfo.gwd.nTime);
		workInfo.targetCompact = getCompact(workInfo.gwd.nBits);
		
		return true;
	}
	else { // If GetWork failed then we can assume that the client is disconnected
		_connected = false;
		return false;
	}
}
