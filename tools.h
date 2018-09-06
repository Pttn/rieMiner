// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_TOOLS_H
#define HEADER_TOOLS_H

#include "global.h"
#include <openssl/sha.h>

std::string binToHexStr(const void* p, uint32_t len);
void hexStrToBin(std::string str, uint8_t* data);
uint32_t getCompact(uint32_t nCompact);
// Convert address to ScriptPubKey used for building the Coinbase Transaction
bool addrToScriptPubKey(std::string, uint8_t*);
// Calculate Merkle Root from a list of transactions
std::array<uint32_t, 8> calculateMerkleRoot(std::vector<std::array<uint32_t, 8>>);

inline void sha256(const uint8_t *data, uint8_t hash[32], uint32_t len) {
    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, data, len);
    SHA256_Final(hash, &sha256);
}

#define bswap_32(x) ((((x) << 24) & 0xff000000u) | (((x) << 8) & 0x00ff0000u) | (((x) >> 8) & 0x0000ff00u) | (((x) >> 24) & 0x000000ffu))

inline uint32_t swab32(uint32_t v) {
	return bswap_32(v);
}

#if !HAVE_DECL_BE32DEC
inline uint32_t be32dec(const void *pp) {
	const uint8_t *p = (uint8_t const *)pp;
	return ((uint32_t)(p[3]) + ((uint32_t)(p[2]) << 8) +
	    ((uint32_t)(p[1]) << 16) + ((uint32_t)(p[0]) << 24));
}
#endif

#if !HAVE_DECL_LE32DEC
inline uint32_t le32dec(const void *pp) {
	const uint8_t *p = (uint8_t const *)pp;
	return ((uint32_t)(p[0]) + ((uint32_t)(p[1]) << 8) +
	    ((uint32_t)(p[2]) << 16) + ((uint32_t)(p[3]) << 24));
}
#endif

#if !HAVE_DECL_LE32ENC
inline void le32enc(void *pp, uint32_t x) {
	uint8_t *p = (uint8_t *)pp;
	p[0] = x & 0xff;
	p[1] = (x >> 8) & 0xff;
	p[2] = (x >> 16) & 0xff;
	p[3] = (x >> 24) & 0xff;
}
#endif

#endif
