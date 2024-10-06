.data
arreglo:
.word 3, 25, 7, 9, 25, 19  # El n�mero 15 se repite
tama�o: 
.word 6                    # Tama�o del arreglo
valor_maximo:
.word 0                    # Aqu� almacenaremos el valor m�ximo
indice_maximo:
.word 0                    # Aqu� almacenaremos el �ndice del valor m�ximo

.text 
.globl main
main:
    # Cargamos la direcci�n del arreglo
    la $a0, arreglo         # Cargamos la direcci�n base del array en $a0
    lw $a1, tama�o          # Cargamos el tama�o del arreglo en $a1

    # Llamamos al proceso para hallar el valor m�ximo
    jal buscarmax           # Llamamos al proceso buscarmax

    # Guardamos el valor m�ximo y su posici�n
    sw $v0, valor_maximo    # Guardamos el valor en valor_maximo
    sw $v1, indice_maximo   # Guardamos el �ndice en indice_maximo

    # Imprimir el valor m�ximo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_valor       # Cargar mensaje "Valor m�ximo: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, valor_maximo    # Cargar el valor m�ximo desde la memoria en $a0
    syscall

    # Imprimir el �ndice del valor m�ximo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_indice      # Cargar mensaje "Posici�n: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, indice_maximo   # Cargar el �ndice m�ximo desde la memoria en $a0
    syscall

    # Finaliza el programa
    li $v0, 10              # Llamada del sistema para finalizar
    syscall

# Proceso para hallar el valor m�ximo
buscarmax:
    # Iniciar los registros
    lw $t0, 0($a0)          # Cargar el primer valor del arreglo en $t0 (valor m�ximo inicial)
    li $t1, 0               # Iniciar el �ndice del valor m�ximo en $t1
    li $t2, 0               # Iniciar el �ndice actual en $t2

loop:
    bge $t2, $a1, fin       # Si el �ndice actual es mayor o igual al tama�o, termina el bucle

    lw $t3, 0($a0)          # Cargar el valor actual del arreglo en $t3
    bgt $t3, $t0, actualizar # Si el valor actual es mayor que el m�ximo, actualiza

    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el �ndice
    j loop                  # Repetir el ciclo

actualizar:
    move $t0, $t3           # Actualizar el valor m�ximo
    move $t1, $t2           # Actualizar el �ndice del valor m�ximo
    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el �ndice
    j loop                  # Volver al ciclo principal

fin:
    move $v0, $t0           # El valor m�ximo en $v0
    move $v1, $t1           # El �ndice del m�ximo en $v1
    jr $ra                  # Retornar al llamador

# Mensajes
.data
msg_valor: .asciiz "Valor m�ximo: "
msg_indice: .asciiz " Posici�n: "