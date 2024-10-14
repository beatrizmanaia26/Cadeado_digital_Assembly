      ; --- Mapeamento de Hardware (8051) ---
          RS      equ     P1.3    ;Reg Select ligado em P1.3
          EN      equ     P1.2    ;Enable ligado em P1.2
       
      org 0000h
0000| LJMP MAIN
       
      ;o que aparece no display da tela inicial para pessoa digitar a senha e aparecer nos ____
      ESPACOSENHA:
        DB "____";senha com 4 digitos
        DB 00h ;declara string, ler ate final
      BLOQUEADO:
        DB "Bloqueado!"
        DB 00h
       
      org 0080h;espaço pra interrupção
      MAIN:
      ;SENHA INICIAL ;colocamos como "senha de fabrica" 1111 na memoria, do endereço 30 ao 33
0080|     MOV 30H, #1
0083|     MOV 31H, #1
0086|     MOV 32H, #1
0089|     MOV 33H, #1
       
      ;MAPEAMENTO DAS TECLAS
008C| 	MOV 40H, #'#' 
008F| 	MOV 41H, #'0'
0092| 	MOV 42H, #'*'
0095| 	MOV 43H, #'9'
0098| 	MOV 44H, #'8'
009B| 	MOV 45H, #'7'
009E| 	MOV 46H, #'6'
00A1| 	MOV 47H, #'5'
00A4| 	MOV 48H, #'4'
00A7| 	MOV 49H, #'3'
00AA| 	MOV 4AH, #'2'
00AD| 	MOV 4BH, #'1'	  
       
00B0|    ACALL lcd_init ;inicia lcd
00B2| 	LCALL TELA_INICIAL ;chama funcao que escreve no display
      ;posiciona novamente no primeiro espaço para a senha
00B5| 		MOV A, #06h ;centralizado
00B7| 		ACALL posicionaCursor
00B9| 		MOV R3, #4 ;4 repeticoes pq senha tem 4 digitos
           ESPERA_VE_PRESSIONADO:
00BB| 			ACALL leituraTeclado
00BD| 			JNB F0, ESPERA_VE_PRESSIONADO  ;if F0 is clear, jump to ROTINA	
00C0| 			MOV A, #40h
00C2| 			ADD A, R0
00C3| 			MOV R0, A
00C4| 			MOV A, @R0        
00C5| 			ACALL sendCharacter
00C7| 			CLR F0
00C9| 		DJNZ R3, ESPERA_VE_PRESSIONADO ;DECREMENTA R0 E VOLTA
00CB| 	JMP MAIN
       
      TELA_INICIAL:
00CD| 	MOV A, #06h ;centraliza
00CF| 	ACALL posicionaCursor 
00D1| 	MOV DPTR,#ESPACOSENHA ;chama o que será escrito
00D4| 	ACALL escreveStringROM
00D6| 	MOV A, #43h ;posiciona para a linha seguinte
00D8|         ACALL posicionaCursor ;chama cursor para comecar a escrever no endereço 43h
00DA| 	MOV DPTR,#BLOQUEADO 
00DD|         ACALL escreveStringROM ;escreve o que ta no BLOQUEADO
00DF| 	RET
       
      leituraTeclado:
00E0| 	MOV R0, #0		
00E2| 	MOV P0, #0FFh	
00E5| 	CLR P0.0			; clear row0
00E7| 	CALL colScan		; call column-scan subroutine
00E9| 	JB F0, finish2		; | if F0 is set, jump to end of program 		; | (because the pressed key was found and its number is in  R0)
      	; scan row1
00EC| 	SETB P0.0			; set row0
00EE| 	CLR P0.1			; clear row1
00F0| 	CALL colScan		; call column-scan subroutine
00F2| 	JB F0, finish2		; | if F0 is set, jump to end of program 						; | (because the pressed key was found and its number is in  R0)
      	; scan row2
00F5| 	SETB P0.1			; set row1
00F7| 	CLR P0.2			; clear row2
00F9| 	CALL colScan		; call column-scan subroutine
00FB| 	JB F0, finish2		; | if F0 is set, jump to end of program 				; | (because the pressed key was found and its number is in  R0)
      	; scan row3
00FE| 	SETB P0.2			; set row2
0100| 	CLR P0.3			; clear row3
0102| 	CALL colScan		; call column-scan subroutine
0104| 	JB F0, finish2		; | if F0 is set, jump to end of program 
      						; | (because the pressed key was found and its number is in  R0)
      finish2:
0107| 	RET
       
      ; column-scan subroutine
      colScan:
0108| 	JNB P0.4, gotKey	; if col0 is cleared - key found
010B| 	INC R0				; otherwise move to next key
010C| 	JNB P0.5, gotKey	; if col1 is cleared - key found
010F| 	INC R0				; otherwise move to next key
0110| 	JNB P0.6, gotKey	; if col2 is cleared - key found
0113| 	INC R0				; otherwise move to next key
0114| 	RET					; return from subroutine - key not found
      gotKey:
0115| 	SETB F0				; key found - set F0
0117| 	RET					; and return from subroutine
       
      escreveStringROM:
0118|   MOV R1, #00h
      	; Inicia a escrita da String no Display LCD
      loop:
011A|   MOV A, R1
011B| 	MOVC A,@A+DPTR 	 ;lê da memória de programa
011C| 	JZ finish		; if A is 0, then end of data has been reached - jump out of loop
011E| 	ACALL sendCharacter	; send data in A to LCD module
0120| 	INC R1			; point to next piece of data
0121|    MOV A, R1
0122| 	JMP loop		; repeat
      finish:
0124| 	RET
      	
      lcd_init:
0125| 	CLR RS		
       
      ; function set	
0127| 	CLR P1.7		; |
0129| 	CLR P1.6		; |
012B| 	SETB P1.5		; |
012D| 	CLR P1.4		; | high nibble set
       
012F| 	SETB EN		; |
0131| 	CLR EN		; | negative edge on E
       
0133| 	CALL delay		; wait for BF to clear	
      					; function set sent for first time - tells module to go into 4-bit mode
      ; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.
       
0135| 	SETB EN		; |
0137| 	CLR EN		; | negative edge on E
      					; same function set high nibble sent a second time
       
0139| 	SETB P1.7		; low nibble set (only P1.7 needed to be changed)
       
013B| 	SETB EN		; |
013D| 	CLR EN		; | negative edge on E
      				; function set low nibble sent
013F| 	CALL delay		; wait for BF to clear
       
       
      ; entry mode set
      ; set to increment with no shift
0141| 	CLR P1.7		; |
0143| 	CLR P1.6		; |
0145| 	CLR P1.5		; |
0147| 	CLR P1.4		; | high nibble set
       
0149| 	SETB EN		; |
014B| 	CLR EN		; | negative edge on E
       
014D| 	SETB P1.6		; |
014F| 	SETB P1.5		; |low nibble set
       
0151| 	SETB EN		; |
0153| 	CLR EN		; | negative edge on E
       
0155| 	CALL delay		; wait for BF to clear
       
       
      ; display on/off control
      ; the display is turned on, the cursor is turned on and blinking is turned on
0157| 	CLR P1.7		; |
0159| 	CLR P1.6		; |
015B| 	CLR P1.5		; |
015D| 	CLR P1.4		; | high nibble set
       
015F| 	SETB EN		; |
0161| 	CLR EN		; | negative edge on E
       
0163| 	SETB P1.7		; |
0165| 	SETB P1.6		; |
0167| 	SETB P1.5		; |
0169| 	SETB P1.4		; | low nibble set
       
016B| 	SETB EN		; |
016D| 	CLR EN		; | negative edge on E
       
016F| 	CALL delay		; wait for BF to clear
0171| 	RET
       
       
      sendCharacter:
0172| 	SETB RS  		; setb RS - indicates that data is being sent to module
0174| 	MOV C, ACC.7		; |
0176| 	MOV P1.7, C			; |
0178| 	MOV C, ACC.6		; |
017A| 	MOV P1.6, C			; |
017C| 	MOV C, ACC.5		; |
017E| 	MOV P1.5, C			; |
0180| 	MOV C, ACC.4		; |
0182| 	MOV P1.4, C			; | high nibble set
       
0184| 	SETB EN			; |
0186| 	CLR EN			; | negative edge on E
       
0188| 	MOV C, ACC.3		; |
018A| 	MOV P1.7, C			; |
018C| 	MOV C, ACC.2		; |
018E| 	MOV P1.6, C			; |
0190| 	MOV C, ACC.1		; |
0192| 	MOV P1.5, C			; |
0194| 	MOV C, ACC.0		; |
0196| 	MOV P1.4, C			; | low nibble set
       
0198| 	SETB EN			; |
019A| 	CLR EN			; | negative edge on E
       
019C| 	CALL delay			; wait for BF to clear
019E| 	CALL delay			; wait for BF to clear
01A0| 	RET
       
      ;Posiciona o cursor na linha e coluna desejada.
      ;Escreva no Acumulador o valor de endereço da linha e coluna.
      ;|--------------------------------------------------------------------------------------|
      ;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
      ;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
      ;|--------------------------------------------------------------------------------------|
      posicionaCursor:
01A1| 	CLR RS	
01A3| 	SETB P1.7		    ; |
01A5| 	MOV C, ACC.6		; |
01A7| 	MOV P1.6, C			; |
01A9| 	MOV C, ACC.5		; |
01AB| 	MOV P1.5, C			; |
01AD| 	MOV C, ACC.4		; |
01AF| 	MOV P1.4, C			; | high nibble set
       
01B1| 	SETB EN			; |
01B3| 	CLR EN			; | negative edge on E
       
01B5| 	MOV C, ACC.3		; |
01B7| 	MOV P1.7, C			; |
01B9| 	MOV C, ACC.2		; |
01BB| 	MOV P1.6, C			; |
01BD| 	MOV C, ACC.1		; |
01BF| 	MOV P1.5, C			; |
01C1| 	MOV C, ACC.0		; |
01C3| 	MOV P1.4, C			; | low nibble set
       
01C5| 	SETB EN			; |
01C7| 	CLR EN			; | negative edge on E
       
01C9| 	CALL delay			; wait for BF to clear
01CB| 	CALL delay			; wait for BF to clear
01CD| 	RET
       
       
      ;Retorna o cursor para primeira posição sem limpar o display
      retornaCursor:
01CE| 	CLR RS	
01D0| 	CLR P1.7		; |
01D2| 	CLR P1.6		; |
01D4| 	CLR P1.5		; |
01D6| 	CLR P1.4		; | high nibble set
       
01D8| 	SETB EN		; |
01DA| 	CLR EN		; | negative edge on E
       
01DC| 	CLR P1.7		; |
01DE| 	CLR P1.6		; |
01E0| 	SETB P1.5		; |
01E2| 	SETB P1.4		; | low nibble set
       
01E4| 	SETB EN		; |
01E6| 	CLR EN		; | negative edge on E
       
01E8| 	CALL delay		; wait for BF to clear
01EA| 	RET
       
       
      ;Limpa o display
      clearDisplay:
01EB| 	CLR RS	
01ED| 	CLR P1.7		; |
01EF| 	CLR P1.6		; |
01F1| 	CLR P1.5		; |
01F3| 	CLR P1.4		; | high nibble set
       
01F5| 	SETB EN		; |
01F7| 	CLR EN		; | negative edge on E
       
01F9| 	CLR P1.7		; |
01FB| 	CLR P1.6		; |
01FD| 	CLR P1.5		; |
01FF| 	SETB P1.4		; | low nibble set
       
0201| 	SETB EN		; |
0203| 	CLR EN		; | negative edge on E
       
0205| 	MOV R6, #40
      	rotC:
0207| 	CALL delay		; wait for BF to clear
0209| 	DJNZ R6, rotC
020B| 	RET
       
       
      delay:
020C| 	MOV R0, #50
020E| 	DJNZ R0, $
0210| 	RET
