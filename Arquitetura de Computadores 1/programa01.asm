.data
	entrada: .asciiz "Entre com um valor inteiro (N>1): "
	menorigual1: .asciiz "O valor digitado N tem que ser maior que 1. "
	result: .asciiz "O valor da soma dos valores inteiros de 1 ate N = "

.text
	addi $t0, $t0, 1	# atribuindo o valor 1 ao registrador $t0 para servir de parâmetro para as comparações
				# o $t0 também vai servir como nosso contador
	
	leitura:
		li $v0, 4	# imprimir uma string
		la $a0, entrada		# registrador $a0 recebe o endereço de memória da variável "entrada"
		syscall
		
		li $v0, 5	# leitura de inteiros
		syscall
	
		move $t1, $v0	# move o inteiro inserido de $v0 para $t1, ou seja, $t1 = N
	
		ble $t1, $t0, releitura	# se N <= 1, faz a releitura do numero inteiro
		# senão:
	
		move $t1, $v0	# move o inteiro inserido de $v0 para $t1, ou seja, $t1 = N
		
		# colocou um numero certo, agora vai pra parte de somar os inteiros de 1 até N
		j soma	# jump soma, vai pra parte da soma
		
	releitura:
		li $v0, 4	# imprimir string
		la $a0, menorigual1	# imprimir a mensagem de 'menorigual1'
		syscall
		j leitura	# jump leitura, ou seja, volta para a parte de leitura de N
		
	soma:	# (while)
		# enquanto $t0 for menor que N, faz a soma dos inteiros
		blt $t1, $t0, saida	# se $t1 < $t0, ou seja, se N < contador, vai para a label 'saida'
		add $t2, $t2, $t0	# $t2 vai ser o registrador com o valor final da soma, $t2 = $t2 + $t0
		addi $t0, $t0, 1	# acrescenta 1 ao contador
		j soma			# volta para o inicio do laço de repetição soma
		
		
	saida:
		li $v0, 4	# imprimir uma string
		la $a0, result	# registrador $a0 recebe o endereço de memória da variável "result"
		syscall
		
		# imprime o valor de $t2 (resultado da soma dos inteiros de 1 até N) 
		li $v0, 1	# imprimir um inteiro
		move $a0, $t2	# imprime o valor da soma que está armazenada no $t2 
		syscall


	li $v0, 10	# encerra o programa
	syscall
