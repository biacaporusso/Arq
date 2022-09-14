.data
	msgEnt: .asciiz "Insira os valores de 'n' e 'p': "
	msgN: .asciiz "\nn = "
	msgP: .asciiz "p = "
	msgComb: .asciiz "\nCombinação(n, p) = "
	msgArranjo: .asciiz "Arranjo(n, p) = "
	msgErro: .asciiz "Os valores de 'n' e 'p' devem ser positivos e n >= k. Insira novamente.\n"
	
.text
main:
	jal leitura
	
	# fatorial de n
	move $t0, $s0	# passando 'n' de parametro p/ calcular seu fatorial
	jal calcularFatorial	# fatorial de n em $t0
	move $s2, $t0	# $s2 = fatorial de n
	
	#fatorial de p
	move $t0, $s1	# passando 'p' de parametro p/ calcular seu fatorial
	jal calcularFatorial	# fatorial de p em $t0
	move $s3, $t0	# $s3 = fatorial de p
	
	# fatorial de n-p
	sub $t4, $s0, $s1	# $t4 = n - p
	move $t0, $t4	# passando n-p de parametro
	jal calcularFatorial	# fatorial de n-p em $t0
	move $t2, $t0	# $t2 = (n-p)!
	
	# cálculo arranjo
	move $t0, $s2
	jal calcularArranjo
	jal resultadoArranjo
	
	# cálculo combinação
	move $t0, $s2	# $t0 = n!
	move $t1, $s3	# $t1 = p!
	jal calcularCombinacao
	jal resultadoCombinacao

	li $v0, 10	# encerra o programa
	syscall

calcularFatorial:	# retorna o resultado em $t0
	beq $t0, 0, fatorialZero	# 0! = 1
	li $t1, 1	# i = 1
	move $t9, $t0	# $t9 = parametro
	move $t2, $t0
	sub $t2, $t2, 1	# $t2 = parametro - 1
	loop:
		beq $t1, $t9, endLoop
		mul $t0, $t0, $t2	# $t0 = $t0 * ($t0 - 1)
		add $t1, $t1, 1	# i = i + 1
		sub $t2, $t2, 1	# multiplicador 
		j loop
	
fatorialZero:
	li $t0, 1	# 0! = 1
	jr $ra

calcularArranjo:	# retorna o resultado em $t0
	div $t0, $t2	# n! / (n-p)!
	mflo $t0	# $t0 = resultado da divisão
	jr $ra
			
calcularCombinacao:	# retorna o resultado em $t0
	mul $t3, $t1, $t2	# $t3 = p! * (n-p)!
	div $t0, $t3	# n! / ( p! * (n-p)! )
	mflo $t0	# $t0 = resultado da divisão 
	jr $ra
	
resultadoArranjo:
	li $v0, 4	# codigo de impressao de string
	la $a0, msgArranjo	# parâmetro
	syscall
	
	li $v0, 1	# codigo de impressao de inteiro
	move $a0, $t0	# resultado em $t0
	syscall
	jr $ra
	
resultadoCombinacao:
	li $v0, 4	# codigo de impressao de string
	la $a0, msgComb	# parâmetro
	syscall
	
	li $v0, 1	# codigo de impressao de inteiro
	move $a0, $t0	# resultado em $t0
	syscall
	jr $ra
	
endLoop:
	jr $ra
	

leitura:
	li $v0, 4	# codigo de impressao de string
	la $a0, msgEnt	# parametro
	syscall
	
	li $v0, 4	# codigo de impressao de string
	la $a0, msgN	# parametro
	syscall
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall
	move $s0, $v0	# $s0 = n
	
	li $v0, 4	# codigo de impressao de string
	la $a0, msgP	# parametro
	syscall
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall
	move $s1, $v0	# $s1 = p
	
	# tanto para arranjo quanto combinação, condição: n >= k
	# se n, p <= 0, faz a leitura novamente 
	blt $s0, 0, erro
	blt $s1, 0, erro
	bgt $s1, $s0, erro
	jr $ra
	
erro:
	li $v0, 4	# codigo de impressao de string
	la $a0, msgErro	# parametro
	syscall
	j leitura	# faz a leitura novamente 