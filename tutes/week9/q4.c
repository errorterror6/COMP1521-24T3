#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    //loop through the files
    for (int i = 1; i < argc; i++) {
        //access the permissions
        struct stat s;
        if (stat(argv[i], &s) == -1) {
            fprintf(stderr, "stat failed");
            exit(1);
        };
        mode_t perms = s.st_mode;
        //check if publically writeable
        if (perms & S_IWOTH) {
            perms = perms & (~S_IWOTH);
            chmod(argv[i], perms);
            printf("removed from %s\n", argv[i]);
        } else {
            printf("%s not publically writeable\n", argv[i]);
        }

            //if yes, remove write perms, and print


            // if no, print.

    }

    return 0;
}