.data
	mEntrada: .asciiz "Vetor: \n"
	mN: .asciiz "N (par): "
	mErro: .asciiz "O numero inserido nao e par.\n"
	mOrdenado: .asciiz "Vetor ordenado: \n"
	espaco: .byte ' '
.text

main:
	# LEITURA DO N
	jal leituraN

	# ------------------------------ ALOCANDO MEMORIA PARA O VETOR -----------------------------------------------
	mul $s4, $s5, 4		# $s4 = quantidade de memoria a ser alocada (4*N)
	move $a0, $s4		# $a0 <- $s4 (argumento da funcao de alocar)
	li $v0, 9		# codigo de aloca�ao dinamica heap
	syscall			# aloca 4*N bytes (endere�o em $v0)
	
	move $s0, $v0		# $s0 recebe o endere�o inicial do vetor e vai ser fixo, nao vai sofrer altera�oes
	move $s1, $s0
	add $s1, $s1, 4		# $s1 vai sempre apontar pro elemento a frente do $s0, e � fixo
	
	li $v0, 4		# codigo de impressao de string
	la $a0, mEntrada	# carrega o endere�o da string
	syscall			# impressao da string

	li $t0, 0
	move $t9, $s0
	j loopLeitura
	back:

	li $t1, 2
	div $s5, $t1
	mflo $s6	# $s6 = N/2
	
	# ordena��o crescente da primeira metade
	li $t8, 0
	jal percorrerVetorNvezes
	
	# ordena��o decrescente da segunda metade
	move $t8, $s6
	jal oDecrescente
	
	li $v0, 4		# impressao de string
	la $a0, mOrdenado
	syscall
	li $t9, 0
	move $t0, $s0	# endere�o inicial da string
	jal imprimeVetor

	
	# finaliza o programa
	li $v0, 10	# encerra o programa
	syscall


# ------------------------------------ FUN��ES ------------------------------------------------------------
leituraN:
	li $v0, 4	# codigo de impressao de string
	la $a0, mN	# carrega o endere�o da string
	syscall		# impress�o da string
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $s5, $v0	# $s5 = N
	li $t0, 2	# $t0 = 2
	div $s5, $t0	# realiza a divisao $t1/$t0 (N/2)
	mfhi $t9	# $t9 = resto da divisao
	bne $t9, 0, erro
	jr $ra
	erro:
		li $v0, 4		# codigo de impressao de string
		la $a0, mErro		# carrega o endere?o da string
		syscall			# impress?o da string
		j leituraN
		
loopLeitura:
	beq $t0, $s5, endLoopLeitura	# quando $t0 = $s5 (N) termina a leitura
		li $v0, 5			# codigo de leitura de inteiro
		syscall				# leitura do inteiro
		move $t2, $v0			# $t2 = aux (elemento inserido)
		sw $t2, ($t9)			# armazenando $t2 na posi�ao de memoria que $t9 aponta 
		add $t9, $t9, 4			# proxima posi�ao do vetor
		add $t0, $t0, 1			# i = i+1
		j loopLeitura	
	endLoopLeitura:
	j back
	
# ------------------------------------------ ordena��o crescente -------------------------------------------------------	
percorrerVetorNvezes:
	move $t0, $s0	# endere�o de $s0 que vai sofrer altera��o
	move $t1, $s1	# endere�o de $s1 que vai sofrer altera��o
	# $t8 = 0
	li $t9, 1
	# $s6 = N/2
	beq $t8, $s5, fimN 
	percorrerVetor1vez:
		beq $t9, $s5, fim1	# loop pra percorrer o vetor 1 vez, precisa percorrer o vetor N vezes
			lw $t3, ($t0)		# $t0 = vetor[$s0]
			lw $t4, ($t1)		# $t1 = vetor[$s1]
			blt $t4, $t3, troca
			# else, atualiza posi��o:
			add $t0, $t0, 4	# i = i+1
			add $t1, $t1, 4 # j = j+1
			add $t9, $t9, 1	# x = x+1
			j percorrerVetor1vez
		fim1:
		add $t8, $t8, 1
		j percorrerVetorNvezes
	fimN:
	jr $ra

troca: 
	move $t2, $t3	# $t2 � o aux
	sw $t4, ($t0)	# v[i] = v[i+1]
	sw $t2, ($t1)	# v[i+1] = v[i] 	ou seja, troca os dois de posi��o
	add $t0, $t0, 4	# i = i+1
	add $t1, $t1, 4 # j = j+1
	add $t9, $t9, 1	# x = x+1
	j percorrerVetor1vez
# --------------------------------------------------------------------------------------------------------------------------

# ------------------------------------ ordena��o decrescente a partir da metade do vetor ----------------------------------------
oDecrescente:
	move $t0, $s0
	mul $t7, $s6, 4
	add $t0, $t0, $t7	# $t0 aponta pro endere�o da metade do vetor
	
	move $t1, $s1
	add $t1, $t1, $t7
	# $t8 = $s6 la na main antes de chamar essa fun��o 
	li $t9, 1 
	beq $t8, $s5, fimODecrescente
	percorreDecrescente:
		beq $t9, $s6, fim2
			lw $t3, ($t0)
			lw $t4, ($t1)
			bgt $t4, $t3, troca2
			# else: 
			add $t0, $t0, 4	# i = i+1
			add $t1, $t1, 4 # j = j+1
			add $t9, $t9, 1	# x = x+1
			j percorreDecrescente
		fim2:
		add $t8, $t8, 1
		j oDecrescente
	fimODecrescente:
	jr $ra

troca2:
	move $t2, $t3
	sw $t4, ($t0)
	sw $t2, ($t1)
	add $t0, $t0, 4	# i = i+1
	add $t1, $t1, 4 # j = j+1
	add $t9, $t9, 1	# x = x+1
	j percorreDecrescente
# ----------------------------------------------------------------------------------------------------------------------------

			
imprimeVetor:
	beq $t9, $s5, endImprime
		lw $t1, ($t0)
		
		li $v0, 1 	#instru��o para imprimir inteiro
		move $a0, $t1
		syscall
		
		li $v0, 4
		la $a0, espaco
		syscall
		
		add $t0, $t0, 4
		add $t9, $t9, 1
		j imprimeVetor
	endImprime:
	jr $ra