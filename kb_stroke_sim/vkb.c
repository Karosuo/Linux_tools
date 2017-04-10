/**
 *  Independent module that receives a string as parameter and send it to the OS as virtual keyboard
 * 	The characters as expected as basic ASCII, no accents or other unicode characters tested, but sendInput in windows support thouse tho
 * 	
 * 	It supports Windows systems from 2000, in 32 bit systems (which also run in x64), as well as linux x64 versions only
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
 * 		WINVER number representations - https://msdn.microsoft.com/en-us/library/6sehtctf.aspx
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
		printf("\nHello World Linux + char: %c\n", key);
		return 0;
	}
#elif _WIN32
	/// Brief Minimum wrapper function to simulate vkb on windows systems
	int kb_print_char(char key)
	{
		unsigned int in_status = 0; ///< Holds the return status from SendInput, 0 is input was already blocked by another thread, non zero is the amount of succesfull inserted events
		//~ printf("\nHello World Windows + char: %c\n", key);
		INPUT in_struct; ///< Declare an INPUT structure, to know which type will be, mouse, kb or other hdw
		in_struct.type = INPUT_KEYBOARD; ///< INPUT_KEYBOARD is an enum (num 1) and should be combined with "ki" struct
		in_struct.ki.time = 0; ///< 0 means let the OS put it's own time stamp
		in_struct.ki.wVk = key; // virtual-key code, use the sent char param
		in_struct.ki.dwFlags = 0; // 0 for key press
		in_status = SendInput(1, &in_struct, sizeof(INPUT)); ///< Indicates only 1 input
		if(in_status == 0)
			return 0; ///< don't try to lift the key since resource is blocked
		in_struct.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
		SendInput(1, &in_struct, sizeof(INPUT));
		return in_status; ///< return the number of succesfull insertions
	}
	
	/// Brief Wrapper of the kb_print_char function, to be able to print strings in a faster way
	int kb_print_str(char * str)
	{
		Sleep(7000);
		while(*str)
		{
			char key = *str;
			printf("%c", key);
			kb_print_char(key);
			str++;			
			// printf("%x", *str++);
		}
	}
#endif


int main(int argc, char * argv[])
{
	if(argc == 2)///< Should be ONLY one parameter
	{
		//~ printf("The param: %s", argv[1]);
		kb_print_str(argv[1]);		
		// kb_print_char('Q');
	}
	else
	{
		printf("\n\n>> Error: Need one string parameter\n\nUsage: %s \"the_string_to_print\"\n\n", argv[0]);
		return -1; ///Return generic error code
	}
		
	return 0; ///Return OK code
}
