//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

static cNomeArq:="zMvcMain2"
static cTitulo := "TESTE_EDU"

/*/{Protheus.doc} U_MyMvc----------------------------------------------------------------------
@type function
@version  12
@author Eduardo Paro de SImoni
@since 04/06/2021
//---------------------------------------------------------------------------------------------------/*/
function U_MyMvc()
	local cView:='VIEWDEF.'+cNomeArq

	FWExecView( 'CAB + DETAIL', cView, MODEL_OPERATION_INSERT, , { || .T. }, , 30 )

return

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
	local oStCab   := FWFormModelStruct():New()
    local oStDet1  := FWFormModelStruct():New()

	//Adiciona a tabela cABEÇALHO
	oStCab:AddTable('SB1', {'B1_FILIAL', 'B1_COD'}, "Cabecalho SB1")
	
	//Adiciona o campo de Código da Tabela
	oStCab:AddField(;
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
	
    	oStDet1:AddField(;
		"DESCRICAO DETAIL",;                                                                    // [01]  C   Titulo do campo
		"DESCRICAO DETAIL",;                                                                    // [02]  C   ToolTip do campo
		"B1_DESC",;                                                                  // [03]  C   Id do Field
		"C",;                                                                         // [04]  C   Tipo do campo
		TamSX3("B1_DESC")[1],;                                                      // [05]  N   Tamanho do campo
		0,;                                                                           // [06]  N   Decimal do campo
		nil,;                                                                         // [07]  B   Code-block de validação do campo
		nil,;                                                                         // [08]  B   Code-block de validação When do campo
		{},;                                                                          // [09]  A   Lista de valores permitido do campo
		.T.,;                                                                         // [10]  L   Indica se o campo tem preenchimento obrigatório
		FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SB1->B1_DESC,'')" ),;    // [11]  B   Code-block de inicializacao do campo
		.T.,;                                                                         // [12]  L   Indica se trata-se de um campo chave
		.F.,;                                                                         // [13]  L   Indica se o campo pode receber valor em uma operação de update.
		.F.)                                                                          // [14]  L   Indica se o campo é virtual
	
	oModel:AddFields("FORMCAB",/*cOwner*/,oStCab)
	oModel:AddFields('FORMDETAIL','FORMCAB',oStDet1)
	
	//Adiciona o relacionamento de Filho, Pai
	aAdd(aSB1Rel, {'B1_COD', 'Iif(!INCLUI, SB1->B1_COD,  "")'} ) 
	
	//Criando o relacionamento
	oModel:SetRelation('FORMDETAIL', aSB1Rel, SB1->(IndexKey(1)))
	
	//Setando outras informações do Modelo de Dados
    oModel:GetModel("FORMCAB"):SetDescription("Formulário do Cadastro "+cTitulo)
    oModel:GetModel("FORMDETAIL"):SetDescription("Formulário do Cadastro "+cTitulo)

	oModel:SetPrimaryKey({})

Return oModel


/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@since 04/06/2021
//---------------------------------------------------------------------------------------------------/*/
static function ViewDef()
	local oModel     := FWLoadModel(cNomeArq)
	local oStCab     := FWFormViewStruct():New()
	local oStDet1   := FWFormViewStruct():New()
	local oView      := nil
	
	//Adicionando o campo Chave para ser exibido
	
	oStCab:AddField(;
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

        oStDet1:AddField(;
		"B1_DESC",;               // [01]  C   Nome do Campo
		"01",;                      // [02]  C   Ordem
		"DESCRICAO DETAIL",;               // [03]  C   Titulo do campo
		X3Descric('B1_DESC'),;    // [04]  C   Descricao do campo
		nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("B1_DESC"),;    // [07]  C   Picture
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
	
	//Criando a view que será o retorno da função e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_CAB", oStCab, "FORMCAB")
	oView:AddField('VIEW_DETAIL1',oStDet1,'FORMDETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('DETAIL1',70)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_CAB','CABEC')
	oView:SetOwnerView('VIEW_DETAIL1','DETAIL1')
	
	//Habilitando título
	oView:EnableTitleView('VIEW_CAB','Cabeçalho ')
	oView:EnableTitleView('VIEW_DETAIL1','Itens ')
	
	//Tratativa padrão para fechar a tela
	oView:SetCloseOnOk({||.T.})
	
	oView:AddOtherObject("VIEW_DETAIL1", {|oPanel| InfoPreve(oPanel)})
	//Remove os campos de Filial e Tabela da DETAIL1
	//oStDet1:RemoveField('B1_FILIAL')
	//oStDet1:RemoveField('B1_COD')
Return oView

/*/{Protheus.doc}----------------------------------------------------------------------
@type function 
@version  12
@author Eduardo Paro de SImoni
@since 04/06/2021
//---------------------------------------------------------------------------------------------------/*/
Static Function InfoPreve(oPanel)
    local cHtml := ''
    Local lHtml := .T.
    local oFont := TFont():New('Courier new',,26,.T.)
   
    cHtml += "  <h2>TESTE LISTA ORDENADA CLIENTE</h2>
    cHtml += "  <ol>
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
    cHtml += "      <li> item </li>"
	cHtml += "      <li> item </li>"
	cHtml += "      <li> item </li>"
	cHtml += "      <li> item </li>"
    cHtml += "  </ol>
    cHtml += "  <br>

    oSay := TSay():New(110,350,{||cHtml},oPanel,nil,oFont,nil,nil,nil,.T.,nil,nil,830,200,nil,nil,nil,nil,nil,lHtml)
Return 
