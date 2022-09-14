.data
	matriz1: .asciiz "Matriz["
	matriz2: .asciiz "]["
	matriz3: .asciiz "] = "
	msgSoma: .asciiz "Soma dos elementos da diagonal secundária = "
	zero: .float 0.0
	
.text
main:
	li $s0, 3	# $s0 = quantidade de linhas/colunas da matriz
	lwc1 $f0, zero	# $f0 = 0.0
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
	li $v0, 6		# código de leitura de float
	syscall			# o valor lido estará em $f0
	
	jal indice		# calcula a posicao da matriz e armazena em $v0
	swc1 $f0, ($v0)		# guarda na posição calculada o valor lido
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
	lwc1 $f1, ($v0)	# carrega em a0 o valor da posicao calculada

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
	add.s $f3, $f3, $f1	# $s2 = soma dos valores da diagonal secundaria
	j back
	
imprimeMatriz:
	subi $sp, $sp, 4
	sw $ra ($sp)
	move $a3, $a0
	li $t1, 0
	li $t2, 0
	lwc1 $f2, zero	# $f2 = 0.0
            
	loop_escrita:
        jal indice                  # calcula o v0 de acordo com o indice
        
        lwc1 $f1, ($v0)		# carrega em a0 (f1) o valor da posicao calculada
        add.s $f12, $f1, $f2	# $f12 = $f2 (zero) + $f1 (numero lido)
	li $v0, 2	# código de impressão de float 
	syscall
	
        la $a0, 32	# codigo ascii para espaco
        li $v0, 11	# impressao de char
        syscall
        
        addi $t2, $t2, 1            # j++
        blt $t2, $a1, loop_escrita  # se o j é menor q o numero de linhas/colunas da matriz
                
        la $a0, 10                  # codigo ascii para o \n
        syscall
        li $t2, 0                   # j = 0
        addi $t1, $t1, 1            # i++
        blt $t1, $a1, loop_escrita  # se o i for menor que o numero de linhas/colunas salta pro loop novamente
        
        li $t1, 0	# i = 0 
        lw $ra, ($sp)               # recupera o endereco do $ra que estava na pilha
        addi $sp, $sp, 4            # devolve o ponteiro da pilha pro topo
        jr $ra
        
resultado:
	li $v0, 4	# impressao de string
	la $a0, msgSoma
	syscall
	
	add.s $f12, $f3, $f2	# $f12 = $f3 (soma) + $f2 (zero)
	li $v0, 2	# código de impressão de float 
	syscall
	jr $ra
	