#include <iostream>
#include <string>

//Usage: assembler <file>
//assembler <file> <output>


//TO DO!
//Handle numbers, not just addresses. Already does? Just need to set addy flags for necessary functions
//Variable names for addresses, not just the raw value;
//Generate valid command sentences. Possibly change command sentence structure

std::string commandParser(std::string commandIn)
{
	std::string output;
	switch(commandIn)
	{
		case "add" : output = "0001"
					break;
		case "sub" : output = "0010"
					break;
		case "inv" : output = "0011"
					break;
		case "mov" : output = "0100"
					break;
		case "jfl" : output = "0101"
					break;
		case "jfe" : output = "0110"
					break;
		case "jfg" : output = "0111"
					break;
		default : output = "ERROR"
					break;
	}
}

//Function not needed
std::string shexTosbin(std::string shex)
{
	std::string sbin;
	switch(shex)
	{
		case "0" : sbin = "0000";
					break;
		case "1" : sbin = "0001";
					break;
		case "2" : sbin = "0010";
					break;
		case "3" : sbin = "0011";
					break;
		case "4" : sbin = "0100";
					break;
		case "5" : sbin = "0101";
					break;
		case "6" : sbin = "0110";
					break;
		case "7" : sbin = "0111";
					break;
		case "8" : sbin = "1000";
					break;
		case "9" : sbin = "1001";
					break;
		case "A" : sbin = "1010";
					break;
		case "B" : sbin = "1011";
					break;
		case "C" : sbin = "1100";
					break;
		case "D" : sbin = "1101";
					break;
		case "E" : sbin = "1110";
					break;
		case "F" : sbin = "1111";
					break;
		default : sbin = "ERROR";
					break;
	}
	return sbin;
}

std::string valueToWord(std::string value)
{
	std::string word;
	switch(value) //need to do this for each value. Pain in the ass if you ask me
	{
		case "regA" : word = "100000000";
						break;
		case "regB" : word = "100000001";
						break;
		case "regC" : word = "100000010";
						break;
		case "regD" : word = "100000011";
						break;
		case "regE" : word = "100000100";
						break;
		case "regF" : word = "100000101";
						break;
		case "regG" : word = "100000110";
						break;
		case "regH" : word = "100000111";
						break;
		case "regI" : word = "100001000";
						break;
		case "regJ" : word = "100001001";
						break;
		case "regK" : word = "100001010";
						break;
		case "regL" : word = "100001011";
						break;
		case "regM" : word = "100001100";
						break;
		case "regN" : word = "100001101";
						break;
		case "regO" : word = "100001110";
						break;
		case "regP" : word = "100001111";
						break;
		default : word = "ERROR";
						break;
	}

	long wordNum
	if (word == "ERROR")
	{
		try
		{
			wordNum = stol(word);
			if (wordNum < 255 && wordNum > 0) //if 8 bit. If value should actually be 16 bit can buffer it in the mov function
				word = std::bitset<9>(wordNum).to_string(); //includes register bit set to 0
			else
				word = std::bitset<16>(wordNum).to_string();
		}
		catch(...)
		{
			word = "ERROR";
		}	
	}
	if (word == "ERROR")
	{
		word = labelMap[word];
		if (word == "")
			word = "ERROR";
	}

	return word;
}

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
	std::string assemblyLine, commandWord, value1Word, value2Word, value3Word;
	std::string command, value1, value2, value3;
	int valueCounter = 0;
	std::map<std::string, int> labelMap;
	
	//Correct syntax
	// lbl value1
	// add/sub value1 value2 value3;
	// mov value1 value2
	// inv value1 value2
	// jf  value1 value2
	// int var = 0;?
	while(validInput && line << inputFile)
	{
		try
		{
			//parsing
			//if(line.find(';') == NULL) throw;
			//line.erase(0, line.find(';'));
			command = line.substr(0, line.find(' '));
			line.erase(0, line.find(' '));
			valueCounter = 0
			value1 = line.substr(0, line.find(' ')); //what if ends with;? can use ' ;' and endl synatx?
			valueCounter++;
			line.erase(0, line.find(' '));
			try
			{
				value2 = line.substr(0, line.find(' '));//endline instead?
				value2Word = valueToWord(value2);
				valueCounter++;
				line.erase(0, line.find(' '));
				value3 = line.substr(0, line,find(' '));//endline instead?
				value3Word = valueToWord(value3);
				value3Counter++;
				//erase is unnecessary, line not used
			}
			catch(...)
			{
				if(command == "lbl")
				{
					labelMap[value1] = lineCounter; //should this be the address to jump to?
				}
			}
			
			//value checking && generate sentence

			assemblyLine = "ERROR";
			commandWord = commandWordParser(command);
			if (command == "sub" || command == "add") //only ternary commands
			{
				if (valueCounter != 3)
					std::cout<<"Wrong number of arguements for command on line "<<lineCounter<<std::endl;
				assemblyLine = commandWord + value1Word + value2Word + value3Word[6:9]; //don't include first 5 bits for word 3
			}

			else
			{
				if (valueCounter != 2)
					std::cout<<"Wrong number of arguements for command on line "<<lineCounter<<std::endl;
			}

			if (command == "inv")
				assemblyLine = commandWord + value1Word + value2Word[6:9] + "000000000";

			if (command == "mov");

			if (command == "jfl" || command == "jfe" || command == "jfg")
			{
				if (value2Word.length < 16)
					assemblyLine = commandWord + value1Word + "00000000" + value2Word + "00";
				else
					assemblyLine = commandWord + value1Word + value2Word + "00";
			}

		}
		catch(...)
		{
			printf("Malformed statement at line %d", lineCounter):
		}
		lineCounter += 1;
	}	
}
