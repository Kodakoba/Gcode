#pragma once
//for extra security, as always.
#ifndef SUBROUTINE_H
//subroutine.h 
//"So basically, we call it a lemma" - Mr. Peck, an awesome math teacher.
//
//The Subroutine List, Version 1.0.2 - LICV
//What is this file? It easy! It's for basic subroutine functions
//Mostly information and verifying the system will even work with our program.
//I intend to keep this file as generic as posible, so I can use 
//#define PBSTR "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
#define PBSTR "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
#define PBWIDTH 60
#define define
//inlcudes
#include "iostream"
#include "Windows.h"
#include "tchar.h"
#include "stdio.h"
#include "time.h"


//Pause on enter function - Pauses until enter is pressed.
inline void pause_on_enter()
{
    std::cin.clear();
    std::string pause;
    std::cout << "Press enter to continue . . .";
    std::getline(std::cin, pause);
}
//Hardware specs, mostly to determine what GPU, how much memory, and what OS build.

inline void gpu_vendor()
{  
    pause_on_enter();
}

inline void printProgress(double percentage)
{
    int val = (int)(percentage * 100);
    int lpad = (int)(percentage * PBWIDTH);
    int rpad = PBWIDTH - lpad;
    std::printf("\r%3d%% [%.*s%*s]", val, lpad, PBSTR, rpad, "");
    std::fflush(stdout);
}


#endif // !SUBROUTINE_H
