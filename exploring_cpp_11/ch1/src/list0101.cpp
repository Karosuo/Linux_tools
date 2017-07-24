/// Sort the standard input alphabetically.
/// Read lines of text, sort them, and print the results to the standard output.
/// If the command line names a file, read from that file. Otherwise, read from
/// the standard input. The entire input is stored in memory, so don’t try
/// this with input files that exceed available RAM.


#include <algorithm>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

void read (std::istream& in, std::vector<std::string>& text)
{
	std::string line;
	while(std::getline(in,line))
		text.push_back(line);
}

int main(int argc, char* argv[])
{
	///Part1. Read the entire input into text. If the command line names a file,
	///read that file. Otherwise, read the standard input.
	std::vector<std::string> text; ///< store the lines of text here
	if (argc < 2) ///< if no file name named
		read(std::cin, text);
	else
	{
		std::ifstream in(argv[1]);
		if(not in)
		{
			std::perror(argv[1]);
			return EXIT_FAILURE;
		}
		read(in, text);
	}
	
	///Part2. Sort the text
	std::sort(text.begin(), text.end());
	
	///Part3. Print the sorted text
	std::copy(text.begin(), text.end(), std::ostream_iterator<std::string>(std::cout, "\n"));
}
