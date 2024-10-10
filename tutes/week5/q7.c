#include <stdio.h>
#include <stdint.h>
typedef unsigned int Word;  //uint32_t (on CSE machines)

Word reverseBits(Word w);

int main(void) {
    Word w = 0x01234567;
    printf("%x\n", reverseBits(w));
    return 0;
}

Word reverseBits(Word w) {
    //loop through each bit
    Word mask_read = 1u;
    Word mask_write = 1u << 31;
    Word return_value = 0;
    for (int i = 0; i < 32; i++) {
        //read the back bit
        Word result = w & mask_read;
        // w = 1100
        // m = 0100
        // ---------
        //     0100
        //write to the front bit
        if (result != 0) {
            return_value |= mask_write;
        }
        //shuffle to the next bit
        mask_read = mask_read << 1;
        mask_write = mask_write >> 1;
    }

    return return_value;
}