.data

mVet: .asciiz "Vetor: \n"
mN: .asciiz "N: "
mMenorEle: .asciiz "\nMenor elemento: "
mPosicaoMenor: .asciiz "\nPosicao do menor elemento: "
mMaiorEle: .asciiz "\nMaior elemento: "
mPosicaoMaior: .asciiz "\nPosicao do maior elemento: "

.text

li $v0, 4	# codigo de impressao de string
la $a0, mN	# carrega o endere?o da string
syscall		# impress?o da string

li $v0, 5	# codigo de leitura de inteiro
syscall		# leitura do inteiro
move $t1, $v0	# $t1 = N

mul $s1, $t1, 4	# $s1 = quantidade de mem?ria a ser alocada (4*N)
move $a0, $s1	# $a0 <- $s1 (argumento da funcao de alocar)
li $v0, 9	# codigo de aloca?ao dinamica heap
syscall		# aloca 4*N bytes (endere?o em $v0)
move $t9, $v0	# move para $t9 o endere?o do primeiro elemento do vetor 


li $v0, 4	# codigo de impressao de string
la $a0, mVet	# carrega o endere?o da string
syscall		# impress?o da string

li $t0, 0	# $t0 = i 
loopLeituraVet:
	beq $t0, $t1, endLoopLeituraVet	# quando $t0 = $t1 termina a leitura
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $t2, $v0	# $t2 = aux (elemento inserido)
	sw $t2, ($t9)	# armazenando $t2 na posi??o de memoria que $t9 aponta 
	add $t9, $t9, 4	# proxima posi??o do vetor
	add $t0, $t0, 1	# i = i+1
	j loopLeituraVet	
endLoopLeituraVet:

li $t3, 99999	# $t3 vai ser o registrador que carrega o MENOR elemento do vetor
li $t4, 0	# $t4 vai ser o registrador que carrega a posi??o do MENOR elemento
li $t5, -99999 	# $t5 vai ser o registrador que carrega o MAIOR elemento do vetor
li $t6, 0	# $t6 vai ser o registrador que carrega a posi??o do MAIOR elemento

# ------------------------------------------------------ ANALISE MENOR ELEMENTO ---------------------------------------------------

# agora preciso fazer $t9 apontar pro inicio do vetor de novo, ent?o pega a ultima posi??o e subtrai 4*N
sub $t9, $t9, $s1	# agora $t9 aponta pra primeira posi??o do vetor

li $t0, 0
loopAnaliseMenor:
	beq $t0, $t1, endLoopAnaliseMenor	# quando $t0 = $t1 sai do loop
	
	lw $t8, ($t9) 			# carrega $t8 com o valor da posi??o apontada por $t9
	blt $t8, $t3, menorElemento	# if $t8 < $t3 , substitui o valor de $t3 por $t8
	# senao:
	add $t9, $t9, 4			# proxima posi??o do vetor 
	add $t0, $t0, 1			# i = i+1
	j loopAnaliseMenor
endLoopAnaliseMenor:

# ------------------------------------------------------ ANALISE MAIOR ELEMENTO ----------------------------------------------------

# agora preciso fazer $t9 apontar pro inicio do vetor de novo, ent?o pega a ultima posi??o e subtrai 4*N
sub $t9, $t9, $s1	# agora $t9 aponta pra primeira posi??o do vetor

li $t0, 0
loopAnaliseMaior:
	beq $t0, $t1, endLoopAnaliseMaior	# quando $t0 = $t1 sai do loop
	
	lw $t8, ($t9) 			# carrega $t8 com o valor da posi??o apontada por $t9
	bgt $t8, $t5, maiorElemento	# if $t8 > $t5 , substitui o valor de $t5 por $t8
	# senao:
	add $t9, $t9, 4			# proxima posi??o do vetor 
	add $t0, $t0, 1			# i = i+1
	j loopAnaliseMaior
endLoopAnaliseMaior:

# -----------------------------------------------------------------------------------------------------------------------

li $v0, 4		# codigo de impressao de string
la $a0, mMenorEle	# carrega o endere?o da string
syscall			# impress?o da string

li $v0, 1		# comando para imprimir inteiro
move $a0, $t3		# movendo o valor de $t3 para o registrador $a0
syscall			# executando

li $v0, 4		# codigo de impressao de string
la $a0, mPosicaoMenor	# carrega o endere?o da string
syscall			# impress?o da string

li $v0, 1		# comando para imprimir inteiro
move $a0, $t4		# movendo o valor de $t4 para o registrador $a0
syscall			# executando
# -----------------------------------------------------------------------------------
li $v0, 4		# codigo de impressao de string
la $a0, mMaiorEle	# carrega o endere?o da string
syscall			# impress?o da string

li $v0, 1		# comando para imprimir inteiro
move $a0, $t5		# movendo o valor de $t3 para o registrador $a0
syscall			# executando

li $v0, 4		# codigo de impressao de string
la $a0, mPosicaoMaior	# carrega o endere?o da string
syscall			# impress?o da string

li $v0, 1		# comando para imprimir inteiro
move $a0, $t6		# movendo o valor de $t4 para o registrador $a0
syscall			# executando


li $v0, 10	# encerra o programa
syscall
#-------------------------------------------------------------------------------------------------------------
menorElemento:
	move $t3, $t8		# $t3 (menor elemento) passa a ter o valor de $t8
	add $t4, $t0, 1		# $t4 tem o indice 
	add $t9, $t9, 4			# proxima posi??o do vetor 
	add $t0, $t0, 1			# i = i+1
	j loopAnaliseMenor
	
maiorElemento:
	move $t5, $t8		# $t5 (menor elemento) passa a ter o valor de $t8
	add $t6, $t0, 1		# $t6 tem o indice 
	add $t9, $t9, 4		# proxima posi??o do vetor 
	add $t0, $t0, 1		# i = i+1
	j loopAnaliseMaior
