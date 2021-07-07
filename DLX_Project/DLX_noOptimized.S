
	.data
; Espacio de datos

; VARIABLES DE ENTRADA: NO MODIFICAR ORDEN (Se pueden modificar los valores)
a1: .float 1.1
a2: .float 2.2
a3: .float 3.3
a4: .float 4.4

;;;;; VARIABLES DE SALIDA: NO MODIFICAR ORDEN
         ; m11, m12, m13, m14
         ; m21, m22, m23, m24
         ; m31, m32, m33, m34
         ; m41, m42, m43, m44
M:  .float 0.0, 0.0, 0.0, 0.0
    .float 0.0, 0.0, 0.0, 0.0
    .float 0.0, 0.0, 0.0, 0.0
    .float 0.0, 0.0, 0.0, 0.0

            ; hm1, hm2, hm3, hm4
HM: .float    0.0, 0.0, 0.0, 0.0

            ; vm1, vm2, vm3, vm4
VM: .float    0.0, 0.0, 0.0, 0.0

check: .float 0.0
;;;;; FIN NO MODIFICAR ORDEN



	.text

; Espacio de codigo
	.global main

main:
    ; cargar los datos de entrada en los registros
    lf f1, a1   ; f1 = a1
    lf f2, a2   ; f2 = a2
    lf f3, a3   ; f3 = a3
    lf f4, a4   ; f4 = a4


    ; Calculo matriz MF(a1,a2) = A
    ; A11 A12  =  f1 f5
    ; A21 A22  =  f2 f6

                        ; A11 = f1  
    eqf f2, f0          ; Comprobación de no división entre 0 
    bfpt endProgram
    divf f5, f1, f2     ; A12 = f5 = a1/a2
                        ; A21 = f2
    multf f6, f1, f2    ; A21 = f6 = a1/a2


    ; calculo matriz MF(a3,a4) = B
    ; B11 B12  =  f3 f7
    ; B21 B22  =  f4 f8

                        ; B11 = f3         
    eqf f4, f0          ; Comprobación de no división entre 0
    bfpt endProgram
    divf f7, f3, f4     ; B12 = f7 = a3/a4
                        ; B21 = f4  
    multf f8, f3, f4    ; B22 = f8 = a3*a4


    ; calculo matriz MF(a2,a3) = C
    ; C11 C12  =  f2 f9   
    ; C21 C22  =  f3 f10

                        ; C11 = f2              
    eqf f3, f0          ; Comprobación de no división entre 0
    bfpt endProgram
    divf f9, f2, f3     ; C12 = f9 = a2/a3
                        ; C21 = f3  
    multf f10, f2, f3   ; C22 = f10 = a2*a3



    ; Calculo del producto de Kronecker de MF(a1,a2) y MF(a3,a4) = P = A x B
    multf f11, f1, f3 ; P11 = f11 = A11 * B11
    multf f12, f1, f7 ; P12 = f12 = A11 * B12
    multf f13, f5, f3 ; P13 = f13 = A12 * B11
    multf f14, f5, f7 ; P14 = f14 = A12 * B12

    multf f15, f1, f4 ; P21 = f15 = A11 * B21
    multf f16, f1, f8 ; P22 = f16 = A11 * B22
    multf f17, f5, f4 ; P23 = f17 = A12 * B21
    multf f18, f5, f8 ; P24 = f18 = A12 * B22

    multf f19, f2, f3 ; P31 = f19 = A21 * B11
    multf f20, f2, f7 ; P32 = f20 = A21 * B12
    multf f21, f6, f3 ; P33 = f21 = A21 * B11
    multf f22, f6, f7 ; P34 = f22 = A21 * B12

    multf f23, f2, f4 ; P41 = f23 = A21 * B21
    multf f24, f2, f8 ; P42 = f24 = A21 * B22
    multf f25, f6, f4 ; P43 = f25 = A21 * B21
    multf f26, f6, f8 ; P44 = f26 = A21 * B22


    ; Calculo determinante de MF(a2,a3) = C
    multf f28, f2, f10   ; f28 = f2 * f10 = C11 * C22
    multf f29, f3, f9    ; f29 = f3 * f9  = C21 * C12
    subf f28, f28, f29   ; f28 = f28 - f29 = (C11 * C22) - (C21 * C12)

    eqf f28, f0          ; Comprobación de no división entre 0
    bfpt endProgram

    ; Calcular (a1+a4)/|MF(a2,a3)| = (a1+a4)/|C|
    addf f27, f1, f4     ; f27 = f1 + f4 = a1 + a4
    divf f27, f27, f28   ; f27 = f27/f28 = (a1+a4)/|C|

    ; Calcular M final -> M = P * (a1+a4)/|MF(a2,a3)|
    multf f11, f11, f27 ; M11 = f11 = P11 * (a1+a4)/|MF(a2,a3)|
    multf f12, f12, f27 ; M12 = f12 = P12 * (a1+a4)/|MF(a2,a3)|
    multf f13, f13, f27 ; M13 = f13 = P13 * (a1+a4)/|MF(a2,a3)|
    multf f14, f14, f27 ; M14 = f14 = P14 * (a1+a4)/|MF(a2,a3)|

    multf f15, f15, f27 ; M21 = f15 = P21 * (a1+a4)/|MF(a2,a3)|
    multf f16, f16, f27 ; M22 = f16 = P22 * (a1+a4)/|MF(a2,a3)|
    multf f17, f17, f27 ; M23 = f17 = P23 * (a1+a4)/|MF(a2,a3)|
    multf f18, f18, f27 ; M24 = f18 = P24 * (a1+a4)/|MF(a2,a3)|

    multf f19, f19, f27 ; M31 = f19 = P31 * (a1+a4)/|MF(a2,a3)|
    multf f20, f20, f27 ; M32 = f20 = P32 * (a1+a4)/|MF(a2,a3)|
    multf f21, f21, f27 ; M33 = f21 = P33 * (a1+a4)/|MF(a2,a3)|
    multf f22, f22, f27 ; M34 = f22 = P34 * (a1+a4)/|MF(a2,a3)|

    multf f23, f23, f27 ; M41 = f23 = P41 * (a1+a4)/|MF(a2,a3)|
    multf f24, f24, f27 ; M42 = f24 = P42 * (a1+a4)/|MF(a2,a3)|
    multf f25, f25, f27 ; M43 = f25 = P43 * (a1+a4)/|MF(a2,a3)|
    multf f26, f26, f27 ; M44 = f26 = P44 * (a1+a4)/|MF(a2,a3)|

    ; Guardar matriz
    sf M, f11           ; guardar M11
    sf M+0x4, f12       ; guardar M12
    sf M+0x8, f13       ; guardar M13
    sf M+0xc, f14       ; guardar M14

    sf M+0x10, f15      ; guardar M21
    sf M+0x14, f16      ; guardar M22
    sf M+0x18, f17      ; guardar M23
    sf M+0x1c, f18      ; guardar M24

    sf M+0x20, f19      ; guardar M31
    sf M+0x24, f20      ; guardar M32
    sf M+0x28, f21      ; guardar M33
    sf M+0x2c, f22      ; guardar M34

    sf M+0x30, f23      ; guardar M41
    sf M+0x34, f24      ; guardar M42
    sf M+0x38, f25      ; guardar M43
    sf M+0x3c, f26      ; guardar M44


    ; Ya no necesitamos tener cargados los valores de a1-a4 en registros 
    ;    asique ya lo podemos usar para nuestros cálculos
    ; Lo mismo nos ocurre con las matrices MF calculadas anteriormente

    ; Calcular VM
    multf f1, f11, f15 ; VM1 = f1 = M11 * M21
    multf f2, f12, f16 ; VM2 = f2 = M12 * M22
    multf f3, f13, f17 ; VM3 = f3 = M13 * M23
    multf f4, f14, f18 ; VM4 = f4 = M14 * M24

    sf VM, f1       ; guardar VM1
    sf VM+0x4, f2   ; guardar VM2
    sf VM+0x8, f3   ; guardar VM3
    sf VM+0xc, f4   ; guardar VM4


    ; Calcular HM
    multf f5, f19, f23 ; HM1 = f5 = M31 * M41
    multf f6, f20, f24 ; HM2 = f6 = M32 * M42
    multf f7, f21, f25 ; HM3 = f7 = M33 * M43
    multf f8, f22, f26 ; HM4 = f8 = M34 * M44

    sf HM, f5       ; guardar HM1
    sf HM+0x4, f6   ; guardar HM2 
    sf HM+0x8, f7   ; guardar HM3
    sf HM+0xc, f8   ; guardar HM4 


    ; Calcular check (usamos f1 como contador)
    addf f1, f1, f2  ; f1 = f1 + f2 = VM1 + VM2
    addf f1, f1, f3  ; f1 = f1 + f2 = f1 + VM3
    addf f1, f1, f4  ; f1 = f1 + f2 = f1 + VM4
    addf f1, f1, f5  ; f1 = f1 + f2 = f1 + HM1
    addf f1, f1, f6  ; f1 = f1 + f2 = f1 + HM2
    addf f1, f1, f7  ; f1 = f1 + f2 = f1 + HM3
    addf f1, f1, f8  ; f1 = f1 + f2 = f1 + HM4

    sf check, f1   ; guardar check 

endProgram:
	trap 0    ; Finaliza la ejecución
		
