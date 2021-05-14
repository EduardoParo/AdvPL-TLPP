#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} U_TsColumn----------------------------------------------------------------------
description Teste da classe FWBROWSE com uma tabela temporaria
@type function
@version  12
@author Eduardo Paro de SImoni
@since 13/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
function U_TsColumn()

	local oDlg		 := nil
    local cAlias:="MeuAlias"
	local bGetValues  := {||}
	private oBrowse := nil

	//Preparacao do Ambiente
	//RpcSetEnv("99","01", "Administrador","")

    //CRIACAO DA TABELA TEMPORARIA
    ExMyFWTempor(cAlias)
	DbSelectArea(cAlias)
	DbSetOrder(1)

	//Define a janela do Browse
	oDlg = TDialog():New(0, 0, 600, 800,,,,,,,,,,.T.)

	//Cria a gride
	oBrowse := FWBrowse():New(oDlg)
	oBrowse:SetDataTable(.T.)
	oBrowse:SetAlias(cAlias)

	//Montagem das Colunas
	CreateColuns(cAlias)

	//Desabilita opcao de impress�o
	oBrowse:DisableReport()

	//Desabilita opcao de configura��o
	//oBrowse:DisableConfig()

	//Define que as c�lulas ser�o editadas e ser�o validadas por um Code-Block determinado
	oBrowse:SetEditCell(.T., {|lEsc, oBrowse| .T.}) //lEsc: Valida��o cancelada; oBrowse: Objeto FWBrowse

	bGetValues  := {|| MsgRun("Debug para verificar metodos", "Aguarde", {|| GeraDebug()})}
	oBrowse:SetDoubleClick( bGetValues )

	oBrowse:Activate()

	//Exibe a tela
	oDlg:Activate(,,, .T., {|| .T.})

Return

/*/{Protheus.doc} ExMyFWTempor----------------------------------------------------------------------
description
@type function
@version  12
@author Eduardo Paro de SImoni
@since 13/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
static Function ExMyFWTempor(cAlias as caracter)
    local aFields 
    local oTempTable
    local cNameTab
    local cQuery

    //-------------------
    //Criacao do objeto
    //-------------------
    oTempTable := FWTemporaryTable():New( cAlias )

    //--------------------------
    //Monta os campos da tabela
    //--------------------------
    aFields := {}
    aadd(aFields,{"TMP_COD" ,"C",20,0})
    aadd(aFields,{"TMP_DESC","C",20,0})
    aadd(aFields,{"TMP_TIPO","C",20,0})

    oTemptable:SetFields( aFields )
    oTempTable:AddIndex("indice1", {"TMP_COD"} )
    oTempTable:AddIndex("indice2", {"TMP_DESC", "TMP_TIPO"} )
    
    //------------------
    //Criacao da tabela
    //------------------
    oTempTable:Create()
    cNameTab := oTempTable:GetRealName()
    ConOut(Repl("-", 80))
    ConOut(PadC("Tabela criada: " + cNameTab, 80))
    ConOut(Repl("-", 80))
   
    //------------------------------------
    //Executa Insert
    //------------------------------------
    //cQuery:= "INSERT INTO " + oTempTable:GetRealName() + "(TMP_COD, TMP_DESC, TMP_TIPO) VALUES ('TMP',TMP, 'TMP')"
//
	//If (TcSqlExec(cQuery) < 0)
    //    	conout(TCSQLError())
	//EndIf

    DbSelectArea("SB1")
    DbGotop()
    conOut("| TMP_COD          |  TMP_DESC         | TMP_TIPO          | ") 

	While  SB1->(!Eof())
        DbSelectArea(cAlias)
        RecLock(cAlias,.T.)
            (cAlias)->TMP_COD     :=  SB1->B1_COD
            (cAlias)->TMP_DESC    :=  SB1->B1_DESC
            (cAlias)->TMP_TIPO    :=  SB1->B1_TIPO
           
            conOut((cAlias)->TMP_COD + (cAlias)->TMP_DESC + (cAlias)->TMP_TIPO) 
        MsunLock()

        SB1->(DbSkip())
	Enddo

    ConOut(Repl("-", 80))
    ConOut(PadC("Tabela : " + cNameTab + " Prenchida", 80))
    ConOut(Repl("-", 80))

return

/*/{Protheus.doc} CreateColuns---------------------------------------------------------
description
@type function
@version  
@author Eduardo Paro de SImoni
@since 13/05/2021
@return return_type, return_description
-----------------------------------------------------------------------------------------/*/
Static Function CreateColuns(cAlias)

    private oColum := nil
    
    // Cria uma coluna de marca/desmarca
    //oColumn := oBrowse:AddMarkColumns({||If(.T./*Função de Marca/desmaca*/,'LBOK','LBNO')},{|oBrowse|/*Função de DOUBLECLICK*/},{|oBrowse|/* Função de HEADERCLICK*/})
    //
    //// Cria uma coluna de status
    //oColumn := oBrowse:AddStatusColumns({||If(.T./*Função de avaliação de status*/,'BR_VERDE','BR_VERMELHO')},{|oBrowse|/*Função de DOUBLECLICK*/})
    
    // Adiciona legenda no Browse
    oBrowse:AddLegend('TMP_TIPO $ "UN|AR"',"GREEN","Chave teste 1")
    oBrowse:AddLegend('!(TMP_TIPO $ "PA|PI")',"RED","Chave teste 2")
    
    // Adiciona as colunas do Browse
    oColumn := FWBrwColumn():New()
    oColumn:SetData({||TMP_COD})
    oColumn:SetTitle(RetTitle("TMP_COD"))
    oColumn:SetSize(3)
    oBrowse:SetColumns({oColumn})
    
    oColumn := FWBrwColumn():New()
    oColumn:SetData({||TMP_DESC})
    oColumn:SetTitle(RetTitle("TMP_DESC"))
    oColumn:SetSize(10)
    oBrowse:SetColumns({oColumn})
    
    oColumn := FWBrwColumn():New()
    oColumn:SetData({||TMP_TIPO})
    oColumn:SetTitle(RetTitle("TMP_TIPO"))
    oColumn:SetSize(40)
    oBrowse:SetColumns({oColumn})
    
Return 
/*/{Protheus.doc} CreateColuns---------------------------------------------------------
description
@type function
@version  
@author Eduardo Paro de SImoni
@since 13/05/2021
@return return_type, return_description
-----------------------------------------------------------------------------------------/*/
static Function GeraDebug()
    fwAlertInfo("Coluna posicionada : " + cValToChar(oBrowse:Colpos()))
    fwAlertInfo("Conteudo da Coluna : " + oBrowse:GetColumnData(oBrowse:Colpos()))

    oBrowse:GoTo( 2, .T. )

    //teste solicitado pelo cliente
    cCod:="PRODCAL        "
    MeuAlias->(DbSetOrder(1))//TMP_COD
    if MeuAlias->(DbSeek(cCod))
        alert("Localizado")
    EndIf

Return

