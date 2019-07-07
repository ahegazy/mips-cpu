	.text
	.globl main

main:
	addi $s1, $s1,   0x0000 
	addi $t0, $zero, 0x004b
	addi $t1, $zero, 0x000f
	addi $t2, $zero, 3
	sub $t3, $t2, $t2      #0
	add $t4, $t2, $t2      #6
	sw  $t0, 4($s1)

loop_start:	
	lw   $s3, 4($s1)	 #$s3 will be 0x000000ff
	beq  $t3, $t4, loop_end  
	addi $t3, $t3, 1	
	sub  $t0, $t0, $t1
	andi $s2, $t0, 0x00f0
	or   $s3, $s2, $t1
	sw   $s3, 4($s1)
	j loop_start
	
loop_end:
