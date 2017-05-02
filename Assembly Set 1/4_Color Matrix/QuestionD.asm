TITLE Color Matrix					(QuestionD.asm)
; Asks the user for a starting text color, background color,
; and string. The program prints a 16 by 16 grid of incremented
; letters, with each row containing a different background color
; and each letter containing a different color. 

INCLUDE Irvine32.inc

.data
prompt1		BYTE	"Enter the starting text color value (0-15): ",0
prompt2		BYTE	"Enter the starting background color value (0-15): ",0
prompt3		BYTE	"Enter a starting character: ",0
text		DWORD	?
background	DWORD	?
character	BYTE	?

count		BYTE	3															;used for the spacing in Gotoxy

.code
main PROC

;call prompt one
mov	edx, OFFSET prompt1															;prints prompt1
call WriteString

;user enters a color value
call ReadDec																	;user enters a value for text color
mov text, eax																	;saves text color to text variable
mov eax, 0																		;clears eax

;call prompt two
mov	edx, OFFSET prompt2															;prints prompt2
call WriteString

;user enters a background color value
call ReadDec																	;user enters a value for background color
mov background, eax																;saves background color to background variable
mov eax, 0																		;clears eax

;call promp three
mov edx, OFFSET prompt3															;prints prompt3
mov ecx, LENGTHOF prompt2														
call WriteString

;user enter a character
call ReadChar																	;user enters a starting character for printing
mov character, al																;moves the character to the character variable
call crlf

;sets intial background color
mov ebx, 0																		;clears ebx
mov ecx, 16																		;sets ecx to 16 for loop count
L3:																				;L3 sets the intitial corrected background color value
	add ebx, background															;adds background variable to ebx until complete 
loop L3

;sets initial foreground color
mov esi, text																	;moves text variable to esi for text color changes

;loop one progresses for 16 rows
mov ecx, 16																		;sets ecx to 16 for loop count	
L1:																				;loops for 16 rows of changes to color and characters

;shifts the column to the appropriate spot
	mov dh, count																;moves count into dh for row shifting
	mov dl, 15																	;moves 15 to dl for column shifting
	call Gotoxy																	;sets row and column (where it will print on console)
	inc count																	;increments count for next row

;saves the value of ecx for the main loop
	push ecx																	;saves the value in ecx to the stack
	mov ecx, 16																	;sets ecx to 16 for loop count

		;loop prints the row and each character a different color
		L2:																		;nested loop for color and character changes		
			mov eax, esi														;moves esi value(text color) to eax
			add eax, ebx														;adds ebx value(background color) to eax
			call SetTextColor													;sets the color based on the previous two values in eax

		;prints the character
			mov al, character													;moves character to al for printing
			call WriteChar

		;continues if we're not at the end
			inc character														;increments to the next character
			cmp al, 'Z'															;checks if al (character) is equal to Z
			jne	skip															;jumps to "skip" if the character doesn't need resetting
			mov character, 'A'													;changes the character to A if reset is needed
			skip:

		;resets the color in eax if it's at 15
			inc esi																;increments to the next color
			cmp esi, 16															;if text color is greater than 15 reset
			jne skip2															;jumps to "skip2" if color doesn't need changing		
			mov esi, 0															;resets the text color

			skip2:

		loop L2																	

;resets the count 
	pop ecx																		;pop stack to ecx (for L1 before decremented)

;checks 
	add ebx, 16																	;add 16 to ebx, which increments the background color
	cmp ebx, 256																;checks if the background color needs resetting		
	jne nobackgroundChange														;jumps if it doens't need resetting			
	mov ebx, 0;																	;resets the background color
	nobackgroundChange:
loop L1

call crlf

	exit
main ENDP
END main
