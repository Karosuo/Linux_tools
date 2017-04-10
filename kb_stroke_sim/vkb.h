#ifdef __linux__ /**Could be __linux, linux or __linux__*/
#elif _WIN32
	#include <windows.h>
#else
#error "Not targeted OS!"
#endif
