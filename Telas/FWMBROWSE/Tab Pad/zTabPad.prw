//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variaveis Estaticas
static cTitulo := "Modelo 1"
static cNomeArq :="zTabPad"

/*/{Protheus.doc} U_zFwmBr----------------------------------------------------------------------
description Teste da classe FWMBROWSE com uma tabela padrao
@type function
@version  12
@author Eduardo Paro de SImoni
@since 19/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
function U_zFwmBr()
	local aArea   := GetArea()
	local oBrowse
	
	//Instanciando FWMBrowse - Somente com dicionario de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SB1")

	//Setando a descricao da rotina
	oBrowse:SetDescription(cTitulo)
	
	//oBrowse:SetFilterDefault("SB1->B1_XMEMO <>'' .AND. SB1->B1_TIPO == 'AI' ")
	//Legendas
	oBrowse:AddLegend( "SB1->B1_TIPO == 'PA'", "GREEN",	"Original" )
	oBrowse:AddLegend( "SB1->B1_TIPO == 'MP'", "RED",	"N√£o Original" )
	
	oBrowse:setMenuDef(cNomeArq)
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
return Nil

/*/{Protheus.doc} MenuDef----------------------------------------------------------------------
description Teste da classe FWMBROWSE com uma tabela padrao
@type function
@version  12
@author Eduardo Paro de SImoni
@since 19/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
static Function MenuDef()
    local aRotina := FwMVCMenu(cNomeArq)

return aRotina

/*/{Protheus.doc} ModelDef----------------------------------------------------------------------
description Teste da classe FWMBROWSE com uma tabela padrao
@type function
@version  12
@author Eduardo Paro de SImoni
@since 19/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
static Function ModelDef()
	//Criacao do objeto do modelo de dados
	local oModel := Nil
	
	//Criacao da estrutura de dados utilizada na interface
	local oStSB1 := FWFormStruct(1, "SB1")
	
	//Instanciando o modelo, nao e recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("zMVCMd1M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	
	//Atribuindo formularios para o modelo
	oModel:AddFields("FORMSB1",/*cOwner*/,oStSB1)
	
	//Setando a chave primaria da rotina
	oModel:SetPrimaryKey({'SB1_FILIAL','SB1_COD'})
	
	//Adicionando descri√cao ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descricao do formulario
	oModel:GetModel("FORMSB1"):SetDescription("Formulario do Cadastro "+cTitulo)
return oModel

/*/{Protheus.doc} ViewDef----------------------------------------------------------------------
description Teste da classe FWMBROWSE com uma tabela padrao
@type function
@version  12
@author Eduardo Paro de SImoni
@since 19/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
static Function ViewDef()
	//Criacaoo do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	local oModel := FWLoadModel(cNomeArq)
	
	//Criacaoo da estrutura de dados utilizada na interface do cadastro de Autor
	local oStSB1 := FWFormStruct(2, "SB1")  //pode se usar um terceiro parametro para filtrar os campos exibidos { |cCampo| cCampo $ 'SB1_NOME|SB1_DTAFAL|'}
	
	//Criando oView como nulo
	local oView := Nil

	//Criando a view que sera o retorno da fun√caoo e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formularios para interface
	oView:AddField("VIEW_SB1", oStSB1, "FORMSB1")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando ti≠tulo do formulario
	oView:EnableTitleView('VIEW_SB1', 'Dados do Grupo de Produtos' )  
	
	//Forca o fechamento da janela na confirma√caoo
	oView:SetCloseOnOk({||.T.})

	//O formulario da interface sera° colocado dentro do container
	oView:SetOwnerView("VIEW_SB1","TELA")
return oView



