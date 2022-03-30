.data
	vetor:  .word -2, 4, 7, -3, 0, -3, 5, 6		#soma positivos = 22, soma negativos = -8
	tamanho: .word 8	# tamanho do vetor
	msg1: .asciiz "A soma dos valores positivos: "
	msg2: .asciiz "\nA soma dos valores negativos: "
	

.text

	la $t0, vetor	# ponteiro para posição do vetor (em relação à memória, de 4 em 4)
	li $t1, 0 	# indice j do loop, j = 0
	lw $t2, tamanho	# tamanho do vetor
	li $t3, 0 	# soma positivos = 0
	li $t4, 0	# soma negativos = 0

	percorreVetor:
	
		# se j = 6, encerra o programa
		beq $t1, $t2, fim
	
		lw $t6, ($t0)	# ponteiro para vetor[i], carrega $t6 com o valor do vetor[i]
		
		# se vetor[i] >= 0, então vai para a função de soma dos positivos
		bge $t6, $zero, somaPositivos
		
		#senão:
		# se vetor[i] <= 0, então vai para a função de soma dos negativos
		ble $t6, $zero, somaNegativos
		
		# senão, acrescenta j+1 e jump
		add $t1,$t1,1 		# j = j + 1
		j percorreVetor
		
	somaPositivos:
		add $t3, $t3, $t6	# somaPositivo = somaPositivo + vetor[i]
		add $t1,$t1, 1 		# j = j + 1
		add $t0,$t0, 4 		# atualiza endereço do vetor (i=i+4)
		j percorreVetor		# volta para a função de percorrer o vetor
		
	somaNegativos:
		add $t4, $t4, $t6	#somaNegativo = somaNegativo + vetor[i]
		add $t1, $t1, 1		# j = j + 1
		add $t0, $t0, 4		# atualiza endereço do vetor (i=i+4)
		j percorreVetor		# volta para a função de percorrer o vetor
		
	fim:
		li $v0, 4 # instrução para impressão de string
		la $a0, msg1 # indica o endereço em que está a mensagem
		syscall # faça, imprima
	
		li $v0, 1 		#instrução para imprimir inteiro
		add $a0, $zero, $t3	# carregando o registrador $a0 com o valor da soma dos positivos
		syscall
		
		li $v0, 4	# instrução para impressão de string
		la $a0, msg2	# indica o endereço em que está a mensagem
		syscall		
	
		li $v0, 1 		#instrução para imprimir inteiro
		add $a0, $zero, $t4	# carregando o registrador $a0 com o valor da soma dos negativos
		syscall
		
		li $v0, 10	# encerra o programa
		syscall
