.data
	msg: .asciiz "\nInsira um numero N: "
	msgSoma: .asciiz "Soma = "
	
.text

	leitura:
		li $v0, 4	# imprimir uma string
		la $a0, msg	# imprime msg
		syscall
		li $v0, 5	# leitura do inteiro N
		syscall
		move $t0, $v0	# movendo o inteiro N inserido para o registrador $t0, $t0 = N
		
		
	li $t1, 0	# contador i, $t1 = 0
	li $t9, 0	# $t9 vai armazenar a soma dos quadrados dos números até N
	
	loop1:
		beq $t1, $t0, fim	# se i = N, sai do loop
		mul $s0, $t1, $t1	# $s0 = $t1 * $t1
		add $t9, $t9, $s0	# $t9 = $t9 + %s0
		addi $t1, $t1, 1	# $t1 = $t1 + 1
		j loop1	
		
	fim:
		li $v0, 4		# comando para imprimir uma string
		la $a0, msgSoma
		syscall
		
		li $v0, 1		# comando para imprimir inteiro
		move $a0, $t9
		syscall
	
	li $v0, 10	# encerra o programa
	syscall
	
	
	
	
