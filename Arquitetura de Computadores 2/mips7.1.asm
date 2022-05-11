.data
	msg: .asciiz "\nInsira um numero inteiro N: "
	erro: .asciiz "O numero inserido e menor ou igual a zero. Favor inserir novamente.\n"
	espaco: .byte ' '
	msgPrimosGemeos: .asciiz "\nPrimos gêmeos: "
	parenteses1: .byte '('
	virgula: .asciiz ", "
	parenteses2: .asciiz ") , "
.text
	
main:
	leitura:
	li $v0, 4	# imprimir uma string
	la $a0, msg	# imprime msg
	syscall
	li $v0, 5	# leitura do inteiro N
	syscall
	move $s0, $v0			# movendo o inteiro N inserido para o registrador $s0, $s0 = N
	ble $s0, 0, msgerro		# se N <= 0, ocorre erro na leitura
		
	li $v0, 4		# imprimir uma string
	la $a0, msgPrimosGemeos	# imprime msg
	syscall
	
	li $t0, 0	# contador i
	li $t1, 3	# numeros primos (vao ser incrementados)
	li $t2, 2	# divisoes por 2
	
	jal primos
	
	li $v0, 10	# encerra o programa
	syscall

# verificadorDePrimo:

# primo: tem que ser ímpar 
# primo: só pode ser divisível por 1 e por ele mesmo
# passa de parametro o numero a ser analisado pra $t9
# move $s1, $t9
verificadorDePrimo:
	# N = $s0
	beq $t8, $s0, saiDoLoop		# $t8 sao os numeros que vao dividindo ex N=10  10/3 10/4 10/5 10/6
	# 1º dividir por dois
	div $t8, $t2
	mfhi $t3	# resto
	bne $t3, 0, segundaParte
	# senão, $t8 não é primo, analisa o proximo:
	addi $t8, $t8, 1
	j verificadorDePrimo
	segundaParte:


saiDoLoop:


primos:
	beq $t0, $s0, endLoop	
	li $t9, 4
	loopPrimo:
		beq $t9, $s0, ePrimo
		div $t9, $t1
		mfhi $t3
		bne $t3, 0, continua
		# else:
		addi $t0, $t0, 1	# numero que vai ser verificado se é primo ou não	
		addi $t1, $t1, 1	# contador i = i+1
		j primos
		continua:
		div $t1, $t2	# $t1 / 2
		mfhi $t3	# resto da divisão por 2
		bne $t3, 0, continua2
		# else:
		addi $t0, $t0, 1	# numero que vai ser verificado se é primo ou não	
		addi $t1, $t1, 1	# contador i = i+1
		j primos
		continua2:
		addi $t9, $t9, 1
		j loopPrimo
			
	
ePrimo:
	# se N é primo, verifica se N+2 é primo tambem	
	addi $s1, $t1, 2	# $s1 = $t1 + 2
	div $s1, $t2	# $s1 / 2
	mfhi $t3	# resto da divisão por 2
	bne $t3, 0, primosGemeos
	#else:
	addi $t0, $t0, 1	# numero que vai ser verificado se é primo ou não	
	addi $t1, $t1, 1	# contador i = i+1
	j primos
	
primosGemeos:
	li $v0, 4		# imprimir uma string
	la $a0, parenteses1	# imprime msg
	syscall

	li $v0, 1		# imprime inteiro
	move $a0, $t1		# movendo o valor de $t1 para o registrador $a0
	syscall	
	
	li $v0, 4		# imprimir uma string
	la $a0, virgula		# imprime msg
	syscall
		
	li $v0, 1		# imprime inteiro
	move $a0, $s1		# movendo o valor de $t1 para o registrador $a0
	syscall		

	li $v0, 4		# imprimir uma string
	la $a0, parenteses2	# imprime msg
	syscall
	
	addi $t0, $t0, 1	# numero que vai ser verificado se é primo ou não	
	addi $t1, $t1, 1	# contador i = i+1
	j primos
	
endLoop:
	jr $ra	
	
msgerro:
	# caso o usuario tenha inserido um numero menor ou igual a zero, imprime uma mensagem de erro e faz a leitura novamente
	li $v0, 4	# imprimir uma string
	la $a0, erro	# imprime erro
	syscall	
	j leitura	# volta para fazer a leitura de um numero correto