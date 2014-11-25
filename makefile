ADN: ADN.o
	gcc -m32 ADN.o -o ADN 
	rm ADN.o
	clear && ./ADN && ./ADN

ADN.o: ADN.asm
	nasm -f elf ADN.asm