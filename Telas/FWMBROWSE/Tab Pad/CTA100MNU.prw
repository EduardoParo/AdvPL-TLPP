#Include 'Protheus.ch'
#Include "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
/*-------------------------------------------------
Descri��o:
localIZA��O : Function CNTA100 - Rotina respons�vel
 pela Manuten��o de Contratos.

EM QUE PONTO : Antes de montar a tela do browser.

UTILIZA��O : Para adicionar bot�es no menu principal da
 rotina.

Eventos
Acionar a rotina "Contratos" pelo menu do m�dulo SIGAGCT.

Programa Fonte
CNTA100.PRW
Sintaxe
CTA100MNU - Manuten��o de contratos ( ) --> Nulo

Retorno
Nulo(nulo)
N�o h� retorno.
Exemplos
User Function CTA100MNU//Customizacoes espec�ficasReturn 
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

    //��������������������������������������������������������������Ŀ
	//� Define o cabecalho da tela de atualizacoes                   �
	//����������������������������������������������������������������
	PRIVATE cTitulo := OemToAnsi("TOTVS - EDU") 
	
    DbSelectArea("SB1")

    //Instanciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
 
    //Setando a tabela de Cadastro de Limites Extras
    oBrowse:SetAlias('SB1')

    //Setando o menu da User
    oBrowse:setMenuDef("CTA100MNU")

    //Setando a descri��o da rotina
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
Programa  �MenuDef  
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
    //Cria��o do objeto do modelo de dados
    local oModel := Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    local oStSB1 := FWFormStruct(1, "SB1")

    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("MODCTA100MNU",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 

    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMSB1",/*cOwner*/,oStSB1)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'B1_FILIAL','B1_COD'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro CTA100MNU")
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMSB1"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel


//-------------------------------------------------------------------
/*{Protheus.doc} ViewDef
//-------------------------------------------------------------------*/
Static Function ViewDef()
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    local oModel := FWLoadModel("CTA100MNU")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    local oStSB1 := FWFormStruct(2, "SB1")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SB1_NOME|SB1_DTAFAL|'}
     
    //Criando oView como nulo
    local oView := Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)

    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_SB1", oStSB1, "FORMSB1")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_SB1', 'Dados CTA100MNU' )  
     
    //For�a o fechamento da janela na confirma��o
    //oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_SB1","TELA")


Return oView


