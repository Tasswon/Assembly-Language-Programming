TITLE Shift Three Mem Bytes					(QuestionA.asm)
;NAME: Joseph Tassone
;DESCRIPTION: Shifts all three memory bytes to the right by 1 position

INCLUDE Irvine32.inc

.data
byteArray	BYTE	81h, 20h, 33h			;byte array whose values will be shifted

.code
main PROC

mov esi, OFFSET byteArray					;mov the OFFSET of byteArray to esi (indirect addressing)
mov ecx, LENGTHOF byteArray					;set ecx for the number of elements in the byteArray
L1:											;loops all the insturctions based on the array size
	mov eax, 0								;clear the eax register

	mov al, [esi]							;mov the element at the array point into the al register
	SHR al, 1								;shift the element in the al register 1 bit position

	inc esi									;increment esi to point to the next element in the array

	mov ebx, TYPE byteArray					;sets the size of the hex value that will be printed
	call WriteHexB							;prints the new shifted hex value
	call crlf								;moves to a new line
loop L1

	exit
main ENDP
END main