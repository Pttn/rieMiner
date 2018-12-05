/* (c) 2018 Michael Bell/Rockhawk */

#include <stdint.h>
#include <cpuid.h>
#include "CpuID.hpp"

CpuID::CpuID() {
	uint32_t eax(0), ebx(0), ecx(0), edx(0);
	__get_cpuid(0, &eax, &ebx, &ecx, &edx);
	_intel = (ebx == 0x756e6547 && ecx == 0x6c65746e && edx == 0x49656e69);
	if (eax < 7) {
		_avx = false;
		_avx2 = false;
		_avx512 = false;
	}
	else {
		__get_cpuid(1, &eax, &ebx, &ecx, &edx);
		_avx = (ecx & (1 << 28)) != 0;

		// Must do this with inline assembly as __get_cpuid is unreliable for level 7
		// and __get_cpuid_count is not always available.
		//__get_cpuid_count(7, 0, &eax, &ebx, &ecx, &edx);
		uint32_t level(7), zero(0);
		asm ("cpuid\n\t"
		    : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
		    : "0"(level), "2"(zero));
		_avx2 = (ebx & (1 << 5)) != 0;
		_avx512 = (ebx & (1 << 16)) != 0;
	}
}

