/// Read the program and determine what the program do


#include <iostream>

int main()
{
	int sum{0};
	int count{};
	int x;
	while(std::cin >> x)
	{
		sum = sum + x;
		count = count + 1;
	}
	
	std::cout << "average = " << sum / count << '\n';
}
