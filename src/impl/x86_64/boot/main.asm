global start

; 000B8000 = VGA
; 36D76289 = Multiboot Flag

section .text
bits 32
start:
	; set stack to our stack
	; [r|e]sp = Stack Pointer
	mov esp, stack_top

	call check_multiboot
	call check_cpuid
	call check_long_mode
	call setup_page_tables
	call enable_paging

	; print `ok` with green background and white text
	mov dword [0xB8000], 0x2F4B2F4F
	hlt

setup_page_tables:
	
	ret

enable_paging:
	ret

check_multiboot:
	cmp eax, 0x36D76289
	jne .no_multiboot
	ret
.no_multiboot:
	mov al, "M"
	jmp error

check_cpuid:
	pushfd
	pop eax
	mov ecx, eax
	xor eax, 1 << 21
	push eax
	popfd
	pushfd
	pop eax
	push ecx
	popfd
	cmp eax, ecx
	je .no_cpuid
	ret
.no_cpuid:
	mov al, "C"
	jmp error

check_long_mode:
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x00000001
	jb .no_long_mode
	
	mov eax, 0x00000001
	cpuid
	test edx, 1 << 29
	jz .no_long_mode

	ret
.no_long_mode:
	mov al, "L"
	jmp error

error:
	mov dword [0xB8000], 0x4F524F45
	mov dword [0xB8004], 0x4F3A4F52
	mov dword [0xB8008], 0x4F204F20
	mov byte  [0xB800A], al
	hlt

section .bss
align 4096
page_table_l4:

stack_bottom:
	; reserve bytes (resb value)
	resb 4096 * 4
stack_top:
