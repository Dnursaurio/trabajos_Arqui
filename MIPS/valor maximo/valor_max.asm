.data
arreglo:
.word 3, 25, 7, 9, 25, 19  # El número 15 se repite
tamaño: 
.word 6                    # Tamaño del arreglo
valor_maximo:
.word 0                    # Aquí almacenaremos el valor máximo
indice_maximo:
.word 0                    # Aquí almacenaremos el índice del valor máximo

.text 
.globl main
main:
    # Cargamos la dirección del arreglo
    la $a0, arreglo         # Cargamos la dirección base del array en $a0
    lw $a1, tamaño          # Cargamos el tamaño del arreglo en $a1

    # Llamamos al proceso para hallar el valor máximo
    jal buscarmax           # Llamamos al proceso buscarmax

    # Guardamos el valor máximo y su posición
    sw $v0, valor_maximo    # Guardamos el valor en valor_maximo
    sw $v1, indice_maximo   # Guardamos el índice en indice_maximo

    # Imprimir el valor máximo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_valor       # Cargar mensaje "Valor máximo: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, valor_maximo    # Cargar el valor máximo desde la memoria en $a0
    syscall

    # Imprimir el índice del valor máximo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_indice      # Cargar mensaje "Posición: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, indice_maximo   # Cargar el índice máximo desde la memoria en $a0
    syscall

    # Finaliza el programa
    li $v0, 10              # Llamada del sistema para finalizar
    syscall

# Proceso para hallar el valor máximo
buscarmax:
    # Iniciar los registros
    lw $t0, 0($a0)          # Cargar el primer valor del arreglo en $t0 (valor máximo inicial)
    li $t1, 0               # Iniciar el índice del valor máximo en $t1
    li $t2, 0               # Iniciar el índice actual en $t2

loop:
    bge $t2, $a1, fin       # Si el índice actual es mayor o igual al tamaño, termina el bucle

    lw $t3, 0($a0)          # Cargar el valor actual del arreglo en $t3
    bgt $t3, $t0, actualizar # Si el valor actual es mayor que el máximo, actualiza

    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el índice
    j loop                  # Repetir el ciclo

actualizar:
    move $t0, $t3           # Actualizar el valor máximo
    move $t1, $t2           # Actualizar el índice del valor máximo
    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el índice
    j loop                  # Volver al ciclo principal

fin:
    move $v0, $t0           # El valor máximo en $v0
    move $v1, $t1           # El índice del máximo en $v1
    jr $ra                  # Retornar al llamador

# Mensajes
.data
msg_valor: .asciiz "Valor máximo: "
msg_indice: .asciiz " Posición: "