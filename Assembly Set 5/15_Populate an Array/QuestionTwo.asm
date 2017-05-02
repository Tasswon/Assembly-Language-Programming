TITLE Question Two		(QuestionTwo.asm)
;DESCRIPTION: Program takes an empty array and addS values to it 
;by using random numbers, addition, multiplication, and division.

INCLUDE Irvine32.inc

addRowThree PROTO, arrayAddr:PTR WORD, numCols:DWORD, numRows:DWORD					   ;create prototype for addRowThree proc
testPrint PROTO, arrayAddr1:PTR WORD, numCols1:DWORD								   ;create prototype for testPrint proc
																					   
.data																				   
NUM_ROWS = 6																		   ;constant for rows
NUM_COLS = 5																		   ;constant for columns
array SWORD NUM_ROWS*NUM_COLS DUP(?)												   ;empty SWORD 2d-array that will be manipulated
																					   
row1	BYTE	"Random A: ",9d,0													   ;string variables final row prints
row2	BYTE	13d,10d,"Random B: ",9d,0											   ;add a new line (before) and tab (after)
row3	BYTE	13d,10d,"C = A + B: ",9d,0											   
row4	BYTE	13d,10d,"D = A * C: ",9d,0											   
row5	BYTE	13d,10d,"E = D / B: ",9d,0											   
row6	BYTE	13d,10d,"F = D % B: ",9d,0											   
																					   
.code																				   
main PROC																			   
	call Randomize																	   ;randomizes seed for random numbers
																					   
	mov esi, OFFSET array															   ;moves OFFSET of array into esi for randomizeTwoRows proc
	mov ecx, NUM_COLS																   ;moves column amount into ecx for randomizeTwoRows proc
	mov edx, NUM_ROWS																   ;moves row amount into edx for randomizeTwoRows proc																				   
	call randomizeTwoRows															   
																					   
	push OFFSET array																   ;push OFFSET of array into esi for printHex proc
	push NUM_COLS																	   ;push column amount into ecx for printHex proc
	push NUM_ROWS																	   ;push row amount into edx for printHex proc	
	call printHex																	   
																					   
	INVOKE addRowThree,																   ;calls the addRowThree proc
	ADDR array,																		   ;pass the OFFSET of array, and column/row amount
	NUM_COLS, NUM_ROWS 																   
																					   
	push OFFSET array																   ;push OFFSET of array into esi for multiplyRow proc
	push NUM_COLS																	   ;push column amount into ecx for multiplyRow proc
	push NUM_ROWS																	   ;push row amount into edx for multiplyRow proc
	call multiplyRow																   
																					   
	push OFFSET array																   ;push OFFSET of array into esi for divideRow proc
	push NUM_COLS																	   ;push column amount into ecx for divideRow proc
	push NUM_ROWS																	   ;push row amount into edx for divideRow proc
	call divideRow																	   
																					   
	INVOKE testPrint,																   ;calls the testPrint proc
	ADDR array,																		   ;pass the OFFSET of array, and column amount
	NUM_COLS																		   
																					   
	call crlf																		   
																					   
	push OFFSET array																   ;push OFFSET of array into esi for printHex proc
	push NUM_COLS																	   ;push column amount into ecx for printHex proc
	push NUM_ROWS																	   ;push row amount into edx for printHex proc
	call printHex																	   
																					   
	exit																			   
main ENDP																			   

;*************************************************************************************************																				   
randomizeTwoRows PROC																   
; Description: Adds random values to the first two rows in a 2d array, and puts 0 into the rest.
; Receives: esi (array Offset), edx (number of rows), ecx (number of columns)
; Returns: N/A
;*************************************************************************************************	

	push ecx																		   ;preserves the registers (column, row, OFFSET)
	push edx																		   
	push esi																		   
																					   
	mov eax, ecx																	   ;move column amount into eax
	mul edx																			   ;multiply it by the row amount
	mov ebx, eax																	   ;total array length is preserved into ebx
																					   
	mov al, 0																		   ;move zero to al
	mov edi, esi																	   ;edi points to target (array point)
	mov ecx, ebx																	   ;mov to ecx to complete task for the length of the array
	cld 																			   ;clear direction flag (forward)
	rep stosw																		   ;repeat, fills each array value to zero
																					   
	pop esi																			   ;restore the offset and colulm/row amounts
	pop edx																			   
	pop ecx																			   
																					   
	mov eax, 2																		   ;move 2 into eax
	mul ecx																			   ;multiply ecx by 2 to ensure we go for the length of two rows
																					   
	mov ecx, eax																	   ;mov eax (multiplication answer) to ecx
		L1:																			   ;loops for two rows 
			call randomNum															   ;generates a random value
			mov [esi], ax															   ;moves the random value into the array point
			add esi, type word														   ;increments esi to the next array spot
		loop L1																		   
	ret 																			   
randomizeTwoRows ENDP																   

;*************************************************************************************************																					   
randomNum PROC
; Description: Generates a random number between -200 and 300
; Receives: Nothing (uses ebx and eax for high and low range values)
; Returns: random number in eax
;*************************************************************************************************	
																		   
	push ebx																		   ;preserve ebx (array length)
	mov eax, 0																		   ;clears eax 
																					   
	mov ebx, -200																	   ;puts the lower value (-200) into ebx
	mov eax, 300																	   ;puts the higher value (300) into eax
	sub eax, ebx																	   ;subs lower value from the higher value
	add eax, 1																		   ;adds 1 to eax to be inclusive of highest value
	call RandomRange																   ;generates a random value in the range
																					   
	add eax, ebx																	   ;adds lowest value to eax to fix the range
																					   
	pop ebx																			   ;restore ebx
ret																					   
randomNum ENDP																		   

;*************************************************************************************************																					   
printHex PROC
; Description: Prints out all the values of a 2d array in hex form
; Receives: stack paramaters (array offset, number of rows/columns)
; Returns: N/A (prints each value of the array) 
;*************************************************************************************************	
																		   
	push ebp																		   ;preserves the base pointer
	mov ebp, esp																	   ;sets the base of stack frame
																					   
	mov esi, [EBP + 16]																   ;moves the offset of the array into esi
	mov ecx, [EBP + 8]																   ;moves number of rows into ecx for loop
		L2:																			   
			push ecx																   ;preserves the first loop counter
			mov ecx, [EBP + 12]														   ;moves number of rows into ecx for loop
			L3: 																	   
				mov eax, [esi]														   ;moves the point in the array to eax
				mov ebx, TYPE SWORD													   ;moves the SWORD value to ebx
				call WriteHexB														   ;prints out the HEX number in WORD format
				add esi, TYPE SWORD													   ;increments esi to the next point
				mov al, ","															   
				call WriteChar														   ;prints a ',' between each number
			loop L3																	   
			call crlf																   
			pop ecx																	   ;restores the loop counter
		loop L2																		   
																					   
	mov esp, ebp																	   
	pop ebp																			   ;restores the base pointer
																					   
	call crlf																		   
	ret 12																			   ;removes parameters from the stack
printHex ENDP																		   

;*************************************************************************************************																					   
addRowThree PROC, arrayAddr:PTR WORD, numCols:DWORD, numRows:DWORD
; Description: Adds the first row values with the second row values to get the third row values.
; Receives: array offset, number of rows/columns (passed by invoke)
; Returns: N/A (fills the third row with values)
;*************************************************************************************************	
					   
																					   
	mov eax, numCols																   ;moves number of Columns to eax
	mov ebx, TYPE SWORD																   ;moves the array type to ebx
	mul ebx																			   ;multiplies number of columns by the array type
	mov ebx, eax																	   ;total array length is preserved into ebx
																					   
	mov ecx, numCols																   ;loop counter set to number of columns
	mov esi, arrayAddr																   ;move the off
	mov edi, 0																		   ;sets edi to the first row
	L4:																				   
		movsx eax, SWORD PTR [esi + edi]											   ;moves the value from the first row to eax
		add edi, ebx																   ;sets edi to the second row
																					   
		movsx edx, SWORD PTR [esi + edi]											   ;move value from the second row into edx
		add eax, edx																   ;adds the first row and second row value together
																					   
		add edi, ebx																   ;progress to the third row
		mov [esi + edi], ax															   ;mov the added value ax to the third row point
		add esi, TYPE SWORD															   ;increment esi to the next point in the column
																					   
		mov edi, 0																	   ;sets edi to the first row
	loop L4																			   
																					   
	ret																				   
addRowThree ENDP																	   

;*************************************************************************************************																				   
multiplyRow PROC
; Description: Mutiplies the first row values with the third row values to get the fourth row values.
; Receives: stack paramaters (array offset, number of rows/columns)
; Returns: N/A (fills the fourth row with values)
;*************************************************************************************************	
																	   
	addrArray	EQU[EBP + 16]														   ;symbolic constant: offset for array
	numCols		EQU[EBP + 12]														   ;symbolic constant: parameter for number of columns
	numRows		EQU[EBP + 8]														   ;symbolic constant: parameter for number of rows
	rowJump		EQU[EBP - 4]														   ;symbolic constant: variable for rowJump (go to next row)
																					   
	ENTER 4,0																		   ;sets the base of stack frame, and initialies local variables
																					   
	mov eax, numCols																   ;move number of columns to eax
	mov ebx, TYPE SWORD																   ;move the array type to ebx
	mul ebx																			   ;multiply the array type by the number of columns
	mov rowJump, eax																   ;rowJump allows you to move to the next row
																					   
	mov ecx, numCols																   ;sets the loop counter for the number of columns
	mov esi, addrArray																   ;sets esi for the offset of the array
	mov edi, 0																		   ;makes edi point to the first row
	L5:																				   
		movsx eax, SWORD PTR [esi + edi]											   ;moves the value from the first row to eax
		add edi, rowJump															   
		add edi, rowJump															   ;move to row three (two adds)
																					   
		movsx ebx, SWORD PTR [esi + edi]											   ;moves the value from the third row to ebx
		mul ebx																		   ;multiply row one value by row three value 
																					   
		add edi, rowJump															   ;move to row four
		mov [esi + edi], ax															   ;move the multiplied value into row four point
		add esi, TYPE SWORD															   ;increment esi to the next column point
																					   
		mov edi, 0																	   ;reset edi to the first row
	loop L5																			   
																					   
	mov ecx, numCols																   ;sets the loop counter for the number of columns
	mov esi, addrArray																   ;sets esi for the offset of the array
	mov edi, 0																		   
	add edi, rowJump																   
	add edi, rowJump																   
	add edi, rowJump																   ;sets edi for the fourth row	(3 adds)															   
	L6:																				   
		movsx eax, SWORD PTR [esi + edi]											   ;moves the value from the fourth row to eax
		mov ebx, 2																	   ;mov 2 into ebx
		cwd																			   ;convert word to doubleword for division
		idiv bx																		   ;divide fourth row point by 2
		mov [esi + edi], ax															   ;move the divided value into the row four point
		add esi, TYPE SWORD															   ;increment esi to the next column point
	loop L6																			   
																					   
	LEAVE																			   ;clears the stack frame, and cleans up local variables
	ret 12																			   ;clears the parameters from the stack
multiplyRow ENDP																	   

;*************************************************************************************************																				   
divideRow PROC
; Description: Divides the fourth row values by the second row values, and puts the quotients into
; the fifth row values and the remainders in the sixth row values.
; Receives: stack paramaters (array offset, number of rows/columns)
; Returns: N/A (fills the fifth and sixth rows with values)
;*************************************************************************************************
																	   
	;addrArray		EQU[EBP + 16]													   
	;numCols		EQU[EBP + 12]													   
	;numRows		EQU[EBP + 8]													   
	;rowJump		EQU[EBP - 4]													   
																					   
	ENTER 4,0																		   ;sets the base of stack frame, and initialies local variables
																					   
	mov eax, [EBP + 12]																   ;move number of columns into eax
	mov ebx, TYPE SWORD																   ;mov the array type into ebx
	mul ebx																			   ;multiply number of columns by array type
	mov [EBP - 4], eax																   ;mov rowJump value into local variable
																					   
	mov ecx, [EBP + 12]																   ;set loop counter to the number of columns
	mov esi, [EBP + 16]																   ;move the offset of the array into esi
	L7:																				   
		mov edi, 0																	   
		add edi, [EBP - 4]															   
		add edi, [EBP - 4]															   
		add edi, [EBP - 4]															   ;points edi to the fourth row (3 adds)
		movsx eax, SWORD PTR [esi + edi]											   ;moves the value from the fourth row to eax
																					   
		mov edi, 0																	   ;point to row one 
		add edi, [EBP - 4]															   ;point edi to second row
																					   
		movsx ebx, SWORD PTR [esi + edi]											   ;moves the value from the second row to ebx
		cwd																			   ;convert word to doubleword for division
		idiv bx																		   ;divide the fourth row by the second row value																		   ;
																					   
		add edi, [EBP - 4]															   
		add edi, [EBP - 4]															   
		add edi, [EBP - 4]															   ;points edi to the fifth row (3 adds)
																					   
		mov [esi + edi], ax															   ;move the quotient value into row five point
																					   
		add edi, [EBP - 4]															   ;points edi to the sixth row (1 add)
		mov [esi + edi], dx															   ;move the remainder value into row six point
																					   
		add esi, TYPE SWORD															   ;increment esi to the next column 
	loop L7																			   
																					   
	LEAVE																			   ;clears the stack frame, and cleans up local variables
	ret																				   
divideRow ENDP																		   

;*************************************************************************************************																				   
testPrint PROC, arrayAddr1:PTR WORD, numCols1:DWORD
; Description: Prints out each value in the array in decimal format and procedes the row prints with
; the string explaining how the values were achieved. 
; Receives: array offset, number of columns (passed by invoke)
; Returns: N/A (prints each value of the array) 
;*************************************************************************************************									   
																					   
	mov ecx, numCols1																   ;sets loop counter for the number of columns
	mov esi, arrayAddr1																   ;moves the offset of the array to esi
	mov edx, OFFSET row1															   ;moves the row1 string to edx for printing
	call WriteString																   
	L8:																				   
		movsx eax, SWORD PTR [esi]													   ;moves the value from the first row to eax
		call WriteInt																   ;prints the value in eax
		mov al, 9d																	   ;adds a tab after the number
		call WriteChar																   
		add esi, TYPE SWORD															   ;increments esi to the next column value
	loop L8																			   
																					   
	mov ecx, numCols1																   ;sets loop counter for the number of columns
	mov edx, OFFSET row2															   ;moves the row2 string to edx for printing
	call WriteString																   
	L9:																				   
		movsx eax, SWORD PTR [esi]													   ;moves the value from the second row to eax
		call WriteInt																   ;prints the value in eax
		mov al, 9d																	   ;adds a tab after the number
		call WriteChar																   
		add esi, TYPE SWORD															   ;increments esi to the next column value
	loop L9																			   
																					   
	mov ecx, numCols1																   ;sets loop counter for the number of columns
	mov edx, OFFSET row3															   ;moves the row3 string to edx for printing
	call WriteString																   
	L10:																			   
		movsx eax, SWORD PTR [esi ]											   		   ;moves the value from the third row to eax
		call WriteInt																   ;prints the value in eax
		mov al, 9d																	   ;adds a tab after the number
		call WriteChar																   
		add esi, TYPE SWORD															   ;increments esi to the next column value
	loop L10																		   
																					   
	mov ecx, numCols1																   ;sets loop counter for the number of columns
	mov edx, OFFSET row4															   ;moves the row4 string to edx for printing
	call WriteString																   
	L11:																			   
		movsx eax, SWORD PTR [esi]											   		   ;moves the value from the fourth row to eax
		call WriteInt																   ;prints the value in eax
		mov al, 9d																	   ;adds a tab after the number
		call WriteChar																   
		add esi, TYPE SWORD															   ;increments esi to the next column value
	loop L11																		   
																					   
	mov ecx, numCols1																   ;sets loop counter for the number of columns
	mov edx, OFFSET row5															   ;moves the row5 string to edx for printing
	call WriteString																   
	L12:																			   
		movsx eax, SWORD PTR [esi]											   		   ;moves the value from the fifth row to eax
		call WriteInt																   ;prints the value in eax
		mov al, 9d																	   ;adds a tab after the number
		call WriteChar																   
		add esi, TYPE SWORD															   ;increments esi to the next column value
	loop L12																		   
																					   
	mov ecx, numCols1																   ;sets loop counter for the number of columns
	mov edx, OFFSET row6															   ;moves the row6 string to edx for printing
	call WriteString																   
	L13:																			   
		movsx eax, SWORD PTR [esi]											   		   ;moves the value from the sixth row to eax
		call WriteInt																   ;prints the value in eax
		mov al, 9d																	   ;adds a tab after the number
		call WriteChar																   
		add esi, TYPE SWORD															   ;increments esi to the next column value
	loop L13																		   

	call crlf
	ret
testPrint ENDP

END main