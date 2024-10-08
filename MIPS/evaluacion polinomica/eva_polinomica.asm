.data
    prompt_n: .asciiz "Ingrese el grado del polinomio: "
    prompt_coef: .asciiz "Ingrese el coeficiente a"
    prompt_x: .asciiz "Ingrese el valor de x: "
    newline: .asciiz "\n"
    
.text
    .globl main

main:
    # Pedir el grado del polinomio
    li $v0, 4                # syscall para imprimir cadena
    la $a0, prompt_n         # cargar direcci�n del mensaje
    syscall

    li $v0, 5                # syscall para leer entero (grado n)
    syscall
    move $t0, $v0            # guardar el grado n en $t0
    
    # Calcular bytes necesarios para coeficientes (4 bytes por float)
    addi $t1, $t0, 1         # n + 1 coeficientes
    li $t2, 4                # 4 bytes por float (32 bits)
    mul $a0, $t1, $t2        # n�mero total de bytes necesarios
    
    # Reservar memoria para los coeficientes
    li $v0, 9                # syscall para solicitar memoria
    syscall
    move $s0, $v0            # guardar la direcci�n de la memoria reservada en $s0
    
    # Ingresar los coeficientes como float
    li $t3, 0                # �ndice para los coeficientes

enter_coefficients:
    li $v0, 4                # syscall para imprimir cadena
    la $a0, prompt_coef       # cargar mensaje "Ingrese el coeficiente a"
    syscall

    li $v0, 1                # imprimir el �ndice del coeficiente (a0, a1, ..., an)
    move $a0, $t3            # cargar el �ndice
    syscall

    li $v0, 4                # imprimir salto de l�nea
    la $a0, newline
    syscall

    li $v0, 6                # syscall para leer float
    syscall

    # Almacenar coeficiente (float) en la memoria reservada
    swc1 $f0, 0($s0)
    addi $s0, $s0, 4         # avanzar al siguiente espacio en memoria
    addi $t3, $t3, 1         # incrementar �ndice
    
    blt $t3, $t1, enter_coefficients  # repetir hasta leer todos los coeficientes
    
    # Pedir el valor de x (en punto flotante)
    li $v0, 4                # syscall para imprimir cadena
    la $a0, prompt_x         # cargar direcci�n del mensaje
    syscall

    li $v0, 6                # syscall para leer float
    syscall
    mov.s $f12, $f0          # guardar x en $f12
    
    # Resetear la memoria para la evaluaci�n
    subu $s0, $s0, $t1       # volver a la direcci�n inicial de los coeficientes
    
    # Evaluar el polinomio
    li $t3, 0                # reiniciar �ndice para los coeficientes
    
    # Inicializar el acumulador de resultados en 0.0
    li $t6, 0                # Cargar 0 en un registro entero
    mtc1 $t6, $f2            # Mover el valor entero 0 al registro flotante $f2

evaluate_polynomial:
    lwc1 $f4, 0($s0)         # cargar coeficiente de memoria (float)
    
    # Calcular x^exponente y multiplicar por coeficiente
    mov.s $f6, $f12          # cargar x en $f6 (x^1 inicialmente)
    li $t5, 0                # exponente actual
exp_loop:
    mul.s $f6, $f6, $f12     # calcular x^exponente
    addi $t5, $t5, 1         # incrementar exponente
    blt $t5, $t3, exp_loop   # repetir para calcular x^exponente
    
    mul.s $f6, $f6, $f4      # multiplicar coeficiente por x^exponente
    add.s $f2, $f2, $f6      # sumar al acumulador de resultados
    
    addi $s0, $s0, 4         # avanzar al siguiente coeficiente en memoria
    addi $t3, $t3, 1         # incrementar el �ndice del coeficiente
    
    blt $t3, $t1, evaluate_polynomial  # repetir para todos los coeficientes
    
    # Mostrar el resultado del polinomio
    li $v0, 2                # syscall para imprimir float
    mov.s $f12, $f2          # pasar el resultado a $f12
    syscall

    # Terminar el programa
    li $v0, 10               # syscall para salir
    syscall