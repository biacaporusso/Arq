# 	programa incompleto
.data
	array:
		.align 2	# alinha palavra na posição correta
		.space 20	# array de 5 inteiros
		
	ent: .asciiz "Insira os valores do vetor: \n"
	msoma: .asciiz "\nSoma dos numeros pares: "
	mchavek: .asciiz "\nInsira a chave k (numero inteiro): "
	mmeiok: .asciiz "\Número de elementos que são maiores que a chave k e menores que 2k: "
	migualk: .asciiz "\nNumero de elementos que são iguais a chave k: "
	
	#arrayOrdenado:
	#	.align 2
	#	.space 20
		
	espaco: .byte ' '

.text
	move $t0, $zero	# indice do array
	li $t1, 20	# tamanho do array
	
	li $v0, 4	# codigo de impressao de string
	la $a0, ent	# carrega o endereço da string
	syscall		# impressão da string
	
	leitura:
		beq $t0, $t1, saileitura
		li $v0, 5	# codigo de leitura de inteiro
		syscall		# leitura do inteiro
		move $t2, $v0	# movendo o inteiro  inserido para o registrador $t2
		sw $t2, array($t0)	# armazenando o valor inserido no array
		add $t0, $t0, 4		# atualizando o indice do array
		j leitura
	
	saileitura:
		move $t0, $zero
		imprime:
			beq $t0, $t1, fim
			li $v0, 1		# comando para imprimir inteiro
			lw $a0, array($t0)	# passando o conteudo de um registrador para a CPU
			syscall			# executando
			
			# imprime um espaço
			li $v0, 4
			la $a0, espaco
			syscall
			
			add $t0, $t0, 4
			j imprime
			
	fim:
	li $t9, 0		# $t9 vai armazenar a soma dos pares
	move $t0, $zero		# zerando o contador i
	li $t8, 2		# para realizar divisao por 2
	loopPares:
		beq $t0, $t1, fim2
		lw $a0, array($t0)
		div $a0, $t8
		mfhi $s1	# move o resto da divisao pra $s1
		beq $s1, $zero, somaPares
		add $t0, $t0, 4
		j loopPares
			
	somaPares:
		add $t9, $t9, $a0
		add $t0, $t0, 4
		j loopPares
		
	fim2:
		li $v0, 4	# codigo de impressao de string
		la $a0, msoma	# carrega o endereço da string
		syscall		# impressão da string
		li $v0, 1	# comando para imprimir inteiro
		move $a0, $t9
		syscall	
			
	leituraChaveK:
		li $v0, 4	# codigo de impressao de string
		la $a0, mchavek	# carrega o endereço da string
		syscall		# impressão da string
		
		li $v0, 5	# codigo de leitura de inteiro
		syscall		# leitura do inteiro
		move $t9, $v0	# movendo o inteiro  inserido para o registrador $t9, $t9 = k			
	
		mul $t8, $t9, 2 # $t8 = 2k
		
	move $t0, $zero		# zerando o contador i
	li $t7, 0		# $t7 = quantidade de elementos iguais a chave k
	loopChaveK:
		beq $t0, $t1, fim3
		lw $a0, array($t0)
		bgt $a0, $t9, loopChaveK2	# if $a0 > k , vai pra segunda analise 
		add $t0, $t0, 4			# senão, atualiza o indice do vetor e verifica dnv
		j loopChaveK
		
		loopChaveK2:
		blt $a0, $t8, somaMeioChave	# se k < $a0 < 2k, soma um na quantidade de numeros
		j loopChaveK
		
		somaMeioChave:
		add $t7, $t7, 1		# soma um e volta pro loop p verificr os outros elementos
		add $t0, $t0, 4
		j loopChaveK
		
	fim3:
		imprimeMeioChave:
		li $v0, 4	# codigo de impressao de string
		la $a0, mmeiok	# carrega o endereço da string
		syscall		# impressão da string
		
		li $v0, 1	# codigo de leitura de inteiro
		move $a0, $t7	# imprime $t7 (quantidade de elementos entre k e 2k)
		syscall		# leitura do inteiro
	
#	move $t0, $zero		# zerando o contador i	
#	li $t8, 0
#	loopChaveK3:
#		beq $t0, $t1, fim4
#		lw $a0, array($t0)
#		beq $a0, $t9, somaIgualK	# if $a0 = k , vai pra segunda analise 
#		add $t0, $t0, 4			# senão, atualiza o indice do vetor e verifica dnv
#		j loopChaveK3
		
#	somaIgualK:
#		beq $t0, $t1, fim4
#		add $t8, $t8, 1
#		add $t0, $t0, 4			# senão, atualiza o indice do vetor e verifica dnv
#		j loopChaveK3
		
#	fim4:
#		li $v0, 4	# codigo de impressao de string
#		la $a0, migualk	# carrega o endereço da string
#		syscall		# impressão da string
		
#		li $v0, 1	# codigo de leitura de inteiro
#		move $a0, $t8	# imprime $t7 (quantidade de elementos entre k e 2k)
#		syscall		# leitura do inteiro
			
	# comentarios gerais:
	# nao deu tempo de terminar, faltou o item a), d) e e)
