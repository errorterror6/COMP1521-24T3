#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    //open the file
    FILE *stream = fopen(argv[1], "a");
    if (stream == NULL) {
        perror(argv[1]);
        exit(1);
    }

    //read in one line
    //stop reading upon EOF or '\n'
    int c;
    while ((c = fgetc(stdin)) != EOF) {
        if (c == '\n') {
            break;
        }
        fputc(c, stream);
    }
    fclose(stream);


    //print to stdout




    return 0;
}