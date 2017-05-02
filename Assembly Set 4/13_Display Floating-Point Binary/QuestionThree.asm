TITLE Display Floating Point Binary		(QuestionThree.asm)
;DESCRIPTION: Receives a single-precision floating point binary
;value and displays it in scientific notation. Before the program
;completes, the special cases are printed as well.

INCLUDE Irvine32.inc

.data
prompt		BYTE	"Enter a floating point number: ",0		;following are prompts for entering data and displaying answers
specail1	BYTE	"Positive Zero: ",0
specail2	BYTE	"Negative Zero: ",0
specail3	BYTE	"Positive Infinity: ",0
specail4	BYTE	"Negative Infinity: ",0
specail5	BYTE	"QNaN: ",0
specail6	BYTE	"SNaN: ",0
complete	BYTE	"Completed!",0

posZero		DWORD	00000000000000000000000000000000b		;following hold the variables for the special cases
negZero		DWORD	10000000000000000000000000000000b	
posInf		DWORD	01111111100000000000000000000000b
negInf		DWORD	11111111100000000000000000000000b
QNaN		DWORD	01111111110000000000000000000000b
SNaN		DWORD	01111111101010101010101010101000b

number		REAL4	?										;following holds the variable for the user enter floating-point number

.code
main PROC

L1:
	mov edx, OFFSET prompt
	call WriteString
	call ReadFloat
	fldz													;pushes +0.0 onto the FPU stack
	fcomp													;compares the stack variables and pops st(0)
	fnstsw ax												;store FPU status word in AX register
	sahf													;store AH into Flags
	je complete1											;if zero has been entered jump to complete1
	fstp number												;value is put into the number variable
	mov ebx, number											;moves the number variable into ebx for the printRealValue PROC
	call printRealValue										;calls the printRealValue proc for the conversion
	
	jmp L1													;jumps to the top of the loop until the user enter zero		

complete1:
call crlf

mov edx, OFFSET specail1									;moves special1 into edx for printing
call WriteString	
mov ebx, posZero											;moves posZero variable into ebx for the proc
call printRealValue

mov edx, OFFSET specail2									;moves special2 into edx for printing
call WriteString
mov ebx, negZero											;moves negZero variable into ebx for the proc
call printRealValue

mov edx, OFFSET specail3									;moves special3 into edx for printing
call WriteString
mov ebx, posInf												;moves posInf variable into ebx for the proc
call printRealValue

mov edx, OFFSET specail4									;moves special4 into edx for printing
call WriteString
mov ebx, negInf												;moves negInf variable into ebx for the proc
call printRealValue

mov edx, OFFSET specail5									;moves special5 into edx for printing
call WriteString
mov ebx, QNaN												;moves QNaN variable into ebx for the proc
call printRealValue

mov edx, OFFSET specail6									;moves special6 into edx for printing
call WriteString
mov ebx, SNaN												;moves SNaN variable into ebx for the proc
call printRealValue

call crlf
mov edx, OFFSET complete									;moves complete into edx for printing
call WriteString
call crlf

	exit
main ENDP


;**********************************************************************
printRealValue PROC
; Description: Displays a single-precision floating point number in
; scientific notation.
; Receives: A floating point value in ebx
; Returns: Nothing (prints sign, significand, and exponent)
;**********************************************************************

finit														;initializes the FPU
push eax													;following pushes save the register values
push ebx
push ecx
push edx
		
		push ebx											;saves the value of ebx for the shift
		mov eax, 0											;clears the eax register
		shl ebx, 1											;shifts the value ebx left one
		jnc positive										;jumps if the carry value isn't signed

		mov al, '-'											;moves '-' into al for printing 
		call WriteChar
		mov al, '1'											;moves '1' into al for printing 
		call WriteChar
		mov al, '.'											;moves '.' into al for printing 
		call WriteChar
		jmp skip											;jumps to "skip" to avoid printing again

		positive:
			mov al, '+'										;moves '+' into al for printing 
			call WriteChar
			mov al, '1'										;moves '1' into al for printing 
			call WriteChar
			mov al, '.'										;moves '.' into al for printing 
			call WriteChar
		skip:

	
		pop ebx												;pops the currently saved value in ebx
		push ebx											;saves the value in ebx to the register
		shl ebx, 9											;shifts the value in ebx left 9 (to ingore sign and exponent)
		mov ecx, 23											;need 23 bits, so loops 23 times (put 23 into eax to do this)
		L2:
			shl ebx, 1										;shifts ebx left 1
			jnc zerobit										;jumps if the carry bit isn't set (a zero)

			mov eax, 1										;moves 1 into eax for printing
			call WriteDec
			jmp continue									;jumps to continue to avoid printing again

			zerobit:
				mov eax, 0									;moves 0 into eax for printing
				call WriteDec
			continue:
		loop L2
	
		mov al, 'E'											;moves 'E' into al for printing 
		call WriteChar

		mov eax, 0											;clears the eax register
		pop ebx												;pops the value back into ebx
		shl ebx, 1											;shift left 1 to get rid of the sign bit
		shld eax, ebx, 8									;shifts 8 bits from ebx into eax (exponent)
		sub eax, 127										;subs 127 from eax
			
		call WriteInt										;prints the exponent value in eax

		call crlf

	pop edx													;following pops restore the registers
	pop ecx
	pop ebx
	pop eax

	ret
printRealValue ENDP

END main