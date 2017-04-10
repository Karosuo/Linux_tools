#ifdef __linux__ /**Could be __linux, linux or __linux__*/
#elif _WIN32
	//~ As in the Ted Burke example, set WINVER shold be setted to win 2000
	#define WINVER 0x0500
	//~ #define WINVER 0x0601 //For win 7
	#include <windows.h>	
#else
#error "Not targeted OS!"
#endif

/// Brief wrapper function to print a string using kb_print_char
int kb_print_str(char * str);
/// Brief single call to sendInput or xxx, in windows or linux systems respectively
/// Details Only simulates a hit and release of a character key, doesn't support the long press or combinations
int kb_print_char(char key);
