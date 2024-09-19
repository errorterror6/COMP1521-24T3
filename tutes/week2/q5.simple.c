// Squares a number, unless its square is too big for a 32-bit integer.
// If it is too big, prints an error message instead.

#include <stdio.h>

#define SQUARE_MAX 46340

int main(void) {
    int x, y;

    printf("Enter a number: ");
    scanf("%d", &x);

main__if:
    if (x <= SQUARE_MAX) goto main__else;
    printf("square too big for 32 bits\n");
    goto main__end;
main__else:
    y = x * x;
    printf("%d\n", y);


main__end:
    return 0;
}