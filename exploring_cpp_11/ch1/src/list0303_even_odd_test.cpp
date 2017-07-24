/// Read integers and print a message that tells the user
/// whether the number is evenor odd.

#include <iostream>

int main()
{
	int x;
	while(std::cin >> x)
	{
		if(x % 2 == 0) ///fill in the condition
			std::cout << x << " is odd.\n";
		else
			std::cout << x << " is even.\n";
	}
}
