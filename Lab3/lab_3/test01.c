/*
  Test 1, uninitialized variables.
*/
#include <stdio.h>

void main()
{
/*    int k; 
    float f;  

    printf("%d %f\n", k, f);
    
    return 0;
*/
int a=5;
int c=1;
	if(c>a)
{
c=c+c;
}
	else
{
a=c-a;

}
c=0;
}
