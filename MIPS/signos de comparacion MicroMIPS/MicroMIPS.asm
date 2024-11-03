.data
prompt1:     .asciiz "Introduce el primer número: "
prompt2:     .asciiz "Introduce el segundo número: "
msg_igual:   .asciiz "Los números son iguales.\n"
msg_menor:   .asciiz "El primer número es menor que el segundo.\n"
msg_mayor:   .asciiz "El primer número es mayor que el segundo.\n"

.text
.globl main

main:
    li $v0, 4                # Imprimir cadena
    la $a0, prompt1
    syscall

    li $v0, 5                # Leer entero
    syscall
    move $t0, $v0            # Primer número

    li $v0, 4                # Imprimir cadena
    la $a0, prompt2
    syscall

    li $v0, 5                # Leer entero
    syscall
    move $t1, $v0            # Segundo número

    beq $t0, $t1, igual      # Si son iguales
    slt $t2, $t0, $t1        # $t2 = ($t0 < $t1)
    bne $t2, $zero, menor    # Si $t0 < $t1, saltar a menor

    # Si no es menor, es mayor
    li $v0, 4
    la $a0, msg_mayor
    syscall
    j fin

igual:
    li $v0, 4
    la $a0, msg_igual
    syscall
    j fin

menor:
    li $v0, 4
    la $a0, msg_menor
    syscall

fin:
    li $v0, 10               # Salir
    syscall