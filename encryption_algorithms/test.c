#include <stdio.h>

int main(){
	unsigned char r,l;
	unsigned int elem = 0xDDFF;
	r = elem;
	l = elem>>8;
	printf("\nPrinting r: %x, l: %x\n", r,l);
	return 0;
}
