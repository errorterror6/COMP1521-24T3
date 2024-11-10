// Write a C program, print_diary.c, which prints the contents of the file $HOME/.diary to stdout
// The lecture example getstatus.c shows how to get the value of an environment variable.
// snprintf is a convenient function for constructing the pathname of the diary file. 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

    //figure out the pathname
    //evaluate $HOME
    char *home = getenv("HOME");
    if (home == NULL) {
        fprintf(stderr, "home didnt work");
        exit(1);
    }
    //append /.diary to the back of that.
    char *diary = "/.diary";
    int size = strlen(home) + strlen(diary) + 1;
    char buffer[size];
    snprintf(buffer, size, "%s%s", home, diary);
    // printf("%s", buffer);

    //fopen the file
    FILE *stream = fopen(buffer, "r");
    if (stream == NULL) {
        perror(buffer);
        exit(1);
    }


    //read the contents
    int c;
    while ((c = fgetc(stream)) != EOF) {
        fputc(c, stdout);
    }

    //output to stdout




    return 0;
}