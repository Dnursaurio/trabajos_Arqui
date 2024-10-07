.data
arreglo:
.word 3, 25, 7, 9, 25, 19  # Los n�meros del array
tama�o: 
.word 6                    # Tama�o del arreglo
valor_minimo:
.word 0                    # Aqu� almacenaremos el valor m�nimo
indice_minimo:
.word 0                    # Aqu� almacenaremos el �ndice del valor m�nimo

.text 
.globl main
main:
    # Cargamos la direcci�n del arreglo
    la $a0, arreglo         # Cargamos la direcci�n base del array en $a0
    lw $a1, tama�o          # Cargamos el tama�o del arreglo en $a1

    # Llamamos al proceso para hallar el valor m�nimo
    jal buscarmenor         # Llamamos al proceso buscarmenor

    # Guardamos el valor m�nimo y su posici�n
    sw $v0, valor_minimo    # Guardamos el valor en valor_minimo
    sw $v1, indice_minimo   # Guardamos el �ndice en indice_minimo

    # Imprimir el valor m�nimo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_valor       # Cargar mensaje "Valor m�nimo: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, valor_minimo    # Cargar el valor m�nimo desde la memoria en $a0
    syscall

    # Imprimir el �ndice del valor m�nimo
    li $v0, 4               # Llamada para imprimir una cadena
    la $a0, msg_indice      # Cargar mensaje "Posici�n: "
    syscall

    li $v0, 1               # Llamada del sistema para imprimir entero
    lw $a0, indice_minimo   # Cargar el �ndice m�nimo desde la memoria en $a0
    syscall

    # Finaliza el programa
    li $v0, 10              # Llamada del sistema para finalizar
    syscall

# Proceso para hallar el valor m�nimo
buscarmenor:
    # Iniciar los registros
    lw $t0, 0($a0)          # Cargar el primer valor del arreglo en $t0 (valor m�nimo inicial)
    li $t1, 0               # Iniciar el �ndice del valor m�nimo en $t1
    li $t2, 0               # Iniciar el �ndice actual en $t2

loop:
    bge $t2, $a1, fin       # Si el �ndice actual es mayor o igual al tama�o, termina el bucle

    lw $t3, 0($a0)          # Cargar el valor actual del arreglo en $t3
    blt $t3, $t0, actualizar # Si el valor actual es menor que el m�nimo, actualiza

    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el �ndice
    j loop                  # Repetir el ciclo

actualizar:
    move $t0, $t3           # Actualizar el valor m�nimo
    move $t1, $t2           # Actualizar el �ndice del valor m�nimo
    addi $a0, $a0, 4        # Avanzar al siguiente valor del arreglo
    addi $t2, $t2, 1        # Incrementar el �ndice
    j loop                  # Volver al ciclo principal

fin:
    move $v0, $t0           # El valor m�nimo en $v0
    move $v1, $t1           # El �ndice del m�nimo en $v1
    jr $ra                  # Retornar al llamador

# Mensajes
.data
msg_valor: .asciiz "Valor m�nimo: "
msg_indice: .asciiz " Posici�n: "