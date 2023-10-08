#include <stdio.h>
#include <stdint.h>
#define data 19

// count_trailing_zeros function
uint16_t ctz(uint32_t x) 
{
    if (x == 0) return 32;
    int n = 1;
    if ((x << 16) == 0) {
        n += 16;
        x >>= 16;
    }
    if ((x << 24) == 0) {
        n += 8;
        x >>= 8;
    }
    if ((x << 28) == 0) {
        n += 4;
        x >>= 4;
    }
    if ((x << 30) == 0) {
        n += 2;
        x >>= 2;
    }
    n = n - (x & 1);
    return n;
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
  printf("The steps of Collatz conjecture is %u", result);
  return result;
}

int main (){
  uint32_t x = data;
  x = collatz(x);
  return 0;
}
