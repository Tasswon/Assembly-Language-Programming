TITLE AdvancedProcs							(AdvancedProcs.asm)
;DESCRIPTION: Creates an array of 10 SDWORDS initialized with all zeros, and then
;presents a menu allowing the user to manipulate the array based on the options.

INCLUDE Irvine32.inc

genRandomNum PROTO, upperBound2:SDWORD, lowerBound2:SDWORD												;creates a prototype for the genRandomNum proc

.data
menuPrompt	BYTE	"1 - Populate the array with random numbers (user supplied range)", 13d, 10d,		;long string utilized as the menu for program	
					"2 - Multiply the array with a user provided multiplier", 13d, 10d,
					"3 - Divide the array with a user provided divisor", 13d, 10d,
					"4 - Mod the array with a user provided divisor", 13d, 10d,
					"5 - Print the array", 13d, 10d,
					"0 - Exit", 13d, 10d,0

mPrompt1	BYTE	"Enter the low number in the range: ",0												;below are the user prompts for all the procs
mPrompt2	BYTE	"Enter the high number in the range: ",0
mulPrompt	BYTE	"Enter a multiplier: ",0
divPrompt	BYTE	"Enter a divisor: ",0

completed	BYTE	"Task Completed...",0																;string states when the procs are complete
thanks		BYTE	"THANK YOU!",0																				

array		SDWORD	10 DUP(0)																			;empty array manipulated by all the procs

.code
main PROC

start:																	;"start" while loop continues until the user enters 0 (ending)
	mov edx, OFFSET menuPrompt											;moves the menuprompt into the edx register for printing
	call WriteString
	call ReadDec

	cmp eax, 0															;compares the users choice and jumps to the appropriate spot for the procudure				
	je finished
	cmp eax, 1
	je proc1
	cmp eax, 2
	je proc2
	cmp eax, 3
	je proc3
	cmp eax, 4
	je proc4
	cmp eax, 5
	je proc5
	jmp start															;jumps to the start of the loop if the user enters an invalid response

	proc1:																;option one: filling the array with random numbers
		mov eax, 0														;clears the eax register for use in the proc
		push OFFSET array												;pushes the array type, length, and offset onto the stack for use in the proc
		push TYPE array
		push LENGTHOF array
		call populateArray												;calls the proc to add random numbers
		call crlf
		jmp start														;jumps to the start of the loop once the proc is completed 

	proc2:																;option two: multiplies all the array values
		mov eax, 0														;clears the eax register for use in the proc
		push OFFSET array												;pushes the array type, length, and offset onto the stack for use in the proc
		push TYPE array
		push LENGTHOF array
		call multiplyArray												;calls the proc to multiply the array values by the user multiplier
		call crlf
		jmp start														;jumps to the start of the loop once the proc is completed

	proc3:																;option three: divides all the array values
		mov eax, 0														;clears the eax register for use in the proc
		push OFFSET array												;pushes the array type, length, and offset onto the stack for use in the proc
		push TYPE array
		push LENGTHOF array
		call divideArray												;calls the proc to divide the array values by the user divisor
		call crlf
		jmp start														;jumps to the start of the loop once the proc is completed

	proc4:																;option four: mods all the array values
		mov eax, 0														;clears the eax register for use in the proc
		push OFFSET array												;pushes the array type, length, and offset onto the stack for use in the proc
		push TYPE array
		push LENGTHOF array
		call modArray													;calls the proc to mod the array values by the user divisor
		call crlf
		jmp start														;jumps to the start of the loop once the proc is completed
			
	proc5:																;option five: prints all the array values
		mov eax, 0														;clears the eax register for use in the proc
		push OFFSET array												;pushes the array type, length, and offset onto the stack for use in the proc
		push TYPE array
		push LENGTHOF array
		call printArray													;calls the proc to print the array values
		call crlf
		jmp start														;jumps to the start of the loop once the proc is completed

	finished:															;jumps to this point if the user enters 0 (program ending)
		call crlf
		mov edx, OFFSET thanks											;moves the "thanks" string into the edx register for printing
		call WriteString
		call crlf	
	exit
main ENDP

;**********************************************************************
populateArray PROC
; Description: Populates the array with random values based on the user
; entered range.
; Receives: OFFSET of array, TYPE of array, LENGTHOF array
; Requires: User entered upper and lower bound numbers
; Returns: Random value in eax, each then put into [esi] array point
;**********************************************************************

	arrayTemp	EQU[EBP+16]												;symbolic constant: for array offset
	arrayType	EQU[EBP+12]												;symbolic constant: for array type
	lengthArray	EQU[EBP+8]												;symbolic constant: for the length of the array

	lowerBound	EQU[EBP-4]												;symbolic constant: local variable for lowerBound
	upperBound	EQU[EBP-8]												;symbolic constant: local variable for upperBound

	push ebp															;save base pointer
	mov ebp, esp														;base of stack frame
	sub esp, 8															;create locals (allocates room for lowerBound and upperBound)

	push eax															;following "push" operations save the registers
	push ebx
	push ecx
	push edx
	push esi

	call crlf
	mov edx, OFFSET mPrompt1											;moves mPrompt1 into edx register for printing 
	call WriteString
	call ReadInt
	mov lowerBound, eax													;moves user's inputed value to lowerBound local variable
	mov edx, OFFSET mPrompt2											;moves mPrompt2 into edx register for printing
	call WriteString
	call ReadInt
	mov upperBound, eax													;moves user's inputed value to upperBound local variable
	
	mov esi, arrayTemp													;array offset
	mov ebx, arrayType													;doubleword format
	mov ecx, lengthArray												;sets to loop for the number of elements in the array		
	L1:																	;loops for all the elements in the array	
		mov eax, 0														;clears eax to hold each new value	
		INVOKE genRandomNum, lowerBound, upperBound						;calls genRandomNum and pushes lowerBound and upperBound onto the stack
		mov [esi], eax													;moves value in eax to the array point at esi
		add esi, ebx													;increments ebx by the type of the array
	loop L1

	mov edx, OFFSET completed											;moves the offset of completed to edx for printing
	call WriteString
	call crlf

	pop esi																;following "pop" operations restore the registers
	pop edx
	pop ecx
	pop ebx
	pop eax

	mov esp, ebp														;removes locals from the stack
	pop ebp																;restores the base pointer

	ret 8																;cleans up stack
populateArray ENDP

;**********************************************************************
multiplyArray PROC
; Description: Multiplies each array value by a user entered mutliplier.
; Receives: OFFSET of array, TYPE of array, LENGTHOF array
; Requires: User entered multiplier
; Returns: Multiplied answer in eax, each then put into [esi] array point
;**********************************************************************

	LOCAL	multiplier:DWORD											;declares multiplier variable and creates a stack frame
	arrayTemp	EQU[EBP+16]												;symbolic constant: for array offset
	arrayType	EQU[EBP+12]												;symbolic constant: for array type
	lengthArray	EQU[EBP+8]												;symbolic constant: for the length of the array

	push eax															;following "push" operations save the registers
	push ebx
	push ecx
	push edx
	push esi

	call crlf
	mov edx, OFFSET mulPrompt											;moves OFFSET  of mulPrompt into edx for printing 
	call WriteString
	call ReadInt
	mov multiplier, eax													;moves user's inputed value to multiplier local variable
	
	mov esi, arrayTemp													;array offset
	mov ebx, arrayType													;doubleword format
	mov ecx, lengthArray												;sets to loop for the number of elements in the array
	L2:																	;loops for all the elements in the array	
		mov eax, 0														;clears eax to hold each new value	
		mov eax, [esi]													;moves value in array point at eax for multiplication
		mov ebx, multiplier												;moves the user entered value into ebx for multiplication
		imul ebx														;multiplies the value in user entered value by the array point
		mov [esi], eax													;saves the resulting multiplication to the array point
		add esi, TYPE SDWORD											;increments esi to the next array value
	loop L2

	mov edx, OFFSET completed											;moves the offset of completed to edx for printing
	call WriteString
	call crlf

	pop esi																;following "pop" operations restore the registers
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret 
multiplyArray ENDP

;**********************************************************************
divideArray PROC
; Description: Divides each array value by a user entered divisor. 
; Receives: OFFSET of array, TYPE of array, LENGTHOF array
; Requires: User entered divisor
; Returns: Divided answer in eax, each then put into [esi] array point
;**********************************************************************

	divisor		EQU[EBP-4]												;symbolic constant: local variable for divisor

	push ebp															;save base pointer
	mov ebp, esp														;base of stack frame
	sub esp, 4															;create locals (allocates room for divisor)

	push eax															;following "push" operations save the registers
	push ebx
	push ecx
	push edx
	push esi

	call crlf
	mov edx, OFFSET divPrompt											;move divPrompt into edx for printing 
	call WriteString
	call ReadInt
	mov divisor, eax													;moves user's inputed value to divisor local variable

	mov esi, [EBP+16]													;explicit stack parameter: array offset
	mov ebx, [EBP+12]													;explicit stack parameter: array type
	mov ecx, [EBP+8]													;explicit stack parameter: length of the array
	L3:																	;loops for all the elements in the array
		mov eax, 0														;clears eax to hold each new value	
		mov eax, [esi]													;moves value in array point at eax for division
		cdq																;convert doubleword to quadword: extends sign bit
		mov ebx, divisor												;moves the user entered value into ebx for division
		idiv ebx														;divides the value in user entered value by the array point
		mov [esi], eax													;saves the resulting division to the array point
		add esi, [EBP+12]												;increments esi to the next array value
	loop L3

	mov edx, OFFSET completed											;moves offset of "completed" into edx for printing
	call WriteString
	call crlf

	pop esi																;following "pop" operations restore the registers
	pop edx
	pop ecx
	pop ebx
	pop eax

	mov esp, ebp														;removes locals from the stack
	pop ebp																;restores the base pointer

	ret 4																;cleans up stack
divideArray ENDP

;**********************************************************************
modArray PROC
; Description: Mods each array value by a user entered divisor. 
; Receives: OFFSET of array, TYPE of array, LENGTHOF array
; Requires: User entered divisor
; Returns: Remainder in edx, each then put into [esi] array point
;**********************************************************************

	ENTER 4,0															;creates a stack frame

	push eax															;following "push" operations save the registers
	push ebx
	push ecx
	push edx
	push esi

	call crlf
	mov edx, OFFSET divPrompt											;moves the divPrompt string into edx for printing
	call WriteString
	call ReadInt
	mov [EBP-4], eax													;parameter holds the divisor
	
	mov esi, [EBP+16]													;explicit stack parameter: array offset
	mov ebx, [EBP+12]													;explicit stack parameter: array type
	mov ecx, [EBP+8]													;explicit stack parameter: length of the array
	L4:																	;loops for all the elements in the array
		mov eax, 0														;clears eax to hold each new value	
		mov eax, [esi]													;moves value in array point at eax for division
		cdq																;convert doubleword to quadword: extends sign bit
		mov ebx, [EBP-4]												;moves the user entered value into ebx for division
		idiv ebx														;divides the value in user entered value by the array point
		mov [esi], edx													;saves the resulting division (remainder portion) to the array point
		add esi, [EBP+12]												;increments esi to the next array value
	loop L4

	mov edx, OFFSET completed											;moves offset of "completed" into edx for printing
	call WriteString
	call crlf

	pop esi																;following "pop" operations restore the registers
	pop edx
	pop ecx
	pop ebx
	pop eax

	LEAVE																;terminates the stack frame

	ret 
modArray ENDP

;**********************************************************************
printArray PROC
; Description: Prints out the value of each array point. 
; Receives: OFFSET of array, TYPE of array, LENGTHOF array
; Returns: Array point(esi) in eax, each is then printed 
;**********************************************************************

	arrayTemp	EQU[EBP+16]												;symbolic constant: for array offset
	arrayType	EQU[EBP+12]												;symbolic constant: for array type
	lengthArray	EQU[EBP+8]												;symbolic constant: for the length of the array

	push ebp															;save base pointer
	mov ebp, esp														;base of stack frame

	push eax															;following "push" operations save the registers
	push ebx
	push ecx
	push esi

	call crlf
	mov al, '{'															;move '{' into al for printing
	call WriteChar

	mov esi, arrayTemp													;array offset
	mov ebx, arrayType													;doubleword format
	mov ecx, lengthArray												;sets to loop for the number of elements in the array
	L5:																	;loops for all the elements in the array
		mov eax, [esi]													;moves value in array point at eax for printing
		call WriteInt													
		add esi, ebx													;increments esi by ebx (type of array)
		mov al, ','														;move ',' into al for printing
		call WriteChar
	loop L5

	mov al, '}'															;move '}' into al for printing
	call WriteChar
	
	call crlf
	mov edx, OFFSET completed											;moves offset of "completed" into edx for printing
	call WriteString
	call crlf

	pop esi																;following "pop" operations restore the registers
	pop ecx
	pop ebx
	pop eax

	mov esp, ebp														;removes locals from the stack
	pop ebp																;restores the base pointer

	ret
printArray ENDP

;**********************************************************************
genRandomNum PROC, lowerBound2:SDWORD, upperBound2:SDWORD				;creates local variables for passed in values (lowerBound and upperBound)
; Description: Returns a random value based on a lower and upper range.
; Receives: upper and lower bound stack variables
; Returns: random number held in eax
;**********************************************************************
	
	mov eax, upperBound2												;moves the upperBound2 variable to eax for the RandomRange procedure
	sub eax, lowerBound2												;subs the lowerBound2 variable from eax for the RandomRange procedure
	add eax, 1															;adds 1 to eax to be inclusive of the value of upperBound2
	call RandomRange													;returns a random value to eax 

	add eax, lowerBound2												;add lowerBound2 variable to eax to be inclusive of lower range of random

	ret
genRandomNum ENDP

END main
