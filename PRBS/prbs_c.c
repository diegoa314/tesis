#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
    
int main(int argc, char* argv[]) {
    uint32_t start = 0xffffffff;
    uint32_t a = start;
    int i;
    int j;    
    for(j=1; j<=1; j++){    
        for (i = 1; i<=32; i++) {
            uint32_t newbit = (((a >> 6) ^ (a >> 5)) & 1);
            a = ((a << 1) | newbit) & 0x7fffffff;
            //a = ((a << 1) | newbit) ;
            if(a==0x06147916) {
                printf("estoy%s\n", a);
                break;
            }
            
            if (a == start) {
                printf("repetition period is %d\n", i);
                break;
            }
        
        }
        printf("%x\n", a);
    }
}
