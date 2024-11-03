#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main() {
    //    0 01111111 10000000000000000000000

    // equivilent to 1.5

    double value = 1.5;
    printf("%d\n", (value | 1.0));
    

    return 0;
}