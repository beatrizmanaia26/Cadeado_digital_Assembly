; --- Mapeamento de Hardware (8051) ---
          RS      equ     P1.3    ;Reg Select ligado em P1.3
          EN      equ     P1.2    ;Enable ligado em P1.2
       
      org 0000h

      ;SENHA INICIAL ;colocamos como "senha de fabrica" 1111 na memoria, do endereço 30 ao 33
 MOV 30H, #1
 MOV 31H, #1
 MOV 32H, #1
 MOV 33H, #1

      ;MAPEAMENTO DAS TECLAS
MOV 40H, #'#' 
 MOV 41H, #'0'
 MOV 42H, #'*'
 MOV 43H, #'9'
 MOV 44H, #'8'
 MOV 45H, #'7'
 MOV 46H, #'6'
 MOV 47H, #'5'
 MOV 48H, #'4'
 MOV 49H, #'3'
 MOV 4AH, #'2'
 MOV 4BH, #'1'	
       LJMP MAIN
      ;o que aparece no display da tela inicial para pessoa digitar a senha e aparecer nos __
      ESPACOSENHA:
        DB "____";senha com 4 digitos
        DB 00h ;declara string, ler ate final
      BLOQUEADO:
        DB "Bloqueado!"
        DB 00h
      SENHA_INCORRETA:
        DB "Senha Incorreta!"
        DB 00H
      SENHA_INCORRETA2:
        DB "XXXX"
        DB 00H
      MUDAR_SENHA:
        DB "1-Mudar Senha"
        DB 00H
      NOVA_SENHA:
        DB "Nova Senha"
        DB 00H
      SENHASALVA:
        DB "Senha Salva"
        DB 00H
      SAIR:
        DB "2-Sair"
        DB 00H
      TCHAU:
        DB "Tchau =)"
        DB 00H
       ;tiramos jmp main daqui pq falavamos q comecava no 80h e escreviamos mais que 80h
      MAIN:
     ACALL lcd_init ;inicia lcd
  	LCALL TELA_INICIAL ;chama funcao que escreve no display
      ;posiciona novamente no primeiro espaço para a senha
 	MOV A, #06h ;centralizado
 	ACALL posicionaCursor
      ;escrever senha digitada na memoria
    MOV R1, #60H
	MOV R3, #4 ;4 repeticoes pq senha tem 4 digitos
          ESPERA_VE_PRESSIONADO:
			ACALL leituraTeclado
			JNB F0, ESPERA_VE_PRESSIONADO  ;if F0 is clear, jump to ESPERA_VE_PRESSIONADO
        	MOV A, #40h ;salva os
			ADD A, R0
 			MOV R0, A
			MOV A, @R0  
                  
            MOV R7, A ;adiciona valor relacionado ao botao do teclado pressionado, que esta em a, no R7
             MOV R2, #30H ;coloca valor 30 no r2 
             SUBB A, R2 ;subtrai valor de a com 30 que ai da o valor pressionado
             MOV @R1, A ;coloca o resultado de a no endereco de r1 
             INC R1 ;incrementa r1 para ir pro prox endereço da senha guardada
             MOV A, R7      
             
 		   	ACALL sendCharacter 
 			CLR F0
 		DJNZ R3, ESPERA_VE_PRESSIONADO ;DECREMENTA R3 E VOLTA
	;Parte para imitar um enter;(#23H)
		MOV R3, #23H
		ESPERA_VE_PRESSIONADO_ENTER:
            CLR A
 			ACALL leituraTeclado
			JNB F0, ESPERA_VE_PRESSIONADO_ENTER 
         	MOV A, #40h
 			ADD A, R0
 			MOV R0, A
 			MOV A, @R0  
			CLR F0 ;coloca clr f0 para dar certo
            CJNE A, 03H,ESPERA_VE_PRESSIONADO_ENTER
      ;Parte onde comparamos a senha salva com os digitados pelo usuario 
         MOV R3, #4 ;loop 4x
         MOV R0, #30H ;valor 30 para ir ao endereço 30 e comparar
       MOV R1, #60H
              COMPARA:
          MOV A, @R0 ;coloca o endereço 30h no a
          MOV 70H,@R1
         CJNE A, 70H, ERRADO;DIFERENTE PULA
          INC R0 ;incrementa r0 para comparar o proximo valor da senha
         INC R1  ;incrementa r1 para comparar o prox valor da senha com valor digitado pelo user
         DJNZ R3, COMPARA ;LOOP 4X 
      ;"Menu"
 			SETB P3.1 ; Gira motor no sentido horário se a pessoaa acerta a senha
 			CLR P3.0
	MENU:
 	LCALL TELA_MENU
     MOV R3, #31H
     MOV R4, #32H  
      	 ESPERA_VE_PRESSIONADO2:
            CLR A
 			ACALL leituraTeclado
			JNB F0, ESPERA_VE_PRESSIONADO2  ;if F0 is clear, jump to ROTINA	
         	MOV A, #40h
 			ADD A, R0
 			MOV R0, A
 			MOV A, @R0  
             CJNE A, 03H,COMPARANDO2
                  ;SE O USUARIO DIGITOU 1
             LCALL TELA_MUDARSENHA
             CLR F0
                  ;posiciona novamente no primeiro espaço para a nova senha
			    MOV A, #45h ;centralizado
 			   	ACALL posicionaCursor
                  ;LOOP para guardar senha nova
             MOV R1, #50H ;onde vai guardar senha nova
			      MOV R2, #4;4 repeticoes pq senha tem 4 digitos 
                   ;le valor que pessoa digitou para guardar na memoria
           			ESPERA_VE_PRESSIONADO_MENU1:
 								ACALL leituraTeclado
 								JNB F0, ESPERA_VE_PRESSIONADO_MENU1  ;if F0 is clear, jump to ROTINA	
 								MOV A, #40h
 								ADD A, R0
								MOV R0, A
 								MOV A, @R0        
 							 ;contas para guardar valor digitado no teclado (armazenado em A) na memoria 
                	 MOV R6, A
                	 MOV R3, #30H
                	 SUBB A,R3
                	 MOV @R1, A
                	 INC R1
               	 MOV A,R6
						   ACALL sendCharacter
							CLR F0
					  DJNZ R2, ESPERA_VE_PRESSIONADO_MENU1 ;loop, decrementa R2 para rodar 4x
             ;espera pessoa clicar no # (23h) para sobreescrever senha antiga pela nova
             MOV R3, #23H
             ESPERA_VE_PRESSIONADO_ENTER2:
                CLR A
 		       	ACALL leituraTeclado
				JNB F0, ESPERA_VE_PRESSIONADO_ENTER2
         		MOV A, #40h
 				ADD A, R0
 				MOV R0, A
 				MOV A, @R0  
					CLR F0 ;coloca clr f0 para dar certo
           			CJNE A, 03H,ESPERA_VE_PRESSIONADO_ENTER2
                ;se termos do cjne tiver igual, faz o que ta aqui (passa senha nova pro endereço da antiga
                ;sobreescrevendo a antiga pela nova
                CLR A
                MOV R0, #30H
                MOV R1, #50H
                MOV R5, #4
                MUDAR_SENHA_DE_ENDERECO:
                    MOV A, @R1; coloca o que ta no endereço do R1 pro A
                    MOV @R0, A ;passa o que ta no a para o que ta no endereço de R1
                    INC R0
                    INC R1
                DJNZ R5, MUDAR_SENHA_DE_ENDERECO

            LCALL TELA_SENHASALVA
            JMP MENU
       
 	JMP MAIN

	 ERRADO:
      	;MENSAGEM DE SENHA ERRADA NO LCD E VOLTA PRO INICIO
    LCALL TELA_ERRO
    MOV R5, #02H
    LJMP MAIN
       
      COMPARANDO2:;AQUI É SE O NUMERO NÃO FOR UM
 	CJNE A, 04H, ESPERA_VE_PRESSIONADO2
      ;SE VIER PRA CA, QUER DIZER QUE O USUARIO DIGITOU 2
         ;gira motor para sentido anti-horario "fechando" cadeado
 	     SETB P3.0
			CLR P3.1
    LCALL clearDisplay
    MOV A, #03h ;centraliza
          ; Espera por um sinal de rotação completa no pino P3.2
      EsperaRotacaoAnti: 
     JNB P3.2, EsperaRotacaoAnti ; Continua no loop enquanto P3.2 for 0 (espera o sinal do sensor)
      ; Parar o motor após uma rotação completa
     CLR P3.0  
          
 	ACALL posicionaCursor 
	MOV DPTR,#TCHAU ;chama o que será escrito
 	ACALL escreveStringROM
 	CALL delay
    LCALL clearDisplay
    CLR F0;NECESSARIO, POIS NESSE CASO NÃO VOLTA PARA MAIN
	LJMP MAIN
       
      ;telas
;tela de erro tem que ta no comeco se nao nao da para ser chamada

      TELA_SENHASALVA:
      	 LCALL clearDisplay
          MOV A, #02h ;centraliza
         ACALL posicionaCursor
         MOV DPTR, #SENHASALVA
         ACALL escreveStringROM
         LCALL clearDisplay
         RET
       
      TELA_MUDARSENHA:
      	;escreve no display
 	 LCALL clearDisplay
     MOV A, #03h ;centraliza
 	 ACALL posicionaCursor
   MOV DPTR, #NOVA_SENHA
  ACALL escreveStringROM
   MOV A, #45h ;posiciona para a linha seguinte
   ACALL posicionaCursor ;chama cursor para comecar a escrever no endereço 43h
   MOV DPTR,#ESPACOSENHA 
    ACALL escreveStringROM ;escreve o que ta no BLOQUEADO
    RET
       
      TELA_INICIAL:
	MOV A, #06h ;centraliza
 	ACALL posicionaCursor 
 	MOV DPTR,#ESPACOSENHA ;chama o que será escrito
 	ACALL escreveStringROM
 	MOV A, #43h ;posiciona para a linha seguinte
         ACALL posicionaCursor ;chama cursor para comecar a escrever no endereço 43h
 	MOV DPTR,#BLOQUEADO 
        ACALL escreveStringROM ;escreve o que ta no BLOQUEADO
	RET
       
      TELA_ERRO:
    MOV A, #06h ;centraliza
 	ACALL posicionaCursor 
 	MOV DPTR,#SENHA_INCORRETA2 ;chama o que será escrito
	ACALL escreveStringROM
  	MOV A, #40h ;posiciona para a linha seguinte
     ACALL posicionaCursor ;chama cursor para comecar a escrever no endereço 43h
 	MOV DPTR,#SENHA_INCORRETA
     ACALL escreveStringROM 
 	CALL delay
    LCALL clearDisplay
 	RET
       
      TELA_MENU:
 	LCALL clearDisplay
       
         ;quando entra no menu para de rodar motor
      ; Espera por um sinal de rotação completa no pino P3.2
      EsperaRotacao:
     JNB P3.2,EsperaRotacao ; Espera até que sensor no pino P3.2 indique a rotação completa
         ; Parar o motor
	CLR P3.1  
       
 	MOV A, #00h ;centraliza
 	ACALL posicionaCursor 
 	MOV DPTR,#MUDAR_SENHA ;chama o que será escrito
 	ACALL escreveStringROM
  	MOV A, #40h ;posiciona para a linha seguinte
     ACALL posicionaCursor ;chama cursor para comecar a escrever no endereço 43h
 	MOV DPTR,#SAIR
     ACALL escreveStringROM ;escreve o que ta no BLOQUEADO
 	RET
       
      leituraTeclado:
 	MOV R0, #0		
 	MOV P0, #0FFh	
 	CLR P0.0			; clear row0
 	CALL colScan		; call column-scan subroutine
	JB F0, finish2		; | if F0 is set, jump to end of program 		; | (because the pressed key was found and its number is in  R0)
      	; scan row1
 	SETB P0.0			; set row0
 	CLR P0.1			; clear row1
 	CALL colScan		; call column-scan subroutine
 	JB F0, finish2		; | if F0 is set, jump to end of program 						; | (because the pressed key was found and its number is in  R0)
      	; scan row2
 	SETB P0.1			; set row1
 	CLR P0.2			; clear row2
 	CALL colScan		; call column-scan subroutine
 	JB F0, finish2		; | if F0 is set, jump to end of program 				; | (because the pressed key was found and its number is in  R0)
      	; scan row3
 	SETB P0.2			; set row2
 	CLR P0.3			; clear row3
 	CALL colScan		; call column-scan subroutine
	JB F0, finish2		; | if F0 is set, jump to end of program 
      						; | (because the pressed key was found and its number is in  R0)
      finish2:
 	RET
       
      ; column-scan subroutine
      colScan:
	JNB P0.4, gotKey	; if col0 is cleared - key found
 	INC R0				; otherwise move to next key
	JNB P0.5, gotKey	; if col1 is cleared - key found
 	INC R0				; otherwise move to next key
 	JNB P0.6, gotKey	; if col2 is cleared - key found
 	INC R0				; otherwise move to next key
 	RET					; return from subroutine - key not found
      gotKey:
	SETB F0				; key found - set F0
	RET					; and return from subroutine
       
      escreveStringROM:
  MOV R1, #00h
      	; Inicia a escrita da String no Display LCD
      loop:
   MOV A, R1
 	MOVC A,@A+DPTR 	 ;lê da memória de programa
 	JZ finish		; if A is 0, then end of data has been reached - jump out of loop
	ACALL sendCharacter	; send data in A to LCD module
	INC R1			; point to next piece of data
    MOV A, R1
	JMP loop		; repeat
      finish:
 	RET
      	
      lcd_init:
 	CLR RS		
       
      ; function set	
 	CLR P1.7		; |
	CLR P1.6		; |
 	SETB P1.5		; |
 	CLR P1.4		; | high nibble set
       
 	SETB EN		; |
 	CLR EN		; | negative edge on E
       
 	CALL delay		; wait for BF to clear	
      					; function set sent for first time - tells module to go into 4-bit mode
      ; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.
       
 	SETB EN		; |
 	CLR EN		; | negative edge on E
      					; same function set high nibble sent a second time
       
	SETB P1.7		; low nibble set (only P1.7 needed to be changed)
       
 	SETB EN		; |
	CLR EN		; | negative edge on E
      				; function set low nibble sent
 	CALL delay		; wait for BF to clear
       
       
      ; entry mode set
      ; set to increment with no shift
 	CLR P1.7		; |
 	CLR P1.6		; |
 	CLR P1.5		; |
 	CLR P1.4		; | high nibble set
       
	SETB EN		; |
	CLR EN		; | negative edge on E
       
 	SETB P1.6		; |
	SETB P1.5		; |low nibble set
       
	SETB EN		; |
 	CLR EN		; | negative edge on E
       
 	CALL delay		; wait for BF to clear
       
       
      ; display on/off control
      ; the display is turned on, the cursor is turned on and blinking is turned on
	CLR P1.7		; |
 	CLR P1.6		; |
 	CLR P1.5		; |
	CLR P1.4		; | high nibble set
      
 	SETB EN		; |
 	CLR EN		; | negative edge on E
       
 	SETB P1.7		; |
 	SETB P1.6		; |
 	SETB P1.5		; |
 	SETB P1.4		; | low nibble set
       
 	SETB EN		; |
 	CLR EN		; | negative edge on E
       
 	CALL delay		; wait for BF to clear
 	RET
       
       
      sendCharacter:
 	SETB RS  		; setb RS - indicates that data is being sent to module
 	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
 	MOV P1.6, C			; |
 	MOV C, ACC.5		; |
 	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set
       
	SETB EN			; |
	CLR EN			; | negative edge on E
       
	MOV C, ACC.3		; |
	MOV P1.7, C			; |
 	MOV C, ACC.2		; |
 	MOV P1.6, C			; |
 	MOV C, ACC.1		; |
 	MOV P1.5, C			; |
 	MOV C, ACC.0		; |
 	MOV P1.4, C			; | low nibble set
       
 	SETB EN			; |
 	CLR EN			; | negative edge on E
       
 	CALL delay			; wait for BF to clear
 	CALL delay			; wait for BF to clear
 	RET
       
      ;Posiciona o cursor na linha e coluna desejada.
      ;Escreva no Acumulador o valor de endereço da linha e coluna.
      ;|--------------------------------------------------------------------------------------|
      ;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
      ;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
      ;|--------------------------------------------------------------------------------------|
      posicionaCursor:
 	CLR RS	
 	SETB P1.7		    ; |
 	MOV C, ACC.6		; |
 	MOV P1.6, C			; |
 	MOV C, ACC.5		; |
 	MOV P1.5, C			; |
 	MOV C, ACC.4		; |
 	MOV P1.4, C			; | high nibble set
       
 	SETB EN			; |
 	CLR EN			; | negative edge on E
       
 	MOV C, ACC.3		; |
	MOV P1.7, C			; |
 	MOV C, ACC.2		; |
 	MOV P1.6, C			; |
 	MOV C, ACC.1		; |
 	MOV P1.5, C			; |
 	MOV C, ACC.0		; |
 	MOV P1.4, C			; | low nibble set
       
 	SETB EN			; |
 	CLR EN			; | negative edge on E
       
 	CALL delay			; wait for BF to clear
 	CALL delay			; wait for BF to clear
 	RET
       
       
      ;Retorna o cursor para primeira posição sem limpar o display
      retornaCursor:
 	CLR RS	
 	CLR P1.7		; |
 	CLR P1.6		; |
 	CLR P1.5		; |
 	CLR P1.4		; | high nibble set
       
 	SETB EN		; |
 	CLR EN		; | negative edge on E
       
	CLR P1.7		; |
	CLR P1.6		; |
 	SETB P1.5		; |
 	SETB P1.4		; | low nibble set
       
 	SETB EN		; |
 	CLR EN		; | negative edge on E
       
 	CALL delay		; wait for BF to clear
 	RET
       
       
      ;Limpa o display
      clearDisplay:
 	CLR RS	
 	CLR P1.7		; |
 	CLR P1.6		; |
 	CLR P1.5		; |
 	CLR P1.4		; | high nibble set
       
 	SETB EN		; |
 	CLR EN		; | negative edge on E
       
 	CLR P1.7		; |
 	CLR P1.6		; |
 	CLR P1.5		; |
 	SETB P1.4		; | low nibble set
       
 	SETB EN		; |
 	CLR EN		; | negative edge on E
       
 	MOV R6, #20
      	rotC:
 	CALL delay		; wait for BF to clear
 	DJNZ R6, rotC
 	RET
       
      delay:
 	MOV R0, #50
 	DJNZ R0, $
 	RET