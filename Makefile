AS = yasm
LD = ld#i686-elf-ld

#KERNEL_SRC = ${wildcard src/kernel/*.asm}
#KERNEL_OBJ = ${KERNEL_SRC:.asm=.o}


.PHONY: clean run

Alpha.bin: boot1.bin os.bin hll.bin
	dd if=/dev/zero of=Alpha.bin bs=512 count=2880
	dd if=boot1.bin of=Alpha.bin bs=512 count=1 skip=0 conv=notrunc
	dd if=os.bin of=Alpha.bin bs=512 count=2 seek=1 conv=notrunc
	dd if=hll.bin of=Alpha.bin bs=512 count=1 seek=3 conv=notrunc
	#cat $^ > Alpha.bin

boot1.bin:
	${AS} src/bootloader/boot1.asm -f bin -o $@ -p nasm


os.bin: ./src/kernel/kern.o#${KERNEL_OBJ}
	${LD} -m elf_i386 -o $@ -Ttext 0x9000 $^ --oformat binary -e kern_main

hll.bin: ./src/helloworld/main.o#${KERNEL_OBJ}
	${LD} -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary -e start

%.o: %.asm
	${AS} $< -f elf -o $@ -p nasm

run: clean Alpha.bin
	qemu-system-x86_64 -fda Alpha.bin

clean:
	rm -f ./src/kernel/*.o
	rm -f ./src/helloworld/*.o
	rm -f *.bin