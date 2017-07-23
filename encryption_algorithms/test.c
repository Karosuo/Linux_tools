#include <stdio.h>

typedef struct {
		unsigned int my_int;
		unsigned char my_char;
}template;

typedef struct {
		unsigned int my_int:1;
		unsigned char my_char:1;
}bit_fields;


int main(){
	unsigned char r,l;
	unsigned int elem = 0xDDFF;
	r = elem;
	l = elem>>8;
	printf("\nPrinting r: %x, l: %x\n", r,l);
	bit_fields.my_char = 2;
	printf("\nSize of template: %d, Size of reduced: %d\n", sizeof(template), sizeof(bit_fields));
	return 0;
}
