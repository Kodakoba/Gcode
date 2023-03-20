#pragma once
//for extra security- mostly to prevent accidental duping to prevent LNK2001, LNK2005, and LNK1120
#ifndef includes
//includes.h
//
/* Someone once told me, there's usually two way things to do things: my way or the high way. */
//The Include List, Version 1.0.1 - LICV
//These includes are from three sources: FFMPEG, LAME, and VS Standard Include Library (where things like Windows.h will come from)
//Credit is Availiable at Credits.txt for the makers of FFMPEG and LAME.
//This is a standard(?)ish practice I use when programming in Unity or UE4.
//First is FFMPEG's required files.
#include <ffmpegcpp.h>
#include "ffmpeg.h"
#include "SimpleInterface.h"
//Next is LAME
//lame is uneccessary cause its a muckla. 
//We include ffmpeghandler for, as its name implies, handles ffmpeg
#include "ffmpeghandler.h"

//The VS standard C++ and C libraries
#include <Windows.h>
#include <intrin.h>
#include <iostream>
#include <vector>
#include <stdio.h>
#include <fstream>
//Lastly, my home made includes
#include "onion.h" // TEACHER DONT TOUCH UNLESS YOU WANT #define _mesotheleoma_CANCER* , ECLIPSE mADE it >:^)
#include "subroutine.h" // <--- you are especially important 
//That concludes this list, hopefully its not too annoying.
#endif // !includes