.data
	vet1: .asciiz "Vet["
	vet2: .asciiz "] = "
	msgN: .asciiz " Entre com o numero de elementos: "
	msgElementos: .asciiz "Elementos inteiros: \n"
	msgSoma: .asciiz "Soma dos elementos = "
	msgMenorSoma: .asciiz "\nO número de elementos menores que a soma dos N elementos lidos é = "
	qntNumImpares: .asciiz "\nO número de elementos ímpares é = "
	nenhumImpar: .asciiz "\nNao ha elementos impares no vetor!"
	nenhumPar: .asciiz "\nNão há elementos pares no vetor!"
	msgProduto: .asciiz "\nO produto da posição do menor elemento par do vetor com a posição do maior elemento ímpar do vetor é = "
	msgEspaco: .asciiz " "
	msgOrdenado: .asciiz "\nO vetor ordenado de forma decrescente = "
	msgErroN: .asciiz "O numero de elementos deve ser maior que zero!"
	
.text
# registradores fixos:
# $s0 = N
# $s1 = endereço do inicio do vetor (fixo)
# $t0 = argumentos passados para $a0 (resultados das operações)
main:
	jal leituraN
	
	jal leituraVetor
	
	jal somaElementos
	move $s2, $t0
	# impressao da soma dos elementos
	la $a0, msgSoma	# carrega o endereço da string
	jal imprimeResultado
	
	jal proc_menor_soma
	# imprime o nº de elementos menores que a soma
	la $a0, msgMenorSoma	# carrega o endereço da string
	jal imprimeResultado
	
	li $a3, -99999	# $a3 = maior numero impar do vetor
	li $s3, 999999	# $s3 = menor numero par do vetor
	jal proc_num_impar
	# imprime o nº de elementos ímpares do vetor
	beq $t0, 0, naoTemImpar
	bne $t0, 0, temImpar
	move $s4, $t0	# $s4 = quantidade de impares
	back:
	jal imprimeResultado

	
	jal proc_prod_pos
	# imprime o produto da posição do menor par com a posição do maior impar
	beq $t7, 0, naoTemPar
	beq $s4, 0, naoTemImpar2
	la $a0, msgProduto
	jal imprimeResultado
	back2:
	
	jal proc_ord
	# imprime o vetor ordenado decrescentemente
	la $a0, msgOrdenado
	li $v0, 4
	syscall
	li $t0, 0	# indice i
	move $t1, $s1	# endereço inicial do vetor
	jal imprimeVetor
	
	li $v0, 10
	syscall		# encerra programa


# ------------------------------------------------------- FUNÇÕES ----------------------------------------------------------

leituraN:
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
	
naoTemImpar:
	la $a0, nenhumImpar
	li $v0, 4
	syscall
	j back

naoTemImpar2:
	la $a0, nenhumImpar
	j back2
			
naoTemPar:
	la $a0, nenhumPar
	li $v0, 4
	syscall
	j back2

temImpar:
	la $a0, qntNumImpares
	j back
	
leituraVetor:
	mul $t0, $s0, 4	# $t0 = quantidade de memória a ser alocada (4*N)
	move $a0, $t0	# $a0 <- $t0 (argumento da funcao de alocar)
	li $v0, 9	# codigo de alocação dinamica heap
	syscall		# aloca 4*N bytes (endereço em $v0)
	move $s1, $v0	# move para $ts1 o endereço do primeiro elemento do vetor (fixo)
	move $t9, $s1	# endereço que vai sofrer alterações
	li $t1, 0	# indice i
	loopLeitura:
		beq $t1, $s0, endLoop
		# imprimindo "vet[i] = "
		li $v0, 4
		la $a0, vet1
		syscall
		li $v0, 1
		move $a0, $t1
		syscall
		li $v0, 4
		la $a0, vet2
		syscall
		# leitura dos elementos
		li $v0, 5	# codigo de leitura de inteiro
		syscall		# leitura do inteiro
		move $t2, $v0	# $t2 = aux (elemento inserido)
		sw $t2, ($t9)	# armazenando $t2 na posição de memoria que $t9 aponta 
		add $t9, $t9, 4	# proxima posição do vetor
		add $t1, $t1, 1	# i = i+1
		j loopLeitura
	
somaElementos:
	move $t9, $s1	# resgatando o endereço inicial do vetor
	li $t0, 0	# reiniciando o valor de $t0
	li $t1, 0	# reiniciando o valor do indice i
	loopSoma:
		beq $t1, $s0, endLoop
		lw $t2, ($t9)	# $t0 = elemento apontado pelo endereço em $t9
		add $t9, $t9, 4
		add $t0, $t0, $t2	# $t0 recebe a soma dos elementos
		add $t1, $t1, 1	# i = i+1
		j loopSoma
	
proc_menor_soma:
	move $t9, $s1	# resgatando o endereço inicial do vetor
	li $t0, 0	# reiniciando o valor de $t0
	li $t1, 0	# reiniciando o valor do indice i
	loopMenorSoma:
		beq $t1, $s0, endLoop
		lw $t2, ($t9)
		blt $t2, $s2, menorQueASoma	# if vet[i] < soma, incrementa 1
		# else:
		attMenorSoma:
		add $t9, $t9, 4	# proxima posição do vetor
		add $t1, $t1, 1	# i = i + 1
		j loopMenorSoma
		
menorQueASoma:
	add $t0, $t0, 1
	j attMenorSoma
	
proc_num_impar:
	move $t9, $s1	# resgatando o endereço inicial do vetor
	li $t0, 0	# reiniciando o valor de $t0
	li $t1, 0	# reiniciando o valor do indice i
	li $t8, 2
	loopNumImpar:
		beq $t1, $s0, endLoop
		lw $t2, ($t9)
		div $t2, $t8
		mfhi $t3	# $t3 = resto da divisao por 2
		bne $t3, 0, eImpar	# if $t3 != 0, é impar
		beq $t3, 0, ePar
		attNumImpar:
		add $t9, $t9, 4	# proxima posição do vetor
		add $t1, $t1, 1	# i = i + 1
		j loopNumImpar
		
eImpar:
	add $t0, $t0, 1	# $t0 = qtde de impares
	analiseDoMaiorImpar:
	bgt $t2, $a3, attMaiorImpar	# if vet[i] (impar) > maiorImpar, atualiza o valor de maiorImpar
	backEImpar:
	j attNumImpar
	
ePar:
	add $t7, $t7, 1	# $t7 = qtde de pares
	analiseDoMenorPar:
	blt $t2, $s3, attMenorPar	# if vet[i] (par) < menorPar, atualiza o valor de menorPar
	backEPar:
	j attNumImpar

attMenorPar:
	move $s3, $t2	# $s3 = menor nº par do vetor
	move $t5, $t1	# $t5 = posição do menor par
	j backEPar
	
	
attMaiorImpar:
	move $a3, $t2	# $a3 = maior numero impar do vetor
	move $t4, $t1	# $t4 = posição do maior impar
	j backEImpar
	
proc_prod_pos:
	mul $t0, $t4, $t5
	jr $ra
	
imprimeResultado:
	li $v0, 4	# codigo de impressao de string
	syscall		# impressao da string
	li $v0, 1	# codigo de impressao de inteiro
	move $a0, $t0	# parametro = $t0
	syscall		#imprime
	jr $ra

proc_ord:
	li $t8, 0	# indice i
	percorrerVetorNvezes:
		li $t9, 1	# indice j
		move $t0, $s1	# endereço
		move $t1, $s1	# endereço
		add $t1, $t1, 4	# endereço a frente
		beq $t8, $s0, endLoop 
		percorrerVetor1vez:
			beq $t9, $s0, fim1	# loop pra percorrer o vetor 1 vez, precisa percorrer o vetor N vezes
			lw $t3, ($t0)		# $t0 = vetor[$t0]
			lw $t4, ($t1)		# $t1 = vetor[$t1]
			bgt $t4, $t3, troca
			atualizaPosicao:
			add $t0, $t0, 4	# i = i+1
			add $t1, $t1, 4 # j = j+1
			add $t9, $t9, 1	# x = x+1
			j percorrerVetor1vez
		fim1:
		add $t8, $t8, 1
		j percorrerVetorNvezes

troca: 
	move $t2, $t3	# menor valor
	sw $t4, ($t0)	# v[i] = v[i+1]  (maior valor na primeira posicao)
	sw $t2, ($t1)	# v[i+1] = v[i]  (menor valor na posicao da frente)
	j atualizaPosicao
	
imprimeVetor:
	beq $t0, $s0, endLoop	# if i = N -> endLoop
	lw $t2, ($t1)	# $t2 = vet[i]
	
	li $v0, 1 	# instrução para imprimir inteiro
	move $a0, $t2	# argumento
	syscall		# imprime elemento do vetor
	
	li $v0, 4	# codigo para imprimir string
	la $a0, msgEspaco	
	syscall		# imprime um espaço
	
	add $t1, $t1, 4	# atualiza a posição do vetor
	add $t0, $t0, 1	# atualiza o indice i = i+1
	j imprimeVetor

endLoop:
	jr $ra	
