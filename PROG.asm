;										UNIVERSIDADE FEDERAL DO RIO GRANDE DO SUL
;								 Arquitetura e Organização de Computadores I 
;											     Processador Intel (80x86)
;											 Gustavo Sartori - 231234	
;                   A parte dos calculos e do programa propriamente dito nao estava montado no masm entao decedi deixar fora desta primeira entrega
;                   Para a recuperação entregarei o programa completo, por enquanto estou apenas validando a linha de comando 
	.model		small
	.stack

CR					equ		0dh
LF					equ		0ah 

	.data	
;variavel de chamada
CMDLINE  		db      256 dup (?)
varteste        db      256 dup (?)
FstChamada      db      256 dup (?)
varteste2       db      0
TamCMDLINE      dw      0
VParamString    db		10 dup (?)
VParamStringP   dw		0
TamanhoSN		dw		0
VParamInt		dw		0
OutPadrao		db		"a.out", 0      ;saida padrao quando -o nao for informado
InPadrao        db      "a.in", 0       ;entrada padrao quando o -i nao for informado
TensaoPadrao    db      "127",0         ;tensao padrao quando nao tiver -v


;variaveis de arquivos
FileNameSRC		db		256 dup (?)		; Nome do arquivo a ser lido
FileNameSRCptr1 dw      0               ;ponteiro do inicio do nome do arquivo de origem
FileNameDSTptr1 dw      0               ;ponteiro do inicio do nome do arquivo de destino
TamanhoNomeSrc  dw      0               ;tamanho do nome do arquivo de origem
TamanhoNomeDST  dw      0               ;tamanho do nome do arquivo de origem
FileNameDST		db		256 dup (?)		; Nome do arquivo a ser escrito
FileBuffer  	db		10 dup (?)		; Buffer de leitura do arquivo
FileHandleSRC	dw		0				; Handler do arquivo de origem
FileHandleDST	dw		0				; Handler do arquivo de destino
FileNameBuffer	db		150 dup (?)
FileBufferDst   dw      256 dup (?)      ;usado para escrever no arquivo
ptrFile			dw		0				 ;ponteiro para definir a partir de qual byte sera a leitura
CountLinha		dw		0				 ;conta a linha de leitura do arquivo
CountCR			dw		0				 ;numero de CR no arquivo
CountLF			dw		0				 ;numero de LF no arquivo
NumLinhas		dw		1				 ;numero total de linhas no 
AchouLF			db		0				 ;flag para contar as linhas
T1_Buffer		db		1000 dup(0)	
zero1			db		0
T2_Buffer		db		1000 dup(0)
zero2			db		0
T3_Buffer		db		1000 dup(0)
zero3			db		0
T1_Pointer		dw		0
T2_Pointer		dw		0
T3_Pointer		dw		0
T1_int			dw		0
T2_int			dw		0
T3_int			dw 		0
T1Flag			db		1
T2Flag			db		0
T3Flag			db		0
Tempo_Ok		dw		0
Tempo_Sem		dw		0
Tempo_total     dw      0
Tempo_Ok_s		dw		0
Tempo_Sem_s		dw		0
Tempo_total_s   dw      0
Tempo_Ok_m		dw		0
Tempo_Sem_m		dw		0
Tempo_total_m   dw      0
Tempo_Ok_h		dw		0
Tempo_Sem_h		dw		0
Tempo_total_h   dw      0
IndexString		dw		0
ErrorFlag		dw		0
Mid_numFlag		dw		0
;Mensagens
MsgPedeArquivo		    db	"Nome do arquivo: ", 0
MsgPedeArquivoDst		db	"Nome do arquivo destino: ", 0
MsgErroCreateFile		db	"Erro na criacao do arquivo.", CR, LF, 0
MsgErroWriteFile		db	"Erro na escrita do arquivo.", CR, LF, 0
MsgErroOpenFile		    db	"O arquivo ", 0
MsgErroOpenFile2		db	" nao existe!", 0
MsgErroReadFile		    db	"Erro na leitura do arquivo.", CR, LF, 0
MsgCRLF				    db	 CR, LF, 0
MsgSCC                  db  "Arquivo aberto com sucesso", CR, LF, 0
MsgSCC2                 db  "Arquivo criado com sucesso", CR, LF, 0
MsgIgual			    db	" = ", 0
msgErroCaracter			db  "Foi encontrado um caracter '", 0
msgErroCaracter2        db  "' na linha ", 0
MsgErroLinha    	    db  "Erro na linha :  ",0
MsgInvalido     	    db  "Invalido: ",0
MsgErroParI     	    db  "Opcao [-i] sem parametro", CR, LF, 0  
MsgErroParO     	    db  "Opcao [-o] sem parametro", CR, LF, 0 
MsgErroParV     	    db  "Opcao [-v] sem parametro", CR, LF, 0 
MsgErroValorPar  	    db  "Parametro da opcao [-v] deve ser 127 ou 220", CR, LF, 0 
MSgTAB					db	"  ", 0 
MensagemNomeEntrada		db	 CR, LF,"O nome do arquivo de entrada eh :", CR, LF,0
MensagemNomeSaida		db	 CR, LF,"O nome do arquivo de saida eh :", CR, LF,0
MensagemTensao          db   CR, LF,"A tensao escolhida foi:" ,CR, LF,0
MSG_TEMP_OK				db	  CR, LF,"O tempo com tensao adequada foi de :",0
MSG_TEMP_SEM			db	  CR, LF,"O tempo sem tensao foi de :",0
MSG_TEMP_TOTAL			db	 CR, LF, "O tempo total de medicoes foi de :",0
msgDPontosHoras			db	"  Hora(s)  : ", 0
msgDPontosMinutos		db	"  Minuto(s)  :  ", 0
msgSegundos				db	"  Segundo(s)", 0
MsgSemUmaTensao			db	"Esta faltando uma tensao na linha", CR, LF, 0 
MsgNumbInvalid			db	"  Numero com espaco entre os algarismos", CR, LF, 0 
; Variavel interna usada na rotina printf_w
BufferWRWORD			db		10 dup (?)
BufferWRWORD2			db		10 dup (?)
BufferWRWORD3			db		10 dup (?)
Tempo_ok_string_s		db		20 dup (?)
Tempo_sem_string_s		db		20 dup (?)
Tempo_total_string_s	db		20 dup (?)
Tempo_ok_string_m			db		20 dup (?)
Tempo_sem_string_m		db		20 dup (?)
Tempo_total_string_m		db		20 dup (?)
Tempo_ok_string_h			db		20 dup (?)
Tempo_sem_string_h		db		20 dup (?)
Tempo_total_string_h		db		20 dup (?)
; Variaveis para uso interno na funcao sprintf_w
sw_n	dw	0
sw_f	db	0
sw_m	dw	0






	.code
	.startup



push ds 					; Salva as informações de segmentos
push es
mov ax,ds 					; Troca DS com ES para poder usa o REP MOVSB
mov bx,es
mov ds,bx
mov es,ax
mov si,80h 					; Obtém o tamanho do string da linha de comando e coloca em CX
mov ch,0
mov cl,[si]
mov ax,cx 					; Salva o tamanho do string em AX, para uso futuro
mov si,81h 					; Inicializa o ponteiro de origem
lea di,CMDLINE 				; Inicializa o ponteiro de destino
rep movsb
pop es 						; retorna as informações dos registradores de segmentos
pop ds



mov TamCMDLINE, ax

mov		ax,ds				; Seta ES = DS
mov		es,ax
call	GetVParam


;------------------------------------------
;abre o arquivo
;------------------------------------------
    call	GetFileName                     ;pega o nome do arquivo de origem da string de entrada
	mov		al,0
	lea		dx,FileNameSRC
	mov		ah,3dh
	int		21h
	jnc		sem_erro_abertura
	lea		bx,MsgErroOpenFile              ;imprime a mensagem de erro
	call	printf_s
	lea 	bx, FileNameSRC
	call	printf_s
	lea		bx, MsgErroOpenFile2
	call	printf_s
	mov		al,1
	jmp		TERMINA    
   
sem_erro_abertura:
    mov		FileHandleSRC,ax

;----------------------------------------------
;cria arquivo de destino
;----------------------------------------------
    call 	GetFileNameDst
    lea		dx,FileNameDst
	call	fcreate
	mov		FileHandleDst,bx
	jnc		criou_arquivo
	mov		bx,FileHandleSrc
	call	fclose
	lea		bx, MsgErroCreateFile
	call	printf_s
 



criou_arquivo:




Continue2:

	mov		bx,FileHandleSrc							;PEGA O CARACTERE DO FILEHANDLESRC E CHAMA GETCHAR
	call	getChar
	jnc		Continue3
	lea		bx, MsgErroReadFile
	call	printf_s
	mov		bx,FileHandleSrc
	call	fclose
	mov		bx,FileHandleDst
	call	fclose
	.exit	1

Continue3:

	;	if (AX==0) break;
	cmp		ax,0					;Caso Ax == 0 Termina a leitura e liga a flag LastCharacter
	jz		FIM_ARQ	
	cmp		dl,CR					;Caso seja CR, encerra a linha
	jz		end_Line
	cmp		dl,LF					;Caracter LF aceito
	jz		Continue2
	cmp		dl,20h					;Caracter SPACE aceito e continua a leitura
	jz		TESTA				
	cmp		dl,9h					;Caracter TAB aceito e continua a leitura
	jz		TESTA
	cmp		dl,','					;Caso seja ',' altera a flag da tensao registrada
	jz		Set_NumberFlag			;Verifica se o caracter está no intervalor '0'-'9'
	cmp		dl,'F'
	jz		FIM_ARQ
	cmp		dl,'f'
	jz		FIM_ARQ
	cmp		dl,'0'
	jb		Set_InvalidLineFlag
	cmp		dl,'9'
	ja		Set_InvalidLineFlag			;Caso não esteja altera a flag da linha para inválida
	jmp		Set_Number					;Pula para o armazenamento do caractere número

Set_InvalidLineFlag:
	lea		bx,msgErroCaracter
	call	printf_s
	jmp		end_Line

TESTA:
	cmp		Mid_numFlag,0
	jz		Continue2
	inc		ErrorFlag
	lea		bx,MsgErroLinha
	call	printf_s
	mov		ax,NumLinhas
	call	printf_w
	lea		bx,MsgNumbInvalid
	call	printf_s
	jmp		continue2

	



Set_NumberFlag:
	mov		Mid_numFlag,0
	cmp		T1Flag,1
	jz		setaT2
	cmp		T2Flag,1
	jz		setaT3
	cmp		T3Flag,1
	jz		TERMINA

setaT2:

	mov		T1Flag,0
	mov		T2Flag,1
	jmp		Continue2
setaT3:
	mov		T2Flag,0
	mov		T3Flag,1
	jmp		Continue2	

Set_Number:				
	cmp		T1Flag,1
	jz		Set_T1
	cmp		T2Flag,1
	jz		Set_T2
	cmp		T3Flag,1
	jz		Set_T3
	jmp		ERROLINHA

Set_T1:								;Armazena o caractere na string T1Buffer
	mov		Mid_numFlag,1
	lea		bx,T1_Buffer
	add		bx,T1_Pointer
	mov		byte ptr[bx],dl
	inc		T1_Pointer
	inc		bx
	mov		byte ptr[bx],0h
	jmp		Continue2

Set_T2:								;Armazena o caractere na string T2Buffer
	mov		Mid_numFlag,1
	lea		bx,T2_Buffer
	add		bx,T2_Pointer
	mov		byte ptr[bx],dl
	inc		T2_Pointer
	inc		bx
	mov		byte ptr[bx],0h
	jmp		Continue2

Set_T3:								;Armazena o caractere na string T2Buffer
	mov		Mid_numFlag,1
	lea		bx,T3_Buffer
	add		bx,T3_Pointer
	mov		byte ptr[bx],dl
	inc		T3_Pointer
	inc		bx
	mov		byte ptr[bx],0h
	jmp		Continue2


end_Line:	
	cmp		T3Flag,0
	jz		erro_linha_t3_sem
	call	tranforma_tensao
	inc		NumLinhas
	mov		T2Flag,0
	mov		T3Flag,0				;seta t3flag para 0
	mov		T1Flag,1				;seta T1flag para 1 pois vai começar uma nova linha
	cmp		T1_int,500
	jae 	erro_linha_t1
	cmp		T2_int,500
	jae		erro_linha_t2	
	cmp		T3_int,500
	jae 	erro_linha_t3
	cmp		VParamInt,127
	je		Teste_Qualidade_127
	jmp		Teste_Qualidade_220

Teste_Qualidade_127:
		
	cmp		T1_int,117
	jb		Linha_abaixo
	cmp		T1_int,137
	ja		Linha_acima
	mov		ax, T2_int
	cmp		T2_int,117
	jb		Linha_abaixo
	cmp		T2_int,137
	ja		Linha_acima
	cmp		T3_int,117
	jb		Linha_abaixo
	cmp		T3_int,137
	ja		Linha_acima
    inc     Tempo_total
	inc		Tempo_Ok
	jmp		zeraTensao



Teste_Qualidade_220:
	cmp		T1_int,210
	jb		Linha_abaixo
	cmp		T1_int,230
	ja		Linha_acima
	cmp		T2_int,210
	jb		Linha_abaixo
	cmp		T2_int,230
	ja		Linha_acima
	cmp		T3_int,210
	jb		Linha_abaixo
	cmp		T3_int,230
	ja		Linha_acima
	inc		Tempo_Ok
    inc     Tempo_total
	jmp		zeraTensao


erro_linha_t1:
	inc		ErrorFlag
	lea		bx,MsgErroLinha
	call	printf_s
	mov		ax,NumLinhas
	call	printf_w
	call 	imprimeEspaco
	lea		bx,MsgInvalido
	call	printf_s
	mov		ax,T1_int
	call 	printf_w
	lea		bx,MsgCRLF
	call	printf_s
	jmp		zeraTensao
erro_linha_t2:
	inc		ErrorFlag
	lea		bx,MsgErroLinha
	call	printf_s
	mov		ax,NumLinhas
	call	printf_w
	call 	imprimeEspaco
	lea		bx,MsgInvalido
	call	printf_s
	mov		ax,T2_int
	call 	printf_w
	lea		bx,MsgCRLF
	call	printf_s
	jmp		zeraTensao
erro_linha_t3:
	inc		ErrorFlag
	lea		bx,MsgErroLinha
	call	printf_s
	mov		ax,NumLinhas
	call	printf_w
	call 	imprimeEspaco
	lea		bx,MsgInvalido
	call	printf_s
	mov		ax,T3_int
	call 	printf_w
	lea		bx,MsgCRLF
	call	printf_s
	jmp		zeraTensao	
erro_linha_t3_sem:
	inc		ErrorFlag
	lea		bx,MsgErroLinha
	call	printf_s
	mov		ax,NumLinhas
	call	printf_w
	call 	imprimeEspaco
	lea		bx,MsgInvalido
	call	printf_s
	lea		bx,MsgSemUmaTensao
	call	printf_s
	lea		bx,MsgCRLF
	call	printf_s
	jmp		zeraTensao


ERROLINHA:
	inc		ErrorFlag
	lea		bx,MsgErroLinha
	call	printf_s
	mov		ax,NumLinhas
	call	printf_w
	lea		bx,MsgInvalido
	call	printf_s
	call	printf_w
	call	imprimeEspaco
	jmp		Continue2

zeraTensao:
	mov		T1_Pointer,0
	mov		T2_Pointer,0
	mov		T3_Pointer,0
	mov		T1_int,0
	mov		T2_int,0
	mov		T3_int,0	
	jmp		continue2


Linha_abaixo:
	cmp		T1_int,10
	jae		zeraTensao
	cmp		T2_int,10
	jae		zeraTensao
	cmp		T3_int,10
	jae		zeraTensao
    inc     Tempo_total
	inc		Tempo_Sem
	jmp 	zeraTensao

Linha_acima:
	jmp		zeraTensao


FIM_ARQ:
	cmp		ErrorFlag,1
	jae		TERMINA
	lea		bx,MSG_TEMP_OK
	call	printf_s
	mov		ax,Tempo_ok
	call	converte_tempo_ok
	mov		ax,Tempo_ok_h
	call	printf_w
	lea		bx,msgDPontosHoras
	call	printf_s
	mov		ax,Tempo_ok_m
	call	printf_w
	lea		bx,msgDPontosMinutos
	call	printf_s
	mov		ax,Tempo_ok_s
	call	printf_w
	lea		bx,msgSegundos
	call	printf_s
	lea		bx,MsgCRLF
	call	printf_s
	lea		bx,MSG_TEMP_SEM
	call	printf_s
	mov		ax,Tempo_Sem
	call	converte_tempo_sem	
	mov		ax,Tempo_sem_h
	call	printf_w
	lea		bx,msgDPontosHoras
	call	printf_s	
	mov		ax,Tempo_sem_m
	call	printf_w
	lea		bx,msgDPontosMinutos
	call	printf_s
	mov		ax,Tempo_sem_s
	call	printf_w
	lea		bx,msgSegundos
	call	printf_s
	lea		bx,MsgCRLF
	call	printf_s    
    lea     bx,MSG_TEMP_TOTAL
    call    printf_s
	mov		ax,Tempo_total
	call	converte_tempo_total
	mov		ax,Tempo_total_h
	call	printf_w
	lea 	bx,msgDPontosHoras
	call	printf_s	
	mov		ax,Tempo_Total_m
	call	printf_w
	lea		bx,msgDPontosMinutos
	call	printf_s
	mov		ax,Tempo_Total_s
	call	printf_w
	lea		bx,msgSegundos
	call	printf_s
	lea		bx,MsgCRLF
	call	printf_s  
	lea		bx,MensagemNomeEntrada
	call	printf_s
	lea		bx,FileNameSRC
	call	printf_s
	lea		bx,MsgCRLF
	call	printf_s  
	lea		bx,MensagemNomeSaida
	call	printf_s
	lea		bx,FileNameDST
	call	printf_s
	lea		bx,MsgCRLF
	call	printf_s  
	lea		bx,MensagemTensao
	call	printf_s
	mov		ax,VParamInt
	call	printf_w
	lea		bx,MsgCRLF
	call	printf_s
	


lop1:
	lea		bx,MensagemNomeEntrada
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		Nome_do_arquivo
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop1
Nome_do_arquivo:
	mov		IndexString,0
lop11:
	lea		bx,FileNameSRC
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		Escreve_no_arquivo_nome_saida
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop11	

Escreve_no_arquivo_nome_saida:
	mov		IndexString,0
lop2:
	lea		bx,MensagemNomeSaida
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		Nome_DST
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop2

Nome_DST:
	mov		IndexString,0
lop22:
	lea		bx,FileNameDST
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		Escreve_no_arquivo_tensao
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop22

Escreve_no_arquivo_tensao:
	mov		IndexString,0
lop3:
	lea		bx,MensagemTensao
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_tensao
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop3

valor_tensao:
	mov		IndexString,0
lop33:
	lea		bx,VParamString
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		Relatorio_ok
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop33

Relatorio_ok:
	mov		IndexString,0
lop4:
	lea		bx,MSG_TEMP_OK
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_ok
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop4
valor_ok:
	mov		IndexString,0
	mov		ax,Tempo_Ok_h
	lea		bx,Tempo_ok_string_h
	call	sprintf_w
lop44:
	lea		bx,Tempo_ok_string_h
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_ok_m
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop44

valor_ok_m:
	call	colocadpontos	
	mov		IndexString,0
	mov		ax,Tempo_ok_m
	lea		bx,Tempo_ok_string_m
	call	sprintf_w
lop444:
	lea		bx,Tempo_ok_string_m
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_ok_s
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop444
valor_ok_s:
	call	colocadpontos
	mov		IndexString,0
	mov		ax,Tempo_ok_s
	lea		bx,Tempo_ok_string_s
	call	sprintf_w
lop4444:
	lea		bx,Tempo_ok_string_s
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		Relatorio_sem
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop4444
Relatorio_sem:
	mov		IndexString,0
lop5:
	lea		bx,MSG_TEMP_SEM
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_sem
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop5
valor_sem:
	mov		IndexString,0
	mov		ax,Tempo_sem_h
	lea		bx,Tempo_sem_string_h
	call	sprintf_w
lop55:
	lea		bx,Tempo_sem_string_h
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_sem_m
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop55

valor_sem_m:
	call	colocadpontos	
	mov		IndexString,0
	mov		ax,Tempo_sem_m
	lea		bx,Tempo_sem_string_m
	call	sprintf_w
lop555:
	lea		bx,Tempo_sem_string_m
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_sem_s
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop555
valor_sem_s:
	call	colocadpontos
	mov		IndexString,0
	mov		ax,Tempo_sem_s
	lea		bx,Tempo_sem_string_s
	call	sprintf_w
lop5555:
	lea		bx,Tempo_sem_string_s
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		Relatorio_total
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop5555
Relatorio_total:
	mov		IndexString,0
lop6:
	lea		bx,MSG_TEMP_TOTAL
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_total
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop6
valor_total:
	mov		IndexString,0
	mov		ax,Tempo_total_h
	lea		bx,Tempo_total_string_h
	call	sprintf_w
lop66:
	lea		bx,Tempo_total_string_h
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_total_m
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop66

valor_total_m:
	call	colocadpontos	
	mov		IndexString,0
	mov		ax,Tempo_total_m
	lea		bx,Tempo_total_string_m
	call	sprintf_w
lop666:
	lea		bx,Tempo_total_string_m
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		valor_total_s
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop666
valor_total_s:
	call	colocadpontos
	mov		IndexString,0
	mov		ax,Tempo_total_s
	lea		bx,Tempo_total_string_s
	call	sprintf_w
lop6666:
	lea		bx,Tempo_total_string_s
	add		bx, IndexString
	mov		dl,[bx]
	cmp		dl,0
	jz		TERMINA
	mov		bx,FileHandleDst
	call	setChar
	inc		IndexString
	jmp		lop6666



TERMINA:

    .exit 	0




;*********************************************************************************************************
;--------------------------------------------------------------------
;Funções
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;Funcao pega o nome do arquivo origem da string de entrada
;--------------------------------------------------------------------
GetFileName	proc	near
    ;procura - na string de chamada
    mov al, "-"
    mov di, offset CMDLINE
    mov cx, TamCMDLINE
    repne scasb
	jnz	sem_nome_entrada


confere_i:
    ;confere se o proximo caractere eh i
    mov cl, byte ptr [di]
    cmp cl, "i"
    je achou_nome

    ;procura o proximo "-" na string de chamada
    repne scasb
	jnz sem_nome_entrada
    jmp confere_i
	

achou_nome:  

	
    inc di                              ;tira o proprio i
    inc di                              ;tira o espaco
    mov FileNameSRCptr1, di             ;salva o offset do inicio do nome
	mov cl, byte ptr [di]
	cmp cl," "
	je	msg_erro_par_i
	cmp	cl,"	"
	je	msg_erro_par_i
	cmp	cl,"-"
	je	msg_erro_par_i
    ;procura o prox " " na string de chamada
    mov al, " "
    repne scasb
	dec di							   ;impede o " " de entrar na conta
    mov TamanhoNomeSrc, di             ;salva o offset do fim do nome
    mov dx, FileNameSRCptr1
    sub TamanhoNomeSrc, dx             ;obtem o tamanho do nome do arquivo de entrada

;
    mov si,FileNameSRCptr1
    mov di, offset FileNameSRC
    mov cx, TamanhoNomeSrc
    rep movsb
    ret

sem_nome_entrada:
	mov si, offset InPadrao
    mov di, offset FileNameSrc
    mov cx, 4
    rep movsb	
	ret
Msg_Erro_Par_i:
	lea bx,MsgErroParI 
	call printf_s
	.exit 1 
GetFileName	endp

;--------------------------------------------------------------------
;Funcao Escrever um string na tela
;		printf_s(char *s -> BX)
;--------------------------------------------------------------------
printf_s	proc	near
	mov		dl,[bx]
	cmp		dl,0
	je		ps_1

	push	bx
	mov		ah,2
	int		21H
	pop		bx

	inc		bx		
	jmp		printf_s
		
ps_1:
	ret
printf_s	endp

;
;--------------------------------------------------------------------
;Funcao: Escreve o valor de AX na tela
;		printf("%
;--------------------------------------------------------------------
printf_w	proc	near
	; sprintf_w(AX, BufferWRWORD)
	lea		bx,BufferWRWORD
	call	sprintf_w
	
	; printf_s(BufferWRWORD)
	lea		bx,BufferWRWORD
	call	printf_s
	
	ret
printf_w	endp

;
;--------------------------------------------------------------------
;Funcao: Converte um inteiro (n) para (string)
;		 sprintf(string->BX, "%d", n->AX)
;--------------------------------------------------------------------
sprintf_w	proc	near
	mov		sw_n,ax
	mov		cx,5
	mov		sw_m,10000
	mov		sw_f,0
	
sw_do:
	mov		dx,0
	mov		ax,sw_n
	div		sw_m
	
	cmp		al,0
	jne		sw_store
	cmp		sw_f,0
	je		sw_continue
sw_store:
	add		al,'0'
	mov		[bx],al
	inc		bx
	
	mov		sw_f,1
sw_continue:
	
	mov		sw_n,dx
	
	mov		dx,0
	mov		ax,sw_m
	mov		bp,10
	div		bp
	mov		sw_m,ax
	
	dec		cx
	cmp		cx,0
	jnz		sw_do

	cmp		sw_f,0
	jnz		sw_continua2
	mov		[bx], "0"
	inc		bx
sw_continua2:

	mov		byte ptr[bx],0
	ret		
sprintf_w	endp
;--------------------------------------------------------------------
;Funcao pega o nome do arquvio de destino da string de entrada
;--------------------------------------------------------------------
GetFileNameDst	proc	near
	 ;procura - na string de chamada
    mov al, "-"
    mov di, offset CMDLINE
    mov cx, TamCMDLINE
    repne scasb
confere_o:
    ;confere se o proximo caractere eh o
    mov ah, byte ptr [di]
    cmp ah, "o"
    je achou_nome_dst

    ;procura o proximo "-" na string de chamada
    repne scasb
	jnz nao_achou_o					   ;pula para rotina de destino automatico
    jmp confere_o


achou_nome_dst:  
    inc di                              ;tira o proprio o
    inc di                              ;tira o espaco
    mov FileNameDSTptr1, di             ;salva o offset do inicio do nome
	mov ah, byte ptr [di]
	cmp ah, " "							; verifica se não esta em branco o parametro
	je	Msg_Erro_Par_o
    ;procura o prox " " na string de chamada
    mov al, " "
    repne scasb
	dec di							   ;impede o " " de entrar na conta
    mov TamanhoNomeDST, di             ;salva o offset do fim do nome
    mov dx, FileNameDSTptr1
    sub TamanhoNomeDST, dx             ;obtem o tamanho do nome do arquivo de entrada

;
    mov si,FileNameDSTptr1
    mov di, offset FileNameDST
    mov cx, TamanhoNomeDST
    rep movsb
    ret
nao_achou_o:
    mov si, offset OutPadrao
    mov di, offset FileNameDST
    mov cx, 5
    rep movsb	
	ret
Msg_Erro_Par_o:
	lea bx,MsgErroParO 
	call printf_s
	.exit 1  

GetFileNameDst	endp
;--------------------------------------------------------------------
;Entra: BX -> file handle
;       dl -> caractere
;Sai:   AX -> numero de caracteres escritos
;		CF -> "0" se escrita ok
;--------------------------------------------------------------------
setChar	proc	near
	mov		ah,40h
	mov		cx,1
	mov		FileBuffer,dl
	lea		dx,FileBuffer
	int		21h
	ret
setChar	endp

;--------------------------------------------------------------------
;Fun��o Cria o arquivo cujo nome est� no string apontado por DX
;		boolean fcreate(char *FileName -> DX)
;Sai:   BX -> handle do arquivo
;       CF -> 0, se OK
;--------------------------------------------------------------------
fcreate	proc	near
	mov		cx,0
	mov		ah,3ch
	int		21h
	mov		bx,ax
	ret
fcreate	endp

;--------------------------------------------------------------------
;Entra:	BX -> file handle
;Sai:	CF -> "0" se OK
;--------------------------------------------------------------------
fclose	proc	near
	mov		ah,3eh
	int		21h
	ret
fclose	endp
;--------------------------------------------------------------------
;Funcao pega o valor do parametro -v e converte para inteiro
;coloca o valor como string em vParamString e como interio em
;vParamInt
;--------------------------------------------------------------------
GetVParam	proc	near
	 ;procura - na string de chamada
    mov al, "-"
    mov di, offset CMDLINE
    mov cx, TamCMDLINE
    repne scasb

confere_v:
    ;confere se o proximo caractere eh v
    mov ah, byte ptr [di]
    cmp ah, "v"
    je achou_v_param

    ;procura o proximo "-" na string de chamada
    repne scasb
	jnz sem_vparam
    jmp confere_v
	

achou_v_param:  
	inc di
	inc di
    mov VParamStringP, di            	;salva o offset do inicio do parametro v

    ;procura o prox " " na string de chamada
    mov al, " "
    repne scasb
	dec di							   ;evita que se conte o " " no tamanho
    mov TamanhoSN, di            	   ;salva o offset do parametro v
    mov dx, VParamStringP
    sub TamanhoSN, dx             	   ;obtem o tamanho do string parametro v

	;coloca a string V em VParamString
    mov si, VParamStringP
    mov di, offset VParamString
    mov cx, TamanhoSN
    rep movsb

	;coloca o inteiro v em vParamInt
	lea bx, VParamString
	call atoi
	mov VParamInt, ax
	cmp VParamInt, 220
	je	verificado
	cmp VParamInt,127
	je	verificado
	lea	bx,MsgErroValorPar 
	call printf_s
	.exit 1

 verificado:
    ret
sem_vparam:
    mov si, offset TensaoPadrao
    mov di, offset VParamString
    mov cx, 3
    rep movsb	
    lea	bx,VParamString
	call atoi
	mov	VParamInt,ax
	ret


GetVParam	endp

;--------------------------------------------------------------------
;Função:Converte um ASCII-DECIMAL para HEXA
;Entra: (S) -> DS:BX -> Ponteiro para o string de origem
;Sai:	(A) -> AX -> Valor "Hex" resultante
;Algoritmo:
;	A = 0;
;	while (*S!='\0') {
;		A = 10 * A + (*S - '0')
;		++S;
;	}
;	return
;--------------------------------------------------------------------
atoi	proc near

		; A = 0;
		mov		ax,0
		
atoi_2:
		; while (*S!='\0') {
		cmp		byte ptr[bx], 0
		jz		atoi_1

		; 	A = 10 * A
		mov		cx,10
		mul		cx

		; 	A = A + *S
		mov		ch,0
		mov		cl,[bx]
		add		ax,cx

		; 	A = A - '0'
		sub		ax,'0'

		; 	++S
		inc		bx
		
		;}
		jmp		atoi_2

atoi_1:
		; return
		ret

atoi	endp



getChar	proc	near
	mov		ah,3fh
	mov		cx,1
	lea		dx,FileBuffer
	int		21h
	mov		dl,FileBuffer
	ret
getChar	endp

imprimeEspaco proc	near
	lea		bx,MSgTAB
	call	printf_s
	ret
imprimeEspaco endp

tranforma_tensao proc	near
	lea		bx,T1_Buffer
	call 	atoi
	mov		T1_int,ax
	lea		bx,T2_Buffer
	call 	atoi
	mov		T2_int,ax
	lea		bx,T3_Buffer
	call 	atoi
	mov		T3_int,ax
	ret

tranforma_tensao endp

converte_tempo_ok proc near

p1:
	cmp		ax,3600
	jae		up_horas
	cmp		ax,60
	jae		up_minutos
	mov		Tempo_Ok_s,ax
	ret


up_horas:
	sub		ax,3600
	inc		Tempo_Ok_h
	jmp		p1
up_minutos:
	sub		ax,60
	inc		Tempo_Ok_m
	jmp		p1

converte_tempo_ok endp

converte_tempo_total proc near

p2:
	cmp		ax,3600
	jae		up_horas1
	cmp		ax,60
	jae		up_minutos1
	mov		Tempo_Total_s,ax
	ret


up_horas1:
	sub		ax,3600
	inc		Tempo_Total_h
	jmp		p2
up_minutos1:
	sub		ax,60
	inc		Tempo_Total_m
	jmp		p2

converte_tempo_total endp

converte_tempo_sem proc near
p3:
	cmp		ax,3600
	jae		up_horas2
	cmp		ax,60
	jae		up_minutos2
	mov		Tempo_Sem_s,ax
	ret


up_horas2:
	sub		ax,3600
	inc		Tempo_Sem_h
	jmp		p2
up_minutos2:
	sub		ax,60
	inc		Tempo_Sem_m
	jmp		p3

converte_tempo_sem endp
colocadpontos 	proc near

   		mov     bx, FileHandleDST
		mov		FileBuffer, ":"
		lea		dx, FileBuffer
    	mov     cx, 1
    	mov     ah, 40h
    	int     21h
		ret
colocadpontos		endp
;--------------------------------------------------------------------
	end
;--------------------------------------------------------------------
