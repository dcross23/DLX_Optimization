
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
    lf f2, a2         ; f2 = a2
    lf f1, a1         ; f1 = a1
    eqf f2, f0        ; Comprobación de no división entre 0           
    bfpt endProgram

    divf f6, f1, f2      ; f6 = f1/f2             ->         x2 = a1/a2 = f6    <---- x2
    lf f3, a3

    lf f4, a4
    multf f10, f2, f3    ; f10 = f2/f3            ->         x6 = a2/a3 = f10   <---- x6

    eqf f4, f0        ; Comprobación de no división entre 0  
    bfpt endProgram
    
    multf f12, f2, f10   ; f12 = f2 * f10 = a2*x6
    addf f11, f1, f4     ; f11 = f1 + f4 = a1 + a4
    multf f5, f1, f3     ; f5 = f1*f3             ->         x1 = a1*a3 = f5    <---- x1
    
    subf f12, f12, f2    ; f12 = f12 - f2 = a2*x6 - a2 = |MF(a2,a3)|


    eqf f12, f0        ; Comprobación de no división entre 0  
    bfpt endProgram
    divf f11, f11, f12  ; f11 = f11/f12 = (a1+a4)/(a2*x6 - a2)  ->   y = f11    <----  y

    multf f8, f2, f4     ; f8 = f2*f4             ->         x4 = a2*a4 = f8    <---- x4

    multf f27, f1, f2   ; f27 = f1 * f2 = a1 * a2 (para el calculo M34)

    multf f9, f6, f3     ; f9 = f6*f3             ->         x5 = x2*a3 = f9    <---- x5  

    eqf f3, f0        ; Comprobación de no división entre 0 (aunque esta división no se va a realizar)
    bfpt endProgram

    multf f12, f5, f11  ; f12 = f5*f11            ->          z1 = x1*y = f12   <---- z1 
    multf f13, f8, f11  ; f13 = f8*f11            ->          z2 = x4*y = f13   <---- z2 
    multf f14, f1, f11  ; f14 = f1*f11            ->          z3 = a1*y = f14   <---- z3 
    multf f16, f4, f11  ; f16 = f4*f11            ->          z5 = a4*y = f16   <---- z5 
    
    divf f7, f3, f4      ; f7 = f3/f4             ->          x3 = a3/a4 = f7   <---- x3 

                          ; M11 = f12 = z1
    multf f18, f9, f11    ; M13 = f18 = x5 * y

    multf f20, f14, f4    ; M21 = f20 = z3 * a4
    multf f22, f6, f16    ; M23 = f22 = x2 * z5
    multf f21, f12, f4    ; M22 = f21 = z1 * a4

    sf M, f12       ; guardar M11 = f12 = z1
    sf M+0x10, f20  ; guardar M21

    multf f15, f7, f11  ; f15 = f4*f11            ->          z4 = x3*y = f15   <---- z4
    sf M+0x8, f18   ; guardar M13
    sf M+0x14, f21  ; guardar M22

    multf f23, f9, f16    ; M24 = f23 = x5 * z5

    multf f19, f6, f15    ; M14 = f19 = x2 * z4
    sf M+0x1c, f23  ; guardar M24

    multf f17, f15, f1    ; M12 = f17 = z4 * a1
    sf M+0xc, f19   ; guardar M14
    sf M+0x18, f22  ; guardar M23

    multf f24, f10, f11   ; M31 = f24 = x6 * y
    sf M+0x4, f17   ; guardar M12

    multf f25, f2, f15    ; M32 = f25 = a2 * z4
    sf M+0x20, f24  ; guardar M31

    multf f26, f12, f2    ; M33 = f26 = z1 * a2
    sf M+0x24, f25  ; guardar M32

    ; Antes calculamos f27 = f1*f2 = a1*a2
    multf f27, f27, f15   ; M34 = f27 = (a1*a2) * z4
    sf M+0x28, f26  ; guardar M33

                          ; M41 = f13
    multf f28, f13, f3    ; M42 = f28 = z2 * a3
    sf M+0x2c, f27  ; guardar M32

    multf f30, f12, f8    ; M44 = f30 = z1 * x4
    sf M+0x30, f13  ; guardar M41
    sf M+0x34, f28  ; guardar M42

    multf f29, f13, f1    ; M43 = f29 = z2 * a1
    sf M+0x3c, f30  ; guardar M44



    multf f1, f12, f20 ; VM1 = f1 = M11 * M21
    sf M+0x38, f29  ; guardar M43

    multf f2, f17, f21 ; VM2 = f2 = M12 * M22
    sf VM, f1       ; guardar VM1

    multf f3, f18, f22 ; VM3 = f3 = M13 * M23
    sf VM+0x4, f2   ; guardar VM2
    addf f1, f1, f2 ; f1 = f1 + f2  ->  check = VM1 + VM2

    multf f4, f19, f23 ; VM4 = f4 = M14 * M24
    sf VM+0x8, f3   ; guardar VM3 
    addf f1, f1, f3 ; f1 = f1 + f3  ->  check = check + VM3


    multf f5, f24, f13 ; HM1 = f5 = M31 * M41
    addf f1, f1, f4 ; f1 = f1 + f4  ->  check = check + VM4

    multf f6, f25, f28 ; HM2 = f6 = M32 * M42
    sf HM, f5       ; guardar HM1 
    addf f1, f1, f5 ; f1 = f1 + f5  ->  check = check + HM1 

    multf f8, f27, f30 ; HM4 = f8 = M34 * M44
    addf f1, f1, f6 ; f1 = f1 + f6  ->  check = check + HM2 

    multf f7, f26, f29 ; HM3 = f7 = M33 * M43
    sf VM+0xc, f4   ; guardar VM4
    sf HM+0x4, f6   ; guardar HM3 
    sf HM+0xc, f8   ; guardar HM4  
    addf f1, f1, f8 ; f1 = f1 + f8  ->  check = check + HM4 

    sf HM+0x8, f7   ; guardar HM3  
    addf f1, f1, f7 ; f1 = f1 + f7  ->  check = check + HM3 

    sf check, f1   ; guardar check  

endProgram:
	trap 0    ; Finaliza la ejecución
		
