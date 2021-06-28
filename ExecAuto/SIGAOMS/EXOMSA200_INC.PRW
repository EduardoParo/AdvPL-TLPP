#include "tbiconn.ch"
#Include "totvs.ch"
/*------------------------------------------
SELECT TOP 1 C5_FECENT,* FROM SC5990 ORDER BY R_E_C_N_O_ DESC 

SELECT TOP 1  C6_NUM,C6_ENTREG,* FROM SC6990 ORDER BY R_E_C_N_O_ DESC 

SELECT TOP 1 * FROM SC9990 ORDER BY R_E_C_N_O_ DESC 

SELECT * FROM DAK990 ORDER BY R_E_C_N_O_ DESC 
---------------------------------------------*/
/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@GitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
Function U_zXjob()
//<<NAO MANIPULAR O FONTE>> APENAS CHUMBE OS VALORES NAS VARIAVEIS
  local lret := .F.
  
  lret := startjob("U_MyOMS200",getenvserver(),.T.,"Data Atual " + cvaltochar(date()))
	if !lret
    	return -1
	endif
    
return

/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@GitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
Function U_MyOMS200() as undefined
//<<NAO MANIPULAR O FONTE>> APENAS CHUMBE OS VALORES NAS VARIAVEIS
	local aCab      := {}  as array // Array do Cabeçalho da Carga
	local aItem     := {}  as array  // Array dos Pedidos da Carga
	
	local cTransp   := ""        as string
	local cPedido   := "000006"  as string
    local cRotei	:="AEREO1"   as string
	
	private lMsHelpAuto := .T. as logical//Variavel de controle interno do ExecAuto
	private lMsErroAuto := .F. as logical//Variavel que informa a ocorrência de erros no ExecAuto
	
	//INFORMAR OS DADOS REFERENTE AO SEU AMBIENTE
	RpcSetEnv("99","01","Administrador","","OMS","OMSA200",{"DAK","SC5","SA1"})
			
	// Posiciona no primeiro pedido de venda 
	cPedido := PadR(cPedido,TamSx3("C5_NUM")[1])
	SC5->(DbSetOrder(1))
	if ! SC5->(DbSeek(xFilial("SC5")+cPedido))
        Return
	endIf
	// Posiciona no cliente do primeiro pedido
	SA1->(DbSetOrder(1))
	if !SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE))
        return 
	endIf
	Pergunte("OMS200",.F.)
    SetMVValue("OMS200",mv_par01,"")   
    SetMVValue("OMS200",mv_par02,"ZZZZZZ")   
    SetMVValue("OMS200",mv_par03,"")   
    SetMVValue("OMS200",mv_par04,"ZZZZZZ")   
    SetMVValue("OMS200",mv_par05,2)   
    SetMVValue("OMS200",mv_par06,2)   
    SetMVValue("OMS200",mv_par07,"")   
    SetMVValue("OMS200",mv_par08,"ZZZZZZZZZZZZZZZ")   
	SetMVValue("OMS200",mv_par09,"")   
	SetMVValue("OMS200",mv_par10,"ZZ")   
	SetMVValue("OMS200",mv_par11,STOD("01/01/2004"))   
	SetMVValue("OMS200",mv_par12,STOD("29/01/2026"))   
	SetMVValue("OMS200",mv_par13,"")   
	SetMVValue("OMS200",mv_par14,"ZZZZZZ")   
	SetMVValue("OMS200",mv_par15,STOD("01/01/2004")   )
	SetMVValue("OMS200",mv_par16,STOD("29/01/2026"))   
	SetMVValue("OMS200",mv_par17,"")   
	SetMVValue("OMS200",mv_par18,"ZZ")   
	SetMVValue("OMS200",mv_par19,"")   
	SetMVValue("OMS200",mv_par20,"ZZZZZZ")   
	SetMVValue("OMS200",mv_par21,"")  
	SetMVValue("OMS200",mv_par22,"ZZZZZZ")  

	aAdd(aCab,{"DAK_FILIAL", xFilial("DAK"),             nil})
	aAdd(aCab,{"DAK_COD"   , GETSX8NUM("DAK","DAK_COD"), nil}) //Campo com inicializador padrão para pegar GESX8NUM
	aAdd(aCab,{"DAK_SEQCAR", "01",                       nil})
	aAdd(aCab,{"DAK_ROTEIR", cRotei,                     nil})
	aAdd(aCab,{"DAK_CAMINH", "",                         nil})
	aAdd(aCab,{"DAK_MOTORI", "",                         nil})
	aAdd(aCab,{"DAK_PESO"  , 0,                          nil}) // Calculado pelo OMSA200
	aAdd(aCab,{"DAK_DATA"  , DATE(),                     nil})
	aAdd(aCab,{"DAK_HORA"  , TIME(),                     nil})
	aAdd(aCab,{"DAK_JUNTOU", "Manual",                   nil})
	aAdd(aCab,{"DAK_ACECAR", "2",                        nil})
	aAdd(aCab,{"DAK_ACEVAS", "2",                        nil})
	aAdd(aCab,{"DAK_ACEFIN", "2",                        nil})
	aAdd(aCab,{"DAK_FLGUNI", "2",                        nil}) //Campo com inicializador padrão  - 2
	aAdd(aCab,{"DAK_TRANSP", cTransp,                    nil})
    
	// Informações do primeiro pedido
	// Este array não tem o formato padrão de execuções automáticas
	Aadd(aItem, {;
		    aCab[2][2],; // 01 - Código da carga
	        "999999" ,; // 02 - Código da Rota - 999999 (Genérica)
	        "999999" ,; // 03 - Código da Zona - 999999 (Genérica)
	        "999999" ,; // 04-  Código do Setor - 999999 (Genérico)
	        SC5->C5_NUM   ,; // 05 - Código do Pedido Venda
	        SA1->A1_COD   ,; // 06 - Código do Cliente
	        SA1->A1_LOJA  ,; // 07 - Loja do Cliente
	        SA1->A1_NOME  ,; // 08 - Nome do Cliente
	        SA1->A1_BAIRRO,; // 09 - Bairro do Cliente
	        SA1->A1_MUN   ,; // 10 - Município do Cliente
	        SA1->A1_EST   ,; // 11 - Estado do Cliente
	        SC5->C5_FILIAL,; // 12 - Filial do Pedido Venda
	        SA1->A1_FILIAL,; // 13 - Filial do Cliente
	        0             ,; // 14 - Peso Total dos Itens
	        0             ,; // 15 - Volume Total dos Itens
	        "08:00"       ,; // 16 - Hora Chegada
	        "0001:00"     ,; // 17 - Time Service
	        nil           ,; // 18 - Não Usado
	        dDatabase     ,; // 19 - Data Chegada
	        dDatabase     ,; // 20 - Data Saída
	        nil           ,; // 21 - Não Usado
	        nil           ,; // 22 - Não Usado
	        0             ,; // 23 - Valor do Frete
	        0             ,; // 24- Frete Autonomo
	        0             ,; // 25 - Valor Total dos Itens (Calculado pelo OMSA200)
	        0             ,; // 26 - Quantidade Total dos Itens (Calculado pelo OMSA200)
	        nil           ,; // 27 - Não usado
	        ""      }) // 28 - Transportadora redespachante (não obrigatório)
	
	SetFunName("OMSA200")

	MSExecAuto( { |x, y, z| OMSA200(x, y, z) }, aCab, aItem, 3 )

	If (!IsBlind() .and. lMsErroAuto) // COM INTERFACE GRÁFICA
 		MostraErro()
		DisarmTransaction()
 		ConOut("Erro na inclusao!")
	ElseiF(IsBlind() .and. lMsErroAuto) // EM ESTADO DE JOB
    	cError := MostraErro("/spool", "error.log") //ARMAZENA A MENSAGEM DE ERRO
		  aLog := aClone(GetAutoGRLog())	 
		
		DisarmTransaction()
	ElseiF(lMsErroAuto ==.f.)
		ConOut("Sucesso!!")
	endIf


	RESET ENVIRONMENT

Return

//Pergunte("OMS200",.F.)
/* -------------------------------------------------------
Ponto de entrada para validar itens do Pedido de Venda
Este ponto de entrada é executado na seleção dos itens de pedido de venda ( SC9 ) que estão amarrados a carga.
Ele tem como objetivo validar o item de pedido de venda ( SC9 ).
----------------------------------------------------------------*/
USER FUNCTION OS200PC9()
		cAliasSC9:= paramixb[1]
	IF ! Empty(cAliasSC9)

		ConOut("PEDIDO -> "+(cAliasSC9)->PED_PEDIDO)  //  5- Pedido)
		ConOut("ITEM -> "+(cAliasSC9)->C9_ITEM   ) //  6- Item)
		ConOut("CLIENTE -> "+(cAliasSC9)->PED_CODCLI)  //  7- Cliente)
		ConOut("LOJA -> "+(cAliasSC9)->PED_LOJA )  //  8- Loja)
		ConOut("REG SC9 -> "+ cValToChar((cAliasSC9)->RECSC9))     //  9- Reg. SC9
		ConOut("FILIAL -> "+(cAliasSC9)->PED_FILORI)

	ENDIf
return .T.
