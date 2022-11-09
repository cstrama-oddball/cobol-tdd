#include <stdlib.h>
#include<stdio.h>

int xctl(char *binary, int binarylen)
{
    int i;
    char word[binarylen + 1];
    for (i = 0; i < binarylen; i++)
        word[i] = binary[i];
    word[i] = '\0';
    (void)system(word);
    
    return(0);
}

int main()
{
    return xctl("ls", 2);
}