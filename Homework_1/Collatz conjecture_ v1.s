.data

data0: .word 0                          # N = 0
data1: .word 1                          # 0 steps
data2: .word 7                          # 16 steps
data3: .word 1024                       # 10 steps
data4: .word 27                         # 111 steps
str1: .string "The number is zero"
str2: .string "The number of steps for Collatz conjecture is "

.text
# s1 : test data
# a0 : the input number of collatz function
# a1 : the steps need for finishing collatz conjecture
# t0 : the input of ctz function
# a5 : the return value of ctzfunction
# ra : return address

main:
    lw s1, data2
    mv a0, s1
    jal ra, collatz                     # call collatz function
    li a7, 10                           # exit program
    ecall

collatz:
    addi sp, sp, -4                     # push s0
    sw ra, 0(sp)                        # store ra into s0

    add a1, zero, zero                  # result(a1) = 0
    addi a2, zero, 1                    # a2 = 0x01
   
    bne zero, a0, loop                  # confirm a0 is 0 or not
    mv t3, a0                           # printf("The number is zero \n")
    la a0, str1
    li a7, 4                                                                                
    ecall
    mv a0, t3                                    
    lw ra, 0(sp)
    addi sp, sp, 4                      # return s0
    jr ra                               # end function
   
loop:  
    beq a0, a2, end                     # if number = 1, end the function  
    and a3, a0, a2                      # confirm the number is even or odd
    bne a3, a2, even
    slli a3, a0, 1                      # ood execute 3n + 1
    addi a3, a3, 1
    add a0, a3, a0
    addi a1, a1, 1
    j loop

even:
    mv t0, a0                           # even number execute n / 2
    jal ra, ctz                         # call ctz function  
    srl a0, a0, a5                      # remove trailing zero
    add a1, a1, a5
    j loop

end:
    mv t3, a0                           # printf("The number of steps for Collatz conjecture is ");
    la a0, str2
    li a7, 4
    ecall
    mv a0, a1
    li a7, 1
    ecall
    mv a0, t3    
    lw ra, 0(sp)
    addi sp, sp, 4                      # return s0
    jr ra                               # end function

ctz:                                    # counting trailing zero
    slli t1, t0, 1                      # x |= (x << 1);
    or t0, t0, t1

    slli t1, t0, 2                      # x |= (x << 2);
    or t0, t0, t1

    slli t1, t0, 4                      # x |= (x << 4);
    or t0, t0, t1

    slli t1, t0, 8                      # x |= (x << 8);
    or t0, t0, t1

    slli t1, t0, 16                     # x |= (x << 16);
    or t0, t0, t1

                                        # count ones (population count)
    li t1, 0x55555555                   # 0x55555555
    srli t2, t0, 1                      # x >> 1
    and t2, t1, t2                      # (x >> 1) & 0x55555555
    sub t0, t0, t2                      # x -= ((x >> 1) & 0x55555555)

    li t1, 0x33333333                   # 0x33333333
    srli t2, t0, 2                      # x >> 2
    and t2, t1, t2                      # (x >> 2) & 0x33333333
    and t0, t0, t1                      # x & 0x33333333
    add t0, t0, t2                      # x = ((x >> 2) & 0x33333333) + (x & 0x33333333)

    li t1, 0x0f0f0f0f                   # 0x0f0f0f0f
    srli t2, t0, 4                      # x >> 4
    add t0, t2, t0                      # (x >> 4) + x
    and t0, t0, t1                      # x = ((x >> 4) + x) & 0x0f0f0f0f

    srli t2, t0, 8                      # x >> 8
    add t0, t0, t2                      # x += (x >> 8)

    srli t2, t0, 16                     # x >> 16
    add t0, t0, t2                      # x += (x >> 16)

    addi t1, zero,32
    andi t0, t0, 0x7f                   # x & 0x7f
    sub a5, t1, t0
    jr ra