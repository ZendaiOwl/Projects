#!/usr/bin/env -S tcc -run
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <string.h>

/* Author § Victor-ray, S. owl@zendai.net.eu.org */

int read_file() {
  
  FILE *file_pointer;
  char buff[255];
  char ch;
  
  file_pointer = fopen("./input.txt", "r");
  
  if (NULL == file_pointer) {
      printf("file can't be opened \n");
  }
  
  // Printing what is written in file
  // character by character using loop.
  do {
      ch = fgetc(file_pointer);
      printf("%c", ch);
 
      // Checking if character is not EOF.
      // If it is EOF stop reading.
  } while (ch != EOF);
 
  // Closing the file
  fclose(file_pointer);
    
  return EXIT_SUCCESS;
}

int main() {
  read_file();
  return EXIT_SUCCESS;
}
