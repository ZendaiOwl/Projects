#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>

int main(int argc, char *argv[]) {
    int i, z;
    for (i = 1; i < argc; i++) {
        // Printing all the arguments and their characters ASCII value
        printf("%s ", argv[i]);
        for (z = 0; argv[i][z] != '\0'; z++) {
            printf("%d ", argv[i][z]);
        }
        printf("\n");
    }
    // char chr;
    // printf("Enter a character: ");
    // scanf("%c", &chr);     
    // 
    // // When %c is used, a character is displayed
    // printf("You entered %c.\n",chr);  
    // 
    // // When %d is used, ASCII value is displayed
    // printf("ASCII value is %d.\n", chr);
    return EXIT_SUCCESS;
}
