
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
    lf f2, a2
    lf f1, a1

    eqf f2, f0
    bfpt endProgram
    divf f6, f1, f2     ; x2 = f6


    lf f4, a4
    lf f3, a3
    eqf f4, f0
    bfpt endProgram

    multf f10, f2, f3   ; x6 = f10
    multf f8, f2, f4    ; x4 = f8

    ; calculo de la matriz M
    multf f5, f1, f3    ; x1 = f5
    multf f12, f2, f10
    addf f11, f1, f4 
    subf f12, f12, f2
    multf f27, f1, f2

    eqf f12, f0
    bfpt endProgram
    divf f11, f11, f12  ; y = f11

    multf f9, f6, f3    ; x5 = f9    

    
    multf f12, f5, f11  ; z1 = f12
    multf f13, f8, f11  ; z2 = f13
    multf f14, f1, f11  ; z3 = f14
    multf f16, f4, f11  ; z5 = f16
    
    divf f7, f3, f4     ; x3 = f7

    multf f18, f9, f11    ; M13 = f18

    multf f20, f14, f4    ; M21 = f20
    multf f22, f6, f16    ; M23 = f22
    multf f21, f12, f4    ; M22 = f21

    sf M, f12       ; M11 = f12
    multf f15, f7, f11  ; z4 = f15


    multf f17, f15, f1    ; M12 = f17
    multf f19, f6, f15    ; M14 = f19
    multf f22, f6, f16    ; M23 = f22
    multf f23, f9, f16    ; M24 = f23

    multf f24, f10, f11   ; M31 = f24
    multf f25, f2, f15    ; M32 = f25
    multf f26, f12, f2    ; M33 = f26
    multf f27, f27, f15   ; M34 = f27

                          ; M41 = f13
    multf f28, f13, f3    ; M42 = f28
    multf f30, f12, f8    ; M44 = f30
    multf f29, f13, f1    ; M43 = f29


    ; Guardar matriz
    sf M+0x4, f17 
    sf M+0x8, f18 
    sf M+0xc, f19 

    sf M+0x10, f20
    sf M+0x14, f21
    sf M+0x18, f22
    sf M+0x1c, f23 

    sf M+0x20, f24
    sf M+0x24, f25
    sf M+0x28, f26
    sf M+0x2c, f27

    sf M+0x30, f13
    sf M+0x34, f28
    sf M+0x38, f29 
    sf M+0x3c, f30


    ; Ya no necesitamos tener cargados los valores de a1-a4 en registros asique ya lo podemos usar para nuestros cálculos
    ; Lo mismo nos ocurre con las matrices MF calculadas anteriormente
    ; Calcular VM
    multf f1, f12, f20 ; VM1 = f1
    multf f2, f17, f21 ; VM2 = f2
    multf f3, f18, f22 ; VM3 = f3
    multf f4, f19, f23 ; VM4 = f4

    sf VM, f1
    sf VM+0x4, f2 
    sf VM+0x8, f3 
    sf VM+0xc, f4 


    ; Calcular HM
    multf f5, f24, f13 ; HM1 = f5
    multf f6, f25, f28 ; HM2 = f6
    multf f7, f26, f29 ; HM3 = f7
    multf f8, f27, f30 ; HM4 = f8

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
		
