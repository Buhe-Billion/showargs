showargs: showargs.o
	ld -o showargs showargs.o
showargs.o: showargs.asm
	nasm -f elf64 -g -F dwarf showargs.asm
