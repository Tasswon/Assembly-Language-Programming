TITLE QuestionC			(QuestionC.asm)
;DESCRIPTION: The program calculates the following formula using signed operands: val1 = (val2 / val3) * (val1 + val2)

INCLUDE Irvine32.inc

.data
val1		DWORD	?								;val1 is the final answer and a variable in the problem
val2		DWORD	?
val3		DWORD	?

prompt1	BYTE	"Enter a value for val1: ", 0
prompt2	BYTE	"Enter a value for val2: ", 0
prompt3	BYTE	"Enter a value for val3: ", 0
answer	BYTE	"The answer is: ", 0

.code
main PROC

mov eax, 0

mov edx, OFFSET prompt1								;moves prompt1 into edx to prompt user for val1 input
call WriteString
call ReadInt
mov val1, eax										;saves the user entered value to the val1 variable	

mov edx, OFFSET prompt2								;moves prompt2 into edx to prompt user for val2 input
call WriteString
call ReadInt
mov val2, eax										;saves the user entered value to the val2 variable	

mov edx, OFFSET prompt3								;moves prompt3 into edx to prompt user for val3 input
call WriteString
call ReadInt
mov val3, eax										;saves the user entered value to the val3 variable	

mov ebx, val1										;moves val1 to ebx for addition operation
add ebx, val2										;add val2 to ebx (val1)

mov edx, 0											;clears the edx register
mov eax, val2										;moves val2 into eax for division operation
cdq													;extends eax into edx (signed divison requirement)
mov ecx, val3										;moves val3 into ecx for division operation
idiv ecx											;does signed division operation between eax (val2) and ecx (val3)

imul ebx											;multiplies the answer from the division (eax) by ebx
jo printhex											;if the answer is spills into the edx register it jumps to printhex

mov val1, eax										;moves val1 into eax for printing

mov edx, OFFSET answer								;moves the answer string into edx for printing
call WriteString

mov eax, val1										;moves val1 (final answer) into eax for printing
call WriteInt
call crlf
jmp over											;jumps to end of the program once the value is printed


printhex:											;used if the answer is contained in both eax and edx
	push edx										;saves the edx register (upper portion of the answer)
	mov edx, OFFSET answer							;moves the answer string string into edx for printing
	call WriteString	
	pop edx											;pops the answer back into edx for printing 

	xchg edx, eax									;exchanges the edx and eax registers so the upper portion of the answer prints
	call WriteHex
	xchg edx, eax									;exchanges the edx and eax registers so the lower portion of the answer prints
	call WriteHex									;prints the value as a hex
	call crlf

over:

	exit
main ENDP
END main