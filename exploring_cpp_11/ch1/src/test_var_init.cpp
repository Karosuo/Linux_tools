/// Test when and which value a variable could take as defaul value

#include <iostream>

int main()
{
	int init_var{10};
	int var_init_var{init_var};
	int empty_var;
	
	std::cout << "init_var: " << init_var << " var_init_var: " << var_init_var << " empty_var: " << empty_var;
}
