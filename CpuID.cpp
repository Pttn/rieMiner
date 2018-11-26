/* (c) 2018 Michael Bell/Rockhawk */

#include <stdint.h>
#include <cpuid.h>
#include "CpuID.hpp"

CpuID::CpuID() {
	if (__get_cpuid_max(0, 0) < 7) {
		_avx = false;
		_avx2 = false;
		_avx512 = false;
	}
	else {
		uint32_t eax(0), ebx(0), ecx(0), edx(0);
		__get_cpuid(1, &eax, &ebx, &ecx, &edx);
		_avx = (ecx & (1 << 28)) != 0;

		__get_cpuid(7, &eax, &ebx, &ecx, &edx);
		_avx2 = (ebx & (1 << 5)) != 0;
		_avx512 = (ebx & (1 << 16)) != 0;
	}
}

