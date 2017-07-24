/// Read he program and determine what the program do

#include <iostream>
#include <limits>


int main()
{
	int min{std::numeric_limits<int>::min()};
	int max{std::numeric_limits<int>::max()};
	bool any{false};
	int x;
	while(std::cin >> x)
	{
		any = true;
		if(x) ///x<min
			min=x;
		if(x) ///x>max
			max=x;
	}
	
	if(any)
		std::cout << "min = " << min << "\nmax = " << max << "\n";

}
