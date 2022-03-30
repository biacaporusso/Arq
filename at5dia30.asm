# parei na aprte do guardaMenor na função compara


.data
	mEntrada: .asciiz "Vetor: "
	mN: .asciiz "N (par): "
	mErro: .asciiz "O numero inserido nao e par."
	
.text
jal leituraN

mul $s1, $s0, 4		# $s1 = quantidade de memória a ser alocada (4*N)
move $a0, $s1		# $a0 <- $s1 (argumento da funcao de alocar)
li $v0, 9		# codigo de alocaçao dinamica heap
syscall			# aloca 4*N bytes (endereço em $v0)
move $s1, $v0		# $s1 recebe o endereço inicial do vetor e vai ser fixo, nao vai sofrer alterações
move $t9, $v0		# move para $t9 o endereço do inicio do vetor e vai sofrer alteraçoes

li $v0, 4		# codigo de impressao de string
la $a0, mEntrada	# carrega o endereço da string
syscall			# impressão da string
jal loopLeitura

# valores fixos:
# $s0 = N 
# $s1 = endereço do inicio do vetor
# $s2 = N/2

j compara
backMain1:


leituraN:
	li $v0, 4	# codigo de impressao de string
	la $a0, mN	# carrega o endereço da string
	syscall		# impressão da string
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $s0, $v0	# $s0 = N
	li $t0, 2	# $t0 = 2
	div $s0, $t0	# realiza a divisão $s0/$t0
	mfhi $s2	# $s2 = resto da divisão
	bne $s2, 0, erro
	jr $ra
	erro:
		li $v0, 4		# codigo de impressao de string
		la $a0, mN		# carrega o endereço da string
		syscall			# impressão da string
		j leituraN
	

loopLeitura:
	li $t0, 0
	beq $t0, $s0, endLoopLeitura		# quando $t0 = $s0 (N) termina a leitura
		li $v0, 5			# codigo de leitura de inteiro
		syscall				# leitura do inteiro
		move $t2, $v0			# $t2 = aux (elemento inserido)
		sw $t2, ($t9)			# armazenando $t2 na posição de memoria que $t9 aponta 
		add $t9, $t9, 4			# proxima posição do vetor
		add $t0, $t0, 1			# i = i+1
	j loopLeitura	
	endLoopLeitura:
		jr $ra

compara:
	mflo $t9	# $t9 = N/2
	move $s5, $s1	# $s5 recebe endereço do inicio do vetor
	move $s6, $s1	# $s6 recebe endereço do inicio do vetor
	add $s6, $s6, 4	# $s6 vai percorrer o vetor
	lw $t5, ($s5)	# $t5 = $s5[i]
	lw $t6, ($s6) 	# $t6 = $s6[j] ou $s5[i+1]
	
	li $t0, 1
	
	# for(i=0; i<N/2; i++) {
	# comparando o primeiro elemento com o resto, depois compara o segundo, depois o terceiro....
	
	li $t8, 0	# i
	li $t9, 1	# j
	$s2 = N/2
	
	loopi:
	beq $t8, $s2, fimloopi
	
		lw $t5, ($s5)
		add $s6, $s6, 4	# j começando em 1
		loopj:
		beq $t9, $s2, fimloopj
		
			lw $t6, ($s6)
			blt $t6, $t5, guardaMenor	# se $t6 < $t5 , $t5 vai receber o valor de $t6
			...
			...
			add $t9, $t9, 1
			add $s6, $s6, 4
			j loopj
		fimloopj:
		}
		add $t8, $t8, 1
		add $s5, $s5, 4
	fimloopi:
	}
	
	#	for(j=0; j<N/2; j++) {
	
	
	lCompara1:
		beq $t0, $t9, endCompara	# IF J = N , TEM QUE IR PRO i+1 agora 
		blt $t6, $t5, guardaMenor
		add $s6, $s6, 4
		lw $t6, ($s6)
		add $t0, $t0, 1
		j lCompara1
	guardaMenor:
		move $t5, $t6	
		add $s6, $s6, 4
		lw $t6, ($s6)
		add $t0, $t0, 1
		j lCompara1
endCompara:
j backmain1





# ------------------------------------------------------------ RASCUNHO ---------------------------------------------------------------------------
ordenaParte1:
	mflo $s0	# $s0 = N/2
	li $t0, 0	# $t0 = 0
	li $t2, 0	# %t2 = 0
	move $t9, $s1	# $t9 recebe o inicio do vetor contido em $s1
	move $t8, $s1	# $t8 recebe o inicio do vetor contido em $s1
	add $t8, $t8, 4	# $t8 começa apontando para o proximo elemento do vetor
	loopOrdena1:
		beq $t0, $s0, endLoopOrdena1	# se i = N/2 encerra o loop
		lw $t3, ($t9)		# carrega $t3 com o valor da posição apontada por $t9
		loopOrdena2:
			beq $t2, $s0, endLoopOrdena2
			lw $t4, ($t8)		# carrega $t2 com o valor da posição apontada por $t9
			
			add $t2, $t2, 1
		
		add $t0, $t0, 1		# i = i+1
		






