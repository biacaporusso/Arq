.data
	msgN: .asciiz "Insira o numero de posicoes do vetor: "
	msgVet: .asciiz "Insira vet["
	msgVet2: .asciiz "]: "
	zero: .float 0.0
	dez: .float 10.0
	espaco: .byte ' '
	msgMedia: .asciiz "\nMedia = "
	msgSomatorio: .asciiz "\nSomatorio = "
	nove: .float 9.0
	msgDesvio: .asciiz "\nDesvio padrao = "
	
.text
# variáveis fixas:
# $s0 = endereço base do vetor

# $f0 = 10 (N)
# $f1 = media
# $f2 = 0
main: 
	lwc1 $f0, dez	# N = 10
	
	jal alloc	# alocando memoria pro vetor
	move $s0, $v0 	# $s0 = endereço base do vetor (fixo, nao vai alterar)
	
	move $t1, $s0	# passa o endereço base do vetor para o argumento $a0
	jal leituraVetor
	
	#move $a0, $s0	# passa o endereço base do vetor para o argumento 
	#jal imprimeVetor
	
	move $t0, $s0	# $t0 = endereço base do vetor (será incrementado)
	jal calcularMedia	# retorna a media em $f1
	# imprime float
	li $v0, 4
	la $a0, msgMedia
	syscall
	lwc1 $f2, zero
	add.s $f12, $f1, $f2
	li $v0, 2
	syscall
	
	jal somatorio
	# imprime float
	li $v0, 4
	la $a0, msgSomatorio
	syscall
	lwc1 $f2, zero
	add.s $f12, $f6, $f2
	li $v0, 2
	syscall
	
	jal desvioPadrao
	# imprime float
	li $v0, 4
	la $a0, msgDesvio
	syscall
	lwc1 $f2, zero
	add.s $f12, $f8, $f2
	li $v0, 2
	syscall
	
	# encerra o programa
	li $v0, 10
	syscall
	
alloc:	# retorna o endereço do vetor em $v0
	li $a0, 40	
	li $v0, 9		# código de alocação dinâmica
	syscall
	jr $ra

leituraVetor:
	li $t0, 0		# $t0 = i = 0
	
	loop:
	la $a0, msgVet	
	li $v0, 4		# código de impressão de string
	syscall
	move $a0, $t0
	li $v0, 1		# código de impressão de inteiro
	syscall
	la $a0, msgVet2
	li $v0, 4		# código de impressão de string
	syscall
	
	li $v0, 6		# código de leitura de float
	syscall			# o valor lido estará em $f0
	
	swc1 $f0, ($t1)		# armazena $f0 na posição $t1 
	addi $t1, $t1, 4	# incrementa o endereço do vetor
	addi $t0, $t0, 1	# # i = i+1
	
	blt $t0, 10, loop	# if i < N continua a leitura do vetor
	jr $ra
	
imprimeVetor:
	move $t0, $s0	# endereço base do vetor (será incrementado)
	lwc1 $f2, zero	# $f2 = 0.0
	li $t1, 0	# i = 0
	
	loopimprime:
	beq $t1, 10, end	# if i = N sai do loop
	
	lwc1 $f1, ($t0)	# $f0 recebe o float armazenado em $t0
	add.s $f12, $f1, $f2	# $f12 = $f1 (zero) + $f0 (numero lido)
	li $v0, 2	# código de impressão de float 
	syscall
	
	la $a0, espaco
	li $v0, 4
	syscall

	addi $t0, $t0, 4	# incrementa o endereço do vetor
	addi $t1, $t1, 1	# i = i + 1
	j loopimprime
	
calcularMedia:
	# $t0 = endereço base vetor (será incrementado)
	li $t1, 0	# i = 0
	lwc1 $f12, zero
	
	soma:
	beq $t1, 10, media	# if i = N 
	lwc1 $f20, ($t0)	# $f0 = float na posição $t0
	add.s $f12, $f12, $f20	# $f12 = soma dos floats do vetor
	add $t0, $t0, 4	# incrementa o endereço do vetor
	add $t1, $t1, 1	# i = i + 1
	j soma
	
	media: 
	div.s $f1, $f12, $f20	# $f1 = soma / N
	jr $ra
	
somatorio:
	li $t1, 0	# i = 0
	move $t0, $s0	# endereço incrementavel
	
	loopPercorre:
	beq $t1, 10, end
	lwc1 $f3, ($t0)
	
	sub.s $f4, $f3, $f1	# $f4 = vet[i] - media
	mul.s $f5, $f4, $f4	# $f5 = (vet[i] - media)^2
	add.s $f6, $f6, $f5	# $f6 = somatório 
	
	add $t0, $t0, 4
	add $t1, $t1, 1
	j loopPercorre
	
desvioPadrao:
	lwc1 $f9, nove	# $f9 = 9
	div.s $f7, $f6, $f9	# $f7 = somatorio / n-1
	sqrt.s $f8, $f7	#  $f8 = raiz quadrada de tudo, ou seja, desvio padrao
	jr $ra
	  
end:
	jr $ra
