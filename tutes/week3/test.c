#include <stdio.h>

int main() {

    int string[4] = {1, 2, 3, 4};
    int *s = &string[0];
    int   length = 0;
    while (*s != 4) {
    length++;  // increment length
    s += 1;       // move to next char
    }
    printf("%d\n", length);

    return 0;
}