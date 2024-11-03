// read from a file alphabets.txt and separate the alphabets into a struct,
//  with fields first_13, last_13.

// use fread for first_13 and fgetc for last_13.

#include <stdio.h>
#include <stdlib.h>

struct alpha_struct{
    char first_13[14];
    char last_13[14];
};

int main() {

    //read from a file
    //open the file
    FILE *stream = fopen("alphabets.txt", "r");
    //check that the file opened successfully
    if (stream == NULL) {
        perror("alphabets.txt");
        exit(1);
    }

    struct alpha_struct alphabets;
    //fread for first_13
    if (fread(alphabets.first_13, 1, 13, stream) != 13) {
        fprintf(stderr, "not enough characters in file\n");
        fclose(stream);
        exit(1);
    };
    //write to struct


    //fgetc for last_13
    for (int i = 0; i < 13; i++) {
        char c;
        if ((c = fgetc(stream)) != EOF) {
            alphabets.last_13[i] = c;
        } else {
            fprintf(stderr, "Unexpected EOF\n");
            fclose(stream);
            exit(1);
        }
    }
    //write to struct

    alphabets.first_13[13] = '\0';
    alphabets.last_13[13] = '\0';
    //print to verify results

    printf("%s\n", alphabets.first_13);
    printf("%s\n", alphabets.last_13);
    fclose(stream);
    return 0;
}