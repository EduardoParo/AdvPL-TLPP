#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"
/*------------------------------------------------------------
https://tdn.totvs.com/pages/releaseview.action?pageId=6089279
SELECT * FROM SC7990 ORDER BY R_E_C_N_O_ DESC 
/{Protheus.doc}----------------------------------------------------------------------
@type function 
@version  12
@author Eduardo Paro de SImoni
@GitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
Function U_EXEC122() // teste ok 03/03/2020
	
	if !RpcSetEnv("99","02","Administrador","","COM")
		msgInfo("Não foi possivel realizar o login")
		return 
	endIf

	STARTJOB("U_FINAJOB",getenvserver(),.t.,,,)

	RpcClearEnv()
Return


function U_EXEC121() as undefined
	//<<NAO MANIPULAR O FONTE>> APENAS CHUMBE OS VALORES NAS VARIAVEIS
	local aCabec := {} as array
	local aItens := {} as array
	local aLinha := {} as array
	
	local nX := 1 as numeric
	local cDoc := "" as string
	local nOpc := 3 as numeric

	local cForn :="F00000"
	local cProd :="PROD           "

	private lMsErroAuto := .F.

	if !RpcSetEnv("99","01","Administrador","","COM")
		msgInfo("Não foi possivel realizar o login")
		return 
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
		RETURN
	endIf

	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))//B1_FILIAL, B1_COD, R_E_C_N_O_, D_E_L_E_T_
	if !SB1->(DbSeek(xFilial("SB1")+PadR(cProd,Tamsx3("B1_COD")[1])))
		msgINFO("Não foi encontrado o produto")
		RETURN
	endIf

	aadd(aCabec,{"C7_NUM" ,cDoc})
	aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
	aadd(aCabec,{"C7_FORNECE" ,SA2->A2_COD})
	aadd(aCabec,{"C7_LOJA" ,SA2->A2_LOJA})
	aadd(aCabec,{"C7_COND" ,"001"})
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

	MSExecAuto({|a,b,c,d,e,f,g| MATA120(a,b,c,d,e,f,,g)},1,aCabec,aItens,nOpc,.F.,nil,nil)

	If !lMsErroAuto
		ConOut("Incluido PC: "+cDoc)
	Else
		ConOut("Erro na inclusao!")
		cFileLog := NomeAutoLog()
		MostraErro("",cFile)		
		cErro := FwNoAccent(MemoRead("" + cFile))
	EndIf

	RpcClearEnv()

Return
