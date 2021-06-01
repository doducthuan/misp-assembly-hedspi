
############## De ##############

#Bieu thuc trung to hau to

################################
.data
infix: .space 256
postfix: .space 256
stack: .space 256
prompt:	.asciiz "Nhap bieu thuc trung to\nChi nhap so nguyen va khong chua ki hieu dac biet va bo dau '('"
newLine: .asciiz "\n"
prompt_postfix: .asciiz "PostFix is: "                # Khai bao string cho nhan
#prompt_result: .asciiz "Result is: "                  # Khai bao string cho nhan
prompt_infix: .asciiz "Infix is: "                    # Khai bao string cho nhan

# Nhan tien to
.text
 li $v0, 54                                           # Dat gia tri cho $v0
 la $a0, prompt                                       # Loi goi den string
 la $a1, infix                                        # Loi goi den string
 la $a2, 256                                          # Dat gia tri cho $a2
 syscall                                              # Thuc hien
  
la $a0, prompt_infix                                  # Loi goi den string
li $v0, 4                                             # Dat gia tri cho $v0
syscall                                               # Thuc hien
	
la $a0, infix                                         # Thiet lap dia cho nhan cho $a0
li $v0, 4                                             # Dat gia tri cho $v0
syscall                                               # Thuc hien

# chuyen doi sang hau to

li $s6, -1                                            # counter
li $s7, -1                                            # Scounter
li $t7, -1                                            # Pcounter
while:
        la $s1, infix                                 #buffer = $s1
        la $t5, postfix                               #postfix = $t5
        la $t6, stack                                 #stack = $t6
        li $s2, '+'                                   # $s2 = '+'
        li $s3, '-'                                   # $s3 = '-'
        li $s4, '*'                                   # $s4 = '*'
        li $s5, '/'                                   # $s5 = '/'
	addi $s6, $s6, 1                              # Tang gia tri len 1
	
# get buffer[counter]
	add $s1, $s1, $s6                             
	lb $t1, 0($s1)	                              # t1 = value of buffer[counter]
	
	beq $t1, $s2, operator # '+'                  # so sanh input voi toan tu
	nop                                           # lenh tre
	beq $t1, $s3, operator # '-'                  # so sanh input voi toan tu
	nop                                           # lenh tre
	beq $t1, $s4, operator # '*'                  # so sanh input voi toan tu
	nop                                           # lenh tre
	beq $t1, $s5, operator # '/'                  # so sanh input voi toan tu
	nop                                           # lenh tre
	beq $t1, 10, n_operator # '\n'                # so sanh input voi lenh xuong dong
	nop                                           # lenh tre
	beq $t1, 32, n_operator # ' '                 # so sanh input voi khoang trong
	nop                                           # lenh tre
	beq $t1, $zero, endWhile                      # so sanh input voi 0
	nop                                           # lenh tre
	
# Day so den hau to
	addi $t7, $t7, 1                              # tang gia tri len 1          
	add $t5, $t5, $t7                             # $t5 = $t5 + $t7
	sb $t1, 0($t5)                                # store byte: ghi $t1 -> $t5
	lb $a0, 1($s1)                                # load byte  
	jal check_number                              # chuyen den nhan check so
	nop                                           # lenh tre
	beq $v0, 1, n_operator                        # so sanh gia tri $v0 va chuyen huong neu trung
	nop                                           # lenh tre
	#Khoang Cach
	add_space:
	add $t1, $zero, 32                            # $t1 = 32
	sb $t1, 1($t5)                                # store byte den $t1
	addi $t7, $t7, 1                              # tang $t7 them 1
	j n_operator                                  # chuyen huong den n_operator
	nop                                           # lenh tre
	operator:
# add to stack ...	
	beq $s7, -1, pushToStack                      # so sanh $s7 va dieu huong neu giong
	nop                                           # lenh tre
	add $t6, $t6, $s7                             # $t6 = $t6 + $s7
	lb $t2, 0($t6)                                # t2 = value of stack[counter]
# check t1 precedence
	beq $t1, $s2, t1to1                           # so sanh       
	nop                                           # lenh tre
	beq $t1, $s3, t1to1                           # so sanh
	nop                                           # lenh tre
	li $t3, 2                                     # gan gia tri
	j check_t2                                    # link den nhan check_t2
	nop	                                      # lenh tre
t1to1:
	li $t3, 1                                     # gan gia tri $t3
# check t2 precedence
check_t2:
	beq $t2, $s2, t2to1                           # so sanh
	nop                                           # lenh tre
	beq $t2, $s3, t2to1                           # so sanh
	nop                                           # lenh tre
	li $t4, 2	                              # gan gia tri
	j compare_precedence                          # chuyen den nhan compare_precedence
	nop                                           # lenh tre
	
t2to1:
	li $t4, 1	                              # gan gia tri
	
compare_precedence:
	
	beq $t3, $t4, equal_precedence                # so sanh
	nop                                           # lenh tre
	slt $s1, $t3, $t4                             # so sanh <  then $s1 =1
	beqz $s1, t3_large_t4                         # j t3_large_t4 if $s1=0                          
	nop                                           # lenh tre
################	
# t3 < t4
# pop t2 from stack  and t2 ==> postfix  
# get new top stack do again

	sb $zero, 0($t6)                              # store byte
	addi $s7, $s7, -1                             # giam gia tri
	addi $t6, $t6, -1                             # gian gia tri
	la $t5, postfix                               # postfix = $t5
	addi $t7, $t7, 1                              # tang gia tri
	add $t5, $t5, $t7                             # thuc hien cong
	sb $t2, 0($t5)                                # ghi byte
	
#addi $s7, $s7, -1  # scounter = scounter - 1
	j operator                                    # den nhan operator
	nop                                           # lenh tre
	
################	
t3_large_t4:
# push t1 to stack
	j pushToStack                                 # nhay den nhan pushToStack
	nop                                           # lenh tre
################
equal_precedence:
# pop t2  from stack  and t2 ==> postfix  
# push to stack

	sb $zero, 0($t6)                              # ghi byte
	addi $s7, $s7, -1                             # giam gia tri
	addi $t6, $t6, -1                             # giam gia tri
	la $t5, postfix                               #postfix = $t5 
	addi $t7, $t7, 1                              # tang gia tri 
	add $t5, $t5, $t7                             # thuc hien lenh cong
	 
	sb $t2, 0($t5)                                # ghi byte
	j pushToStack                                 # nhay den nhan pushToStack
	nop                                           # lenh tre
################
pushToStack:

	la $t6, stack                                 #stack = $t6
	addi $s7, $s7, 1                              # scounter ++
	add $t6, $t6, $s7                             # Lenh cong
	sb $t1, 0($t6)	                              # ghi byte den $t1
	
	n_operator:	
	j while	                                      # nhay den while
	nop                                           # lenh tre
	
#######################
endWhile:
	addi $s1, $zero, 32                           # $s1=32
	addi $t7, $t7, 1                              # tang gia tri                       
	add $t5, $t5, $t7 
	la $t6, stack                                 # $t6= stack
	add $t6, $t6, $s7                             # thuc hien lenh cong thanh ghi
	
popallstack:

	lb $t2, 0($t6)                                # t2 = value of stack[counter]
	beq $t2, 0, endPostfix                        #phep so sanh
	sb $zero, 0($t6)                              # ghi byte
	addi $s7, $s7, -2                             # cong hang so
	add $t6, $t6, $s7                             # thuc hien phep cong
	
	sb $t2, 0($t5)                                # ghi byte
	add $t5, $t5, 1                               # thuc hien lenh cong
	j popallstack                                 # nhay den nhan papallstack
	nop                                           # lenh tre

endPostfix:
############################################################################### END POSTFIX
# print postfix
la $a0, prompt_postfix                               # $a0 = prompt_postfix
li $v0, 4                                            # gan gia tri
syscall                                              # thuc hien

la $a0, postfix                                      # $a0 = postfix
li $v0, 4                                            # gan gia tri
syscall                                              # thuc hien

la $a0, newLine                                      # $a0 = '\n'
li $v0, 4                                            # gan gia tri
syscall                                              # thuc hien


############################################################################### Caculate

li $s3, 0                                           # gan gia tri
la $s2, stack                                       #stack = $s2


# postfix to stack
while_p_s:
	la $s1, postfix                             #postfix = $s1
	add $s1, $s1, $s3                           # thuc hien phep cong
	lb $t1, 0($s1)                              # load byte
# if null
	beqz $t1 end_while_p_s                      # if $t1=0 then lable end_while_p_s
	nop                                         # gan gia tri
	add $a0, $zero, $t1                         # lenh cong
	jal check_number                            # nhay den check_number
	nop                                         # gan gia tri
	beqz $v0, is_operator                       # if $v0 =0 then is_operator
	nop                                         # gan gia tri
	jal add_number_to_stack                     # nhay den add_number_to_stack
	nop                                         # gan gia tri
	j continue                                  # nhay den nhan continue
	nop                                         # lenh tre
	
is_operator:
	jal pop                                     # nhay den pop
	nop                                         # lenh tre
	add $a1, $zero, $v0                         # thuc hien lenh cong
	jal pop                                     # nhay den pop
	nop                                         # lenh tre
	add $a0, $zero, $v0                         # lenh cong	
	add $a2, $zero, $t1                         # lenh cong
	jal caculate                                # nhay den caculate
	nop                                         # lenh tre
continue:
	add $s3, $s3, 1                            # counter++
	j while_p_s                                # nhay den while_p_s
	nop                                        # lenh tre
#-----------------------------------------------------------------
#Procedure caculate
# @brief caculate the number ("a op b")
# @param[int] a0 : (int) a
# @param[int] a1 : (int) b
# @param[int] a2 : operator(op) as character
#-----------------------------------------------------------------
caculate:
	sw $ra, 0($sp)                             # ghi byte
	li $v0, 0                                  # gan gia tri
	beq $t1, '*', cal_case_mul                 # so sanh toan tu
	nop                                        # lenh tre
	beq $t1, '/', cal_case_div                 # so sanh toan tu
	nop                                        # lenh tre
	beq $t1, '+', cal_case_plus                # so sanh toan tu
	nop                                        # lenh tre
	beq $t1, '-', cal_case_sub                 # so sanh toan tu
	
	cal_case_mul:
		mul $v0, $a0, $a1                  # thuc hien phep nhan
		j cal_push                         # nhay den cal_push
		nop                                # lenh tre
	cal_case_div:
		div $a0, $a1                       # gan bit cao
		mflo $v0                        
		j cal_push                         # nhay den cal_push
		nop                                #lenh tre
	cal_case_plus:
		add $v0, $a0, $a1                  # phep cong
		j cal_push                         # nhay den cal_push
		nop                                #lenh tre 
	cal_case_sub:
		sub $v0, $a0, $a1                  # thuc hien phep tru
		j cal_push                         # nhay den cal_push
		nop                                # lenh tre
	cal_push:
		add $a0, $v0, $zero                # phep gan
		jal push                           # nhay den push
		nop                                #lenh tre
		lw $ra, 0($sp)                     # tro ve
		jr $ra                             # tro ve
		nop                                #lenh tre
	


#-----------------------------------------------------------------
#Procedure add_number_to_stack
# @brief get the number and add number to stack at $s2
# @param[in] s3 : counter for postfix string
# @param[in] s1 : postfix string
# @param[in] t1 : current value
#-----------------------------------------------------------------
add_number_to_stack:
	# save $ra
	sw $ra, 0($sp)
	li $v0, 0
	while_ants:
		beq $t1, '0', ants_case_0                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '1', ants_case_1                         # so sanh if = then lable
		nop                                               # lenh tre                       
		beq $t1, '2', ants_case_2                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '3', ants_case_3                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '4', ants_case_4                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '5', ants_case_5                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '6', ants_case_6                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '7', ants_case_7                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '8', ants_case_8                        # so sanh if = then lable
		nop                                               # lenh tre
		beq $t1, '9', ants_case_9                        # so sanh if = then lable
		nop                                               # lenh tre
		
		ants_case_0:
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre  
		ants_case_1:
			addi $v0, $v0, 1	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_case_2:
			addi $v0, $v0, 2	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_case_3:
			addi $v0, $v0, 3	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_case_4:
			addi $v0, $v0, 4	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_case_5:
			addi $v0, $v0, 5	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_case_6:
			addi $v0, $v0, 6	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_case_7:
			addi $v0, $v0, 7	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_case_8:
			addi $v0, $v0, 8	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop
		ants_case_9:
			addi $v0, $v0, 9	                 # cong hang so
			j ants_end_sw_c                          # nhay den lable
			nop                                      # lenh tre
		ants_end_sw_c:
			add $s3, $s3, 1	                         # cong hang so
			la $s1, postfix                          #postfix = $s1
			add $s1, $s1, $s3                       # thuc hien phep cong
			lb $t1, 0($s1)                           # load byte to $t1
			beq $t1, $zero, end_while_ants           # so sanh if = then lable
			beq $t1, ' ', end_while_ants              # so sanh if = then lable
			mul $v0, $v0, 10                          # phep nhan
			j while_ants                              # nhay den lable
			nop                                      # lenh tre
	end_while_ants:
		add $a0, $zero, $v0                              # phep gan
		jal push                                         # nhay den push
		nop                                              # lenh tre
		# get $ra
		lw $ra, 0($sp)                                   # quay ve
		jr $ra                                           # quay ve
		nop                                              # lenh tre
		
		
#-----------------------------------------------------------------
#Procedure check_number
# @brief check character is number or not 
# @param[int] a0 : character to check
# @param[out] v0 : 1 = true; 0 = false
#-----------------------------------------------------------------
check_number:
        
	li $t8, '0'                                         # gan gia tri
	li $t9, '9'                                         # gan gia tri
	
	beq $t8, $a0, check_number_true                     # so sanh if = then lable
	beq $t9, $a0, check_number_true                     # so sanh if = then lable
	
	slt $v0, $t8, $a0                                # so sanh if < then =1                                 
	beqz $v0, check_number_false                     # so sanh if = 0 then lable
	
	slt $v0, $a0, $t9                                # so sanh if < then =1
	beqz $v0, check_number_false                     # so sanh if = 0then lable
check_number_true:
	
	li $v0, 1                                         # quay ve
	jr $ra                                         # quay ve
	nop                                         # lenh tre
check_number_false:
	
	li $v0, 0                                         # quay ve
	jr $ra                                         # quay ve
	nop                                         # lenh tre
#-----------------------------------------------------------------
#Procedure pop
# @brief pop from stack at $s2
# @param[out] v0 : value to popped
#-----------------------------------------------------------------
pop:
	lw $v0, -4($s2)                          # tra lai stack
	sw $zero, -4($s2)                        #xet lai gia tri
	addi $s2, $s2, -4                        # cong hang so                   
	jr $ra                                   # quay ve
	nop                                      # lenh tre
#-----------------------------------------------------------------
#Procedure push
# @brief push to stack at $s2
# @param[in] a0 : value to push
#-----------------------------------------------------------------
push:
	sw $a0, 0($s2)                           #ghi noi dung
	addi $s2, $s2, 4                         # cong hang so
	jr $ra                                   # quay ve
	nop                                      # lenh tre
end_while_p_s:
# add null to end of stack

# print postfix
#la $a0, prompt_result                             # goi string
#li $v0, 4                                         # gian gia tri
#syscall                                           # thuc hien

#jal pop                                           # nhay den pop
#nop                                               # lenh tre
#add $a0, $zero, $v0                               # lenh gan
#li $v0, 1                                         # gan gia tri
#syscall                                           # thuc hien

la $a0, newLine                                   # goi string
li $v0, 4                                         # gan gia tri
syscall                                           # thuc hien
