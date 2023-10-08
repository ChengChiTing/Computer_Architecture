#include <stdio.h>
#include <stdint.h>
#define data 19 // number N
    
// count_trailing_zeros function 
uint16_t ctz(uint32_t x) 
{
    x |= (x << 1);
    x |= (x << 2);
    x |= (x << 4);
    x |= (x << 8);
    x |= (x << 16);

// count ones (population count)
    x -= ((x >> 1) & 0x5555555555555555);
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x7f));
}

// count how many steps for finishing Collatz conjecture 
uint16_t collatz(uint32_t x){
    if(x == 0){
        printf("The number is zero \n");
        return 0;
    }
    uint16_t result = 0;
    uint16_t y = 0;
    while(x != 1){
        if((x & 0x01) == 1){
            x += ((x << 1) + 1);
            result ++;
        }
        else{
            y = ctz(x);
            x = x >> y;
            result += y; 
        }
    }
    printf("The number of steps for Collatz conjecture is %u", result);
    return result;
}

int main (){
    uint32_t x = data;
    x = collatz(x);
    return 0;
}