#include <iostream>
#include <string>
#include <bitset>
#include <map>
#include <fstream>

//Usage: assembler <file>
//assembler <file> <output>


//TO DO!
//Handle numbers, not just addresses. Already does? Just need to set addy flags for necessary functions
//Variable names for addresses, not just the raw value;
//Generate valid command sentences. Possibly change command sentence structure
//Make it a 2 pass, resolve label names
//Label map needs offset address, not line counter
//Have ';' OR ' ' be the end of each value parsing, currently requires lines to end with ' ;'
//functions?

std::string commandWordParser(std::string commandIn)
{
	std::string output;
	if (commandIn == "add") output = "0001";
	else if (commandIn == "sub") output = "0011";
	else if (commandIn == "inv") output = "0010";
	else if (commandIn == "mov") output = "0100";
	else if (commandIn == "jfl") output = "0101";
	else if (commandIn == "jfe") output = "0110";
	else if (commandIn == "jfg") output = "0111";
	else output = "LONGERROR";
	
	return output;
}

//Function not needed
std::string shexTosbin(std::string shex)
{
	std::string sbin;

	if (shex == "0") sbin = "0000";
	else if (shex == "1") sbin = "0001";
	else if (shex == "2") sbin = "0010";
	else if (shex == "3") sbin = "0011";
	else if (shex == "4") sbin = "0100";
	else if (shex == "5") sbin = "0101";
	else if (shex == "6") sbin = "0110";
	else if (shex == "7") sbin = "0111";
	else if (shex == "8") sbin = "1000";
	else if (shex == "9") sbin = "1001";
	else if (shex == "A") sbin = "1010";
	else if (shex == "B") sbin = "1011";
	else if (shex == "C") sbin = "1100";
	else if (shex == "D") sbin = "1101";
	else if (shex == "E") sbin = "1110";
	else if (shex == "F") sbin = "1111";
	else sbin = "LONGERROR";

	return sbin;
}

std::string valueToWord(std::string value, std::map<std::string,std::string> &labelMap)
{
	std::string word;

	if (value == "regA") 	  word = "100000000";
	else if (value == "regB") word = "100000001";
	else if (value == "regC") word = "100000010";
	else if (value == "regD") word = "100000011";
	else if (value == "regE") word = "100000100";
	else if (value == "regF") word = "100000101";
	else if (value == "regG") word = "100000110";
	else if (value == "regH") word = "100000111";
	else if (value == "regI") word = "100001000";
	else if (value == "regJ") word = "100001001";
	else if (value == "regK") word = "100001010";
	else if (value == "regL") word = "100001011";
	else if (value == "regM") word = "100001100";
	else if (value == "regN") word = "100001101";
	else if (value == "regO") word = "100001110";
	else if (value == "regP") word = "100001111";
	else word = "LONGERROR";

	long wordNum;
	if (word == "LONGERROR")
	{
		try
		{
			wordNum = std::stoi(value, NULL, 0);
			if (wordNum < 255 && wordNum >= 0) //if 8 bit. If value should actually be 16 bit can buffer it in the mov function
				word = std::bitset<9>(wordNum).to_string(); //includes register bit set to 0
			else
				word = std::bitset<16>(wordNum).to_string();
		}
		catch(...)
		{
			word = "LONGERROR";
		}	
	}
	if (word == "LONGERROR")
	{
		word = labelMap[value];
		if (word == "")
			word = "LONGERROR";
	}

	return word;
}

int main(int argc, char* argv[])
{
	bool validInput = true;
	if (argc > 3 || argc == 1)
	{
	//	printHelp();
		validInput = false;
	}

	if (argc == 2) argv[2] = (char*) "./a.out";

	std::ifstream inputFile;
	std::ifstream tempFileIn;
	std::ofstream tempFileOut;
	std::ofstream outputFile;

	try
	{
		inputFile.open(argv[1]);
		outputFile.open(argv[2]);
		tempFileOut.open("./tempFile");
	}
	catch(...)
	{
		std::cout<<"Input files are not valid"<<std::endl;
		validInput = false;
	}

	size_t lengthOfLine;
	std::string line, originalLine;

	int lineCounter = 1;
	int commandLineCounter = 0; //0 indexed
	std::string assemblyLine, commandWord, value1Word, value2Word, value3Word;
	std::string command, value1, value2, value3;
	int valueCounter = 0;
	size_t endOfSearch;
	std::map<std::string, std::string> labelMap;
	
	//pass 1
	std::cout << "Pass 1" <<std::endl;
	while(std::getline(inputFile, line) && validInput)
	{
		//removing comments	
		try{
			line.erase(line.find("//"), std::string::npos);
			std::cout<<"Comment Found"<<std::endl;
			}
		catch(...){}//std::cout<<"No comments on this line"<<std::endl;}
		originalLine = line;

		//parsing
		command = line.substr(0, line.find(' '));
		line.erase(0, line.find(' ')+1);
		valueCounter = 0;
		value1 = line.substr(0, line.find(' ')); //what if ends with;? can use ' ;' and endl synatx?
		value1Word = valueToWord(value1, labelMap);
		valueCounter++;
		line.erase(0, line.find(' ')+1);
		if (command == "lbl")
		{
			labelMap[value1] = std::bitset<16>(3*(commandLineCounter+1)).to_string(); //should this be the address to jump to?
			std::cout<<"Label found"<<std::endl;
		}
		else
		{
			tempFileOut << originalLine << std::endl;
			commandLineCounter++;
		}
	}	
	
	//pass 2
	tempFileOut.close();
	tempFileIn.open("./tempFile");
	std::cout << "Pass 2" <<std::endl;
	while(std::getline(tempFileIn, line) && validInput)
	{
		try
		{
			//parsing
			//if(line.find(';') == NULL) throw;
			//line.erase(0, line.find(';'));
			command = line.substr(0, line.find(' '));
			line.erase(0, line.find(' ')+1);
			valueCounter = 0;
			value1 = line.substr(0, line.find(' ')); //what if ends with;? can use ' ;' and endl synatx?
			value1Word = valueToWord(value1, labelMap);
			valueCounter++;
			line.erase(0, line.find(' ')+1);
			try
			{
				value2 = line.substr(0, line.find(' '));//endline instead?
				value2Word = valueToWord(value2, labelMap);
				valueCounter++;
				line.erase(0, line.find(' ')+1);
				value3 = line.substr(0, line.find(' '));//endline instead?
				value3Word = valueToWord(value3, labelMap);
				valueCounter++;
				line.erase(0, line.find(' ')+1);
			}
			catch(...)
			{
				if (line == ";") std::cout<<"End of line " <<lineCounter<<" reached\n";
			}
			
			//value checking && generate sentence

			assemblyLine = "LONGERROR";
			commandWord = commandWordParser(command);
			if (command == "sub" || command == "add") //only ternary commands
			{
				if (valueCounter != 3)
					std::cout<<"Wrong number of arguements for command on line "<<lineCounter<<std::endl;
				assemblyLine = commandWord + value1Word + value2Word + value3Word.substr(5,4) + "\n"; //don't include first 5 bits for word 3
			}

			if (command == "lbl")
				if (valueCounter != 1)
					std::cout<<"Wrong number of arguements for command on line "<<lineCounter<<std::endl;

			else
			{
				if (valueCounter != 2)
					std::cout<<"Wrong number of arguements for command on line "<<lineCounter<<std::endl;
			}

			if (command == "inv")
				assemblyLine = commandWord + value1Word + value2Word.substr(5,4) + "000000000";

			if (command == "mov");

			if (command == "jfl" || command == "jfe" || command == "jfg")
			{
				if (value2Word.length() < 16)
					assemblyLine = commandWord + value1Word.substr(5,4) + "00000000" + value2Word + "00";
				else
					assemblyLine = commandWord + value1Word.substr(5,4) + value2Word + "00";
			}
			outputFile << assemblyLine;
			std::cout<<"Line "<<lineCounter<<" successfully parsed"<<std::endl;

		}
		catch(...)
		{
			std::cout<<"Malformed statement at line "<<lineCounter<<std::endl;;
		}
		lineCounter += 1;
	}

	std::cout<<"Deleting temporary file"<<std::endl;
	std::remove("./tempFile");
	std::cout<<"Assembly completed"<<std::endl;
}
