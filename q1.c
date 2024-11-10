#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int main() {
    //get HOME environment variable
    char *home_env = getenv("HOME");
    if (home_env == NULL) {
        fprintf(stderr, "HOME DID NOT WORK!!");
        exit(1);
    }

    // printf("%s\n", home_env);

    // add the /.diary to the back of the home env variable
    //figure out the size
    size_t home_env_len = strlen(home_env);
    home_env_len += 8;
    char *diary = "/.diary";
    char new_path[home_env_len];
    //use snprintf
    snprintf(new_path, home_env_len, "%s%s", home_env, diary);
    printf("%s\n", new_path);
    //fopen the file
    FILE *stream = fopen(new_path, "r");
    if (stream == NULL) {
        perror(new_path);
        exit(1);
    }
    //read the file
    char c;
    while((c = fgetc(stream)) != EOF) {
        fputc(c, stdout);
    }

    //print it to stdout

    fclose(stream);

    return 0;
}