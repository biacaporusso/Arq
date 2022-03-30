.data
	msg: .asciiz "\nInsira um numero N: "
	espaco: .byte ' '
	pulalinha: .asciiz "\n"
.text

	leitura:
		li $v0, 4	# imprimir uma string
		la $a0, msg	# imprime msg
		syscall
		li $v0, 5	# leitura do inteiro N
		syscall
		move $t0, $v0	# movendo o N inserido para o registrador $t0, $t0 = N
	
	#imprime o 2 primeiro (o 2 nao tem como inserir nos calculos pq é o unico primo par, entao vou imprimir ele antes)
	li $v0, 1		# comando para imprimir um inteiro
	addi $a0, $zero, 2	# imprimindo o 2
	syscall
	
	# imprime um espaço
	li $v0, 4		# comando para imprimir uma string
	la $a0, espaco
	syscall
	
	# verificar os numeros primos a partir do 3 até N	
	
	# vou precisar de um contador i e j , i dos numeros ate o N e j pra realizar as divisões
	li $t5, 2	# contador i, $t5 = 2
	li $t6, 2	# contador j, $t6 = 2
	
	loop1:
		add $t5, $t5, 1		# $t1 = $t1 + 1
		beq $t5, $t0, fim	# se $t5 = $t0 ( i = N ) , pula para o fim do programa pois ja verificou quais sao os numeros primos até N
	
		loop2:
	
			beq $t6, $t5, imprimePrimo	# se j = i , é primo
	
			div $t5, $t6	# i / j
			mfhi $t3	# $t3 = resto da divisao
		
			# se o resto da divisao for igual a zero, significa que nao é primo
			beq $t3, $zero, naoPrimo
			
			#senao, o resto da divisao é diferente de zero, então pode ser primo
			addi $t6, $t6, 1	# $t6 = $t6 + 1
			j loop2			# jump para loop2
	
	naoPrimo:
		# já que $t5 nao é primo, vai pro proximo numero 
		li $t6, 2	# $t6 = 2 novamente para recomeçar os cálculos
		j loop1		# jump para o loop1
	
	imprimePrimo:
	
		li $v0, 1		# comando para imprimir inteiro
		move $a0, $t5		# movendo o valor de $t5 para o registrador $a0
		syscall			# executando
		
		# imprime um espaço
		li $v0, 4		# comando para imprimir string
		la $a0, espaco		# carregando $a0 com o espaço
		syscall
		
		li $t6, 2		# $t6 = 2 novamente para recomeçar os cálculos
		j loop1			# jump para o loop1
	
	
	fim:
		li $v0, 10	# encerra o programa
		syscall
		
