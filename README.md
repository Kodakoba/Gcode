# mp4mp3
Mp4mp3 - A (sortof) practical approach to an mp4 to mp3 converter

# What is it about? WHY??
Simple! I needed two goals: to demonstrate to the AP™ CollegeBoard™ i know how to write something useful, and i actually needed a utility i can use command line style for large "batch" operations of retrieveing audio from videos. 

# How do i use it?
...not so simple, you need to place the file in the directory /Mp4Mp3/x64/Compile x64/ and run it in CMD (in the directory unless your like me and tried to add it as a PATH variable) and use: 

>mp4mp3.exe -i video.mp4 -o audio.mp3

Obviously the larger the video the longer it will take (its doing its best, jim.) 
But it works! Particularly with a batch file along the lines of:

>@echo off
>xcopy "C:\Users\Joe4556\Videos\mombaron.mp4" "C:\Mp4Mp3\x64\Compile x64\"
>mp4mp3.exe -i mombaron.mp4 -o goodsong.mp3
>xcopy "C:\Mp4Mp3\x64\Compile x64\goodsong.mp3" "c:\Users\Joe4556\Music\"

Here's a helpful tutorial video (that someone at the collegeboard had to watch lmao):
https://youtu.be/y91R5sOlCFs

# Why are there two versions?
One is very pretty and neat code (essentially eyecandy for my grader from AP™ CSP) 
and the other is a mistake in the making (i'm sorry)

# Credits:

>Me (Koda) - layout and some function works (some of the programming)
>Eclipse - awesome parsing function and beutiful classes (my favorite is onion.h)
>Raveler - ffmpeg c++ wrapper and compile on demand library (We tweaked it a bunch, obviously, but great staring point! Thanks!)
