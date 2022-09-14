.data
	matriz1: .asciiz "Matriz["
	matriz2: .asciiz "]["
	matriz3: .asciiz "] = "
	msgN: .asciiz "Quantidade de linhas/colunas da matriz: "
	msgErroN: .asciiz "O numero de linhas/colunas deve ser maior que zero!"
	msgMenorNumero: .asciiz "\nNumero da linha que contem o menor valor = "
	msgMaiorImpar: .asciiz "\nNumero da linha que contem o maior número ímpar = " 
	msgNaoImpar: .asciiz "\nA matriz nao contem números ímpares!"
	
.text
main:
	jal leituraN	# $s0 = N
	jal malloc	# $s1 = endereço base da matriz (fixo)
	move $a0, $s1	# passando de parâmetro o endereço base da matriz
	move $a1, $s0	# passando de parâmetro a quantidade de linhas/colunas
	jal leituraMatriz
	
	move $a0, $s1	# passando de parâmetro o endereço base da matriz
	move $a1, $s0	# passando de parâmetro a quantidade de linhas/colunas
	jal percorreMatriz
	
	# saídas
	la $a0, msgMenorNumero 	# parametro
	move $t9, $s3		# parametro
	jal imprimeResultado
	
	beq $s4, 0, naoTemImpar
	la $a0, msgMaiorImpar 	# parametro
	move $t9, $s4		# parametro
	jal imprimeResultado
	
	# encerra o programa
	end:
	li $v0, 10
	syscall
	
leituraN:	# retorna N no registrador $s0
	li $v0, 4	# codigo de impressao de string
	la $a0, msgN	# carrega o endereço da string
	syscall		# impressao da string
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $s0, $v0	# $s0 = N
	ble $s0, 0, erroN
	jr $ra

erroN:
	li $v0, 4
	la $a0, msgErroN
	syscall
	j leituraN
	
malloc:
	mul $t0, $s0, 4	# $t0 = quantidade de memória a ser alocada (4*N)
	move $a0, $t0	# $a0 <- $t0 (argumento da funcao de alocar)
	li $v0, 9	# codigo de alocação dinamica heap
	syscall		# aloca 4*N bytes (endereço em $v0)
	move $s1, $v0	# move para $s1 o endereço do primeiro elemento do vetor (fixo)
	move $t9, $s1	# endereço que vai sofrer alterações
	
indice:
            mul $v0, $t1, $a1  #i * ncol
            add $v0, $v0, $t2  #i * ncol + j
            sll $v0, $v0, 2    #[(i*ncol) +j ] *4
            add $v0, $v0, $a3
            jr $ra

leituraMatriz:
	subi $sp, $sp, 4	# desempilhando
	sw $ra, ($sp)		# guardando o valor da pilha dessa função
	move $a3, $a0		# $a3 recebe o endereco base da matriz
	li $t1, 0		# contador i = 1
	li $t2, 0		# contador j = 1

	loopLeitura:
	# impressão da entrada da matriz
	la $a0, matriz1	
	li $v0, 4	# codigo de impressao de string
	syscall
	add $a0, $t1, 1
	li $v0, 1	# codigo de impressao de inteiro
	syscall
	la $a0, matriz2
	li $v0, 4	# codigo de impressao de inteiro
	syscall
	add $a0, $t2, 1
	li $v0, 1	# codigo de impressao de inteiro
	syscall
	la $a0, matriz3
	li $v0, 4	# codigo de impressao de string
	syscall
	li $v0, 5	# codigo de leitura de inteiro
	syscall
	move $t0, $v0	# $t0 = valor inteiro lido
	
	jal indice		# calcula a posicao da matriz e armazena em $v0
	sw $t0, ($v0)		# guarda na posição calculada o valor lido
	addi $t2, $t2, 1	# j = j + 1
	blt $t2, $a1, loopLeitura	# if j = N -> volta pro loop
	# else:
	li $t2, 0		# reseta o valor de j	
	addi $t1, $t1, 1	# i = i + 1
	blt $t1, $a1, loopLeitura	# if i = N -> volta pro loop
	# else:
	li $t1, 0		# reseta o valor de i
	lw $ra, ($sp)		# recupera o endereco do $ra que estava na pilha
	addi $sp, $sp, 4	# devolve o ponteiro da pilha pro topo
	jr $ra
	
percorreMatriz:
	subi $sp, $sp, 4	# empilhamento
	sw $ra ($sp)		# empilhamento
	move $a3, $a0
	li $t1, 0	# contador i = 0
	li $t2, 0	# contador j = 0
	li $t3, 2	# para fazer a divisão por 2
	li $t4, 99999	# aux p/ achar o menor numero
	li $s2, -9999	# aux p/ achar o maior impar
	
	loopPercorre:
	jal indice	# calcula o v0 de acordo com o indice
	lw $a0, ($v0)	# carrega em a0 o valor da posicao calculada
	# impressao
	# verifica menor numero:
	ble $a0, $t4, menorNumero
	back1:
	# verifica se é impar:
	div $a0, $t3	# valor / 2
	mfhi $t5	# $t5 = resto da divisao
	bne $t5, 0, eImpar
	back2:

	addi $t2, $t2, 1            # j = j + 1
	blt $t2, $a1, loopPercorre  # if j = N volta pro loop
	# else:
	li $t2, 0                   # reseta o valor de j
	addi $t1, $t1, 1            # i = i + 1
	blt $t1, $a1, loopPercorre  # if i = N volta pro loop
	
	li $t1, 1	# reseta o valor de i 
	lw $ra, ($sp)	# recupera o endereco do $ra que estava na pilha
	addi $sp, $sp, 4	# devolve o ponteiro da pilha pro topo
	jr $ra
	
menorNumero:
	move $t4, $a0	# atualiza o valor do menor numero
	move $s3, $t1	# $s3 = número da linha que contem o menor numero
	add $s3, $s3, 1
	j back1
	
eImpar:
	bge $a0, $s2, maiorImpar	# se valor > maiorImpar -> atualiza o valor do maior impar
	# else, volta para o loop que percorre a matriz
	j back2
	
maiorImpar:
	move $s2, $a0	# $s2 recebe o maior impar
	move $s4, $t1	# $s4 = numero da linha que contem o maior impar
	add $s4, $s4, 1
	j back2		# volta para o loop que percorre a matriz
	
imprimeResultado:
	li $v0, 4	# codigo de impressao de string
	syscall
	li $v0, 1	# codigo de impressao de inteiro
	move $a0, $t9	# $t9 = numero da linha
	syscall
	jr $ra
	
naoTemImpar:
	li $v0, 4
	la $a0, msgNaoImpar
	syscall
	j end