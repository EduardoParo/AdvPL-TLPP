#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"
/*------------------------------------------------------------
https://tdn.totvs.com/pages/releaseview.action?pageId=6089279
SELECT * FROM SC7990 ORDER BY R_E_C_N_O_ DESC 
/{Protheus.doc}----------------------------------------------------------------------
@type Function 
@version  12
@author Eduardo Paro de SImoni
@GitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
Function U_EXEC122() 
	
	if !RpcSetEnv("99","01","Administrador","","COM")
		msgInfo("Não foi possivel realizar o login")
		Return 
	endIf
	//AGORA VOU FORÇAR UM ERRO.LOG
	STARTJOB("U_EXEC121",getenvserver(),.t.,,,)

	RpcClearEnv()
Return


Function U_EXEC121() as undefined
	//<<NAO MANIPULAR O FONTE>> APENAS CHUMBE OS VALORES NAS VARIAVEIS
	Local aCabec := {} as array
	Local aItens := {} as array
	Local aLinha := {} as array
	
	Local nX := 1 as numeric
	Local cDoc := "" as string
	Local nOpc := 3 as numeric

	Local cForn :="F00000"
	Local cProd :="PROD           "
	
	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	if !RpcSetEnv("99","02","Administrador","","COM")
		msgInfo("Não foi possivel realizar o login")
		Return 
	endIf

	dbSelectArea("SC7")

	//Teste de Inclusão
	cDoc := GetSXENum("SC7","C7_NUM")
	SC7->(dbSetOrder(1))

	// EXECUTAR CONFORME ESTA NA DOCUMENTACAO
	While SC7->(dbSeek(xFilial("SC7")+cDoc))
		ConfirmSX8()
		cDoc := GetSXENum("SC7","C7_NUM")
	EndDo

	dbSelectArea("SA2")
	SA2->(DbSetOrder(1))//A2_FILIAL, A2_COD, A2_LOJA, R_E_C_N_O_, D_E_L_E_T_
	if !SA2->(DbSeek(xFilial("SA2")+PadR(cForn,Tamsx3("A2_COD")[1])))
		msgINFO("Não foi encontrado o Fornecedor")
		Return
	endIf

	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))//B1_FILIAL, B1_COD, R_E_C_N_O_, D_E_L_E_T_
	if !SB1->(DbSeek(xFilial("SB1")+PadR(cProd,Tamsx3("B1_COD")[1])))
		msgINFO("Não foi encontrado o produto")
		Return
	endIf

	aadd(aCabec,{"C7_NUM" ,cDoc})
	aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
	aadd(aCabec,{"C7_FORNECE" ,SA2->A2_COD})
	aadd(aCabec,{"C7_LOJA" ,SA2->A2_LOJA})
	aadd(aCabec,{"C7_COND" ,"00x"})
	aadd(aCabec,{"C7_CONTATO" ,"AUTO"})
	aadd(aCabec,{"C7_FILENT" ,cFilAnt})

	For nX := 1 To 1
		aLinha := {}
		aadd(aLinha,{"C7_PRODUTO" ,SB1->B1_COD,nil})
		aadd(aLinha,{"C7_QUANT" ,1 ,nil})
		aadd(aLinha,{"C7_PRECO" ,100 ,nil})
		aadd(aLinha,{"C7_TOTAL" ,100 ,nil})
		aadd(aItens,aLinha)
	Next nX
//VOU FORCAR O ERRO.LOG
	MSExecAuto({|a,b,c,d,e,f,g| MATA120(a,b,c,d,e,f,,g)},1,aCabec,aItens,nOpc,.F.,nil,nil)

	If !lMsErroAuto
		ConOut("Incluido PC: "+cDoc)
	Else
		ConOut("Erro na inclusao!")
		cFile := NomeAutoLog()
		MostraErro("/spool/",cFile)	
		//aLog := aClone(GetAutoGRLog())	 	
		cErro := FwNoAccent(MemoRead("/spool/" + cFile))
	EndIf

	RpcClearEnv()

Return
