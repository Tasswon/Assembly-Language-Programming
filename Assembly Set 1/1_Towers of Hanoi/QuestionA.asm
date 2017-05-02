TITLE QuestionA					(QuestionA.asm)
; The program recursively solves the Towers of Hanoi problem 
; using the users input value.

INCLUDE Irvine32.inc

.data
prompt1	BYTE	"Enter the number of disks: ", 0
disk	BYTE	"Disk ", 0
from	BYTE	" from ", 0
too		BYTE	" to ",0

n		DWORD	?										;the number of disks that will be used
forr	BYTE	'A'										
spare	BYTE	'B'
to		BYTE	'C'

.code
main PROC

mov edx, OFFSET prompt1									;prints prompt 1
call WriteString

call ReadDec											;allows user to enter n value
mov n, eax

mov ecx, n												;sets n to ecx
mov dl, forr											;sets forr(A) to dl
mov bl, spare											;sets spare(B) to bl
mov bh, to												;sets spare(C) to bh

call towers												;calls the towers proc

	exit
main ENDP


;--------------------------------------------------------
 towers PROC
; Recursively solves the tower problems for user n value
; Receives: ECX = value of n
; dl = for/A value, bl = spare/B value, bh = to/C value
; Returns: N/A
;--------------------------------------------------------

;base case
cmp ecx, 1												;continues recursion if ecx is not equal to 1
jne continue											;jumps to continue if above condition is met

push edx												;adds edx value to stack, for later use in dl

mov edx, OFFSET disk									;prints "Disk"
call WriteString

mov eax, ecx											;moves the value of ecx (n) to eax for printing
call WriteDec

mov edx, OFFSET from									;prints "from"
call WriteString

pop edx													;pops the stack value to edx for use in dl
mov al, dl												;moves the value in dl to al for printing
call WriteChar

mov edx, OFFSET too										;prints "to"
call WriteString

mov al, bh												;moves the value of bh to al for printing
call WriteChar

call crlf

	ret													;ends the proc if the base case is met

;not base case
continue:
	pushad												;saves the register values
	dec ecx												;decrements ecx (n)
	xchg bl, bh											;exchanges the value of bl (spare) and bh (to)

	;recursive call
	call towers											;calls the towers proc (recursive call)
	popad												;pop the register values from the stack
	push edx											;adds edx value to stack, for later use in dl

	mov edx, OFFSET disk								;prints "Disk"
	call WriteString

	mov eax, ecx										;moves the value of ecx (n) to eax for printing
	call WriteDec

	mov edx, OFFSET from								;prints "from"
	call WriteString

	pop edx												;pops the stack value to edx for use in dl
	mov al, dl											;moves the value in dl to al for printing
	call WriteChar

	push edx											;adds edx value to stack, for later use in dl
	mov edx, OFFSET too									;prints "to"
	call WriteString

	mov al, bh											;moves the value of bh to al for printing
	call WriteChar

	call crlf

	pop edx												;pops the stack value to edx for use in dl
	pushad												;saves the register values
	dec ecx												;decrements ecx (n)
	xchg dl, bl											;exchanges the value of dl(from) and bl(spare)
	call towers											;recursive call of towers proc
	popad												;pop the register values from the stack

	ret
towers ENDP
END main



