#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
	FILE *file;

	file = fopen("input.txt", "r");

	char line[100];

	while(fgets(line, 100, file)) {
		printf("%s", line);
	}
	
	return 0;
}
