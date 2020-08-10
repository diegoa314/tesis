#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
    
int main(int argc, char* argv[]) {
    uint8_t start = 0x7f;
    uint32_t a = start;
    uint32_t o;
    int i,j;

 
    for (i = 0;i<1; i++) {
          
        for (j=1;j<1000;j++){
            //printf(" i %d\n", j);
            //printf("%x\n",a );
            int newbit = (((a >> 6) ^ (a >> 5)) & 1);
            a = ((a << 1) | newbit); //& 0x7fffffff; //0x7f=0111 1111
                      
            if((j-7)%32==0){
                printf("%x\n",a );
            }
            
        }    
        if (a == start) {
            printf("repetition period is %d\n", i);
            break;
        }
    }
}