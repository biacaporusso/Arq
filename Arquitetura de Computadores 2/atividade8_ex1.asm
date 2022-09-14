.data
	msgN: .asciiz "Insira o numero de posicoes do vetor: "
	msgVet: .asciiz "Insira vet["
	msgVet2: .asciiz "]: "
	saida: .asciiz "O valor "
	saida1: .asciiz " aparece "
	saida2: .asciiz " vez(es)!\n"

.text

#variáveis
#	$s0 = tamanho do vetor
#	$s1 = endereço base do vetor
#	$s7 = null

li $s7, 0xFFFFFFF

main:
	jal leituraN
	move $s0, $v0	# $s0 = N
	
	move $a0, $s0	# passa o tamanho do vetor para o argumento $a0
	jal alloc
	move $s1, $v0 	# $s1 = endereço base do vetor
	
	move $a0, $s1	# passa o endereço base do vetor para o argumento $a0
	move $a1, $s0	# passa o tamanho do vetor para o argumento $a1
	jal leituraVetor
	
	move $a0, $s1	# passa o endereco base do vetor para o parametro
	move $a1, $s0	# passa o tamanho do vetor para o parametro
	jal frequencia
	
	j exit
	 
leituraN:
	# imprimindo mensagem para o usuario
	la $a0, msgN
	li $v0, 4	# código de impressão de string
	syscall
	# leitura do N
	li $v0, 5	# código de leitura de inteiro
	syscall
	jr $ra
	
alloc:	# retorna o endereço do vetor em $v0
	mul $a0, $a0, 4		# multiplica o tamanho do vetor por 4 bits
	li $v0, 9		# código de alocação dinâmica
	syscall
	jr $ra

leituraVetor:
	move $t0, $a0		# salva o endereço base do vetor em $t0
	move $t1, $t0		# salva o endereço base do vetor em $t1 ($t1 será incrementado)
	li $t2, 0		# $t2 = i = 0
	move $t3, $a1		# salva o tamanho do vetor em $t3
	
l:	la $a0, msgVet	
	li $v0, 4		# código de impressão de string
	syscall
	move $a0, $t2
	li $v0, 1		# código de impressão de inteiro
	syscall
	la $a0, msgVet2
	li $v0 4		# código de impressão de string
	syscall
	li $v0, 6		# código de leitura de inteiro
	syscall
	
	sw $v0, ($t1)		# $v0 = conteudo apontado por $t1
	addi $t1, $t1, 4	# incrementa o endereço do vetor
	addi $t2, $t2, 1	# # i = i+1
	
	blt $t2, $t3, l		# if i < N continua a leitura do vetor
	jr $ra
	
frequencia:
	move $t0, $a0		# $t0 = endereco base do vetor
	move $t1, $t0		# t1 = endereco base do vetor (sera incrementado)
	move $t2, $a1		# $t2 = N (tamanho do vetor)
	li $t3, 0		# i = 0
	
l1:	mul $t1, $t3, 4
	add $t1, $t1, $t0	# endereco da posicao i do vetor
	lw $t4, ($t1)		# $t4 = conteudo apontado por $t1
	beq $t4, $s7, eIf	# pula caso o valor seja igual ao define null
	
	li $t5, 0		# reseta o contador de frequencia
	move $t6, $t0		# passa o endereco base do vetor para $t6 (outro registrador para percorrer o vetor)
	li $t7, 0		# reseta o segundo contador
	
l2:	mul $t6, $t7, 4
	add $t6, $t6, $t0
	lw $t8, ($t6)		#Armazena em $t8 o valor do segundo vetor percorrido
	
	bne $t4 $t8, eIf2
	addi $t5, $t5, 1	#Incrementa o contador de frequencia
	sw $s7, ($t6)		#Seta o valor do vetor como null para nao encontra-lo novamente
	
eIf2:	addi $t7, $t7, 1	#Incrementa o contador
	blt $t7, $t2, l2
	
	la $a0, saida
	li $v0, 4
	syscall
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	la $a0, saida1
	li $v0, 4
	syscall
	
	move $a0, $t5
	li $v0, 1
	syscall
	
	la $a0, saida2
	li $v0, 4
	syscall
	
eIf:	addi $t3, $t3, 1	# incrementa o contador
	blt $t3, $t2, l1	# faz o loop enquanto o contador for menor que o tamanho maximo do vetor
	
	jr $ra

exit:
	li $v0, 10
	syscall