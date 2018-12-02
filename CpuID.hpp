
class CpuID {
	bool _avx, _avx2, _avx512;

public:
	CpuID();

	bool hasAVX() const { return _avx; }
	bool hasAVX2() const { return _avx2; }
	bool hasAVX512() const { return _avx512; }
};
	
