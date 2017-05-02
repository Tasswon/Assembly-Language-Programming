TITLE Change String Casing				(QuestionB.asm)
; A user entered string has its even letters turned into capitals
; and it's odd letters turned into lowercase. Both renditions are
; printed to an output file.

INCLUDE Irvine32.inc

.data
prompt	BYTE "Enter string of up to 250 characters: ",0
before	BYTE "Unmodified: ",0
after	BYTE "Modified: ",0
string1 BYTE 250 DUP(?)													;an empty string (for the user) for 250 characters
count	DWORD	?														;used for ecx preservation
wordLength DWORD	?													;will hold string1 length for file entering

space	BYTE 13d, 10d													;used for adding a new line in the file

file	BYTE "output.txt",0												;output file for the string 
filehandle	DWORD ?														;filehandler for the 

.code
main PROC

mov edx,OFFSET prompt													;prints prompt
call WriteString

mov edx,OFFSET string1													;moves the empty string to edx
mov ecx, LENGTHOF string1												
call ReadString															;allows user to enter a string
mov	wordLength, eax														;saves the length of the string to wordlength

mov edx, OFFSET file													;moves the file (title) to edx
call CreateOutputFile													;creates the file
mov filehandle, eax														;moves the eax value to filehandle	

mov eax, filehandle														;resets eax with filehandle
mov edx, OFFSET string1													;moves string1 to edx
mov ecx, wordLength														;sets the length of the string to ecx
call WriteToFile														;prints string1 to the file	

call conversion															;calls the conversion PROC

	exit
main ENDP

;----------------------------------------------------------
 conversion PROC
; Converts the user entered string to alternating capital
; and lower case values (ignores spaces and non letters)
; Receives: Most items (with the exception of string1) are
; modified within the proc itself. Only items received are
; the file and string1.
; Returns: Converted string1, "output.txt" with new string1
;----------------------------------------------------------

mov edx,OFFSET before													;moves before to edx for printing
call WriteString

mov edx,OFFSET string1													;moves string1 to edx for printing
call WriteString
call crlf

mov ecx,LENGTHOF string1												;sets ecx to the length of string1
mov esi,OFFSET string1													;set esi for string progression
mov eax, 0																;clears eax register

L1:																		;loop is used for going through each character of the string
	;saves the ecx count
	mov count, ecx														;preserves the value of ecx to count


;checks if the value is a digit, space, symbol
	mov al, BYTE PTR [esi]												;moves value of esi (part of string) to al for comparing
		
	cmp al, 65															;add ASCII 65 to al
	jl L3																;jumps to L3 if less than 'A' ASCII value

	cmp al, 90															;add ASCII 90 to al
	jg lowercase														;jumps to lowercase if greater that 'Z' ASCII value
	jmp L4																;jumps to L4 if confirmed upper case letter

lowercase:
	cmp al, 97															;add ASCII 97 to al
	jl L3																;jumps to L3 if less that 'a' ASCII value

	cmp al, 122															;add ASCII 122 to al
	jg L3																;jumps to L3 if less that 'z' ASCII value

L4:																
	;checks if the ecx value is odd
	and ecx, 1b															;ands the value in ecx with 1b 
	cmp ecx, 1b															;checks if ecx is an odd number or not
	jne L2																;jumps to L2 if it is

	;converts value to capital version
	mov ecx, count														;moves count back into ecx
	and BYTE PTR [esi], 11011111b										;ands the string value at esi to a capital version
	jmp L3																;jumps to L3 once conversion is complete

	;converts value to lowercase version
L2:
	mov ecx, count														;moves count back int ecx
	or BYTE PTR [esi], 00100000b										;ors the string value at esi to the lowercase version

	;increments the esi value and resets ecx
L3:
	mov ecx, count														;moves count back into ecx
	inc esi																;moves to the next esi value in the chain
loop L1

mov edx,OFFSET after													;moves after to edx for printing
call WriteString

mov edx,OFFSET string1													;moves string1 (converted) to edx for printing
call WriteString
call crlf

;prints the string to a file
mov eax, filehandle														;moves filehandle back into eax
mov edx, OFFSET space													;adds space to edx (makes new line in file)
mov ecx, 2																;sets ecx to 2
call WriteToFile														;writes the new line to the file

mov eax, filehandle														;moves filehandle back into eax
mov edx, OFFSET string1													;moves string1 (converted) in edx 
mov ecx, wordLength														;adds wordlength to ecx for full string progression
call WriteToFile														;writes string1 to the file

	ret
conversion ENDP

END main
