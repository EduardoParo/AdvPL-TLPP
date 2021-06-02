#Include 'Protheus.ch'
#Include "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
/*-------------------------------------------------
Descrição:
localIZAÇÃO : Function CNTA100 - Rotina responsável
 pela Manutenção de Contratos.

EM QUE PONTO : Antes de montar a tela do browser.

UTILIZAÇÃO : Para adicionar botões no menu principal da
 rotina.

Eventos
Acionar a rotina "Contratos" pelo menu do módulo SIGAGCT.

Programa Fonte
CNTA100.PRW
Sintaxe
CTA100MNU - Manutenção de contratos ( ) --> Nulo

Retorno
Nulo(nulo)
Não há retorno.
Exemplos
User Function CTA100MNU//Customizacoes específicasReturn 
nil
-------------------------------------------------------*/
User Function CTA100MNU()
    
    ADD OPTION aRotina TITLE "PE CTA100MNU"	ACTION "U_myTotvs()" OPERATION MODEL_OPERATION_INSERT ACCESS 0 

Return

Function U_myTotvs()
	local oBrowse :=nil
    local aArea   := GetArea()
    local cFunAnt := FunName()
    local aRotAnt :=  If( Type('aRotina') <> 'A', {}, aClone(aRotina) )
    private aRotina := MenuDef() //ESTAVA DEFINIFO COMO LOCAL
    
    SetFunName("CTA100MNU")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o cabecalho da tela de atualizacoes                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE cTitulo := OemToAnsi("TOTVS - EDU") 
	
    DbSelectArea("SB1")

    //Instanciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
 
    //Setando a tabela de Cadastro de Limites Extras
    oBrowse:SetAlias('SB1')

    //Setando o menu da User
    oBrowse:setMenuDef("CTA100MNU")

    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    
    //Desabilita tela de detalhes
    oBrowse:DisableDetails()

    //Ativa a Browse
    oBrowse:Activate()

    SetFunName(cFunAnt)
    RestArea(aArea)
     aRotina := aRotAnt
Return
/*/------------------------------------------
Programa  ³MenuDef  
----------------------------------------------/*/
Static Function MenuDef()     
    local aRotina := {}
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.CTA100MNU" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 
    ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.CTA100MNU" OPERATION MODEL_OPERATION_INSERT ACCESS 0 
    ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.CTA100MNU" OPERATION MODEL_OPERATION_DELETE ACCESS 0 
Return(aRotina) 

//-------------------------------------------------------------------
/*{Protheus.doc} ModelDef
//-------------------------------------------------------------------*/
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    local oStSB1 := FWFormStruct(1, "SB1")

    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("MODCTA100MNU",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 

    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSB1",/*cOwner*/,oStSB1)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'B1_FILIAL','B1_COD'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro CTA100MNU")
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSB1"):SetDescription("Formulário do Cadastro "+cTitulo)
Return oModel


//-------------------------------------------------------------------
/*{Protheus.doc} ViewDef
//-------------------------------------------------------------------*/
Static Function ViewDef()
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    local oModel := FWLoadModel("CTA100MNU")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    local oStSB1 := FWFormStruct(2, "SB1")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SB1_NOME|SB1_DTAFAL|'}
     
    //Criando oView como nulo
    local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)

    //Atribuindo formulários para interface
    oView:AddField("VIEW_SB1", oStSB1, "FORMSB1")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SB1', 'Dados CTA100MNU' )  
     
    //Força o fechamento da janela na confirmação
    //oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SB1","TELA")


Return oView


