; main.asm - Main assembly file for usage with the cisc225-project template.
;	This project links with a subset of the Irvine library written in C/C++
;	and wrapper procedures written in assembly.

; Date: 04.28.21
; Author: Afham Bashir 

.386
.model flat,c
.stack 4096

include cisc225.inc

.data
	str1 BYTE "Press C to convert Celsius to Fahrenheit, or",13,10,0
	str2 BYTE "Press F to convert Fahrenheit to Celsius.",13,10,0
	Cprompt BYTE "Enter Celsius Temperature: ",0
	Fprompt BYTE "Enter Fahrenheit Temperature: " ,0
	Coutput BYTE "Temperature in Celsius is ",0
	Foutput BYTE "Temperature in Fahrenheit is " ,0

	Fahrenheit real8 ?
	Celsius    real8 ?

	conversion_C real8 0.555556
	conversion_F real8 1.8
	constant	 real8 32.0 

.code

main PROC

	mov edx, offset str1
	call WriteString
	mov edx, offset str2
	call WriteString
L1: 
	call ReadChar 

	cmp AL, 67    ; compare to ascii of C
	JE LF
 	cmp AL, 99	  ; compare to ascii of c
	JE LF
	cmp AL, 102	  ; compare to ascii of f
	JE LC 
	cmp AL, 70	  ; compare to ascii of F 
	JE LC 

	JMP L1		  ;loop prompt until valid input 

LF: 
	call Crlf
	mov edx, offset Cprompt 
	call WriteString
	call readfloat 
	fstp Celsius 

	fld Celsius
	fld conversion_F
	fmul
	fld constant
	fadd 
	
	mov edx, offset Foutput 
	call WriteString
	call WriteFloat

	JMP LEND
	
LC: 
	call Crlf
	mov edx, offset Fprompt 
	call WriteString
	call readfloat 
	fstp Fahrenheit

	fld Fahrenheit
	fld constant
	fsub
	fld conversion_C
	fmul


	mov edx, offset Coutput 
	call WriteString
	call WriteFloat

LEND: 
	call ReadChar
	call EndProgram			; Terminates the program

main ENDP
END