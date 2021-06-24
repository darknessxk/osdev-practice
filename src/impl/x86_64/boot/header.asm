section .multiboot_header
header_start:
	; magic number
	dd 0xE85250D6 	; multiboot
	; architeture
	dd 0 		; protected mode i386
	; header len
	dd header_end - header_start
	; checksum
	dd 0x100000000 - (0xE85250D6 + 0 + (header_end - header_start))
	; end tags
	dd 0
	dd 0
	dd 8
header_end:
