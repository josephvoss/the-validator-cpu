#include <stdio,h>
#include <stdlib.h>
#include <string.h>

//Usage: assembler <file>
//assembler <file> <output>

int main(int argc, char* argv[])
{
	bool validInput = true;
	if (argc > 3 || argc == 0)
	{
		printHelp();
		validInput = false;
	}

	if (argc == 1) argv[1] = "./a.out";

	FILE *inputFile;
	FILE *outputFile;

	try
	{
		inputFile = fopen(argv[0], 'r');
		outputFile = fopen(argv[1], 'w');
	}
	catch(...)
	{
		printf("Input files are not valid");
		validInput = false;
	}

	size_t lengthOfLine;
	char* line = NULL;

	int lineCounter = 1;
	char* assemblyLine, commandWord, value1Word, value2Word;
	//Correct syntax
	// add value1 value2;
	// int var = 0;?
	while(validInput && getline(&line, &lengthfOfline, inputFile) != -1)
	{
		try
		{
			//parsing
			commandWord = strtok(line, ' ');
			value1Word = strtok(line, ' ');
			if (commandWord == "
			value2Word = strtok(line, ';');
			
		}
		catch(...)
		{
			printf("Malformed statement at line %d", lineCounter):
		}
		lineCounter += 1;
	}	
}
