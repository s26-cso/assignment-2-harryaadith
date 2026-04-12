.section .text
.global make_node
.global insert
.global get
.global getAtMost
.extern malloc

make_node:
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)

    mv s0, a0 

    li a0, 24
    call malloc
    sw s0, 0(a0)    # value (4 bytes)
    sd x0, 8(a0)    # left child
    sd x0, 16(a0)   # right child

    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -40
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)

    mv s0, a0        # s0 = current node
    mv s1, a1        # s1 = value to insert
    mv s3, a0        # s3 = original root to return later

    # Handle empty tree case
    beq s0, x0, tree_empty_insert

    loop_insert:
        lw s2, 0(s0)
        beq s1, s2, exit_insert   # Value already exists, just return root
        blt s1, s2, smaller_insert

        greater_insert:
            ld t0, 16(s0)
            beq t0, x0, perform_insert_right
            mv s0, t0
            beq x0, x0, loop_insert
        
        smaller_insert:
            ld t0, 8(s0)
            beq t0, x0, perform_insert_left
            mv s0, t0
            beq x0, x0, loop_insert

    perform_insert_left:
        mv a0, s1
        call make_node
        sd a0, 8(s0)
        beq x0, x0, exit_insert

    perform_insert_right:
        mv a0, s1
        call make_node
        sd a0, 16(s0)
        beq x0, x0, exit_insert

    tree_empty_insert:
        mv a0, s1
        call make_node
        mv s3, a0        

    exit_insert:
        mv a0, s3        
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        ld s2, 24(sp)
        ld s3, 32(sp)
        addi sp, sp, 40
        ret

get:
    addi sp, sp, -24
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)

    loop_get:
        beq a0, x0, exit_get 
        lw s1, 0(a0)
        beq a1, s1, exit_get
        blt a1, s1, go_left_get

        go_right_get:
            ld a0, 16(a0)
            beq x0, x0, loop_get

        go_left_get:
            ld a0, 8(a0)
            beq x0, x0, loop_get

    exit_get:
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
    sd s3, 32(sp) 

    li s3, -1               # s3 = best value found so far (predecessor)
    mv s0, a1               # s0 = current node (passed in a1)
    mv s1, a0               # s1 = target value (passed in a0)

    loop_atmost:
        beq s0, x0, exit_atmost
        lw s2, 0(s0)        # s2 = current node's value
        
        beq s2, s1, found_exact
        blt s2, s1, possible_match

        ld s0, 8(s0)
        beq x0, x0, loop_atmost

    possible_match:
        mv s3, s2
        ld s0, 16(s0)
        beq x0, x0, loop_atmost

    found_exact:
        mv s3, s2         

    exit_atmost:
        mv a0, s3       
    
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        ld s2, 24(sp)
        ld s3, 32(sp)
        addi sp, sp, 40
        ret

