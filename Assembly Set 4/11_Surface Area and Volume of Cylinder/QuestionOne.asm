TITLE Surface Area and Volume of Cylinder			(QuestionOne.asm)
;DESCRIPTION:  Reports the Surface Area of a single end, the area of the
;side, the total surface area (both ends and the side) of the cylinder
;and the volume of the cylinder.

INCLUDE Irvine32.inc

.data
promptRadius	BYTE	"Enter a radius: ",0				;following are prompts for entering data and displaying answers
promptHeight	BYTE	"Enter a height: ",0
endAnswer		BYTE	"The end surface area is :", 0
sideAnswer		BYTE	"The side surface area is: ",0
fullAnswer		BYTE	"The full surface area is: ",0
volumeAnswer	BYTE	"The volume is: ",0


radius			REAL4	?									;following hold the variables, and answers (areas, volume)
height			REAL4	?
surfaceEnds		REAL4	?
surfaceSide		REAL4	?
zeroPoint		REAL4	0.0
two				REAL4	2.0
temp			REAL4	?									;used to clear the stack (pop)

.code
main PROC

start: 
	finit													;initializes the FPU

	mov edx, OFFSET promptRadius							;moves the prompt into edx for printing
	call WriteString
	call ReadFloat											;user enters the radius
	fldz													;pushes +0.0 onto the FPU stack
	fcomp													;compares the stack variables and pops st(0)
	fnstsw ax												;store FPU status word in AX register
	sahf													;store AH into Flags
	je completed											;if zero has been entered jump to completed
	fstp radius												;value is put into the radius variable 


	mov edx, OFFSET promptHeight							;moves the prompt into edx for printing
	call WriteString
	call ReadFloat											;user enters the height
	fldz													;pushes +0.0 onto the FPU stack
	fcomp													;compares the stack variables and pops st(0)
	fnstsw ax												;store FPU status word in AX register
	sahf													;store AH into Flags
	je completed											;if zero has been entered jump to completed
	fstp height												;value is put into the height variable 

	fldpi													;pushes value of PI onto the FPU stack
	fld radius												;pushes value of radius onto the FPU stack (radius squared)
	fld radius												;pushes value of radius onto the FPU stack (radius squared)

	FMULP													;multiplies radius by radius
	FMULP													;mutiplies radius squared by PI

	mov edx, OFFSET endAnswer								;moves endAnswer into edx for printing
	call WriteString
	call WriteFloat											;prints out the answer to the area of a single end
	call crlf
	fstp surfaceEnds										;stores answer in surfaceEnds variable (area of a single end)

	fld height												;pushes value of height onto the FPU stack 
	fld radius												;pushes value of radius onto the FPU stack 
	fldpi													;pushes value of PI onto the FPU stack
	fld two													;pushes value of two (2) onto the FPU stack

	FMULP													;multiplies two times PI
	FMULP													;mutiplies answer one line back by radius
	FMULP													;multiplies answer one line back by height
	
	mov edx, OFFSET sideAnswer								;moves sideAnswer into edx for printing
	call WriteString
	call WriteFloat											;prints out the answer to the area of the side
	call crlf
	fstp surfaceSide										;stores answer in surfaceSide variable (area of the side)

	fld surfaceSide											;pushes value of surfaceSide onto the FPU stack 
	fld surfaceEnds											;pushes value of surfaceEnds onto the FPU stack 
	fld two													;pushes value of two (2) onto the FPU stack

	FMULP													;multiplies two by surfaceEnds
	FADDP													;adds answer one line back with surfaceSide

	mov edx, OFFSET fullAnswer								;moves fullAnswer into edx for printing
	call WriteString
	call WriteFloat											;prints out the answer to the full surface area of the shape
	call crlf
	fstp temp												;clears the stack
		
	fld height												;pushes value of height onto the FPU stack 
	fld radius												;pushes value of radius onto the FPU stack (radius squared)
	fld radius												;pushes value of radius onto the FPU stack (radius squared)
	fldpi													;pushes value of PI onto the FPU stack

	FMULP													;multiplies PI by radius
	FMULP													;multiplies answer one line back by radius
	FMULP													;multiplies answer one line back by height
	mov edx, OFFSET volumeAnswer							;moves valumeAnswer into edx for printing
	call WriteString
	call WriteFloat											;prints out the answer to the volume of the shape
	call crlf

jmp start													;jumps to start to repeat until the user enters zero
completed:
call crlf

	exit
main ENDP
END main