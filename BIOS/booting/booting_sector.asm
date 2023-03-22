; This is the booting sector: it is used to  enter the kernel in 32-bit presentation manager
;

;[bits 16]			; the cpu boots in 16-bit real mode for back compatibility 

[org 0x7c00]			; account for memory offset as loaded by BIOS 
				        ; this is done with assembler directives rather than memory segmentation to save bytes in the MBR.

KERNEL_OFFSET equ 0x1000	; as specified in the linker

	mov [BOOT_DRIVE], dl

	mov bp, 0x9000  	; setting the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE	; 16-bit display routine
	call prints
	
	call load_kernel	; load the kernel into memory

	call switch_to_pm 	
	jmp $			; this should not run

; routines
%include "booting_routines_display.asm"
%include "booting_routines_disk.asm"
%include "gdt.asm"
%include "pm_routines_display.asm"
%include "pm_switch.asm"

[bits 16] ; 16 bit real mode.

load_kernel:
	call endl
	mov bx, MSG_LOAD_KERN   ; debug
	call prints
	
	mov bx, KERNEL_OFFSET	; this line tells the disk routine where to load the kernel
	mov dh, 34	           	; load 15 sectors ( starting from 2nd as hardcoded in routine )
	mov dl, [BOOT_DRIVE] 	; same disk as booted from
	call disk_load	       	; load it

	ret


[bits 32]		        	; We are now in 32-bit Protected Mode. changes form [bits 16] to [bits 32]

BEGIN_PM :
	mov ebx, MSG_PROT_MODE	; asm 32-bit display routine
	call print_string_pm 

	call KERNEL_OFFSET  	; THIS EXECUTES THE KERNEL
	
	jmp $ 		        	; this should not run

; global vars
BOOT_DRIVE    db 0
MSG_REAL_MODE db "Running MBR in 16-bit real mode", 0
MSG_PROT_MODE db "Landed in 32-bit protected mode    ", 0 
MSG_LOAD_KERN db "Loading kernel", 0

; bootsector padding
times 510-($-$$) db 0
dw 0xaa55