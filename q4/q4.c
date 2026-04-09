#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
int main()
{
    while(1)
    {
        char op[6];
        int op1, op2;
        scanf("%s", op);
        scanf("%d%d",&op1, &op2);
        char sharedlib[15] = "lib";
        strcat(sharedlib, op);
        strcat(sharedlib, ".so");
        void* library = dlopen(sharedlib, RTLD_LAZY);
        if(library==NULL)
        {
            dlclose(library);
            continue;
        }
        int(*function)(int, int);
        function = (int (*)(int, int))dlsym(library, op);
        if(function==NULL)
        {
            dlclose(library);
            continue;
            
        }
        int answer = function(op1, op2);
        printf("%d\n",answer);

        dlclose(library);
    }
    return 0;
}