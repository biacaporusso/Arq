.data
	matriz1: .asciiz "Matriz["
	matriz2: .asciiz "]["
	matriz3: .asciiz "] = "
	msgSoma: .asciiz "Soma dos elementos da diagonal secundária = "
	
.text
main:
	li $s0, 3	# $s0 = quantidade de linhas/colunas da matriz
	jal malloc	# $s1 = endereço base da matriz (fixo)
	
	move $a0, $s1	# passando de parâmetro o endereço base da matriz
	move $a1, $s0	# passando de parâmetro a quantidade de linhas/colunas
	jal leituraMatriz
	
	move $a0, $s1
	jal imprimeMatriz
	
	move $a0, $s1	# passando de parâmetro o endereço base da matriz
	move $a1, $s0	# passando de parâmetro a quantidade de linhas/colunas
	jal percorreMatriz
	
	jal resultado
	
	# encerra o programa
	li $v0, 10
	syscall
	
malloc:
	mul $t0, $s0, 4	# quantidade de memória a ser alocada (nesse caso, 4*3)
	move $a0, $t0	# $a0 <- $t0 (argumento da funcao de alocar)
	li $v0, 9	# codigo de alocação dinamica heap
	syscall		# aloca 4*N bytes (endereço em $v0)
	move $s1, $v0	# move para $s1 o endereço do primeiro elemento do vetor (fixo)

indice:
            mul $v0, $t1, $a1  #i * ncol
            add $v0, $v0, $t2  #i * ncol + j
            sll $v0, $v0, 2    #[(i*ncol) +j ] *4
            add $v0, $v0, $a3
            jr $ra

leituraMatriz:
	subi $sp, $sp, 4	# desempilhando
	sw $ra, ($sp)		# guardando o valor da pilha dessa função
	move $a3, $s1		# $a3 recebe o endereco base da matriz
	li $t1, 0		# contador i = 0
	li $t2, 0		# contador j = 0

	loopLeitura:
	# impressão da entrada da matriz
	la $a0, matriz1	
	li $v0, 4	# codigo de impressao de string
	syscall
	add $a0, $t1, 1
	li $v0, 1	# codigo de impressao de inteiro
	syscall
	la $a0, matriz2
	li $v0, 4	# codigo de impressao de string
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
	add $t4, $s0, 1		# t4 = n + 1
	
	loopPercorre:
	jal indice	# calcula o v0 de acordo com o indice
	lw $a0, ($v0)	# carrega em a0 o valor da posicao calculada

	# verifica se i+j = n+1 :
	add $t3, $t1, $t2	# t3 = i + j
	add $t3, $t3, 2		# i+1 + j+1 = i+j + 2
	beq $t3, $t4, diagSec
	back:

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
	
diagSec:
	add $s2, $s2, $a0	# $s2 = soma dos valores da diagonal secundaria
	j back
	
imprimeMatriz:
	subi $sp, $sp, 4
	sw $ra ($sp)
	move $a3, $a0
	li $t1, 0
	li $t2, 0
            
	loop_escrita:
        jal indice                  #Calcula o v0 de acordo com o indice
        lw $a0, ($v0)               #Carrega em a0 o valor da posicao calculada
        li $v0, 1
        syscall
        la $a0, 32                  #Codigo ascii para espaco
        li $v0, 11
        syscall
        addi $t2, $t2, 1            #j++
        blt $t2, $a1, loop_escrita  #Se o j é menor q o numero de linhas/colunas da matriz
                
        la $a0, 10                  #Codigo ascii para o \n
        syscall
        li $t2, 0                   #j = 0
        addi $t1, $t1, 1            #i++
        blt $t1, $a1, loop_escrita  #Se o i for menor que o numero de linhas/colunas salta pro loop novamente
        
        li $t1, 0       #i = 0 
        lw $ra, ($sp)               #Recupera o endereco do $ra que estava na pilha
        addi $sp, $sp, 4            #Devolve o ponteiro da pilha pro topo
        jr $ra
        
resultado:
	li $v0, 4	# impressao de string
	la $a0, msgSoma
	syscall
	
	li $v0, 1	# impressao de inteiro
	move $a0, $s2	# resultado da soma 
	syscall
	jr $ra
	