//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#define cNomeArq "zModEdu" 
Static cTitulo := "MVC MOD 2"

/*/{Protheus.doc}----------------------------------------------------------------------
@type function 
@version  12
@author Eduardo Paro de SImoni
@since 04/06/2021
//---------------------------------------------------------------------------------------------------/*/
Function u_zModEdu()
	local aArea   := GetArea()
	local oBrowse
	local cFunBkp := FunName()
	local aRotAnt :=  If( Type('aRotina') <> 'A', {}, aClone(aRotina) )
	private aRotina := MenuDef() 

	SetFunName(cNomeArq)
	
	//Cria um browse para a SB1, filtrando somente a tabela 00 (cabeçalho das tabelas
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SB1")
	oBrowse:SetDescription(cTitulo)
	//oBrowse:SetFilterDefault("SB1->B1_COD == '00'")
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)
	aRotina := aRotAnt
return nil

/*/{Protheus.doc}----------------------------------------------------------------------
@type function MENU
@version  12
@author Eduardo Paro de SImoni
@since 04/06/2021
//---------------------------------------------------------------------------------------------------/*/
static function MenuDef()

	local cView:= 'VIEWDEF.'+cNomeArq
	
	aRotina	:= {}
	//Adicionando opções
	ADD OPTION aRotina TITLE 'Visualizar' ACTION cView OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRotina TITLE 'Incluir'    ACTION cView OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE 'Alterar'    ACTION cView OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRotina TITLE 'Excluir'    ACTION cView OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
return aRotina

/*/{Protheus.doc}----------------------------------------------------------------------
@type function MODEL
@version  12
@author Eduardo Paro de SImoni
@since 04/06/2021
//---------------------------------------------------------------------------------------------------/*/
static function ModelDef()
	local aSB1Rel  := {}
	local bVldPos:={||}
	local bVldCom:={||u_zSaveMd2()}
	
	local oModel   := MPFormModel():New("zModel2M", , bVldPos, bVldCom) 
	local oStTmp   := FWFormModelStruct():New()
	local oStFilho := FWFormStruct(1, 'SB1')

	
	//Adiciona a tabela cABEÇALHO
	oStTmp:AddTable('SB1', {'B1_FILIAL', 'B1_COD'}, "Cabecalho SB1")
	
	//Adiciona o campo de Código da Tabela
	oStTmp:AddField(;
		"CODIGO CAB",;                                                                    // [01]  C   Titulo do campo
		"CODIGO CAB",;                                                                    // [02]  C   ToolTip do campo
		"B1_COD",;                                                                  // [03]  C   Id do Field
		"C",;                                                                         // [04]  C   Tipo do campo
		TamSX3("B1_COD")[1],;                                                      // [05]  N   Tamanho do campo
		0,;                                                                           // [06]  N   Decimal do campo
		nil,;                                                                         // [07]  B   Code-block de validação do campo
		nil,;                                                                         // [08]  B   Code-block de validação When do campo
		{},;                                                                          // [09]  A   Lista de valores permitido do campo
		.T.,;                                                                         // [10]  L   Indica se o campo tem preenchimento obrigatório
		FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SB1->B1_COD,'')" ),;    // [11]  B   Code-block de inicializacao do campo
		.T.,;                                                                         // [12]  L   Indica se trata-se de um campo chave
		.F.,;                                                                         // [13]  L   Indica se o campo pode receber valor em uma operação de update.
		.F.)                                                                          // [14]  L   Indica se o campo é virtual
	
	//Setando as propriedades na grid, o inicializador da Filial e Tabela, para não dar mensagem de coluna vazia
	oStFilho:SetProperty('B1_COD', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
	
	oModel:AddFields("FORMCAB",/*cOwner*/,oStTmp)
	oModel:AddGrid('SB1DETAIL','FORMCAB',oStFilho)
	
	//Adiciona o relacionamento de Filho, Pai
	aAdd(aSB1Rel, {'B1_COD', 'Iif(!INCLUI, SB1->B1_COD,  "")'} ) 
	
	//Criando o relacionamento
	oModel:SetRelation('SB1DETAIL', aSB1Rel, SB1->(IndexKey(1)))
	
	//Setando o campo único da grid para não ter repetição
	oModel:GetModel('SB1DETAIL'):SetUniqueLine({"B1_COD"})
	
	//Setando outras informações do Modelo de Dados
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	oModel:SetPrimaryKey({})
	oModel:GetModel("FORMCAB"):SetDescription("Formulário do Cadastro "+cTitulo)
return oModel

/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@since 04/06/2021
//---------------------------------------------------------------------------------------------------/*/
static function ViewDef()
	local oModel     := FWLoadModel(cNomeArq)
	local oStTmp     := FWFormViewStruct():New()
	local oStFilho   := FWFormStruct(2, 'SB1')
	local oView 	 := FWFormView():New()
	
	//Adicionando o campo Chave para ser exibido
	
	oStTmp:AddField(;
		"B1_COD",;               // [01]  C   Nome do Campo
		"01",;                      // [02]  C   Ordem
		"CODIGO CAB",;               // [03]  C   Titulo do campo
		X3Descric('B1_COD'),;    // [04]  C   Descricao do campo
		nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("B1_COD"),;    // [07]  C   Picture
		nil,;                       // [08]  B   Bloco de PictTre Var
		nil,;                       // [09]  C   Consulta F3
		.T.,;                       // [10]  L   Indica se o campo é alteravel
		nil,;                       // [11]  C   Pasta do campo
		nil,;                       // [12]  C   Agrupamento do campo
		nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		nil,;                       // [15]  C   Inicializador de Browse
		nil,;                       // [16]  L   Indica se o campo é virtual
		nil,;                       // [17]  C   Picture Variavel
		nil)                        // [18]  L   Indica pulo de linha após o campo
	
	oView:SetModel(oModel)
	oView:AddField("VIEW_CAB", oStTmp, "FORMCAB")
	oView:AddGrid('VIEW_DET1',oStFilho,'SB1DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_CAB','CABEC')
	oView:SetOwnerView('VIEW_DET1','GRID')
	
	//Habilitando título
	oView:EnableTitleView('VIEW_CAB','Cabeçalho ')
	oView:EnableTitleView('VIEW_DET1','Itens ')
	
	//Tratativa padrão para fechar a tela
	oView:SetCloseOnOk({||.T.})
	
	//Remove os campos de Filial e Tabela da Grid
	oStFilho:RemoveField('B1_FILIAL')
	oStFilho:RemoveField('B1_COD')
return oView

User Function zVldX5Tab()
	Local aArea      := GetArea()
	Local lRet       := .T.
	Local oModelDad  := FWModelActive()
	Local cFilSX5    := oModelDad:GetValue('FORMCAB', 'X5_FILIAL')
	Local cCodigo    := SubStr(oModelDad:GetValue('FORMCAB', 'X5_CHAVE'), 1, TamSX3('X5_TABELA')[01])
	Local nOpc       := oModelDad:GetOperation()
	
	//Se for Inclusão
	If nOpc == MODEL_OPERATION_INSERT
		DbSelectArea('SX5')
		SX5->(DbSetOrder(1)) //X5_FILIAL + X5_TABELA + X5_CHAVE
		
		//Se conseguir posicionar, tabela já existe
		If SX5->(DbSeek(cFilSX5 + '00' + cCodigo))
			Aviso('Atenção', 'Esse código de tabela já existe!', {'OK'}, 02)
			lRet := .F.
		EndIf
	EndIf
	
	RestArea(aArea)
return lRet

User Function zSaveMd2()
	Local aArea      := GetArea()
	Local lRet       := .T.
	Local oModelDad  := FWModelActive()
	Local cFilSX5    := oModelDad:GetValue('FORMCAB', 'X5_FILIAL')
	Local cCodigo    := SubStr(oModelDad:GetValue('FORMCAB', 'X5_CHAVE'), 1, TamSX3('X5_TABELA')[01])
	Local cDescri    := oModelDad:GetValue('FORMCAB', 'X5_DESCRI')
	Local nOpc       := oModelDad:GetOperation()
	Local oModelGrid := oModelDad:GetModel('SX5DETAIL')
	Local aHeadAux   := oModelGrid:aHeader
	Local aColsAux   := oModelGrid:aCols
	Local nPosChave  := aScan(aHeadAux, {|x| AllTrim(Upper(x[2])) == AllTrim("X5_CHAVE")})
	Local nPosDescPt := aScan(aHeadAux, {|x| AllTrim(Upper(x[2])) == AllTrim("X5_DESCRI")})
	Local nPosDescSp := aScan(aHeadAux, {|x| AllTrim(Upper(x[2])) == AllTrim("X5_DESCSPA")})
	Local nPosDescEn := aScan(aHeadAux, {|x| AllTrim(Upper(x[2])) == AllTrim("X5_DESCENG")})
	Local nAtual     := 0
	
	DbSelectArea('SX5')
	SX5->(DbSetOrder(1)) //X5_FILIAL + X5_TABELA + X5_CHAVE
	
	//Se for Inclusão
	If nOpc == MODEL_OPERATION_INSERT
		//Cria o registro na tabela 00 (Cabeçalho de tabelas)
		RecLock('SX5', .T.)
			X5_FILIAL   := cFilSX5
			X5_TABELA   := '00'
			X5_CHAVE    := cCodigo
			X5_DESCRI   := cDescri
			X5_DESCSPA  := cDescri
			X5_DESCENG  := cDescri
		SX5->(MsUnlock())
		
		//Percorre as linhas da grid
		For nAtual := 1 To Len(aColsAux)
			//Se a linha não estiver excluída, inclui o registro
			If ! aColsAux[nAtual][Len(aHeadAux)+1]
				RecLock('SX5', .T.)
					X5_FILIAL   := cFilSX5
					X5_TABELA   := cCodigo
					X5_CHAVE    := aColsAux[nAtual][nPosChave]
					X5_DESCRI   := aColsAux[nAtual][nPosDescPt]
					X5_DESCSPA  := aColsAux[nAtual][nPosDescSp]
					X5_DESCENG  := aColsAux[nAtual][nPosDescEn]
				SX5->(MsUnlock())
			EndIf
		Next
		
	//Se for Alteração
	ElseIf nOpc == MODEL_OPERATION_UPDATE
		//Se conseguir posicionar, altera a descrição digitada
		If SX5->(DbSeek(cFilSX5 + '00' + cCodigo))
			RecLock('SX5', .F.)
				X5_DESCRI   := cDescri
				X5_DESCSPA  := cDescri
				X5_DESCENG  := cDescri
			SX5->(MsUnlock())
		EndIf
		
		//Percorre o acols
		For nAtual := 1 To Len(aColsAux)
			//Se a linha estiver excluída
			If aColsAux[nAtual][Len(aHeadAux)+1]
				//Se conseguir posicionar, exclui o registro 
				If SX5->(DbSeek(cFilSX5 + cCodigo + aColsAux[nAtual][nPosChave]))
					RecLock('SX5', .F.)
						DbDelete()
					SX5->(MsUnlock())
				EndIf
				
			Else
				//Se conseguir posicionar no registro, será alteração
				If SX5->(DbSeek(cFilSX5 + cCodigo + aColsAux[nAtual][nPosChave]))
					RecLock('SX5', .F.)
				
				//Senão, será inclusão
				Else
					RecLock('SX5', .T.)
					X5_FILIAL := cFilSX5
					X5_TABELA := cCodigo
					X5_CHAVE    := aColsAux[nAtual][nPosChave]
				EndIf
				
				X5_DESCRI   := aColsAux[nAtual][nPosDescPt]
				X5_DESCSPA  := aColsAux[nAtual][nPosDescSp]
				X5_DESCENG  := aColsAux[nAtual][nPosDescEn]
				SX5->(MsUnlock())
			EndIf
		Next
		
	//Se for Exclusão
	ElseIf nOpc == MODEL_OPERATION_DELETE
		//Se conseguir posicionar, exclui o registro
		If SX5->(DbSeek(cFilSX5 + '00' + cCodigo))
			RecLock('SX5', .F.)
				DbDelete()
			SX5->(MsUnlock())
		EndIf
		
		//Percorre a grid
		For nAtual := 1 To Len(aColsAux)
			//Se conseguir posicionar, exclui o registro
			If SX5->(DbSeek(cFilSX5 + cCodigo + aColsAux[nAtual][nPosChave]))
				RecLock('SX5', .F.)
					DbDelete()
				SX5->(MsUnlock())
			EndIf
		Next
	EndIf
	
	//Se não for inclusão, volta o INCLUI para .T. (bug ao utilizar a Exclusão, antes da Inclusão)
	If nOpc != MODEL_OPERATION_INSERT
		INCLUI := .T.
	EndIf
	
	RestArea(aArea)
return lRet
