#include <stdio.h>

int main(void) {

    int x = 24;
main__loop_cond:
    if (x >= 42) goto main__loop_end;
main__loop_body:
    printf("%d\n", x);
    x += 3;
    goto main__loop_cond;
main__loop_end:
    return 0;
}