extern _printf

section .data
	align 16
	n64: times 4 dd 64.0000000
	align 16
	temp: times 64 dd 0
	align 16
    coef_matrix1: dd 0.12500000, 0.12500000, 0.12500000, 0.12500000, 0.12500000, 0.12500000, 0.12500000, 0.12500000 
		dd 0.17337998, 0.14698445, 0.09821187, 0.03448742, -0.03448742, -0.09821187, -0.14698445, -0.17337998 
		dd 0.16332037, 0.06764951, -0.06764951, -0.16332037, -0.16332037, -0.06764951, 0.06764951, 0.16332037 
		dd 0.14698445, -0.03448742, -0.17337998, -0.09821187, 0.09821187, 0.17337998, 0.03448742, -0.14698445 
		dd 0.12500000, -0.12500000, -0.12500000, 0.12500000, 0.12500000, -0.12500000, -0.12500000, 0.12500000 
		dd 0.09821187, -0.17337998, 0.03448742, 0.14698445, -0.14698445, -0.03448742, 0.17337998, -0.09821187 
		dd 0.06764951, -0.16332037, 0.16332037, -0.06764951, -0.06764951, 0.16332037, -0.16332037, 0.06764951 
		dd 0.03448742, -0.09821187, 0.14698445, -0.17337998, 0.17337998, -0.14698445, 0.09821187, -0.03448742
	align 16
	coef_matrix2: dd 0.12500000, 0.17337997, 0.16332036, 0.14698444, 0.12500000, 0.09821186, 0.06764951, 0.03448742
		dd 0.12500000, 0.14698444, 0.06764951, -0.03448743, -0.12500001, -0.17337999, -0.16332036, -0.09821185 
		dd 0.12500000, 0.09821186, -0.06764952, -0.17337999, -0.12499999, 0.03448744, 0.16332039, 0.14698444 
		dd 0.12500000, 0.03448742, -0.16332038, -0.09821185, 0.12500001, 0.14698444, -0.06764955, -0.17337997 
		dd 0.12500000, -0.03448743, -0.16332036, 0.09821189, 0.12499998, -0.14698447, -0.06764946, 0.17338000 
		dd 0.12500000, -0.09821188, -0.06764949, 0.17337997, -0.12500003, -0.03448737, 0.16332035, -0.14698449 
		dd 0.12500000, -0.14698446, 0.06764954, 0.03448739, -0.12499996, 0.17337996, -0.16332039, 0.09821194 
		dd 0.12500000, -0.17337999, 0.16332039, -0.14698447, 0.12500004, -0.09821194, 0.06764959, -0.03448752
	align 16
	temp1: times 16 dd 0
	align 16
	mas_to_movaps: times 4 dd 0
	format db "%i", 10, 0 
	format_l db "%lf", 10, 0
	format_d db "%lf %lf %lf %lf",10, 0
	omega1 dq 1
section .text

global _fdct,_idct


_fdct:  
    mov eax, [esp + 4]
    mov ebx, [esp + 8]
    mov ecx, [esp + 12]
	push esi
	xor esi,esi
	push ebx
    _fdct_looop:
		;save regs
		push eax
		push ebx
		push ecx
		;push args to mul_matr(res,m2,m1) 
		push temp
		push eax
		push coef_matrix1
		call mul_matr
		add esp, 12
		;push args to mul_matr(res,m2,m1) 
		push ebx
		push coef_matrix2
		push temp
		call mul_matr
		add esp, 12
		
		;pop regs 
		pop ecx
		pop ebx
		pop eax
		
		add eax, 256
		add ebx, 256
		
        inc esi
		cmp esi,ecx
    jne _fdct_looop
	_fdct_end:
	pop ebx
	pop esi
ret
_idct: 
	
    mov eax, [esp + 4]
    mov ebx, [esp + 8]
    mov ecx, [esp + 12]
	push esi
	xor esi,esi
	push ebx
	
    _idct_looop:
		;save regs
		push eax
		push ebx
		push ecx
		;push args to mul_matr(res,m2,m1) 
		push temp
		push eax
		push coef_matrix2
		call mul_matr
		add esp, 12
		;push args to mul_matr(res,m2,m1) 
		push ebx
		push coef_matrix1
		push temp
		call mul_matr
		add esp, 12
		
		;pop regs 
		pop ecx
		pop ebx
		pop eax
		
		
		push esi
		push eax 
		;call normalization func
		push ebx 
		call normalize64
		add esp, 4
		;call debugp
		
		pop eax
		pop esi 
		
		add eax, 256
		add ebx, 256
		
        inc esi
		cmp esi,ecx
    jne _idct_looop
	_idct_end:
	pop ebx
	pop esi
ret
debugp:
		pusha
			xor ecx,ecx
			mov ecx, 1
			push ecx
			push format
			call _printf
			add esp, 8
		popa
ret
debugi:
		pusha
			push ecx
			push format
			call _printf
			add esp, 8
		popa
ret
;print float 
debugf:
	pusha
	mov [omega1],ecx
	fld dword [omega1]
	sub esp, 8
	fstp qword [esp]
	push format_l
	call _printf
	add esp, 12
	popa
ret
;print xmm0
debug_reg:
	pusha
	movaps [mas_to_movaps],xmm0
	shufps xmm0,xmm0, 1Bh
	movss [omega1],xmm0
	fld dword [omega1]
	sub esp, 8
	fstp qword [esp]
	
	shufps xmm0,xmm0, 39h
	
	movss [omega1],xmm0
	fld dword [omega1]
	sub esp, 8
	fstp qword [esp]
	
	shufps xmm0,xmm0, 39h
	
	movss [omega1],xmm0
	fld dword [omega1]
	sub esp, 8
	fstp qword [esp]
	
	shufps xmm0,xmm0, 39h
	
	movss [omega1],xmm0
	fld dword [omega1]
	sub esp, 8
	fstp qword [esp]
	
	push format_d
	
	call _printf
	add esp, 36
	movaps xmm0, [mas_to_movaps]
	popa
ret
fill_mas_to_movaps:
	mov ebx,[ecx]
	mov [mas_to_movaps],ebx
	mov ebx,[ecx + 32]
	mov [mas_to_movaps + 4],ebx
	mov ebx,[ecx + 64]
	mov [mas_to_movaps + 8], ebx
	mov ebx,[ecx + 96]
	mov [mas_to_movaps + 12],ebx
ret
; void mul_matr(float* matr1, float* matr2, float* matr_res)
filling_xmmreg_from_matrixes:
	;block 1 row 1 column
	movaps xmm0, [eax]
	
	;call debug_reg
	call fill_mas_to_movaps
	movaps xmm1, [mas_to_movaps]
	add ecx, 128
	movaps   xmm2, [eax + 16]
	call fill_mas_to_movaps
	movaps xmm3, [mas_to_movaps]
	sub ecx, 128
	add ecx, 4
	;block 1 row 1 column
	movaps xmm4, [eax]
	call fill_mas_to_movaps
	movaps xmm5, [mas_to_movaps]
	add ecx, 128
	movaps xmm6, [eax + 16]
	call fill_mas_to_movaps
	movaps xmm7, [mas_to_movaps]
	sub ecx, 128
	add ecx, 4
ret
mul_reg:
	mulps xmm0,xmm1
	mulps xmm2,xmm3
	mulps xmm4,xmm5
	mulps xmm6,xmm7
ret	
normalize64:
	
	mov eax, [esp + 4]
	xor esi, esi
	movaps xmm0, [n64]
	normalize64_loop1:
		
		cmp esi, 16
		je normalize64_end
		
		movaps xmm1, [eax]
		mulps xmm1, xmm0
		movaps [eax], xmm1
		add eax, 16
	inc esi
	jmp normalize64_loop1
	normalize64_end:
ret
		
mul_matr:
	
	mov eax,[esp + 4] ;coef_matrix1
	mov ecx,[esp + 8]; coef_matrix2
	mov edx, [esp + 12]; res
	
	
	push esi
	push edi 
	push ebx
	mov esi,0
	mul_matr_loop1:
		cmp esi,8
		je end_mul
		mov edi, 0
		
	mul_matr_loop2:
		;check for end loop
		cmp edi, 2
		je mul_matr_inc_part
		
		call filling_xmmreg_from_matrixes
		call mul_reg
		;save regs data
		movaps [temp1], xmm0
		movaps [temp1 + 16], xmm2
		movaps [temp1 + 32], xmm4
		movaps [temp1 + 48], xmm6
		call filling_xmmreg_from_matrixes
		call mul_reg
		;pop regs data
		movaps xmm1, [temp1]
		movaps xmm3, [temp1 + 16]
		movaps xmm5, [temp1 + 32]
		movaps xmm7, [temp1 + 48]
		;count the ans 
		haddps xmm0,xmm2
		haddps xmm4,xmm6
		haddps xmm1,xmm3
		haddps xmm5,xmm7
		haddps xmm1,xmm5
		haddps xmm0,xmm4
		haddps xmm1,xmm0
		
		movaps [edx],xmm1
		
		
		add edx, 16
		inc edi
	jmp mul_matr_loop2
	mul_matr_inc_part:
		;call debugp
		inc esi
		add eax, 32
		sub ecx,32
	jmp mul_matr_loop1
	end_mul:
		
	pop ebx
	pop edi
	pop esi
	ret 