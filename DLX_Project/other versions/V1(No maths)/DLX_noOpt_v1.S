
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
    lf f1, a1
    lf f2, a2
    lf f3, a3
    lf f4, a4


    ; calculo matriz MF(a1,a2) 
    ; MF11 -> es a1 asique ya tenemos el valor en el registro -> f1       11 12  ->  f1 f5
    ; MF21 -> es a2 asique ya tenemos el valor en el registro -> f2       21 22      f2 f6
    eqf f2, f0
    bfpt endProgram
    divf f5, f1, f2                                    ; MF12 -> f5
    multf f6, f1, f2                                   ; MF21 -> f6


    ; calculo matriz MF(a3,a4) 
    ; MF11 -> es a3 asique ya tenemos el valor en el registro -> f3       11 12  ->  f3 f7
    ; MF21 -> es a4 asique ya tenemos el valor en el registro -> f4       21 22      f4 f8
    eqf f4, f0
    bfpt endProgram
    divf f7, f3, f4                                    ; MF12 -> f7
    multf f8, f3, f4                                   ; MF21 -> f8


    ; calculo matriz MF(a2,a3) 
    ; MF11 -> es a2 asique ya tenemos el valor en el registro -> f2       11 12  ->  f2 f9      
    ; MF21 -> es a3 asique ya tenemos el valor en el registro -> f3       21 22      f3 f10
    eqf f3, f0
    bfpt endProgram
    divf f9, f2, f3                                    ; MF12 -> f9
    multf f10, f2, f3                                  ; MF21 -> f10





    ; Calculo del producto de Kronecker de MF(a1,a2) y MF(a3,a4) -> P 
    multf f11, f1, f3 ; P11
    multf f12, f1, f7 ; P12
    multf f13, f5, f3 ; P13
    multf f14, f5, f7 ; P14

    multf f15, f1, f4 ; P21
    multf f16, f1, f8 ; P22
    multf f17, f5, f4 ; P23
    multf f18, f5, f8 ; P24

    multf f19, f2, f3 ; P31
    multf f20, f2, f7 ; P32
    multf f21, f6, f3 ; P33
    multf f22, f6, f7 ; P34

    multf f23, f2, f4 ; P41
    multf f24, f2, f8 ; P42
    multf f25, f6, f4 ; P43
    multf f26, f6, f8 ; P44


    ; Calculo determinante de MF(a2,a3)
    multf f28, f2, f10
    multf f29, f3, f9
    subf f28, f28, f29

    ;beqz f28, endProgram
    eqf f28, f0
    bfpt endProgram

    ; Calcular (a1+a4)/|MF(a2,a3)|
    addf f27, f1, f4
    divf f27, f27, f28

    ; Multiplicar P por (a1+a4)/|MF(a2,a3)|
    multf f11, f11, f27 ; M11 -> f11
    multf f12, f12, f27 ; M12 -> f12
    multf f13, f13, f27 ; M13 -> f13
    multf f14, f14, f27 ; M14 -> f14
    multf f15, f15, f27 ; M21 -> f15
    multf f16, f16, f27 ; M22 -> f16
    multf f17, f17, f27 ; M23 -> f17
    multf f18, f18, f27 ; M24 -> f18
    multf f19, f19, f27 ; M31 -> f19
    multf f20, f20, f27 ; M32 -> f20
    multf f21, f21, f27 ; M33 -> f21
    multf f22, f22, f27 ; M34 -> f22
    multf f23, f23, f27 ; M41 -> f23
    multf f24, f24, f27 ; M42 -> f24
    multf f25, f25, f27 ; M43 -> f25
    multf f26, f26, f27 ; M44 -> f26

    ; Guardar matriz
    sf M, f11
    sf M+0x4, f12 
    sf M+0x8, f13 
    sf M+0xc, f14 

    sf M+0x10, f15
    sf M+0x14, f16
    sf M+0x18, f17 
    sf M+0x1c, f18 

    sf M+0x20, f19
    sf M+0x24, f20
    sf M+0x28, f21
    sf M+0x2c, f22 

    sf M+0x30, f23
    sf M+0x34, f24
    sf M+0x38, f25 
    sf M+0x3c, f26 


    ; Ya no necesitamos tener cargados los valores de a1-a4 en registros asique ya lo podemos usar para nuestros cálculos
    ; Lo mismo nos ocurre con las matrices MF calculadas anteriormente

    ; Calcular VM
    multf f1, f11, f15 ; VM1 -> f1
    multf f2, f12, f16 ; VM2 -> f2
    multf f3, f13, f17 ; VM3 -> f3
    multf f4, f14, f18 ; VM4 -> f4

    sf VM, f1
    sf VM+0x4, f2 
    sf VM+0x8, f3 
    sf VM+0xc, f4 


    ; Calcular HM
    multf f5, f19, f23 ; HM1 -> f5
    multf f6, f20, f24 ; HM2 -> f6
    multf f7, f21, f25 ; HM3 -> f7
    multf f8, f22, f26 ; HM4 -> f8

    sf HM, f5
    sf HM+0x4, f6 
    sf HM+0x8, f7 
    sf HM+0xc, f8 


    ; Calcular check
    addf f1, f1, f2
    addf f1, f1, f3
    addf f1, f1, f4
    addf f1, f1, f5
    addf f1, f1, f6
    addf f1, f1, f7
    addf f1, f1, f8

    sf check, f1

endProgram:
	trap 0    ; Finaliza la ejecución
		
