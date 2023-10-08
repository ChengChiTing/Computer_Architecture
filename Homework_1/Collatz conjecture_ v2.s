
.data

data0: .word 0                          # N = 0
data1: .word 1                          # 0 steps
data2: .word 7                          # 16 steps
data3: .word 1024                       # 10 steps
data4: .word 27                         # 111 steps
str1: .string "The number is zero"
str2: .string "The number of steps for Collatz conjecture is "

.text
# s0 : test data
# s1 : the steps need for finishing collatz conjecture
# ra : return address

main:
    lw s0, data2
    jal ra, collatz                     # call collatz function
    li a7, 10                           # exit program
    ecall

collatz:
    addi sp, sp, -12
    sw ra, 0(sp)                        # store ra into 0(sp)
    sw s0, 4(sp)                        # store s0 into 4(sp)
    add s1, zero, zero                  # result(s1) = 0
    addi t0, zero, 1                    # t0 = 1
   
    bne zero, s0, loop                  # confirm a0 is 0 or not
    la a0, str1
    li a7, 4                                                                                
    ecall
    addi sp, sp, 12
    jr ra                               # end function
   
loop:
    beq s0, t0, end                     # if number = 1, end the function  
    andi t1, s0, 1                      # confirm the number is even or odd
    bne t1, t0, even
    slli t2, s0, 1                      # ood execute 3n + 1
    addi t2, t2, 1
    add s0, t2, s0
    addi s1, s1, 1
    j loop

even:
    jal ra, ctz                         # call ctz function  
    srl s0, s0, t1                      # remove trailing zero
    add s1, s1, t1
    j loop

end:
    la a0, str2                         # printf("The number of steps for Collatz conjecture is ")
    li a7, 4
    ecall
    mv a0, s1
    li a7, 1
    ecall  
    lw ra, 0(sp)                        # return ra 
    lw s0, 4(sp)                        # return s0
    addi sp, sp, 12                     # return stack
    jr ra                               # end function

ctz:                                    # counting trailing zero
    sw s0, 8(sp)                        # store s0 into 8(sp)
    addi t1, zero, 1
    slli t2, s0, 16
    bne t2, zero, bs24
    addi t1, t1, 16
    srli s0, s0, 16
bs24:
    slli t2, s0, 24
    bne t2, zero, bs28
    addi t1, t1, 8
    srli s0, s0, 8
bs28:
    slli t2, s0, 28
    bne t2, zero, bs30
    addi t1, t1, 4
    srli s0, s0, 4
bs30:
    slli t2, s0, 30
    bne t2, zero, bs31
    addi t1, t1, 2
    srli s0, s0, 2
bs31:
    andi s0, s0, 1
    sub t1, t1, s0
    lw s0, 8(sp)                        # return s0 into 8(sp)
    jr ra