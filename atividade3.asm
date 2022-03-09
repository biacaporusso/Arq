.data
ent1: .asciiz "Insira a string 1: "
ent2: .asciiz "\nInsira a string 2: "
str1: .space 100
str2: .space 100
str3: .space 200

.text
main:
	la $a0, ent1	# parametro: mensagem 
	la $a1, str1	# parametro: endereço da string
	jal leitura 	# leitura (mensagem, string)
	
	la $a0, ent2	# parametro: mensagem 
	la $a1, str2	# parametro: endereço da string
	jal leitura 	# leitura (mensagem, string)
	
	la $a0, str1	# parametro: endereço da string 1
	la $a1, str2	# parametro: endereço da string 2
	la $a2, str3	# parametro: endereço da string 3
	jal intercala	# intercala (str1, str2, str3)
	
	move $a0, $v0	# move o retorno da string resultante
	li $v0, 4	# codigo de impressao da string
	syscall		# imprime a string intercalada
	li $v0, 10	# codigo para finalizar o programa
	syscall		# finaliza o programa
	
leitura:
	li $v0, 4	# codigo de impressao da string
	syscall		# imprime a string
	move $a0, $a1	# endereço da string para leitura
	li $a1, 100	# numero maximo de caracteres
	li $v0, 8 	# codigo de leitura da string
	syscall		# faz a leitura da string
	jr $ra 		# retorna para a main
	
intercala:
	li $t0, 0	# indice i para percorrer o vetor
	li $t1, 100	# N = 100 (tamanho do vetor)
	
	move $s2, $a2	# $s2 recebe o endereço inicial da string 3, porém $s2 vai sofrer alterações pra percorrer o vetor
	move $s3, $a2	# $s3 recebe o endereço inicial da string 3 e vai ficar fixo p/ ser passado de parâmetro no fim
	
	loop:
		beq $t0, $t1, endLoop
		
		lb $s0, ($a0)	# $s0 recebe o valor contido no endereço de $a0 
		sb $s0, ($s2)	# salva na string 3 o elemento da string 1 de $s0
		add $s2, $s2, 1	# atualizando o indice do vetor da string 3
		add $a0, $a0, 1	# atualizando o indice do vetor da string 1
		
		lb $s1, ($a1)	# $s1 recebe o valor contido no endereço de $a1
		sb $s1, ($s2)	# salva na string 3 o elemento da string 2 de $s1
		add $s2, $s2, 1	# atualizando o indice do vetor da string 3
		add $a1, $a1, 1	# atualizando o indice do vetor da string 2
		
		add $t0, $t0, 2	# i = i+2
		j loop		
	endLoop:
	
	move $v0, $s3
	jr $ra 

	
