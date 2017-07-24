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
	if(count == 0)
		count++;
	std::cout << "average = " << sum / count << '\n';
}
