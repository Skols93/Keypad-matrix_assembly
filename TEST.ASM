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
	int 021h
	LEA DI, shifra
	MOV CX, 6d
pak1:
	MOV AL, 11111110b 
	MOV DX, 0378h
	OUT DX, AL 
	
	
	
	MOV DX, 0379h
	IN AL, DX 
	AND AL, 11110000b
	CMP AL, 11110000b
	JNE poraka
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '*'
	MOV BYTE PTR [DI], '*'
	INC DI
	INT 021h
	LOOP pak1
	JMP kraj
poraka:
	CMP AL, 00110000b
	JNE poraka1
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '7'
	INT 021h
	MOV BYTE PTR [DI], '7'
	INC DI
	LOOP pak1
	JMP kraj
poraka1:
	CMP AL, 01010000b
	JNE poraka2
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '4'
	INT 021h
	MOV BYTE PTR [DI], '4'
	INC DI
	LOOP pak1
	JMP kraj

poraka2:
	CMP AL, 01100000b
	JNE pak2
	CALL delay_debounce
	MOV AH, 02h
	MOV DL, '1'
	INT 021h
	MOV BYTE PTR [DI], '1'
	INC DI
	LOOP pak1
	JMP kraj

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
