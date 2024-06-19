TITLE   ************* Proektna Stefan Vasilevski  *************

COMMENT *----------------------------------------------------
			       Rabota so matricna tastatura     
		-----------------------------------------------------*
.386
.model small, c

;----------------------------------------------------------------
; Stek segment

stack_seg SEGMENT stack

	DB 100 DUP(?)

stack_seg ENDS

;----------------------------------------------------------------
; Podatocen segment

data_seg SEGMENT USE16 'DATA'
	ntrue DB   "     Greshna shifra!" , 0ah, 024h
	ttrue DB  "      Tochna shifra!", 0ah, 024h
	msg1 DB "Vnesete znak: ", 0ah, 024h
	shifra DB 6 DUP(0)
	tochna DB "12345#"
data_seg ENDS

;----------------------------------------------------------------
; Koden segment

code_seg SEGMENT USE16 'CODE'
ASSUME cs:code_seg, ds:data_seg
	
start:                  

	; Postavuvanje na adresata na DATA segmentot vo DS
	mov ax, data_seg
	mov ds, ax      

;----------------------------------------------------------------
; Glavna procedura

main PROC
pak:
	;pecati na ekran
	mov ah, 09h
	lea dx, msg1
	int 021h		;service routine for display message on screen
	LEA DI, shifra	;Load effective address in DI 
	MOV CX, 6d		;CX is the counter 
pak1:
	MOV AL, 11111110b 	;In AL loaded combination to be outputed to LPT1
	MOV DX, 0378h		;address of LPT1 
	OUT DX, AL 			;Output to LPT1
	
	
	
	MOV DX, 0379h		;address of LPT1 status register
	IN AL, DX 			;Read LPT1 status register
	AND AL, 11110000b	;mask of LPT1 status register
	CMP AL, 11110000b	;Compare LPT1 status register with 11110000b
	JNE poraka			;if not equal jump to poraka
	CALL delay_debounce	;if equal call delay_debounce
	MOV AH, 02h			;
	MOV DL, '*'			;combination of 11110000b is the "*" switch on the matrix	
	MOV BYTE PTR [DI], '*'	;move it to the memory location pointed by DI	
	INC DI					;increment the pointer
	INT 021h				;service routine
	LOOP pak1				;Loop instruction 
	JMP kraj				;if CX=0 then jump to kraj
poraka:
	CMP AL, 00110000b		;compare AL with 00110000b combination 
	JNE poraka1				;if not equal then jump to poraka1
	CALL delay_debounce		;call delay_debounce if equal
	MOV AH, 02h				;
	MOV DL, '7'				;'7' switch is pressed on the matrix keypad show on the screen
	INT 021h				;interrupt service routine
	MOV BYTE PTR [DI], '7'	;'7' switch is pressed on the matrix keypad store in memory
	INC DI					;increment DI to point on next address	
	LOOP pak1				;Loop to pak1 if CX is not equal to zero
	JMP kraj				;If CX is equal to zero jump to kraj label
poraka1:
	CMP AL, 01010000b		;CMP AL with 01010000b combination of the status register
	JNE poraka2				;if not equal jump to poraka2 label
	CALL delay_debounce		;call delay_debounce 
	MOV AH, 02h				;
	MOV DL, '4'				;'4' is pressed on the matrix keypad based on that combination above
	INT 021h
	MOV BYTE PTR [DI], '4'	;'4' store in memory where DI is pointing in the memory 
	INC DI					;Increment DI to point to the next address
	LOOP pak1				;Loop pak1 if CX is not zero
	JMP kraj				;Jump to label kraj if CX is zero

poraka2:
	CMP AL, 01100000b		;Compare AL with 01100000b combination
	JNE pak2				;If not equal jump to label pak2
	CALL delay_debounce		;Delay_debounce to stabilize the reading
	MOV AH, 02h			
	MOV DL, '1'				;'1' is pressed on the matrix keyapd 	
	INT 021h				;show on the screen
	MOV BYTE PTR [DI], '1'	;'1' is stored in the memory where DI is pointing
	INC DI					;increment DI by one to point to the next address in memory
	LOOP pak1				;loop through pak1 if CX is not equal to zero
	JMP kraj				;jump to kraj 

pak2:
	MOV AL, 11111101b		;MOV in AL the combination 11111101b
	MOV DX, 0378h			;Data register being used 
	OUT DX, AL				;output it to the parallel port

	MOV DX, 0379h			;Status register address store in DX
	IN AL, DX				;input the address store the data in AL
	AND AL, 11110000b		;mask the data in AL
	CMP AL, 11110000b		;compare it with 11110000b combination
	JNE R2					;if not equal jump to label R2
	CALL delay_debounce		;call delay_debounce if equal
	MOV AH, 02h				
	MOV DL, '0'				;'0' is pressed on the matrix keypad
	INT 021h				
	MOV BYTE PTR [DI], '0'	;store it in the memory
	INC DI					;increment the pointer to the the next address
	LOOP pak3				;LOOP pak3 if CX is not equal to zero	
	JMP kraj				;if CX is equal to zero
R2: 
	CMP AL, 00110000b		;compare AL with 00110000b combination	
	JNE R3					;if not equal jump to R3
	CALL delay_debounce		;call procedure delay_debounce
	MOV AH, 02h
	MOV DL, '8'				;'8' is pressed on the matrix keypad	
	INT 021h				;show on the screen
	MOV BYTE PTR [DI], '8'	;store it in the memory
	INC DI					;increment DI for one 		
	LOOP pak3				;LOOP pak3 if CX is not equal to zero	
	JMP kraj				;jump to kraj if CX is equal to zero
R3:
	CMP AL, 01010000b		;compare with 01010000b combination
	JNE R4					;jump to R4 if AL is not equal to that combination
	CALL delay_debounce		;call delay_debounce	
	MOV AH, 02h	
	MOV DL, '5'				;move to DL '5' because switch '5' is pressed
	INT 021h
	MOV BYTE PTR [DI], '5'	;move to where DI is pointing 
	INC DI					;increment DI by one
	LOOP pak3				;loop through pak3 if CX is not equal to zero
	JMP kraj				;if CX is equal to zero jump to kraj
 R4:
	CMP AL, 01100000b		;compare AL with 01100000b combination
	JNE pak3				;if not equal AL to combination jump to pak3	
	CALL delay_debounce		;call delay_debounce
	MOV AH, 02h				
	MOV DL, '2'				;move to DL '2' because switch '2' is pressed	
	INT 021h				;show on screen\
	MOV BYTE PTR [DI], '2'	;'2' store in memory with pointer DI
	INC DI					;increment DI by one
	LOOP pak3				;Loop through pak3 if CX is not equal to zero
	JMP kraj				;jumps to kraj if CX is equal to zero
pak3:
	MOV AL, 11111011b		;MOV in AL 11111011b combination 
	MOV DX, 0378h			;Data register being used 
	OUT DX, AL				;output that combination on parallel port 

	MOV DX, 0379h			;Address for Status register 	
	IN AL, DX				;Input from Status register and store in AL register 
	AND AL, 11110000b		;Mask the AL register 
	CMP AL, 11110000b		;Compare the AL register with 11110000b combination 
	JNE RR1					;if not equal jump to RR1 label
	CALL delay_debounce		;call delay_debounce
	MOV AH, 02h				
	MOV DL, '#'				;'#' being pressed on the matrix keypad 
	INT 021h				;Service routine for writing on screen
	MOV BYTE PTR [DI], '#'	;store in memory with DI pointer 
	INC DI					;increment DI pointer by one
	DEC CX					;Decrement CX pointer by one (Loop instruction is not working)	
	JNZ pak1				;If CX is not zero jump to pak1 label
	JMP kraj				;if CX is zero jump to kraj label

RR1:
	CMP AL, 00110000b 		;Compare AL with 00110000b combination 
	JNE RR2				    ;if not equal to that combination jump to RR2 label
	CALL delay_debounce		;call delay_debounce
	MOV AH, 02h				;service routine for screen update
	MOV DL, '9'				;service routine for screen displaing of '9'
	INT 021h				;interrupt the service routine
	MOV BYTE PTR [DI], '9'	;'9' store in the memory pointed by DI pointer	
	INC DI					;increment DI pointer
	DEC CX					;Decrement CX counter by one (handy decremented counter)	
	JNZ pak1				;if CX is not equal to zero then jump to pak1 label
	JMP kraj				;jump to kraj label if CX is equal to zero		

RR2:        
	CMP AL, 01010000b		;compare AL with 01010000b combination 
	JNE RR3					;if AL is not equal to that combination then jump to RR3 label
	CALL delay_debounce		;call delay_debounce
	MOV AH, 02h
	MOV DL, '6'				;'6' is pressed on the keypad matrix and show on the screen
	INT 021h				;service routine 
	MOV BYTE PTR [DI], '6'	;'6' is pressed on the keypad matrix and store in the memory pointed by the DI pointer	
	INC DI					;increment DI pointer by one
	DEC CX					;Decrement CX by one (manualy decremented counter)
	JNZ pak1				;if not zero jump to pak1
	JMP kraj				;if zero jump to kraj

RR3:
	CMP AL, 01100000b		;compare AL with 01100000b combination
	JNE pak1				;if AL is not that combination jump to pak1
	CALL delay_debounce		;call delay_debounce
	MOV AH, 02h
	MOV DL, '3'
	INT 021h
	MOV BYTE PTR [DI], '3'
	INC DI
	DEC CX
	JNE pak1
	JMP kraj
	

kraj:
	LEA SI, shifra			;Load effective address in SI from Shifra in memory
	LEA DI, tochna			;Load effective address in DI from tochna in memory

	MOV CX, 6d				;CX is counter of elements in memory
loop1:
	MOV AL, [SI]			;Move in AL the element pointed by SI pointer	
	MOV AH, [DI]			;Move in AH the element pointed by DI pointer
	CMP AL, AH				;Compare AL and AH registers 
	JNE notTrue				;If are not equal jump to notTrue label
	INC SI					;increment SI by one 
	INC DI					;Increment DI by one
	LOOP loop1				;Loop loop1 (if CX is not equal to zero)

True:
	MOV AH, 09h
	LEA DX, ttrue			;DX is pointer in memory ttrue variable 
	INT 021h				;interrupt 021h service routine
	JMP EndK				;jump to EndK
notTrue:
	MOV AH, 09h				;AH 09h for showing string on display
	LEA DX, ntrue			;DX is pointer in memory ntrue variable
	INT 021h				;interrupt 021h service routine
EndK:
	NOP						;No operation instruction

	
main ENDP


;---------------------------------------------------------------------------------------------------------------------------------------
; Kraj na programata 
MOV AX, 04C00h
INT 021h
;---------------------------------------------------------------------------------------------------------------------------------------
; Delay debounce procedure
delay_debounce PROC
   PUSH CX ;push CX on stack (old value on stack)
   MOV ECX, 00FFFFFFFh 	;ECX has new value
loop1:
   DEC ECX  ;Decrement ECX by one
   JNE loop1	;if not zero go to loop1
   POP CX		;pop it from stack(bring back old value to CX)	
   RET			;return 
delay_debounce ENDP
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
code_seg ENDS
END start
