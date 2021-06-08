# ================================================================================================
#				   BIEU THUC TRUNG TO HAU TO - MIPS CODE
#				
# Chuc nang:
# - Nhap vao bieu thuc trung to
# - In ra bieu thuc hau to 
# - In ra ket qua cua bieu thuc trung to
# - Ho tro cac phep toan: cong, tru, nha, chia lay thuong
# - Kiem tra cac truong hop dac biet:
#	+ So nam ngoai doan [0, 99]
#	+ Chia cho 0
# 	+ Kiem tra dau ngoac
#
#=================================================================================================

.data
infix:		.space 256
infix_:		.space 256
postfix:	.space 256
postfix_:	.space 256
stack:		.space 256

msg_read_infix:		.asciiz "Xin moi nhap bieu thuc trung to: "
msg_print_infix:	.asciiz "Bieu thuc trung to: "
msg_print_postfix:	.asciiz "Bieu thuc hau to: "
msg_print_result:	.asciiz "Ket qua: "
msg_enter:		.asciiz "\n"
msg_error1:		.asciiz "Ban da nhap so lon hon 99. Lam on nhap lai!"
msg_error2:		.asciiz "Ban da nhap so nho hon 0. Lam on nhap lai!"
msg_error3:		.asciiz "Ban da nhap so chia bang 0. Lam on nhap lai!"
msg_error4:		.asciiz "Nhap sai dau ngoac!"
msg_enter_value:	.asciiz "Nhap vao gia tri cua bien theo thu tu xuat hien trong infix: "
msg_errorValue:         .asciiz "Input khong hop le"
endMsg:                 .asciiz "Ban co muon tiep tuc?"

.text
main:
      jal input_infix
      nop
      jal move_stack_to_postfix
      nop
      jal sort_postfix
      nop
      
end_main:
  li $v0, 10                   # option exit (terminate execution)
  syscall                      #thuc hien    


############################  Produce input #############################################
# nhap infix
input_infix:		addi $sp , $sp, -4                     # create stack
                        sw  $ra, 0($sp)
                        li	$v0, 54                    # nhap dau vao
			la	$a0, msg_read_infix        # loi goi string
			la	$a1, infix_                
			la 	$a2, 256
			syscall                            # thuc hien

# in ra infix
li	$v0, 4
la	$a0, msg_print_infix                               # loi goi string
syscall                                                    # thuc hien

li	$v0, 4
la	$a0, infix_
syscall	

# 1. chuyen infix ve postfix
li	$s0, 0		                                   # bien dem de duyet infix
li	$s1, 0                                  	   # bien dem de duyet postfix
li	$s2, -1                                   	   # bien dem de duyet stack

# bo dau ngoac trong postfix
li	$s6, 0		                                  # bien dem de duyet postfix
li	$s7, 0		                                  # bien dem de duyet postfix_

# bo tat ca dau cach trong infix
li	$s4, 0                                            # drop space
li	$s5, 0                                            # drop space

# bien dem dau (
li	$a3, 0
end_input_infix:
      lw $ra, 0($sp)                         # lay du lieu tu stack vao $ra
      addi $sp, $sp, 4                       # cho stack xuong        
      jr $ra
      nop

############################################################################################
move_stack_to_postfix:		addi $sp , $sp, -4                     # create stack
                        sw  $ra, 0($sp)
      remove_space1:    lb $t5, infix_($s4)                   # load byte
			addi	$s4, $s4, 1                        # tang bien
			beq	$t5, ' ', remove_space1	           # if = space then remove space
			nop                                        # lenh tre
			beq	$t5, 0, iterate_infix              # so sanh gia tri
			nop                                        # lenh tre
			sb	$t5, infix($s5)                    # store byte
			addi	$s5, $s5, 1                        # tang bien
			j	remove_space1                      # quay lai remove_space

iterate_infix:		lb	$t0, infix($s0)				# doc tung ky tu trong infix
			beq	$t0, $0, end_iterate_infix		# neu ket thuc xau infix, nhay den end_iterate_infix
			nop						
			beq	$t0, '\n', end_iterate_infix		# bo dau xuong dong
			nop
			
			# neu $t0 la toan hang, xet thu tu uu tien cua cac toan hang de nap vao stack						
			beq	$t0, '+', consider_plus_minus	    # bieu thuc so sanh	
			nop                                         # lenh tre
			beq	$t0, '-', consider_plus_minus	    # bieu thuc so sanh
			nop                                         # lenh tre
			beq	$t0, '*', consider_mul_div	    # bieu thuc so sanh
			nop                                         # lenh tre
			beq	$t0, '/', consider_mul_div	    # bieu thuc so sanh
			nop                                         # lenh tre
			beq	$t0, '^', push_op_to_stack	    # neu gap '^' thi lap tuc dua vao stack
			nop                                         # lenh tre
			beq	$t0, '(', consider_lpar		    # neu gap '(' thi check so am
			nop                                         # lenh tre
			beq	$t0, ')', consider_rpar1            # bieu thuc so sanh
			nop                                         # lenh tre
			
			# neu $t0 la toan tu, dua vao postfix ngay lap tuc
			sb	$t0, postfix($s1)                   #store bye			
			addi	$s1, $s1, 1                         # tang bien
			
			# ===================================================== xu ly so co 2 chu so - doc truoc 1 ky tu
			addi	$s0, $s0, 1                          # tang bien
			lb	$t2, infix($s0)                      # load byte
			beq	$t2, '0', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '1', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '2', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '3', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '4', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '5', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '6', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '7', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '8', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t2, '9', continue                   # bieu thuc so sanh
			nop                                          # lenh tre
			# =====================================================
			
			li	$s3, ' '			# them dau cach
			sb	$s3, postfix($s1)               # store byte
			addi	$s1, $s1, 1                     # tang bien
			j	iterate_infix                   # nhay den iterate_infix
			nop
						
continue: 		addi	$t3, $s0, 1			# tiep tuc doc truoc 1 ky tu
			lb	$t4, infix($t3)
			beq	$t4, '0', gt99_error_popup	# greater than 99
			nop                                          # lenh tre
			beq	$t4, '1', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '2', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '3', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '4', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '5', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '6', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '7', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '8', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			beq	$t4, '9', gt99_error_popup           # bieu thuc so sanh
			nop                                          # lenh tre
			sb	$t2, postfix($s1)  		# them chu so tiep theo cua so vua nhap vao postfix
			addi	$s1, $s1, 1                     # tang bien
			li	$s3, ' '			# them dau cach
			sb	$s3, postfix($s1)
			addi	$s1, $s1, 1                     # tang bien
			addi	$s0, $s0, 1                     # tang bien
			j 	iterate_infix			# nhay ve iterate_infix de doc ky tu tiep theo
			nop                                          # lenh tre

gt99_error_popup:	li	$v0, 55                         # gan gia tri
			la	$a0, msg_error1                 # thong baso loi
			syscall
			j	main                     # quay lai input_infix
			nop                                     # lenh tre
			
# toan hang '+' va '-' co thu tu uu tien ngang nhau
consider_plus_minus:	beq	$s2, -1, push_op_to_stack	# neu stack rong, nap toan hang dang xet vao stack
			nop                                     # lenh tre
			lb	$t9, stack($s2)
			beq	$t9, '(', push_op_to_stack	# neu dinh stack la dau '(', nap toan hang dang xet vao stack
			nop                                     # lenh tre
			lb	$t1, stack($s2)			# else, day tat ca cac toan hang ra khoi stack, sau do nap toan hang dang xet vao
			sb	$t1, postfix($s1)               # store byte
			addi	$s2, $s2, -1                    # cong hang so
			addi	$s1, $s1, 1                     # cong hang so
			j	consider_plus_minus	
			nop                                     # lenh tre

# toan hang '*' va '/' co thu tu uu tien ngang nhau
consider_mul_div:	beq	$s2, -1, push_op_to_stack	# neu stack rong, nap toan hang dang xet vao stack
			nop                                     # lenh tre
			lb	$t9, stack($s2)			# neu dinh stack la '+', '-', '(', nap toan hang dang xet vao stack
			beq	$t9, '+', push_op_to_stack
			nop                                     # lenh tre
			beq	$t9, '-', push_op_to_stack
			nop                                     # lenh tre
			beq	$t9, '(', push_op_to_stack
			nop                                     # lenh tre
			lb	$t1, stack($s2)			# else, dua lan luot cac ky hieu tu stack vao trong postfix
			sb	$t1, postfix($s1)               # store byte
			addi	$s2, $s2, -1
			addi	$s1, $s1, 1
			j	consider_mul_div                # nhay lai consider_mul_div
			nop                                     # lenh tre
			
consider_rpar1:		addi	$a3, $a3, -1                    # cong hang so
			j	consider_rpar                   # nhay den lable consider
			nop                                     # lenh tre
			
consider_rpar:		beq	$s2, -1, push_op_to_stack	# neu stack rong, nap ky kieu vao stack
			nop
			lb	$t1, stack($s2)			# else, day toan hang ra khoi stack
			sb	$t1, postfix($s1)		# dua vao postfix
			addi	$s2, $s2, -1
			addi	$s1, $s1, 1
			beq	$t1, '(', push_op_to_stack	# cho den khi gap dau '(' dau tien duoc dua ra
			j	consider_rpar
			nop                                     # lenh tre	

consider_lpar:		addi	$a3, $a3, 1
			addi	$t3, $s0, 1
			lb	$t4, infix($t3)
			beq	$t4, '-', lt0_error_popup	# less than 0
			nop                                     # lenh tre
			j	push_op_to_stack
			nop                                     # lenh tre	
		
lt0_error_popup:	li	$v0, 55
			la	$a0, msg_error2
			syscall
			j	main
			nop                                     # lenh tre			
			
push_op_to_stack:	addi	$s2, $s2, 1
			sb	$t0, stack($s2)
			addi	$s0, $s0, 1
			j 	iterate_infix
			nop                                     # lenh tre

# dua toan bo toan hang con lai cua stack ra khoi ngan xep, va push vao postfix
end_iterate_infix:	beq	$s2, -1, L2
                        j abs
                        nop
                   L2: jal sort_postfix
                       nop                                     # lenh tre
	abs:		lb	$t0, stack($s2)
			sb	$t0, postfix($s1)
			addi	$s2, $s2, -1
			addi	$s1, $s1, 1
			j	end_iterate_infix
			nop                                     # lenh tre
end_move_stack_to_postfix:
                        lw $ra, 0($sp)                         # lay du lieu tu stack vao $ra
                        addi $sp, $sp, 4                       # cho stack xuong        
                        jr $ra
                        nop
# bo dau ngoac trong postfix

#####################################  Produce remove_parentheses  ###########################
sort_postfix:	        addi $sp , $sp, -4                     # create stack
                        sw  $ra, 0($sp)                        # doc du lieu vao stack
      remove_parentheses1:   lb	$t5, postfix($s6)
			addi	$s6, $s6, 1
			beq	$t5, '(', remove_parentheses1
			nop                                     # lenh tre
			beq	$t5, ')', remove_parentheses1
			nop                                     # lenh tre
			beq	$t5, 0, print_postfix		# neu gap ky tu rong -> duyet xong postfix -> in ra postfix_
			nop                                     # lenh tre
			sb	$t5, postfix_($s7)
			addi	$s7, $s7, 1
			j	remove_parentheses1
			nop                                     # lenh tre
				
print_postfix:		li	$v0, 4
			la	$a0, msg_print_postfix
			syscall
			li $v0, 4
			la $a0, postfix_
			syscall
			li	$v0, 4
			la	$a0, msg_enter
			syscall
			bne	$a3, 0, error1
			nop                                     # lenh tre
			j	calculate_postfix
			nop                                     # lenh tre
			
error1:			li	$v0, 55
			la	$a0, msg_error4
			syscall
			j	main
			nop                                     # lenh tre

# 2. tinh postfix
calculate_postfix:	li	$s1, 0		# set lai bien duyet postfix
			li	$s2, 1		# biet dem de tinh ham mu
			li	$t5, 1		# phuc vu cho viec tinh ham mu

iterate_postfix: 	lb	$t0, postfix_($s1)
			beq	$t0, 0, printf_result
			
			nop	                                 # lenh tre
	         	beq	$t0, ' ', eliminate_space       # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '0', continue_		# neu gap chu so thi doc tiep ky tu tiep theo
			nop                                     # lenh tre
			beq	$t0, '1', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '2', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '3', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '4', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '5', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '6', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '7', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '8', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '9', continue_           # bieu thuc so sanh
			nop                                     # lenh tre
			
			sge	$t8, $t0, 65			# neu gap chu cai thi yeu cau nhap gia tri cho chu cai do
			beq	$t8, 1, letter_condition1           # bieu thuc so sanh
			nop                                     # lenh tre
			
operand:		lw	$t6, -8($sp)                    # load den $t6
			lw	$t7, -4($sp)                    # load den $t7
			addi	$sp, $sp, -8                    # tra lai stack 
			
			beq	$t0, '+', add_			# neu gap phep toan thi thuc hien phep toan nay voi 2 toan hang duoc lay ra tu ngan xep
			nop                                     # lenh tre
			beq	$t0, '-', sub_                  # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '/', div_                  # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '*', mul_                  # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t0, '^', exp_                  # bieu thuc so sanh
			nop                                     # lenh tre
			addi 	$s1, $s1, 1
			j	iterate_postfix                 # nhay den lable
			
letter_condition1:	sle	$t8, $t0, 90
			beq	$t8, 0, letter_condition2           # bieu thuc so sanh
			nop                                     # lenh tre
			li	$v0, 55
			la	$a0, msg_errorValue
			li $a1, 2
 	                syscall
 	                j ask
 	                nop

ask: 						# tiep tuc khong??
 	li $v0, 50
 	la $a0, endMsg
 	syscall
 	beq $a0,0,main
	beq $a0,2,ask
 	

 end:
 	#li $v0, 55
 	#la $a0, byeMsg
 	#li $a1, 1
 	#syscall
 	li $v0, 10
 	syscall		
letter_condition2:	sge	$t8, $t0, 97
			beq	$t8, 1, letter_condition3           # bieu thuc so sanh
			nop                                     # lenh tre
			j	operand                 # nhay den lable

letter_condition3:	sle	$t8, $t0, 122
			beq	$t8, 0, operand           # bieu thuc so sanh
			nop                                     # lenh tre
			li	$v0, 55
			la	$a0, msg_errorValue
			li $a1, 2
 	                syscall
 	                j ask
 	                nop
			
eliminate_space:	addi	$s1, $s1, 1
			j	iterate_postfix                 # nhay den lable
			nop                                     # lenh tre

continue_:		
			addi	$s1, $s1, 1
			lb	$t2, postfix_($s1)
			beq	$t2, '0', push_number_to_stack		# neu ky tu tiep theo cung la chu so thi push so co 2 c/so nay vao trong stack
			nop                                     # lenh tre
			beq	$t2, '1', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '2', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '3', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '4', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '5', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '6', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '7', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '8', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			beq	$t2, '9', push_number_to_stack           # bieu thuc so sanh
			nop                                     # lenh tre
			
			# neu $t2 ko la chu so, tuc la doc duoc so co 1 c/so, cung push vao stack
			addi	$t0, $t0, -48			# chuyen tu ky tu sang so, VD: tu '1' sang so 1
			sw	$t0, 0($sp)                     # store den sp
			addi	$sp, $sp, 4                     # tang bien
			
			j	iterate_postfix                 # nhay den iterate_postfix
			
push_number_to_stack:	addi	$t0, $t0, -48                   # gian bien 
			addi	$t2, $t2, -48
			mul	$t3, $t0, 10                    # lenh nhan
			add	$t3, $t3, $t2			# neu gap so co 2 chu so thi lay $t3 = 10 * $t1 + $t2
			sw	$t3, 0($sp)                     # store den sp
			addi 	$sp, $sp, 4                     # tang bien sp
			addi	$s1, $s1, 1                     # tang bien
			j	iterate_postfix                 # nhay den lable
			
add_:			add	$t6, $t6, $t7                   # tang bien
			sw	$t6, 0($sp)                     # store den sp
			addi	$sp, $sp, 4                     # tang bien sp
			addi	$s1, $s1, 1                     # tang bien $s1
			j	iterate_postfix                 # nhay den lable
			nop                                     # lenh tre
			
sub_:			sub	$t6, $t6, $t7                   # lenh tru
			sw	$t6, 0($sp)                     # ghi vao sp
			addi	$sp, $sp, 4                     # tang bien
			addi	$s1, $s1, 1                     # tang bien s1
			j	iterate_postfix                 # nhay den lable
			nop                                     # lenh tre
			
div_:			beq	$t7, 0, invalid_dividend	# kiem tra so bi chia khac 0
			nop                                     # lenh tre
			div	$t6, $t6, $t7
			sw	$t6, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix                 # nhay den lable
			nop                                     # lenh tre
			
invalid_dividend:	li	$v0, 55
			la	$a0, msg_error3
			syscall
			j	main                 # nhay den lable
			nop                                     # lenh tre
			
mul_:			mul	$t6, $t6, $t7
			sw	$t6, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix                 # nhay den lable
			nop                                     # lenh tre
			
exp_:			beq	$t7, 0, zero_power		# check so mu = 0
			nop                                     # lenh tre
			mul	$t5, $t5, $t6
			slt	$s3, $s2, $t7
			addi	$s2, $s2, 1
			beq	$s3, 1, exp_
			nop                                     # lenh tre
			sw	$t5, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j 	iterate_postfix                 # nhay den lable

zero_power:		li	$t4, 1
			sw	$t4, 0($sp)
			addi	$sp, $sp, 4                      # tang bien 
			addi	$s1, $s1, 1                      # tang bien
			j	iterate_postfix                 # nhay den lable
end_sort_postfix:
                lw $ra, 0($sp)                         # lay du lieu tu stack vao $ra
                addi $sp, $sp, 4                       # cho stack xuong        
                jr $ra
                nop
# in ket qua bieu thuc

printf_result:	
                       
                        li	$v0, 4                           # gan gia tri
			la	$a0, msg_print_result            # lay string 
			syscall                                  # thuc hien
			li	$v0, 1                           # gan gia tri           
			lw	$t4, -4($sp)                     # doc vao t4
			la	$a0, ($t4)                       # tra noi dung t4 vao a0                        
			syscall                                  # thuc hien
			li	$v0, 4                           # thuc hien
			la	$a0, msg_enter                   # loi goi string
			syscall                                  # thuc hien

