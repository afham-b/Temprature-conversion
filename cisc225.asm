; cisc225.asm - Subset of callable procedures from the Irvine library
;	This module, in conjunction with cisc225_c.cpp is a rewrite of a subset
;	of the procedures outlined in chapter 5 of the Irvine Assembly Language
;	textbook. Modules in this source file are callable from assembly and
;	serve as wrappers for the corresponding functions written in C/C++.

; N. Lippincott, Northampton Community College
; February 18, 2020

.386
.model flat,c

c_delay PROTO
c_endprogram PROTO
c_getmaxxy PROTO
c_gettextcolor PROTO
c_gotoxy PROTO
c_random32 PROTO
c_randomize PROTO
c_readchar PROTO
c_readfloat PROTO
c_readkey PROTO
c_readint PROTO
c_readstring PROTO
c_settextcolor PROTO
c_writechar PROTO
c_writefloat PROTO
c_writehex PROTO
c_writeint PROTO
c_writestring PROTO

.data
	s_crlf BYTE 13,10,0

.code

; Write CR-LF to the console
CrLf PROC
	push EDX
	mov EDX,OFFSET s_crlf
	call WriteString
	pop EDX
	ret
CrLf ENDP

; Pause the program
; Parameters:
;	EAX - Number of milliseconds
Delay PROC
	pushad
	push EAX
	call c_delay
	add ESP,4
	popad
	ret
Delay ENDP

; Ends the program
EndProgram PROC
	call c_endprogram
EndProgram ENDP

; Get size of console window
; Returns:
;	AX - Number of rows
;	DX - Number of columns
GetMaxXY PROC
	pushad
	mov EBP,ESP
	call c_getmaxxy
	mov [EBP+28],AX
	shr EAX,16
	mov [EBP+20],AX
	popad
	ret
GetMaxXY ENDP

; Get text color
; Returns:
;	AL - Colors (fg bits 0-3, bg bits 4-7)
GetTextColor PROC
	pushad
	mov EBP,ESP
	call c_gettextcolor
	mov [EBP+28],AL
	popad
	ret
GetTextColor ENDP

; Set cursor position
; Parameters:
;	DH - Y-coordinate (row)
;	DL - X-coordinate (column)
GotoXY PROC
	pushad
	movzx EAX,DH
	push EAX
	movzx EAX,DL
	push EAX
	call c_gotoxy
	add ESP,8
	popad
	ret
GotoXY ENDP

; Generates a 32-bit random integer
; Returns:
;	EAX - The random integer
Random32 PROC
	pushad
	mov EBP,ESP
	call c_random32
	mov [EBP+28],EAX
	popad
	ret
Random32 ENDP

; Seed the random number generator
Randomize PROC
	pushad
	call c_randomize
	popad
	ret
Randomize ENDP

; Generate random integer in range 0 to N-1
; Parameters:
;	EAX - Number of integers in range
; Returns:
;	EAX - The random integer
RandomRange PROC
	pushad
	mov EBP,ESP
	mov EBX,EAX
	call Random32
	mov EDX,0
	div EBX
	mov [EBP+28],EDX
	popad
	ret
RandomRange ENDP

; Reads a character from the colsole without echo
; Returns:
;	AL - ASCII character (0 if extended key)
;	AH - Keyboard scan code (if extended key)
ReadChar PROC
	pushad
	mov EBP,ESP
	call c_ReadChar
	mov [EBP+28],AX
	popad
	ret
ReadChar ENDP

; Read a floating point value from the console
; Returns:
;	ST(0) - Floating point value read
ReadFloat PROC
	call c_readfloat
	ret
ReadFloat ENDP

; Read an integer from the console
; Returns:
;	EAX - Integer value read
ReadInt PROC
	pushad
	mov EBP,ESP
	call c_readint
	mov [EBP+28],EAX
	popad
	ret
ReadInt ENDP

; Read a string from the console
; Parameters:
;	EDX - Address of buffer to receive string
;	ECX - Size of buffer
; Returns:
;	EAX - Number of characters read
ReadString PROC
	pushad
	mov EBP,ESP
	push ECX
	push EDX
	call c_readstring
	add ESP,8
	mov [EBP+28],EAX
	popad
	ret
ReadString ENDP

; Sets the text foreground and background colors
; Parameters:
;	EAX - Colors (fg bits 0-3, bg bits 4-7)
SetTextColor PROC
	pushad
	push EAX
	call c_settextcolor
	add ESP,4
	popad
	ret
SetTextColor ENDP

; Writes a character to the console
; Parameters:
;	AL - Character to be written
WriteChar PROC
	pushad
	and EAX,0ffh
	push EAX
	call c_writechar
	add ESP,4
	popad
	ret
WriteChar ENDP

; Writes a floating point value to the console
; Parameters
;	ST(0) - The floating point value
WriteFloat PROC
	sub ESP,8
	fst real8 ptr [esp]
	call c_writefloat
	add ESP,8
	ret
WriteFloat ENDP

; Writes an integer to the console in hexadecimal
; Parameters
;	EAX - The integer
WriteHex PROC
	pushad
	push EAX
	call c_writehex
	add ESP,4
	popad
	ret
WriteHex ENDP

; Writes an integer to the console
; Parameters
;	EAX - The integer
WriteInt PROC
	pushad
	push EAX
	call c_writeint
	add ESP,4
	popad
	ret
WriteInt ENDP

; Writes a string to the console
; Parameters:
;	EDX - Address of null-terminated string
WriteString PROC
	pushad
	push EDX
	call c_writestring
	add ESP,4
	popad
	ret
WriteString ENDP
END