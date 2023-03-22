;
; This is the Global Descriptor Table (GDT)
;

; we are in 32 bit mode, thus:
;	db: 8  bits (1 byte)
; 	dw: 32 bits (2 bytes)
;	dd: 64 bits (4 bytes)
; 
; the formatting is kinda weird



gdt_start :		; Entry point

gdt_null : 		; invalid null descriptor ( required by the CPU for sanity )
	dd 0x0 		
	dd 0x0


gdt_code :		; code segment descriptor
			; base=0x0 , limit=0xfffff ( when offsetted by granularity -> 4GB )
			; A) -> 1001b
			; B) -> 1010b
			; C) -> 1100b
	dw 0xffff 	; Limit (bits 0-15)
	dw 0x0 		; Base (bits 0-15)
	db 0x0 		; Base (bits 16-23)
	
	db 10011010b 	; A), B) Flags
	db 11001111b 	; C) flags ( Padded ), Limit ( bits 16-19)
	db 0x0 		; Base (bits 24-31)


gdt_data : 		; data segment descriptor
			; same as code segment, except:
			; B) -> 0010b
	dw 0xffff 	
	dw 0x0 		
	db 0x0 		
	db 10010010b 	
	db 11001111b 	
	db 0x0 		

gdt_end : 		; label used by assembler to calculate GDT size in the descriptor.


gdt_descriptor :
	dw gdt_end - gdt_start - 1 ; GDT ( always one less than true size )
	dd gdt_start 		   ; GDT Start address


; Segment descriptor offset constants.
; Each segment is 16 bytes, so: 0x0 -> NULL: 0x08 -> CODE: 0x10 -> DATA
; i.e, to reference the data segment, set DS (segment register) to 0x10
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start