

SECTION .text
	global main
	global inthexdec
	extern malloc

main:
	push 13245
	call inthexdec
	; eax now holds pointer to the structure

	mov ebx, 0
	mov eax, 1
	int 0x80

inthexdec:
	push ebp
	mov ebp, esp

	; save ebx and edi registers
	push ebx
	push edi

	push 20
	call malloc

	; remove function parameter from stack
	add esp, 4

	test eax, eax ; malloc could return NULL (shouldn't happen)
	jz error

	mov ebx, eax

	; convert to hex
	mov eax, [ebp+8]
	mov ecx, 8
	mov edi, 16
loophex:
	dec ecx
	mov edx, 0 ; clear edx so it doesnt't get intepreted as a 64bit number
	div edi
	cmp edx, 10
	jge hexletter
	
	add dl, 0x30 ; convert to ASCII number
	mov [ebx+ecx], dl
	jmp loopend

hexletter:
	add dl, 55 ; convert to ASCII char
	mov [ebx+ecx], dl

loopend:
	test ecx, ecx
	jnz loophex
	; terminate hex string with NULL
	mov BYTE [ebx+8], 0



	; convert to decimal
	mov eax, [ebp+8]
	mov ecx, 19
	mov edi, 10

loopdec:
	dec ecx
	mov edx, 0
	div edi
	add dl, 0x30
	mov [ebx+ecx], dl
	cmp ecx, 9
	jne loopdec

	; terminate string with NULL
	mov BYTE [ebx+19], 0

	; move struct address to eax (return value)
	mov eax, ebx

	; restore registers
	pop edi
	pop ebx

	pop ebp

	ret

error:
	; exit with 1
	mov ebx, 1
	mov eax, 1
	int 0x80
