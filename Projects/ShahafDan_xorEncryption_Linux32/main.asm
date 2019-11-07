;
;This program will test out the functions library
;
;
;Include our external functions library functions
%include "./functions.inc"
 
SECTION .data
	welcomeAct	db	"Welcome to my progrm", 0ah, 0dh, 0h
	byeAct db 	"Bye, have a good day!", 0ah , 0dh, 0h
	notFound db "Value invalid, enter a new one", 0ah, 0dh, 0h
	
	currentKey db  0h
	
	option1 db "Option 1 Selected: Enter a string:", 0ah, 0dh, 0h
	option2 db "Option 2 Selected: Enter an Encryption key:", 0ah, 0dh, 0h
	option3 db "Option 3 Selected: your last input string was:", 0ah, 0dh, 0h
	option4 db "Option 4 Selected: your last encryption key entered was: ", 0ah, 0dh, 0h
	option5 db "Option 5 Selected: Encrypting...", 0ah, 0dh, 0h
	option6 db "Option 6 Selected: Decrypting...", 0ah, 0dh, 0h
	optionExit db "You chose to eixt the program", 0ah, 0dh, 0h
	
	keyArray db 10h, 20h, 30h, 40h, 50h, 60h, 70h, 80h ;only 8 values for testing purposes right now
		.len equ ($ - keyArray) ;use it later in encryption
	
	menu db "Encrypt / Decrypt Program", 0ah, 0dh,
		 db "1) Enter a String", 0ah, 0dh, 
		 db	"2) Enter an Encryption Key", 0ah, 0dh,
		 db	"3) Print the Input String", 0ah, 0dh,
		 db	"4) Print the Input Key", 0ah ,0dh,
		 db	"5) Encrypt / Display the String", 0ah, 0dh,
		 db	"6) Decrypt / Display the String", 0ah, 0dh,
		 db	"x) Exit Program", 0ah, 0dh,
		 db	"Please Enter One", 0ah, 0dh, 0ah, 0dh, 0h
	
	caseTable 	db '1'
				dd enterString
			.entrySize equ ($ - caseTable)
				db '2'
				dd enterKey
				db '3'
				dd printInputString
				db '4'
				dd printKey
				db '5'
				dd encryptString
				db '6'
				dd decryptKey
		.numberOfEntries equ ($ - caseTable) / caseTable.entrySize
		
	
	
SECTION .bss
	inputString resb 255 ;reserve 255 bits for the inputString variable
		.len equ ($ - inputString) ;no need todivivde. because it is all bytes
	inputValue resb 8;reserving 8 for the inputValue that will be entered by the user
		.len equ ($ - inputValue) ;size of it, will be used for the buffer
	inputKey resb 255 ;reserve 255 for the encryption key variable
		.len equ ($ - inputKey) ;length of
	encryptedValue resb 255 ;reserve 255 bytes for the encrypoted value resulted from choosing option5
		.len equ ($ - encryptedValue)
SECTION     .text
	global      _start
     
_start:
	nop
	;----- WELCOME -----
	call Printendl
	push welcomeAct
	call PrintString ;print the welcome prompt
	call Printendl ;print empty line
	
	;---ASSIGNMENT---
	mov edi, 0 ;reset two pointers
	mov esi, 0 ;reset two pointers
	;---- first: PRINT MENU ---
	printMenu: ;use a flag just in case I need to callit again
	push menu;
	call PrintString
	
	mov ecx, caseTable ;mov the number of items in the switch ;set counter for the switch loop
	mov esi, caseTable ;put the address of our table into the pointer esi register
	
	push inputValue
	push inputValue.len
	call ReadText
	mov al, [inputValue] ;move to the al 1 bytes register the input from the user
	
	
	
	Switch: ;create a loop to go through every element of the table
	
		cmp al,'x' ;compare to x, in order to exit the program
		je exitFlag ;if the user entered x, jmp to exitFlag (exit the program)
	
		cmp al, [esi] ;compre to the look up table
		jne nextSwitchItem ;try the next value in the switch table
		call NEAR[esi + 1] ;call the function associated ith the user input
		
		jmp printMenu
		
		nextSwitchItem:
			add esi, caseTable.entrySize
		
		
	Loop Switch ; go to the switch flag again
	
	notFoundInTable: ;flag to jump to if the value the user entered cannot be found in the look up table
		push notFound
		call PrintString
		call Printendl
		jmp printMenu ;go back to printing the menu again
		
	;----- GOODBYE ---
	exitFlag:
	push byeAct
	call PrintString
	call Printendl
	
;
;Setup the registers for exit and poke the kernel
Exit: 
	mov		eax,sys_exit				;What are we going to do? Exit!
	mov		ebx,0						;Return code
	int		80h							;Poke the kernel


; ----- FUNCTION HERE ----
enterString:
	push option1
	call PrintString
	
	push inputString
	push inputString.len
	call ReadText
	;mov ebx, [inputString] ;move to the ebx 1 string input from the user
ret

enterKey:
	push option2
	call PrintString
		
	push inputKey
	push inputKey.len
	call ReadText
	;mov edx, [inputKey] ;mov to edx the new inputKey

ret
	
printInputString:
	push option3
	call PrintString
	push inputString
	call PrintString ;print the eax returned value (user input)
	call Printendl
	call Printendl ;print two empty lines
ret

printKey:
	push option4
	call PrintString
	
	;mov esi, 0; clear the pointer
	;printKeyArray:
;		mov al, BYTE [inputKey + esi];
;		inc esi ;increase counter++;;
;	Loop printKeyArray

	push inputKey
	call PrintString
	call Printendl
	call Printendl
ret

;----5----
encryptString:
	push option5 ;print the right prompt
	call PrintString
	mov edx, 0
	mov edx, [inputString]
	mov [encryptedValue], edx ;move the inputString from the user to encryptedValue variable
	;then xor that value
	mov esi, 0 ;used to track position of key
	mov edi , 0 ;counter = 0; reset counter variable to access array index
	
	mov ecx, encryptedValue.len
	encLoop:
		mov edx, 0
		mov edx, [keyArray + esi]
		mov [currentKey],edx ;; three last lines meant to move to CurrentKey the currently spoken key from the array
		xor DWORD [encryptedValue + edi], currentKey
		inc edi; counter ++;
		inc esi;
		cmp esi, [keyArray.len]
		jne continueLoop
		mov esi, 0; reset counter to 0
		continueLoop: ;flag to skip increment of keyArray counter
	Loop encLoop
	
	call Printendl
	
ret

decryptKey:
	push option6
	call PrintString
ret



;-----TODO-------
;1) do not forget to clear buffer 
;2) reerase everytime user enters input
;3)leave as many comments as possible
