.data
	msg: .asciiz "Insira um numero inteiro positivo N: "
	msgPerfeito: .asciiz "N é um inteiro perfeito."
	msgNaoPerfeito: .asciiz "N nao é um inteiro perfeito."
	erro: .asciiz "O numero inserido nao e um inteiro positivo. Favor inserir novamente.\n"
	
.text
main:
	jal leitura	# leitura do numero inserido pelo usuario
	
	li $t1, 1	# contador i, $t1 = 1 	
	li $t9, 0	# $t9 vai armazenar a soma dos divisores de N
	
	jal verificador	# função que verifica se N é perfeito
	
	beq $t9, $t0, imprimePerfeito		# se a soma for igual ao N, é perfeito
	bne $t9, $t0, imprimeNaoPerfeito	# se a soma for diferente de N, não é perfeito
	
	encerraPrograma:
	li $v0, 10	# encerra o programa
	syscall		# encerra o programa
	
leitura:
	li $v0, 4	# imprimir uma string
	la $a0, msg	# imprime msg
	syscall
	li $v0, 5	# leitura do inteiro N
	syscall
	move $t0, $v0	# movendo o inteiro N inserido para o registrador $t0, $t0 = N
	
	beq $t0, $zero, imprimeNaoPerfeito	# zero nao e um inteiro perfeito e nao pode ser verificado atraves dos calculos, entao se torna uma excessao
	ble $t0, $zero, msgerro		# se N <= 0, ocorre erro na leitura
	jr $ra
		
	
# verificando se o contador i é divisor de N
verificador:
	beq $t1, $t0, endLoop	# se $t1 = N, sai do loop
	div $t0, $t1	# N / i
	mfhi $t2	# resto da divisão vai para $t3
	beq $t2, 0, eDivisor	# se resto da divisao = 0, é divisor
	# se o resto da divisão não for zero, não é divisor de N, vai pro próximo número
	addi $t1, $t1, 1	# acrescentando 1 ao contador i
	j verificador
	
# realizando a soma dos divisores de N
eDivisor:
	add $t9, $t9, $t1	# armazenando a soma dos divisores no registrador $t9
	addi $t1, $t1, 1	# acrescentando 1 ao contador i
	j verificador

endLoop:
	jr $ra
		
imprimePerfeito:
	# imprimindo a mensagem que diz que N é inteiro perfeito
	li $v0, 4		# comando para imprimir uma string
	la $a0, msgPerfeito	# imprime msgPerfeito	
	syscall
	j encerraPrograma
			
imprimeNaoPerfeito:
	# imprimindo a mensagem que diz que N é inteiro perfeito
	li $v0, 4		# comando para imprimir uma string
	la $a0, msgNaoPerfeito	# imprime msgNaoPerfeito	
	syscall
	j encerraPrograma

msgerro:
	# caso o usuario tenha inserido um numero menor ou igual a zero, imprime uma mensagem de erro e faz a leitura novamente
	li $v0, 4	# imprimir uma string
	la $a0, erro	# imprime erro
	syscall	
	j leitura	# volta para fazer a leitura de um numero correto