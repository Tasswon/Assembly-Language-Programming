TITLE Linking Array Items				(QuestionC.asm)
; Uses a starting point to travel the index of a char array.
; Compares it's point with the value in the index array, and
; progresses to the next character based on this.

INCLUDE Irvine32.inc

.data
start	BYTE	2																		;starting index value
letters	BYTE	'Z', 'X', 'A', 'P', 'Q', 'S', 'I', 'U', 'M', 'K', 'H', 'R', 'L',		;char array 
				'J', 'C', 'E', 'G', 'Y', 'N', 'O', 'V', 'D', 'F', 'B', 'W', 'T'	
index	DWORD	0, 17, 23, 4, 11, 25, 13, 20, 18, 12, 6, 5, 8, 9, 21, 22, 10, 0,		;index array
				19, 3, 24, 15, 16, 14, 1, 7												
updateI	BYTE	26 DUP (?)																;updated index array
newChar BYTE	26 DUP (?)																;empty array for copy

.code
main PROC

mov esi, 0																				;set esi to 0 (start of the index array)
mov edx, 0																				;sets edx to 0 (start of the updateI array)
mov ecx, 26																				;set ecx (loop count) to 26 (elements in index array)
L1:																						;transfers DWORD array to BYTE array
	mov eax, index[esi]																	;transfers index array value to eax
	mov updateI[edx], al																;transfers the al portion of the eax to edx point of updateI

	add esi, 4																			;increments index array (esi val)
	inc edx																				;increments updateI array (edx val)		
loop L1


mov ecx, 26																				;set ecx (loop count) to 26 (elements in index array)
movzx esi, start																		;moves start index point to esi (pads it)
mov edx, 0																				;set edx to 0 (first item)	
L2:																						;array sorts the indexes and transfers values to newChar array
	mov al, letters[esi]																;move the point in the letters array to al
	mov newChar[edx], al																;transfer al value to point in the newChar array
	
	mov al, updateI[esi]																;move the index point to al
	movzx esi, al																		;moves al to esi (pads it)
	inc edx																				;increments edx to go to the next point in newChar
loop L2

mov ecx, 26																				;set ecx to 26 for loop count
mov esi, 0																				;set esi to 0 (first item)	
L3:																						;loop is used to print the newChar array	
	mov al, newChar[esi]																;mov the value in newChar array to al for printing
	call WriteChar																		;prints the character stored in al
	inc esi																				;increments esi for the next array value
loop L3

call crlf
						

	exit
main ENDP
END main



