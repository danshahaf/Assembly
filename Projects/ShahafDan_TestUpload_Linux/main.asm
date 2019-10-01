; Assembler 32bit template

bits 32
section .data
;variables with values go here
section .bss
;reserved memory goes here
section .text
;Your program code goes here

	global _start
_start:
    nop
	
	;Your program code should go here
	
	mov eax, 0ffffffffh
	
	mov ax, 2222h
	mov al, 33h
	mov ah, 44h
	
	;Do not remove/change the lines below here.
	;These exit out of the application and back
	;to linux in an orderly fashion
	nop
	mov eax,1      ; Exit system call value
	mov ebx,0      ; Exit return code
	int 80h        ; Call the kernel
