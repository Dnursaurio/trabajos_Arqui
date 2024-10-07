.data
arreglo:
.word 3, 25, 7, 9, 25, 19  # Los números del array
tamaño: 
.word 6                    # Tamaño del arreglo
valor_minimo:
.word 0                    # Aquí almacenaremos el valor mínimo
indice_minimo:
.word 0                    # Aquí almacenaremos el índice del valor mínimo

.text 
.globl main
main:
    # Cargamos la dirección del arreglo
    la $a0, arreglo         # Cargamos la dirección base del array en $a0
    lw $a1, tamaño          # Cargamos el tamaño del arreglo en $a1

    # Llamamos al proceso para hallar el valor mínimo
    jal buscarmenor         # Llamamos al proceso buscarmenor

    # Guardamos el valor mínimo y su posición
    sw $v0, valor_minimo    # Guardamos el valor en valor_minimo
    sw $v1, indice_minimo   # Guardamos el índice en indice_minimo

    # Imprimir el valor mínimo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_valor       # Cargar mensaje "Valor mínimo: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, valor_minimo    # Cargar el valor mínimo desde la memoria en $a0
    syscall

    # Imprimir el índice del valor mínimo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_indice      # Cargar mensaje "Posición: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, indice_minimo   # Cargar el índice mínimo desde la memoria en $a0
    syscall

    # Finaliza el programa
    li $v0, 10              # Llamada del sistema para finalizar
    syscall

# Proceso para hallar el valor mínimo
buscarmenor:
    # Iniciar los registros
    lw $t0, 0($a0)          # Cargar el primer valor del arreglo en $t0 (valor mínimo inicial)
    li $t1, 0               # Iniciar el índice del valor mínimo en $t1
    li $t2, 0               # Iniciar el índice actual en $t2

loop:
    bge $t2, $a1, fin       # Si el índice actual es mayor o igual al tamaño, termina el bucle

    lw $t3, 0($a0)          # Cargar el valor actual del arreglo en $t3
    blt $t3, $t0, actualizar # Si el valor actual es menor que el mínimo, actualiza

    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el índice
    j loop                  # Repetir el ciclo

actualizar:
    move $t0, $t3           # Actualizar el valor mínimo
    move $t1, $t2           # Actualizar el índice del valor mínimo
    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el índice
    j loop                  # Volver al ciclo principal

fin:
    move $v0, $t0           # El valor mínimo en $v0
    move $v1, $t1           # El índice del mínimo en $v1
    jr $ra                  # Retornar al llamador

# Mensajes
.data
msg_valor: .asciiz "Valor mínimo: "
msg_indice: .asciiz " Posición: "