/*my implementation of an itoa() function:

    - converts an integer value to a null-terminated string using the specified base 
    - then stores the result in the array given by str parameter.
    - the string is placed in the buffer passed whihc must be large 
*/


#include <stdio.h>
#include <string.h>

void reverse(char s[]) {
    for (int i = 0, j = strlen(s) - 1; i < j; ++i, --j) {
        char temp = s[i];
        s[i] = s[j];
        s[j] = temp;
    }
}

int itoa(int value, char* dst, int base) {
    char buffer[16];    
    char* p = buffer;

    int negative = (value < 0 && base == 10);
    unsigned int absValue = (negative ? -value : value);

    while (absValue > 0) {
        int remainder = absValue % base;
        absValue /= base;
        *p++ = (remainder < 10) ? (remainder + '0') : (remainder - 10 + 'a');
    }

    if (negative) {
        *p++ = '-';
    }

    int len = p - buffer;

    *p-- = '\0';

    while (p >= buffer) {
        *dst++ = *p--;
    }

    *dst = '\0';

    return len;
}