TITLE Calculate nMody					(QuestionE.asm)
;DESCRIPTION: The program calculates x = n mod y , using only SUB, MOV, AND

INCLUDE Irvine32.inc

.data
prompt1 BYTE "Enter a value for n: ",0
prompt2 BYTE "Enter a value for y: ",0
answer	BYTE "The answer is: ",0
xval	DWORD 1

.code
main PROC

mov edx, OFFSET prompt1						;moves prompt1 into edx to prompt user for n value
call WriteString
call ReadDec
mov ebx, eax								;saves the user entered value to ebx for AND operation

mov edx, OFFSET prompt2						;moves prompt2 into edx to prompt user for y value
call WriteString
call ReadDec

sub eax, 1									;subtracts the value in eax (y) by 1
and eax, ebx								;ANDs the value of n and the subtracted value of y

mov edx, OFFSET answer						;moves the answer string into edx for answer printing
call WriteString
call WriteDec								;prints the remainder (the answer)
call crlf

	exit
main ENDP
END main