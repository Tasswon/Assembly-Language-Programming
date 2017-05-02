TITLE Display in Decimal Format						(QuestionD.asm)
;DESCRIPTION: The program displays an unsigned 8-bit binary value in decimal format 

INCLUDE Irvine32.inc

.data

.code
main PROC
mov ax, 0					;clears the ax register 

mov al, 00011000b			;moves the binary value into al for the procedure
cmp al, 99					;prevents a number over 99 from being used
jg invalid
cmp al, 0					;prevents a number below 0 from being used
jl invalid

call showDecimal8			;calls procedure that will display the value above in decimal format

invalid:

	exit
main ENDP

;---------------------------------------------------------------------------
; showDecimal8
; 
; Divides a number in al by 10, and then prints the two halfs (answer and 
; remainder) once they've been converted to chars.
; Receives: AL
; Returns: Nothing (prints al and ah)
;---------------------------------------------------------------------------

showDecimal8 PROC
	mov bl, 10				;moves 10 into the bl register for the division
	div bl					;divides the value in al by 10

	add ah, '0'				;makes it so the first part of the number can be printed as a char
	add al, '0'				;makes it so the second part of the number can be printed as a char

	call WriteChar			;prints the first number portion of the the answer
	xchg al, ah				;exchanges the ah and al registers so the second number can be printed
	call WriteChar			;prints the second number of the answer

	call crlf

	ret
showDecimal8 ENDP

END main