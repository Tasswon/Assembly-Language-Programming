TITLE QuestionB		(Question.asm)
;NAME: Joseph Tassone
;DESCRIPTION: The program calculates the following formula using unsigned operands: val1 = (val2 * val3) / (val4 - 3)

INCLUDE Irvine32.inc

.data
val1		DWORD	?								;will hold the answer to the formula					
val2		DWORD	?								
val3		DWORD	?								
val4		DWORD	?								
remainder	DWORD	?								;will hold the remainder after the division has been calculated

prompt1	BYTE	"Enter a value for val2: ", 0
prompt2	BYTE	"Enter a value for val3: ", 0
prompt3	BYTE	"Enter a value for val4: ", 0
answer	BYTE	"The answer is: ", 0
ranswer	BYTE	"The remainder is: ", 0

.code
main PROC

mov eax, 0											;clears the eax register

mov edx, OFFSET prompt1								;moves prompt1 into edx to prompt user for val2 input
call WriteString		
call ReadDec
mov val2, eax										;saves the user entered value to the val2 variable	

mov edx, OFFSET prompt2								;moves prompt2 into edx to prompt user for val3 input
call WriteString
call ReadDec
mov val3, eax										;saves the user entered value to the val3 variable

mov edx, OFFSET prompt3								;moves prompt3 into edx to prompt user for val4 input
call WriteString
call ReadDec
mov val4, eax										;save the user entered value to the val4 variable

mov edx, 0											;clears the edx register (previous prompt still inside)

mov eax, val2										;stores val2 into eax for multiplication	
mov ebx, val3										;stores val3 into eax for multiplication			
mul ebx												;multiplies the values in eax (val2) by ebx (val3)

mov ecx, val4										;moves val4 into ecx for subtraction
sub ecx, 3											;subtraction ecx (val4) by 3

div ecx												;divides the total from the previous multiplication (eax) by ecx
mov val1, eax										;moves the calculated answer to var1
mov remainder, edx									;moves the remainder (edx) from the division to the remainder variable

mov edx, OFFSET answer								;moves the answer string into edx for printing 
call WriteString
mov eax, val1										;move the answer into eax for printing
call WriteDec								
call crlf

mov edx, OFFSET ranswer								;moves the ranswer string into edx for printing
call WriteString
mov eax, remainder									;move the remainder into eax for printing
call WriteDec
call crlf

	exit
main ENDP
END main