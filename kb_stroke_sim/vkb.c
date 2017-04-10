/**
 *  Independent module that receives a string as parameter and send it to the OS as virtual keyboard
 * 	The characters as expected as basic ASCII, no accents or other unicode characters tested, but sendInput in windows support thouse tho
 * 	
 * 	It supports Windows systems from 2000, in 32 and 64 formats, as well as linux 64 systems
 * 
 * 	The parameters can be passed as command line ones, in the project is used by a python script with the following format
 * 	from subprocess import call
	call(["./vkb.exe", "the_rfid_code_to_print"]) //the exe extention is irrelevant in linux
 * 
 * 	Part of a project in UABC that needed a virtual kb interface, FCQI, Computer Engineering 2017-1
 * 	date: apr - 9 - 17
 * 
 * 	Some useful reference:
 * 		KEYBDINPUT structure - https://msdn.microsoft.com/en-us/library/windows/desktop/ms646271(v=vs.85).aspx
 * 		INPUT structure - https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
 *		SendInput function - https://msdn.microsoft.com/es-es/library/windows/desktop/ms646310(v=vs.85).aspx
 * 		ascii table - http://www.asciitable.com/
 * 		doxygen comment style - https://www.stack.nl/~dimitri/doxygen/manual/docblocks.html
 * 	
 * 	By Rafael Karosuo rafaelkarosuo@gmail.com
 * */
#include "vkb.h"
#include <stdio.h>


/***
 * The idea is to make a transparent kb_print_char function to develop cross-platform code and only update if needed in the function declaration
 * for the specific OS
 * 
 * Both return int as a status
 * */
#ifdef __linux__
	/// Brief wrapper function to simulate vkb on linux systems
	int kb_print_char(char key)
	{
		printf("Hello World Linux + char: %c", key);
		return 0;
	}
#elif _WIN32
	/// Brief wrapper function to simulate vkb on windows systems
	int kb_print_char(char key)
	{
		printf("Hello World Windows + char: %c", key);
		return 0;
	}
#endif


int main(int argc, char * argv[])
{
	if(argc > 1)
	{
		printf("\nTested...\n");
	}
	else
	{
		printf("\n\n>> Error: Need one string parameter\n\nUsage: %s \"the_string_to_print\"\n\n", argv[0]);
		return -1; ///Return generic error code
	}
	kb_print_char('A');
	return 0; ///Return OK code
}
