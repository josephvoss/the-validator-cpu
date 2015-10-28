#include <iostream>
#include <string>

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

	ifstream inputFile;
	ofstream outputFile;

	try
	{
		inputFile.open(argv[0]);
		outputFile.open(argv[1]);
	}
	catch(...)
	{
		printf("Input files are not valid");
		validInput = false;
	}

	size_t lengthOfLine;
	std::string line;

	int lineCounter = 1;
	std::string assemblyLine, commandWord, value1Word, value2Word;
	//Correct syntax
	// add value1 value2;
	// int var = 0;?
	while(validInput && line << inputFile)
	{
		try
		{
			//parsing
			//if(line.find(';') == NULL) throw;
			//line.erase(0, line.find(';'));
			commandWord = line.substr(0, line.find(' '));
			line.erase(0, line.find(' '));
			value1 = line.substr(0, line.find(' ')); //what if ends with;? can use ' ;' and endl synatx?
			line.erase(0, line.find(' '));
			try
			{
				value2 = line.substr(0, line.find(' '));//endline instead?
				//erase is unnecessary, line not used
			}
			catch(...)
			{
				if(commandWord == "int" || commandWord == "lab")
					pass;
				else if(commandWord == "add" || commandWord == "sub")
					value2 = "ACC";
			}
				//store/check variables

		}
		catch(...)
		{
			printf("Malformed statement at line %d", lineCounter):
		}
		lineCounter += 1;
	}	
}
