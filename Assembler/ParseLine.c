#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void getParsedLine(char* line, FILE *input)
{
	char letter;
	if (input == NULL)
	{
		printf("Invalid file input");
	}
	
	int i = 0;
	while (letter != ';')
	{
		fscanf(input, '%c', letter); //output should be in char*, why?
		*(line + i) = letter; //issue with mem alloc
		i += 1;
	}
	
}
