yasm -f win32 task2.asm
g++ -c -m32 task2-test.cpp
gcc task2.obj task2-test.o -lstdc++ -o task2.exe