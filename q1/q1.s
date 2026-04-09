
.section .text
.global make_node
.global insert
.global get
.global getAtMost
.extern malloc

make_node:
    #making space for return address and variables
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)

    #storing the parameter for future use cuz malloc
    mv s0, a0 

    #allocating memory for the struct and assigning variables (with padding for the integer, assuming 8 bytes for pointers)
    li a0, 24
    call malloc
    sw s0, 0(a0)
    sd x0, 8(a0)
    sd x0, 16(a0)

    #restoring save registers and stack after use
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    ret

insert:
    #making space for return address and variables
    addi sp, sp, -40
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)

    #moving parameter variables cuz malloc and also storing the root
    mv s0, a0
    mv s1, a1
    addi sp, sp, -8
    sd a0, 0(sp)

    beq x0, s0, exit_loop_insert
    #find the right position in the bst to insert
    loop_insert:
        lw s2, 0(s0)
        bge s1, s2, greater_insert #LMAO
        blt s1, s2, smaller_insert

        greater_insert:
            ld t0, 16(s0)
            beq t0, x0, exit_loop_insert
            mv s0, t0
            beq x0, x0, loop_insert
        
        smaller_insert:
            ld t0, 8(s0)
            beq t0, x0, exit_loop_insert
            mv s0, t0
            beq x0, x0, loop_insert


    exit_loop_insert:
   
    #making the node and storing it in s3
    mv a0, s1
    call make_node
    mv s3, a0

    bne x0, s0, not_initial_null_insert
    mv s0, s3
    beq x0, x0, exit_insert

    not_initial_null_insert:
    lw t0, 0(s0)
    bge s1, t0, larger_insert #LMAO
    blt s1, t0, lesser_insert 

    larger_insert:
        sd s3, 16(s0)
        beq x0, x0, exit_insert

    lesser_insert:
        sd s3, 8(s0)
        beq x0, x0, exit_insert
    
    exit_insert:

    #loading registers back from stack
    ld a0, 0(sp)
    addi sp, sp, 8

    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    addi sp, sp, 40
 
    bne a0, x0, final_exit_insert
    li a0, s0
    final_exit_insert:
        ret

get:
    addi sp, sp, -24
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)

    beq x0, a0, equal_get
    #bst traversal
    loop_get:
        lw s1, 0(a0)
        bgt a1, s1, greater_get
        blt a1, s1, smaller_get
        beq a1, s1, equal_get

        greater_get:
            ld a0, 16(a0)
            beq a0, x0, equal_get
            beq x0, x0, loop_get

        smaller_get:
            ld a0, 8(a0)
            beq a0, x0, equal_get
            beq x0, x0, loop_get
    #exit condition
    equal_get:
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        addi sp, sp, 24
        ret

getAtMost:
    addi sp, sp, -40
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp) #storing the predecessor in s3

    li s3, -1  #default value
    beq a1, x0, exit_predecessor
    loop_predecessor:
        lw s0, 0(a1)
        ble s0, a0, condition_1
        bgt s0, a0, greater_predecessor

        condition_1: 
            bgt s0, s3, condition_2
            beq x0, x0, lesser_predecessor
        condition_2:
            mv s3, s0

        greater_predecessor:
            ld a1, 8(a1)
            beq x0, a1, exit_predecessor
            beq x0, x0, loop_predecessor
        
        lesser_predecessor:
            ld a1, 16(a1)
            beq x0, a1, exit_predecessor
            beq x0, x0, loop_predecessor
        
    exit_predecessor:
        li a0, s3
    
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        ld s2, 24(sp)
        ld s3, 32(sp)
        addi sp, sp, 40
        ret
        






    

