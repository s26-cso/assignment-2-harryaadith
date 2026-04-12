.section .data
mode: .string "r"
yes: .string "Yes\n"
no: .string "No\n"
input_file: .string "input.txt"

.section .text
.global main
.extern fopen
.extern printf
.extern fclose
.extern fseek
.extern ftell
.extern fgetc


main:
    addi sp, sp, -48
    sd s0, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
    sd s3, 24(sp)
    sd s4, 32(sp)
    sd ra, 40(sp)

    la a0, input_file
    la a1, mode
    call fopen
    mv s0, a0 #the file pointer is stored in s0

    mv a0, s0
    li a1, 0
    li a2, 2
    call fseek

    li s1, 0

    mv a0, s0
    call ftell
    mv s2, a0 #s2 stores (effectively) the number of characters in the txt file

    addi s2, s2, -2 #because the cursor points after the last character

    
    loop_q5:
        bge s1, s2, palindrome
        mv a0, s0
        mv a1, s1
        li a2, 0
        call fseek #we have now moved the cursor to the left pointer.

        mv a0, s0
        call fgetc
        mv s3, a0 #stored character at left pointer.

        mv a0, s0
        mv a1, s2
        li a2, 0
        call fseek #we have now moved the cursor to the right pointer.

        mv a0, s0
        call fgetc
        mv s4, a0 #stored character at right pointer.

        beq s3, s4, same
        bne s3, s4, not_same

    same:
        addi s1, s1, 1
        addi s2, s2, -1
        beq x0, x0, loop_q5
        
    not_same:
        la a0, no
        call printf
        beq x0, x0, final_exit_q5

    palindrome:
        la a0, yes
        call printf
        beq x0, x0, final_exit_q5

    final_exit_q5:
        mv a0, s0
        call fclose
        ld s0, 0(sp)
        ld s1, 8(sp)
        ld s2, 16(sp)
        ld s3, 24(sp)
        ld s4, 32(sp)
        ld ra, 40(sp)
        addi sp, sp, 48
        ret







    
    

