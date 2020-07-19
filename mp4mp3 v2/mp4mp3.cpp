// mp4mp3.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#include "includes.h"


using namespace std;
using namespace ffmpegcpp;

char* currentFile;
char* oldFile;

void init()
{
    //some initialization functions
}

void videoH()
{
 
    cout << "\nExit file is: ";
    cout << oldFile;
    cout << "\n";
    void* handle = ffmpegCppCreate((const char*)oldFile);
    printProgress(0.00);
    ffmpegCppAddAudioStream(handle, (const char*)currentFile);
    printProgress(0.25);
    ffmpegCppGenerate(handle);
    printProgress(0.50);
    ffmpegCppClose(handle);
    printProgress(1.0);
    cout << "\r                                                                                              ";
    cout << "\r Finished Conversion!";
    cout << "\n";
}


int main(int argc, char* argv[]) //means it should accept arguments of file name and number.
{
    cout << "Video Audio Converter v.1.0.3\n"; //declares what your using 

    if(argc <=1) //This next section is all about 
    {
        cout << "syntax is mp4mp3.exe -i <input file plus extention> -o <output file plus extention>\n so like mp4mp3.exe -i momvideo.mp4 -o track0.cda";
	}

    for (int i = 1; i <= argc; i++) 
    {
        if (argv[i])
        {
            if (strcmp(argv[i], "-i") == 0)
            {
                
                currentFile = argv[i + 1];
            }
            else if (strcmp(argv[i], "-o") == 0)
            {
                oldFile = argv[i + 1];
			}
            
        } 
    } 
   
    init();
    videoH();
    return 0;
}



