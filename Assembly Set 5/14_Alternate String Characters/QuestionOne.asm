TITLE Alternate String Characters				(QuestionOne.asm)
;DESCRIPTION: Program takes two source strings and joins the two together
;by alternating characters one at a time from each string.

INCLUDE Irvine32.inc

StringMerge PROTO, str1:PTR BYTE, strLength1:DWORD, str2:PTR BYTE, strLength2:DWORD, str3:PTR BYTE		;creates a prototype for StringMerge
.data
	prompt1 BYTE "Enter string 1: ", 0						;section holds the string variables for prompts and final messages
	prompt2 BYTE "Enter string 2: ", 0						
	msg1	BYTE "Merged String 1 and String 2: ", 0
	msg2	BYTE "Merged String 2 and String 1: ", 0

	string1 BYTE 250 DUP(0)									;sections has the variables for user inputed strings and their lengths
	strLen1 DWORD ?
	string2 BYTE 250 DUP(0)
	strLen2 DWORD ?
	string3 BYTE 250 DUP(?)									;will hold the alternating characters from the user inputted strings
	strLen3 DWORD ?										

.code
main PROC
	mov edx, OFFSET prompt1									;prompts the user for string1 (move's message into edx for printing)
	Call WriteString
	mov edx, OFFSET string1				
	mov ecx, SIZEOF string1
	Call ReadString											;has the user enter string one, which will be stored in "string1"
	mov strLen1, eax										;stroes the length of string1


	mov edx, OFFSET prompt2									;prompts the user for string2 (move's message into edx for printing)
	Call WriteString
	mov edx, OFFSET string2
	mov ecx, SIZEOF string2
	Call ReadString											;has the user enter string two, which will be stored in "string2"
	mov strLen2, eax										;stores the length of string2

	INVOKE StringMerge,										;calls the StringMerge proc
	ADDR string1, strLen1,									;passes the offsets and lengths of String1/String2, and the offset of string3
	ADDR string2, strLen2,
	ADDR string3
	
	mov edx, OFFSET msg1									;moves msg1 into edx for printing 
	call WriteString
	mov edx, OFFSET string3									;moves the alternated string into edx for printing (answer)
	call WriteString
	call Crlf
	
	INVOKE StringMerge,										;calls the StringMerge proc (reverse of previous call, less String3)
	ADDR string2, strLen2,									;passes the offsets and lengths of String1/String2, and the offset of string2 again
	ADDR string1, strLen1,
	ADDR string2

	mov edx, OFFSET msg2									;moves msg2 into edx for priniting
	call WriteString
	mov edx, OFFSET string2									;moves the alternated string into edx for printing (answer)
	call WriteString
	call Crlf

	exit
main ENDP

;*************************************************************************************************
StringMerge PROC, str1:PTR BYTE, strLength1:DWORD, str2:PTR BYTE, strLength2:DWORD, str3:PTR BYTE
LOCAL temp[250]:BYTE														;local variable for temp (will temporarily hold the new string)
; Description: Takes in the offsets of two strings and loops until 
; all the characters from the strings have been added to the new one
; (length of the longest string). 
; Note: the longer string adds remaining characters to the end. 
; Receives: OFFSETS of two strings and their lengths, OFFSET of a third
; Returns: The third string with the alternated values
;*************************************************************************************************

	push eax												;preserves the registers
	push ebx
	push ecx

	mov esi, 0												;clears esi and edi
	mov edi, 0

	mov eax, strLength1										;moves the length of the first string to eax
	cmp eax, strLength2										;compares the lengths of the strings and jumps if the first is above
	ja	str1ecx									
	mov ecx, strLength2										;sets ecx to the length of the second string
	mov ebx, 0												;clears ebx
	jmp continue											;jumps to continue to prevent ecx from changing

	str1ecx:
	mov ecx, strLength1										;if the first string length is greater set it to ecx
	mov ebx, 0												;clears ebx
	continue:
		lea edi, temp										;edi points to temp(local variable) 
		L1:													;loops until ebx equals ecx (length of first of second string)
			cmp ebx, strLength1								;jumps of the first string length is less than or equal to ebx
			jae skip1
			mov esi, str1									;move a letter from the first string into esi
			movsb											;move the letter in esi to edi (temp) and increment
			inc str1										;increment str1 to the next letter
			
			cmp ebx, strLength2								;jumps of the second string length is less than or equal to ebx
			jae skip2
			skip1:
			mov esi, str2									;move a letter from the second string into esi
			movsb											;move the letter in esi to edi (temp) and increment
			inc str2										;increment str2 to the next letter
			skip2:
		
		add ebx, 1											;increments ebx
		cmp ebx, ecx										;sees if ebx is equalto ecx, and jumps to the top if not
		jne L1												

	mov eax, strLength2										;moves the lenght of the second string into eax
	add eax, strLength1										;add the length of the first string into eax

	cld														;clear direction flag (forward)
	mov ecx, eax											;moves the length of the two strings to ecx (rep counter)
	lea esi, temp											;moves the offset of temp to esi (source)
	mov edi, str3											;edi point str3 (target)
	rep movsb												;copy bytes

	pop eax													;restores the registers to their previous values
	pop ebx
	pop ecx

	ret
StringMerge ENDP

END main
