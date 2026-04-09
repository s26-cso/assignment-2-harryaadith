.section .data
fmt_out: .string "%lld "

.section .text
.global main
.extern atoi 
.extern malloc
.extern printf

main:
    addi sp, sp, -72
    sd ra, 0(sp)
    sd s0, 8(sp)  #number of cmd arguments
    sd s1, 16(sp) #static pointer for checking
    sd s2, 24(sp) #movable pointer to the array of cmd arguments
    sd s3, 32(sp) #where were storing arr[i]
    sd s4, 40(sp) #where were storing stack.top() if present
    sd s5, 48(sp) #stack height
    li s5, 0
    sd s6, 56(sp) #stack pointer
    sd s7, 64(sp)

    mv s0, a0
    mv s1, a1

    addi s0, s0, -1

    slli s0, s0, 3

    add s2, s1, s0

    li a0, 160000000
    call malloc
    mv s6, a0

    loop_q2:
        beq s1, s2, exit_loop_q2
        ld a0, 0(s2)
        call atoi
        sd a0, 0(s2)
        addi s2, s2, -8
        beq x0, x0, loop_q2

    exit_loop_q2:

    add s2, s1, s0  

    for_q2:
        beq s2, s1, exit_for_q2
        ld s3, 0(s2)       # s3 = current value
        
        sub t2, s2, s1     # t2 = byte offset from argv[0]
        srli t2, t2, 3     # t2 = t2 / 8 (the 1-based index)
        addi s7, t2, -1    # s7 = 0-based index of current element

        while_q2:
            beq s5, x0, exit_while_q2
            addi t0, s5, -16   # Go back 16 bytes 
            add t0, s6, t0
            ld s4, 0(t0)       
            bgt s4, s3, exit_while_q2
            addi s5, s5, -16   # Pop the whole pair
            beq x0, x0, while_q2

    exit_while_q2:
        ble s5, x0, skip_add_q2

        addi t0, s5, -16
        add t0, s6, t0
        ld t1, 8(t0)       =
        beq x0, x0, store_and_push

    skip_add_q2:
        li t1, -1          

    store_and_push:
        sd t1, 0(s2)       
        
        add t0, s6, s5
        sd s3, 0(t0)       # Store current Value
        sd s7, 8(t0)       # Store current Index
        addi s5, s5, 16    # Move stack pointer by 2 entries (16 bytes)
        
        addi s2, s2, -8
        beq x0, x0, for_q2         # Repeat
        
    exit_for_q2:
        addi s0, s0, 8
        add s2, s1, s0
        addi s1, s1, 8
        final_loop_q2:
            beq s1, s2, exit_final_loop_q2
            la a0, fmt_out
            ld a1, 0(s1)
            call printf
            addi s1, s1, 8
            beq x0, x0, final_loop_q2

        exit_final_loop_q2:
            ld ra, 0(sp)
            ld s0, 8(sp)  #number of cmd arguments
            ld s1, 16(sp) #static pointer for checking
            ld s2, 24(sp) #movable pointer to the array of cmd arguments
            ld s3, 32(sp) #where were storing arr[i]
            ld s4, 40(sp) #where were storing stack.top() if present
            ld s5, 48(sp) #stack height
            ld s6, 56(sp) #stack pointer
            ld s7, 64(sp)

            addi sp, sp, 72

            ret
