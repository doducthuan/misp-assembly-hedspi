# ================================================================================================
#				   BIEU THUC TRUNG TO HAU TO - MIPS CODE
#				 
# Chuc nang:
# - Nhap vao bieu thuc trung to
# - In ra bieu thuc hau to 
# - In ra ket qua cua bieu thuc trung to
# - Ho tro cac phep toan: cong, tru, nha, chia lay thuong, luy thua
# - Kiem tra cac truong hop dac biet:
#	+ So nam ngoai doan [0, 99]
#	+ Chia cho 0
# 	+ Luy thua mu 0
#	+ Cho phep nhap bien va nhap gia tri cua bien
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

.text
# nhap infix
input_infix:		li	$v0, 54
			la	$a0, msg_read_infix
			la	$a1, infix_
			la 	$a2, 256
			syscall

# in ra infix
li	$v0, 4
la	$a0, msg_print_infix
syscall

li	$v0, 4
la	$a0, infix_
syscall	

# 1. chuyen infix ve postfix
li	$s0, 0		# bien dem de duyet infix
li	$s1, 0		# bien dem de duyet postfix
li	$s2, -1		# bien dem de duyet stack

# bo dau ngoac trong postfix
li	$s6, 0		# bien dem de duyet postfix
li	$s7, 0		# bien dem de duyet postfix_

# bo tat ca dau cach trong infix
li	$s4, 0
li	$s5, 0

# bien dem dau (
li	$a3, 0
remove_space:		lb	$t5, infix_($s4)
			addi	$s4, $s4, 1
			beq	$t5, ' ', remove_space	
			nop
			beq	$t5, 0, iterate_infix
			nop
			sb	$t5, infix($s5)
			addi	$s5, $s5, 1
			j	remove_space

iterate_infix:		lb	$t0, infix($s0)				# doc tung ky tu trong infix
			beq	$t0, $0, end_iterate_infix		# neu ket thuc xau infix, nhay den end_iterate_infix
			nop						
			beq	$t0, '\n', end_iterate_infix		# bo dau xuong dong
			nop
			
			# neu $t0 la toan hang, xet thu tu uu tien cua cac toan hang de nap vao stack						
			beq	$t0, '+', consider_plus_minus		
			nop
			beq	$t0, '-', consider_plus_minus
			nop
			beq	$t0, '*', consider_mul_div
			nop
			beq	$t0, '/', consider_mul_div
			nop
			beq	$t0, '^', push_op_to_stack	# neu gap '^' thi lap tuc dua vao stack
			nop
			beq	$t0, '(', consider_lpar		# neu gap '(' thi check so am
			nop
			beq	$t0, ')', consider_rpar1
			nop
			
			# neu $t0 la toan tu, dua vao postfix ngay lap tuc
			sb	$t0, postfix($s1)			
			addi	$s1, $s1, 1
			
			# ===================================================== xu ly so co 2 chu so - doc truoc 1 ky tu
			addi	$s0, $s0, 1
			lb	$t2, infix($s0)
			beq	$t2, '0', continue
			nop
			beq	$t2, '1', continue
			nop
			beq	$t2, '2', continue
			nop
			beq	$t2, '3', continue
			nop
			beq	$t2, '4', continue
			nop
			beq	$t2, '5', continue
			nop
			beq	$t2, '6', continue
			nop
			beq	$t2, '7', continue
			nop
			beq	$t2, '8', continue
			nop
			beq	$t2, '9', continue
			nop
			# =====================================================
			
			li	$s3, ' '			# them dau cach
			sb	$s3, postfix($s1)
			addi	$s1, $s1, 1
			j	iterate_infix
			nop
						
continue: 		addi	$t3, $s0, 1			# tiep tuc doc truoc 1 ky tu
			lb	$t4, infix($t3)
			beq	$t4, '0', gt99_error_popup	# greater than 99
			nop
			beq	$t4, '1', gt99_error_popup
			nop
			beq	$t4, '2', gt99_error_popup
			nop
			beq	$t4, '3', gt99_error_popup
			nop
			beq	$t4, '4', gt99_error_popup
			nop
			beq	$t4, '5', gt99_error_popup
			nop
			beq	$t4, '6', gt99_error_popup
			nop
			beq	$t4, '7', gt99_error_popup
			nop
			beq	$t4, '8', gt99_error_popup
			nop
			beq	$t4, '9', gt99_error_popup
			nop
			sb	$t2, postfix($s1)  		# them chu so tiep theo cua so vua nhap vao postfix
			addi	$s1, $s1, 1
			li	$s3, ' '			# them dau cach
			sb	$s3, postfix($s1)
			addi	$s1, $s1, 1
			addi	$s0, $s0, 1
			j 	iterate_infix			# nhay ve iterate_infix de doc ky tu tiep theo
			nop

gt99_error_popup:	li	$v0, 55
			la	$a0, msg_error1
			syscall
			j	input_infix
			nop
			
# toan hang '+' va '-' co thu tu uu tien ngang nhau
consider_plus_minus:	beq	$s2, -1, push_op_to_stack	# neu stack rong, nap toan hang dang xet vao stack
			nop
			lb	$t9, stack($s2)
			beq	$t9, '(', push_op_to_stack	# neu dinh stack la dau '(', nap toan hang dang xet vao stack
			nop
			lb	$t1, stack($s2)			# else, day tat ca cac toan hang ra khoi stack, sau do nap toan hang dang xet vao
			sb	$t1, postfix($s1)
			addi	$s2, $s2, -1
			addi	$s1, $s1, 1
			j	consider_plus_minus	
			nop

# toan hang '*' va '/' co thu tu uu tien ngang nhau
consider_mul_div:	beq	$s2, -1, push_op_to_stack	# neu stack rong, nap toan hang dang xet vao stack
			nop
			lb	$t9, stack($s2)			# neu dinh stack la '+', '-', '(', nap toan hang dang xet vao stack
			beq	$t9, '+', push_op_to_stack
			nop
			beq	$t9, '-', push_op_to_stack
			nop
			beq	$t9, '(', push_op_to_stack
			nop
			lb	$t1, stack($s2)			# else, dua lan luot cac ky hieu tu stack vao trong postfix
			sb	$t1, postfix($s1)
			addi	$s2, $s2, -1
			addi	$s1, $s1, 1
			j	consider_mul_div
			nop
			
consider_rpar1:		addi	$a3, $a3, -1
			j	consider_rpar
			nop
			
consider_rpar:		beq	$s2, -1, push_op_to_stack	# neu stack rong, nap ky kieu vao stack
			nop
			lb	$t1, stack($s2)			# else, day toan hang ra khoi stack
			sb	$t1, postfix($s1)		# dua vao postfix
			addi	$s2, $s2, -1
			addi	$s1, $s1, 1
			beq	$t1, '(', push_op_to_stack	# cho den khi gap dau '(' dau tien duoc dua ra
			j	consider_rpar
			nop	

consider_lpar:		addi	$a3, $a3, 1
			addi	$t3, $s0, 1
			lb	$t4, infix($t3)
			beq	$t4, '-', lt0_error_popup	# less than 0
			nop
			j	push_op_to_stack
			nop	
		
lt0_error_popup:	li	$v0, 55
			la	$a0, msg_error2
			syscall
			j	input_infix
			nop			
			
push_op_to_stack:	addi	$s2, $s2, 1
			sb	$t0, stack($s2)
			addi	$s0, $s0, 1
			j 	iterate_infix
			nop

# dua toan bo toan hang con lai cua stack ra khoi ngan xep, va push vao postfix
end_iterate_infix:	beq	$s2, -1, remove_parentheses
			nop
			lb	$t0, stack($s2)
			sb	$t0, postfix($s1)
			addi	$s2, $s2, -1
			addi	$s1, $s1, 1
			j	end_iterate_infix
			nop

# bo dau ngoac trong postfix
remove_parentheses:	lb	$t5, postfix($s6)
			addi	$s6, $s6, 1
			beq	$t5, '(', remove_parentheses
			nop
			beq	$t5, ')', remove_parentheses
			nop
			beq	$t5, 0, print_postfix		# neu gap ky tu rong -> duyet xong postfix -> in ra postfix_
			nop
			sb	$t5, postfix_($s7)
			addi	$s7, $s7, 1
			j	remove_parentheses
			nop
				
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
			nop
			j	calculate_postfix
			nop
			
error1:			li	$v0, 55
			la	$a0, msg_error4
			syscall
			j	input_infix
			nop

# 2. tinh postfix
calculate_postfix:	li	$s1, 0		# set lai bien duyet postfix
			li	$s2, 1		# biet dem de tinh ham mu
			li	$t5, 1		# phuc vu cho viec tinh ham mu

iterate_postfix: 	lb	$t0, postfix_($s1)
			beq	$t0, 0, printf_result
			nop
			beq	$t0, ' ', eliminate_space
			nop
			beq	$t0, '0', continue_		# neu gap chu so thi doc tiep ky tu tiep theo
			nop
			beq	$t0, '1', continue_
			nop
			beq	$t0, '2', continue_
			nop
			beq	$t0, '3', continue_
			nop
			beq	$t0, '4', continue_
			nop
			beq	$t0, '5', continue_
			nop
			beq	$t0, '6', continue_
			nop
			beq	$t0, '7', continue_
			nop
			beq	$t0, '8', continue_
			nop
			beq	$t0, '9', continue_
			nop
			
			sge	$t8, $t0, 65			# neu gap chu cai thi yeu cau nhap gia tri cho chu cai do
			beq	$t8, 1, letter_condition1
			nop
			
operand:		lw	$t6, -8($sp)
			lw	$t7, -4($sp)
			addi	$sp, $sp, -8
			
			beq	$t0, '+', add_			# neu gap phep toan thi thuc hien phep toan nay voi 2 toan hang duoc lay ra tu ngan xep
			nop
			beq	$t0, '-', sub_
			nop
			beq	$t0, '/', div_
			nop
			beq	$t0, '*', mul_
			nop
			beq	$t0, '^', exp_
			nop
			addi 	$s1, $s1, 1
			j	iterate_postfix
			
letter_condition1:	sle	$t8, $t0, 90
			beq	$t8, 0, letter_condition2
			nop
			li	$v0, 51
			la	$a0, msg_enter_value
			syscall
			sw	$a0, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix
			
letter_condition2:	sge	$t8, $t0, 97
			beq	$t8, 1, letter_condition3
			nop
			j	operand

letter_condition3:	sle	$t8, $t0, 122
			beq	$t8, 0, operand
			nop
			li	$v0, 51
			la	$a0, msg_enter_value
			syscall
			sw	$a0, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix
			
eliminate_space:	addi	$s1, $s1, 1
			j	iterate_postfix
			nop

continue_:		
			addi	$s1, $s1, 1
			lb	$t2, postfix_($s1)
			beq	$t2, '0', push_number_to_stack		# neu ky tu tiep theo cung la chu so thi push so co 2 c/so nay vao trong stack
			nop
			beq	$t2, '1', push_number_to_stack
			nop
			beq	$t2, '2', push_number_to_stack
			nop
			beq	$t2, '3', push_number_to_stack
			nop
			beq	$t2, '4', push_number_to_stack
			nop
			beq	$t2, '5', push_number_to_stack
			nop
			beq	$t2, '6', push_number_to_stack
			nop
			beq	$t2, '7', push_number_to_stack
			nop
			beq	$t2, '8', push_number_to_stack
			nop
			beq	$t2, '9', push_number_to_stack
			nop
			
			# neu $t2 ko la chu so, tuc la doc duoc so co 1 c/so, cung push vao stack
			addi	$t0, $t0, -48			# chuyen tu ky tu sang so, VD: tu '1' sang so 1
			sw	$t0, 0($sp)
			addi	$sp, $sp, 4
			
			j	iterate_postfix
			
push_number_to_stack:	addi	$t0, $t0, -48
			addi	$t2, $t2, -48
			mul	$t3, $t0, 10
			add	$t3, $t3, $t2			# neu gap so co 2 chu so thi lay $t3 = 10 * $t1 + $t2
			sw	$t3, 0($sp)
			addi 	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix
			
add_:			add	$t6, $t6, $t7
			sw	$t6, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix
			nop
			
sub_:			sub	$t6, $t6, $t7
			sw	$t6, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix
			nop
			
div_:			beq	$t7, 0, invalid_dividend	# kiem tra so bi chia khac 0
			nop
			div	$t6, $t6, $t7
			sw	$t6, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix
			nop
			
invalid_dividend:	li	$v0, 55
			la	$a0, msg_error3
			syscall
			j	input_infix
			nop
			
mul_:			mul	$t6, $t6, $t7
			sw	$t6, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix
			nop
			
exp_:			beq	$t7, 0, zero_power		# check so mu = 0
			nop
			mul	$t5, $t5, $t6
			slt	$s3, $s2, $t7
			addi	$s2, $s2, 1
			beq	$s3, 1, exp_
			nop
			sw	$t5, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j 	iterate_postfix

zero_power:		li	$t4, 1
			sw	$t4, 0($sp)
			addi	$sp, $sp, 4
			addi	$s1, $s1, 1
			j	iterate_postfix

printf_result:		li	$v0, 4
			la	$a0, msg_print_result
			syscall
			li	$v0, 1
			lw	$t4, -4($sp)
			la	$a0, ($t4)
			syscall
			li	$v0, 4
			la	$a0, msg_enter
			syscall
			
