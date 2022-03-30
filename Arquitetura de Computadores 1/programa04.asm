.data
	msg: .asciiz "\nInsira um numero inteiro N: "
	msgNaoPrimo: .asciiz "O numero digitado nao e primo."
	msgPrimo: .asciiz "O numero N e primo.\n"
	erro: .asciiz "O numero inserido e menor ou igual a zero. Favor inserir novamente.\n"
	espaco: .byte ' '
	
.text

	leitura:
		li $v0, 4	# imprimir uma string
		la $a0, msg	# imprime msg
		syscall
		li $v0, 5	# leitura do inteiro N
		syscall
		move $t0, $v0			# movendo o inteiro N inserido para o registrador $t0, $t0 = N
		ble $t0, $zero, msgerro		# se N <= 0, ocorre erro na leitura
	
	li $t1, 2	# contador i, $t1 = 2
	
	
# ------------------------ PRIMEIRA PARTE: VERIFICAR SE O N É PRIMO OU NÃO --------------------------------
	
	verificadorN:
		beq $t1, $t0, ePrimo
	
		div $t0, $t1	# N / i
		mfhi $t3
		
		# se o resto da divisao for igual a zero, significa que nao é primo, sai da função e encerra o programa
		beq $t3, $zero, naoPrimo
		#senao, o resto da divisao é diferente de zero, então é primo
		# imprimir os numeros primos ate N
		addi $t1, $t1, 1	# i = i + 1
		j verificadorN
		
	naoPrimo:
		li $v0, 4	# imprimir uma string
		la $a0, msgNaoPrimo	
		syscall
		j fim
		
# ------------------------ SEGUNDA PARTE: CASO O N SEJA PRIMO, IMPRIMIR TODOS OS PRIMOS ATÉ N ------------------------
	
	ePrimo:
		# imprimindo a mensagem que diz que N é primo
		li $v0, 4		# comando para imprimir uma string
		la $a0, msgPrimo	# imprime msgPrimo	
		syscall
		
		#imprime o 2 primeiro (o 2 nao tem como inserir nos calculos pq é o unico primo par, entao vou imprimir ele antes)
		li $v0, 1		# comando para imprimir um inteiro
		addi $a0, $zero, 2	# imprimindo o 2
		syscall
		
		# imprime um espaço
		li $v0, 4		# comando para imprimir uma string
		la $a0, espaco
		syscall
		
		# vou precisar de um contador i e j , i dos numeros ate o N e j pra realizar as divisões
		li $t1, 2	# contador i, $t1 = 2
		li $t2, 2	# contador j, $t2 = 2
		
	loop1:
		add $t1, $t1, 1		# $t1 = $t1 + 1
		beq $t1, $t0, fim	# se $t1 = $t0 ( i = N ) , pula para o fim do programa pois ja verificou quais sao os numeros primos até N
	
		loop2:
	
			beq $t2, $t1, imprimePrimo	# se j = i , é primo
	
			div $t1, $t2	# i / j
			mfhi $t3	# $t3 = resto da divisao
		
			# se o resto da divisao for igual a zero, significa que nao é primo
			beq $t3, $zero, naoPrimo2
			
			#senao, o resto da divisao é diferente de zero, então pode ser primo
			addi $t2, $t2, 1	# $t2 = $t2 + 1
			j loop2			# jump para loop2
		
	naoPrimo2:
		# já que $t1 nao é primo, vai pro proximo numero 
		li $t2, 2	# $t2 = 2 novamente para recomeçar os cálculos
		j loop1		# jump para o loop1
		
	imprimePrimo:
		
		li $v0, 1		# comando para imprimir inteiro
		move $a0, $t1		# movendo o valor de $t1 para o registrador $a0
		syscall			# executando
		
		# imprime um espaço
		li $v0, 4		# comando para imprimir string
		la $a0, espaco		# carregando $a0 com o espaço
		syscall
		
		li $t2, 2		# $t2 = 2 novamente para recomeçar os cálculos
		j loop1			# jump para o loop1
		
	fim:
		li $v0, 10	# encerra o programa
		syscall
		

	msgerro:
	# caso o usuario tenha inserido um numero menor ou igual a zero, imprime uma mensagem de erro e faz a leitura novamente
		li $v0, 4	# imprimir uma string
		la $a0, erro	# imprime erro
		syscall	
		j leitura	# volta para fazer a leitura de um numero correto	
		
