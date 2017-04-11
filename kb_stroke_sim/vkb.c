/**
 *  Independent module that receives a string as parameter and send it to the OS as virtual keyboard
 * 	The characters as expected as basic ASCII, no accents or other unicode characters tested, but sendInput in windows support thouse tho
 * 	
 * 	It supports Windows systems from 2000, in 32 bit systems (which also run in x64), as well as ubuntu x64 versions only using xdotool
 * 
 * 	The parameters can be passed as command line ones, in the project is used by a python script with the following format
 * 	from subprocess import call
	call(["./vkb.exe", "the_rfid_code_to_print"]) //the exe extention is irrelevant in linux
 * 
 * 	Part of a project in UABC that needed a virtual kb interface, FCQI, Computer Engineering 2017-1
 * 	date: apr - 9 - 17
 * 
 * 	For the linux part, install libxdo "sudo apt-get install libxdo-dev libxdo3", since xdotool is a bash tool not a C library
 * 	needed to add deb http://ubuntu.cs.utah.edu/ubuntu trusty main universe to /etc/apt/sources.list, or other repo from
 * 	http://packages.ubuntu.com/precise/amd64/libxdo2/download
 * 
 * 	In Ubuntu 14.04 or later, libxdo3 is the version available
 * 
 * 	Some useful reference:
 * 		KEYBDINPUT structure - https://msdn.microsoft.com/en-us/library/windows/desktop/ms646271(v=vs.85).aspx
 * 		INPUT structure - https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
 *		SendInput function - https://msdn.microsoft.com/es-es/library/windows/desktop/ms646310(v=vs.85).aspx
 * 		ascii table - http://www.asciitable.com/
 * 		doxygen comment style - https://www.stack.nl/~dimitri/doxygen/manual/docblocks.html
 * 		WINVER number representations - https://msdn.microsoft.com/en-us/library/6sehtctf.aspx
 * 		char to virtual key translator funct (VkKeyScanEx) - https://msdn.microsoft.com/en-us/library/windows/desktop/ms646332(v=vs.85).aspx
 * 
 * 		#ALERT! this page has outdated function names, available on libxdo2, to see current names check xdo.h on your system
 * 		xdotool online ref - http://www.semicomplete.com/files/xdotool/docs/html/xdo_8h.html
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
	/// Brief Wrapper function of the kb_print_str, sending a 1 length string
	/**
	 * It prints only one character, xdo has a string prefab function and not an only one char available and as we need to keep the transparent 
	 * interface we need to build a one char length string and print it simulating an only one char function
	 * @param c_key is the character to print using keyboard simulation
	 * */
	
	char key_wrapper[1]; ///< xdo_type needs a pointer, this is to be able to keep the transparent interface of kb_print_char	
	
	int kb_print_char(char key)
	{	
		//~ xdo_t * xdo_instance = xdo_new(":0.0"); ///< Create new xdo instance and null param indicates that uses env var DISPLAY, also could be used ":0.0"
		
		*key_wrapper = key;
		printf("key: %s", key_wrapper);
		return kb_print_str(key_wrapper);		
	}
	
	/// Brief Wrapper function to send a string of chars to the current window, simulating a keyboard in ubuntu like systems
	/**
	 * @param *str is the not constant char pointer to the string that will be printed using the kb simulation
	 * */
	int kb_print_str(char * str)
	{
		xdo_t * xdo_instance = xdo_new(NULL); ///< Create new xdo instance and null param indicates that uses env var DISPLAY, also could be used ":0.0"
		xdo_enter_text_window(xdo_instance, CURRENTWINDOW, str, 0); ///< Send a string to the current window, check xdotool ref
		return 1;///< As windows sendinput return 0 means error, we need to return the number of correct succesful insertions
	}

#elif _WIN32
	/// Brief wrapper function to simulate one char key hit on windows systems
	/**
	 * Uses the SendInput function from windows.h
	 * @param c_key is the character to print using keyboard simulation
	 * */
	int kb_print_char(char c_key)
	{
		/*** 0x0409 is the US english layout, KLF_ACTIVATE is load the layout if not loaded */
		short int v_key = VkKeyScanEx(c_key, LoadKeyboardLayout("0x0409", KLF_ACTIVATE)); ///< Translate char to virtual key code (lower byte is key code, higher byte is the shift state)
		int in_status = 0; ///< Holds the SendInput return, 0 is device already blocked by another threat, different means that amount of times the correct inputs
		INPUT in_struct; ///< Declare an INPUT structure, to know which type will be, mouse, kb or other hdw
		in_struct.type = INPUT_KEYBOARD; ///< INPUT_KEYBOARD is an enum (num 1) and should be combined with "ki" struct
		in_struct.ki.time = 0; ///< 0 means let the OS put it's own time stamp
		in_struct.ki.wVk = v_key; ///< virtual-key code, use the sent char param
		in_struct.ki.dwFlags = 0; ///< 0 for key press
		in_status = SendInput(1, &in_struct, sizeof(INPUT)); ///< Indicates only 1 input
		if(in_status == 0)
			return 0; ///< don't try to lift the key since resource is blocked
		in_struct.ki.dwFlags = KEYEVENTF_KEYUP; ///< KEYEVENTF_KEYUP for key release
		SendInput(1, &in_struct, sizeof(INPUT));
		return in_status; ///< return the number of succesful insertions
	}
	
	/// Brief Wrapper of the kb_print_char function, to be able to print strings in a single way
	/**
	 * @param *str is the not constant char pointer to the string that will be printed using the kb simulation
	 * */
	int kb_print_str(char * str)
	{
		while(*str)///< Iterates over the array, as it's null terminated
		{
			kb_print_char(*str++); ///< Point to the current address, get's it's content and after that, adds the address
		}
	}
#endif


int main(int argc, char * argv[])
{
	if(argc == 2)///< Should be ONLY one parameter
	{
		kb_print_str(argv[1]);						
	}
	else
	{
		printf("\n\n>> Error: Need one string parameter\n\nUsage: %s \"the_string_to_print\"\n\n", argv[0]);
		return -1; ///Return generic error code
	}
		
	return 0; ///Return OK code
}
