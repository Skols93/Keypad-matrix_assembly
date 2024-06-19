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
	MOV AL, 11111101b
	MOV DX, 0378h
	OUT DX, AL

	MOV DX, 0379h
	IN AL, DX
	AND AL, 11110000b
	CMP AL, 11110000b
	JNE R2
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '0'
	INT 021h
	MOV BYTE PTR [DI], '0'
	INC DI
	LOOP pak3
	JMP kraj
R2: 
	CMP AL, 00110000b
	JNE R3
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '8'
	INT 021h
	MOV BYTE PTR [DI], '8'
	INC DI
	LOOP pak3
	JMP kraj
R3:
	CMP AL, 01010000b
	JNE R4
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '5'
	INT 021h
	MOV BYTE PTR [DI], '5'
	INC DI
	LOOP pak3
	JMP kraj
R4:
	CMP AL, 01100000b
	JNE pak3
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '2'
	INT 021h
	MOV BYTE PTR [DI], '2'
	INC DI
	LOOP pak3
	JMP kraj
pak3:
	MOV AL, 11111011b
	MOV DX, 0378h
	OUT DX, AL

	MOV DX, 0379h
	IN AL, DX
	AND AL, 11110000b
	CMP AL, 11110000b
	JNE RR1
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '#'
	INT 021h
	MOV BYTE PTR [DI], '#'
	INC DI
	DEC CX
	JNE pak1
	JMP kraj

RR1:
	CMP AL, 00110000b 
	JNE RR2
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '9'
	INT 021h
	MOV BYTE PTR [DI], '9'
	INC DI
	DEC CX
	JNE pak1
	JMP kraj

RR2:        
	CMP AL, 01010000b
	JNE RR3
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '6'
	INT 021h
	MOV BYTE PTR [DI], '6'
	INC DI
	DEC CX
	JNE pak1
	JMP kraj

RR3:
	CMP AL, 01100000b
	JNE pak1
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '3'
	INT 021h
	MOV BYTE PTR [DI], '3'
	INC DI
	DEC CX
	JNE pak1
	JMP kraj
	

kraj:
	LEA SI, shifra
	LEA DI, tochna

	MOV CX, 6d
loop1:
	MOV AL, [SI]
	MOV AH, [DI]
	CMP AL, AH
	JNZ notTrue
	INC SI
	INC DI
	LOOP loop1

True:
	MOV AH, 09h
	LEA DX, ttrue
	INT 021h
	JMP EndK
notTrue:
	MOV AH, 09h
	LEA DX, ntrue
	INT 021h
EndK:
	NOP

	
main ENDP


;---------------------------------------------------------------------------------------------------------------------------------------
; Kraj na programata 
MOV AX, 04C00h
INT 021h

delay_debounce PROC
   PUSH CX
   MOV ECX, 00FFFFFFFh
loop1:
   DEC ECX
   JNE loop1
   POP CX
   RET
delay_debounce ENDP
code_seg ENDS
END start
