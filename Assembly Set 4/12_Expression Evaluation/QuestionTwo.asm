TITLE Question Two				(QuestionTwo.asm)
;DESCRIPTION: User enters values and the answer to the
;equation "((A + B) / C) * ((D - A) + E)" calculates.

INCLUDE Irvine32.inc

.data
aPrompt	BYTE	"Enter value for A: ",0							;following are prompts for entering data and displaying the answer
bPrompt	BYTE	"Enter value for B: ",0
cPrompt	BYTE	"Enter value for C: ",0
dPrompt	BYTE	"Enter value for D: ",0
ePrompt	BYTE	"Enter value for E: ",0
formula	BYTE	"((A + B) / C) * ((D - A) + E) = ",0

valA	REAL4	?												;following hold the variables (A - E)
valB	REAL4	?
valC	REAL4	?
valD	REAL4	?
valE	REAL4	?
temp	REAL4	?												;used to clear the stack (pop)

.code
main PROC

finit															;initializes the FPU

mov ecx, 5														;moves 5 into ecx (loop repeats 5 times)
L1: 
	cmp ecx, 0													
	je ending													;onces ecx hits 0 the loop ends									

	mov edx, OFFSET aPrompt										;moves the aPrompt into edx for printing
	call WriteString
	call ReadFloat												;user enters variable A
	fstp valA													;pops value of A into valA

	mov edx, OFFSET bPrompt										;moves the bPrompt into edx for printing
	call WriteString
	call ReadFloat												;user enters variable B
	fstp valB													;pops value of B into valB

	mov edx, OFFSET cPrompt										;moves the cPrompt into edx for printing
	call WriteString
	call ReadFloat												;user enters variable C
	fstp valC													;pops value of C into valC

	mov edx, OFFSET dPrompt										;moves the dPrompt into edx for printing
	call WriteString
	call ReadFloat												;user enters variable D
	fstp valD													;pops value of D into valD

	mov edx, OFFSET ePrompt										;moves the ePrompt into edx for printing
	call WriteString
	call ReadFloat												;user enters variable E
	fstp valE													;pops value of E into valE
	
	fld valC													;pushes valC onto FPU stack
	fld valA													;pushes valA onto FPU stack
	fld valB													;pushes valB onto FPU stack
	faddp														;adds valB and valA
	fdiv st(0), st(1)											;divides answer one line back by C
	fstp st(1)													;pops the value in st(1)

	fld valE													;pushes valE onto FPU stack
	fld valD													;pushes valD onto FPU stack
	fld valA													;pushes valA onto FPU stack
	fsubp														;subtracts valD and valA
	faddp														;adds the answer from previous line withe valE

	fmulp														;multiplies answer from line 66 with answer from previous line

	mov edx, OFFSET formula										;moves formula into edx for printing
	call WriteString
	call WriteFloat												;prints the final answer to the forumla
	call crlf

	fstp temp													;clears the FPU stack
	
	dec ecx														;decrements ecx by one
	call crlf

	jmp L1														;jumps to the top of loop
ending:

	exit
main ENDP
END main