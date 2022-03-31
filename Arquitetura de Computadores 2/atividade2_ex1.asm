.data

mVetA: .asciiz "Vetor A: \n"
mVetB: .asciiz "Vetor B: \n"
mN: .asciiz "N: "
mSomaVetA: .asciiz "\nSoma dos elementos das posições pares de A: "
mSomaVetB: .asciiz "\nSoma dos elementos das posições pares de B: "
mSubtracao: .asciiz "\nSoma de A - Soma de B = "
	
.text

li $v0, 4	# codigo de impressao de string
la $a0, mN	# carrega o endereço da string
syscall		# impressão da string

li $v0, 5	# codigo de leitura de inteiro
syscall		# leitura do inteiro
move $t1, $v0	# $t1 = N

li $t0, 0	# $t0 = i 

li $v0, 4	# codigo de impressao de string
la $a0, mVetA	# carrega o endereço da string
syscall		# impressão da string

mul $s1, $t1, 4	# $s1 = quantidade de memória a ser alocada (4*N)
move $a0, $s1	# $a0 <- $s1 (argumento da funcao de alocar)
li $v0, 9	# codigo de alocaçao dinamica heap
syscall		# aloca 4*N bytes (endereço em $v0)
move $t9, $v0	# move para $t9 o endereço do primeiro elemento do vetor A

loopLeituraVetA:
	beq $t0, $t1, endLoopLeituraVetA	# quando $t0 = $t1 termina a leitura
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $t2, $v0	# $t2 = aux (elemento inserido)
	sw $t2, ($t9)	# armazenando $t2 na posição de memoria que $t9 aponta 
	add $t9, $t9, 4	# proxima posição do vetor
	add $t0, $t0, 1	# i = i+1
	j loopLeituraVetA	
endLoopLeituraVetA:

# agora preciso fazer $t9 apontar pro inicio do vetor de novo, então pega a ultima posição e subtrai 4*N
sub $t9, $t9, $s1	# agora $t9 aponta pra primeira posição do vetor
# para começar o loop com $t9 apontando pra posição par (segunda posição = 2), considerando que primeira posição = 1, então :
add $t9, $t9, 4

li $t0, 0	# $t0 = i 
li $t3, 0	# $t3 vai ser a soma dos elementos das posições pares do vetor A
loopSomaVetA:
	beq $t0, $t1, endLoopSomaVetA	# quando $t0 = $t1 termina o loop
	lw $t2, ($t9) 		# carrega $t2 com o valor da posição apontada por $t9
	add $t3, $t3, $t2	# $t3 = $t3 + vetorA[indice par]
	add $t9, $t9, 8		# para que $t9 aponte pra proxima posição par (se somar 4 aponta pra impar, então soma 8)
	add $t0, $t0, 1		# i = i+1
	j loopSomaVetA
endLoopSomaVetA:

# -------------------------------------------------------------------------------------------------------------------------------

# agora basta fazer exatamente a mesma coisa feita anteriormente, dessa vez para realizar a soma do vetor B 
# 1º -  
li $v0, 4	# codigo de impressao de string
la $a0, mVetB	# carrega o endereço da string
syscall		# impressão da string

# 2º - alocação de memória 
move $a0, $s1	# $a0 <- $s1 (argumento da funcao de alocar)
li $v0, 9	# codigo de alocaçao dinamica heap
syscall		# aloca 4*N bytes (endereço em $v0)
move $t8, $v0	# move para $t8 o endereço do primeiro elemento do vetor B

# 3º - loop leitura
li $t0, 0	# $t0 = i 
loopLeituraVetB:
	beq $t0, $t1, endLoopLeituraVetB	# quando $t0 = $t1 termina a leitura
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $t2, $v0	# $t2 = aux (elemento inserido)
	sw $t2, ($t8)	# armazenando $t2 na posição de memoria que $t8 aponta 
	add $t8, $t8, 4	# proxima posição do vetor
	add $t0, $t0, 1	# i = i+1
	j loopLeituraVetB	
endLoopLeituraVetB:

# agora preciso fazer $t8 apontar pro inicio do vetor de novo, então pega a ultima posição e subtrai 4*N
sub $t8, $t8, $s1	# agora $t8 aponta pra primeira posição do vetor
# para começar o loop com $t8 apontando pra posição par (segunda posição = 2), considerando que primeira posição = 1, então :
add $t8, $t8, 4

li $t0, 0	# $t0 = i 
li $t4, 0	# $t4 vai ser a soma dos elementos das posições pares do vetor B
loopSomaVetB:
	beq $t0, $t1, endLoopSomaVetB	# quando $t0 = $t1 termina o loop
	lw $t2, ($t8) 		# carrega $t2 com o valor da posição apontada por $t8
	add $t4, $t4, $t2	# $t3 = $t3 + vetorA[indice par]
	add $t8, $t8, 8		# para que $t8 aponte pra proxima posição par (se somar 4 aponta pra impar, então soma 8)
	add $t0, $t0, 1		# i = i+1
	j loopSomaVetB
endLoopSomaVetB:

# ------------------------------------------------------------------------------------------------------------------------------
# agora, basta subtrair as somas

li $v0, 4		# codigo de impressao de string
la $a0, mSomaVetA	# carrega o endereço da string
syscall			# impressão da string

li $v0, 1	# imprimir um inteiro
move $a0, $t3	# imprime o valor da soma que está armazenada no $t3 
syscall

li $v0, 4		# codigo de impressao de string
la $a0, mSomaVetB	# carrega o endereço da string
syscall			# impressão da string

li $v0, 1	# imprimir um inteiro
move $a0, $t4	# imprime o valor da soma que está armazenada no $t3 
syscall

li $v0, 4		# codigo de impressao de string
la $a0, mSubtracao	# carrega o endereço da string
syscall			# impressão da string

sub $t5, $t3, $t4	# $t5 = $t2 - $t3 (somaA - somaB)
li $v0, 1	# imprimir um inteiro
move $a0, $t5	# imprime o valor da soma que está armazenada no $t3 
syscall
