.data
Mat: .space 36	# 3x3 * 4 (inteiro)
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
msgSomaAcima: .asciiz "Soma dos elementos acima da diagonal principal: "
msgSomaAbaixo: .asciiz "\nSoma dos elementos abaixo da diagonal principal: "
msgSubtracao: .asciiz "\nResultado da subtracao = "
msgMaiorEle:
msgMenorEle: .asciiz "\nMenor elemento abaixo da diagonal principal: "

.text
main:	la $a0, Mat	# endereço base de mat
	li $a1, 3	# numero de linhas
	li $a2, 3	# numero de colunas
	
	li $t8, -99999	# auxiliar, $t8 vai ser o MAIOR ELEMENTO ACIMA DA DIAGONAL PRINCIPAL
	li $t9, 999999	# auxiliar, $t9 vai ser o MENOR ELEMENTO ABAIXO DA DIAGONAL PRINCIPAL
	jal leitura 	# leitura(mat, nlin, ncol)
	move $a0, $v0	# endereço da matriz lida
	jal escrita	# escrita(mat, nlin, ncol)
	
	la $a0, msgSomaAcima	# carrega o endereço da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime 
	li $v0, 1
	move $a0, $s0
	syscall
	la $a0, msgSomaAbaixo	# carrega o endereço da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime 
	li $v0, 1
	move $a0, $s1
	syscall
	jal subtracao
	
	li $v0, 10	# codigo para finalizar o programa
	syscall		# finaliza o programa
	
indice:
	mul $v0, $t0, $a2	# i * ncol
	add $v0, $v0, $t1	# (i * ncol) + j
	sll $v0, $v0, 2		# [ (i * ncol) + j ] * 4 (inteiro)
	add $v0, $v0, $a3	# soma o endereço base de mat
	jr $ra			# retorna para o caller
	
leitura:
	subi $sp, $sp, 4# espaço para 1 item na pilha
	sw $ra, ($sp)	# salva o retorno para a main
	move $a3, $a0	# aux = endereço base de mat
	
l:	la $a0, Ent1	# carrega o endereço da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime 
	
	move $a0, $t0	# valor de i para impressao
	li $v0, 1	# codigo de impressao de inteiro
	syscall 	# imprime i
	
	la $a0, Ent2	# carrega o endereço da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime a string
	
	move $a0, $t1	# valor de j para impressao
	li $v0, 1	# codigo de impressao de inteiro
	syscall		# imprime j
	
	la $a0, Ent3	# carrega o endereço da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime a string
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do valor (retorna em $v0)
	move $t2, $v0	# aux = valor lido
	jal indice	# calcula o endereço de mat[i][j]
	sw $t2, ($v0)	# mat[i][j] = aux
	bgt $t1, $t0, acimaDiagonal
	bgt $t0, $t1, abaixoDiagonal
	return:
	addi $t1, $t1, 1	# j++
	blt $t1, $a2, l	# if(j < ncol) goto l
	li $t1, 0	# j = 0
	
	addi $t0, $t0, 1	# i++
	blt $t0, $a1, l	# if(i < nlin) goto l
	li $t0, 0	# i = 0
	
	lw $ra, ($sp)	# recupera o retorno para a main
	addi $sp, $sp, 4	# libera o espaço na pilha
	move $v0, $a3	# endereço base da matriz para o retorno
	jr $ra		# retorna para a main	
	
acimaDiagonal:
	add $s0, $s0, $t2	# soma dos elementos acima da diagonal principal 
	bge $t2, $t8, maiorElemento	# # if matriz[i][j] > maiorElemento: maiorElemento <- matriz[i][j]
	return2:
	j return	
abaixoDiagonal:
	add $s1, $s1, $t2	# soma dos elementos abaixo da diagonal principal
	ble $s1, $t9, menorElemento	# if matriz[i][j] < menorElemento: menorElemento <- matriz[i][j]
	return3:
	j return
maiorElemento:
	move $t8, $t2
	j return2
menorElemento:
	move $t9, $t2
	j return3
	
subtracao:
	sub $s0, $s0, $s1
	la $a0, msgSubtracao	# carrega o endereço da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime 
	li $v0, 1	# codigo de impressao de inteiro
	move $a0, $s0	# carrega o resultado da subtracao pra imprimir
	syscall		# imprime
	jr $ra
	
escrita:
	subi $sp, $sp, 4	# espaço para 1 item na pilha
	sw $ra, ($sp)	# salva o retorno para a main
	move $a3, $a0	# aux = endereço base de mat
e:	jal indice	# calcula o endereço de mat[i][j]
	lw $a0, ($v0)	# valor em mat[i][j]
	li $v0, 1	# codigo de impressao de inteiro
	syscall		# imprime mat[i][j]
	la $a0, 32	# codigo ASCII para espaço
	li $v0, 11	# codigo de impressao de caracteres
	syscall		# imprime o espaço
	addi $t1, $t1, 1	# j++
	blt $t1, $a2, e	# if(j < ncol) goto e
	la $a0, 10	# codigo ASCII para newline (\n)
	syscall		# pula a linha
	li $t1, 0	# j = 0
	addi $t0, $t0, 1	# i++
	blt $t0, $a1, e	# if(i < nlin) goto e
	li $t0, 0	# i = 0
	lw $ra, ($sp)	# recupera o retorno para a main
	addi $sp, $sp, 4	# libera o espaço na pilha
	move $v0, $a3	# endereço base da matriz para retorno
	jr $ra		# retorna para a main
