#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} U_TsColumn----------------------------------------------------------------------
description Teste da classe FWMBROWSE com uma tabela temporaria
@type function
@version  12
@author Eduardo Paro de SImoni
@since 17/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
function u_DufwMBR()
    local cAlias	:="MeuAlias"
	
	private oBrowse	:=nil
	private aRotina	:= MenuDef()
	private aCampos	:= {}, aSeek := {}, aDados := {}, aValores := {}, aFieFilter := {}
	
    //CRIACAO DA TABELA TEMPORARIA
    ExMyFWTempor(cAlias)
	DbSelectArea(cAlias)
	DbSetOrder(1)
    
	//Campos que irão compor o combo de pesquisa na tela principal
	aAdd(aSeek,{"CODIGO"   , {{"","C",20,0, "TMP_COD"   ,"@!"}}, 1, .T. } )
	aAdd(aSeek,{"DESCR", {{"","C",20,0, "TMP_DESC","@!"}}, 2, .T. } )
	
	//Campos que irão compor a tela de filtro
	aAdd(aFieFilter,{"TMP_COD"	, "CODIGO"   , "C", 20, 0,"@!"})
	aAdd(aFieFilter,{"TMP_DESC"	, "DESCR", "C", 20, 0,"@!"})
	
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( cAlias )
	oBrowse:SetDescription( "TOTVS FWMBROWSE" )
	oBrowse:SetSeek(.T.,aSeek)
	oBrowse:SetTemporary(.T.)
	//oBrowse:SetLocate()
	oBrowse:SetUseFilter(.T.)
	//oBrowse:SetDBFFilter(.T.)
	//oBrowse:SetFilterdefault( "" ) //Exemplo de como inserir um filtro padrão >>> "TR_ST == 'A'"
	oBrowse:SetFieldFilter(aFieFilter)
	oBrowse:DisableDetails()
	
	//Legenda da grade, é obrigatório carregar antes de montar as colunas
    oBrowse:AddLegend('TMP_TIPO $ "UN|AR"',"GREEN","Chave teste 1")
    oBrowse:AddLegend('!(TMP_TIPO $ "PA|PI")',"RED","Chave teste 2")
	
	//Detalhes das colunas que serão exibidas
	oBrowse:SetColumns(IncCol("TMP_COD"	    ,"CODIGO"	,01,"@!",0,010,0))
	oBrowse:SetColumns(IncCol("TMP_DESC"	,"DESCR"	,02,"@!",1,040,0))
	oBrowse:SetColumns(IncCol("TMP_TIPO"	,"TIPO"	    ,03,"@!",1,050,0))

	oBrowse:Activate()
	//If !Empty(cArqTrb)
	//	Ferase(cArqTrb+GetDBExtension())
	//	Ferase(cArqTrb+OrdBagExt())
	//	cArqTrb := ""
	//	TRB->(DbCloseArea())
	//	delTabTmp('TRB')
    //	dbClearAll()
	//Endif
    	
return

/*/{Protheus.doc} ExMyFWTempor----------------------------------------------------------------------
description
@type function
@version  12
@author Eduardo Paro de SImoni
@since 17/05/2021
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
    aAdd(aFields,{"TMP_COD" ,"C",20,0})
    aAdd(aFields,{"TMP_DESC","C",20,0})
    aAdd(aFields,{"TMP_TIPO","C",20,0})

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

/*/{Protheus.doc} ExMyFWTempor----------------------------------------------------------------------
description
@type function
@version  12
@author Eduardo Paro de SImoni
@since 17/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
static function IncCol(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	local aColumn
	local bData 	:= {||}
	default nAlign 	:= 1
	default nSize 	:= 20
	default nDecimal:= 0
	default nArrData:= 0
	
	
	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf
	
	/* Array da coluna
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
	*/
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
return {aColumn}

static Function MenuDef()
	local aRotina 	:= {}
	local aRotina1 := {}
	
	aAdd(aRotina1, {"Legenda"			, "U_DufwV"		, 0,11, 0, Nil })
	
	aAdd(aRotina, {"Pesquisar"			, "PesqBrw"		, 0, 1, 0, .T. })
	aAdd(aRotina, {"Visualizar"			, "U_DufwV"		, 0, 2, 0, .F. })
	
	aAdd(aRotina, {"Incluir"			, "U_DufwI"		, 0, 3, 0, Nil })
	aAdd(aRotina, {"Alterar"			, "U_DufwA"		, 0, 4, 0, Nil })
	aAdd(aRotina, {"Excluir"			, "U_DufwE"		, 0, 5, 3, Nil })
	
	aAdd(aRotina, {"Mais ações..." , aRotina1, 0, 4, 0, Nil }      )
	
return(aRotina)
