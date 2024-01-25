#include <stdio.h>
#include <stdlib.h>

int main()
{
  	int* ptr = (int*)malloc(500);

    if (ptr == NULL) {
        printf("Memory not allocated.\n");
		return 1;
    }
	printf("Success\n");
	free(ptr);
	return 0;
}
