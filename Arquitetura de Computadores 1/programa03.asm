.data
	msgA: .asciiz "\nInsira um inteiro A: "
	msgB: .asciiz "Insira um inteiro B: "
	vezes: .asciiz "A x B = "
	erro: .asciiz "O numero inserido e menor ou igual a zero. Favor inserir novamente.\n"
	
	espaco: .byte ' '
	
.text

	move $t4, $zero		# indice do array (tamanho, em byte)
	
# -------- LEITURA DOS INTEIROS 'A' E 'B' ------------------- 
	leitura:
		li $v0, 4	# imprimir uma string
		la $a0, msgA	# imprime msgA
		syscall
		li $v0, 5	# leitura do inteiro A
		syscall
		move $t0, $v0	# movendo o valor A inserido para o registrador $t0, $t0 = A
		ble $t0, $zero, msgerro	# se A <= 0, ocorre erro na leitura
	
		li $v0, 4	# imprimir uma string
		la $a0, msgB	# imprime msgB
		syscall
		li $v0, 5	# leitura do inteiro B
		syscall
		move $t1, $v0	# movendo o valor B inserido para o registrador $t1, $t1 = B
		ble $t1, $zero, msgerro	# se B <= 0, ocorre erro na leitura
		
	
# ------------ C�LCULOS --------------
	mul $s0, $t0, $t1	# $s0 = $t0 * $t1
	
	li $t2, 0	# $t2 = 0, vai ser o nosso i, o contador 
	
	loop:
		# enquanto i < $s0 , verifica se o n�mero i � m�ltiplo de A
		bgt $t2, $s0, fim	# se $t2 > $s0, sai do loop e pula pro fim
		
		#sen�o:
		# se i dividido por A o resto for igual a zero, � multiplo de A
		# se for multiplo de A, imprime ele
		
		div $t2, $t0	# $t2 / $t0 , resultado inteiro em LO e resto em HI
		mfhi $t3	# $t3 contem o resto da divisao
		
		# se o resto da divisao = 0, � multiplo
		beq $t3, $zero, multiplo
		
		# sen�o, acrescenta 1 no contador e volta pro inicio da fun��o
		add $t2, $t2, 1		# $t2 = $t2 + 1
		j loop
		
		
	multiplo:
	
		beq $t2, $zero, acrescimo	# serve para n�o imprimir o 0, j� que $t2 come�a em 0 e zero n�o � m�ltiplo de ningu�m
		
		# imprime o multiplo 
		li $v0, 1		# comando para imprimir inteiro
		move $a0, $t2		# passando o conteudo de um registrador para a CPU
		syscall			# executando
		# imprime um espa�o
		li $v0, 4
		la $a0, espaco
		syscall
		#acrescenta 1 no contador e volta pro inicio da fun��o
		acrescimo:
		add $t2, $t2, 1		# $t2 = $t2 + 1
		j loop
		
	fim: 
		li $v0, 10
		syscall
		
	msgerro:
		# caso o usuario tenha inserido um numero menor ou igual a zero, imprime uma mensagem de erro e faz a leitura novamente
		# ou seja, volta pro inicio do programa, mesmo a fun��o estando depois do fim 
		li $v0, 4	# imprimir uma string
		la $a0, erro	# imprime erro
		syscall	
		j leitura	# volta para fazer a leitura de um numero correto
		
		# coloquei essa fun��o depois do fim do programa, pois antes nao teria como evitar de passar por esse trecho
		# sendo que s� seria necess�rio passar se caso fosse inserido menor ou igual a zero
		# se nao fosse inserido menor ou igual a zero, iria passar por ela de qualquer jeito
		# por isso foi colocada no fim
		
