#include "TOTVS.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} U_zFwBr01----------------------------------------------------------------------
description Teste da classe FWBROWSE com uma tabela padrao
@type function
@version  12
@author Eduardo Paro de SImoni
@since 19/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
function U_zFwBr01()

    local oDlg		    := nil
    local bGetValues    := {|| MsgRun("Debug para verificar metodos", "Aguarde", {|| GeraDebug()})}
    local aFields       :={}
    private oBrowse     := nil

    //Preparacao do Ambiente
    //RpcSetEnv("99","01", "Administrador","")

    DbSelectArea("SB1")
    DbSetOrder(1)
    
    //Define a janela do Browse
    oDlg = TDialog():New(0, 0, 600, 800,,,,,,,,,,.T.)

    //Cria a gride
    oBrowse := FWBrowse():New(oDlg)
    oBrowse:SetDataTable(.T.)
    oBrowse:SetAlias("SB1")

    //Montagem das Colunas
    CreateColuns()

	Aadd(aFields,{"B1_COD"	, "B1_COD"      , "C", 20, 0,"@!"})
	Aadd(aFields,{"B1_DESC"	, "B1_DESC"     , "C", 50, 0,"@!"})
	Aadd(aFields,{"B1_TIPO"	, "B1_TIPO"     , "C", 2, 0,"@!"})
	
    //Indica os campos que serão apresentados na edição de filtros.             
    oBrowse:SetFieldFilter(aFields)
    oBrowse:SetUseFilter()

    //Desabilita opcao de impressï¿½o
    oBrowse:DisableReport()

    //Desabilita opcao de configuraï¿½ï¿½o
    //oBrowse:DisableConfig()
   
    //Define que as cï¿½lulas serï¿½o editadas e serï¿½o validadas por um Code-Block determinado
    oBrowse:SetEditCell(.T., {|lEsc, oBrowse| .T.}) //lEsc: Validaï¿½ï¿½o cancelada; oBrowse: Objeto FWBrowse

    oBrowse:SetDoubleClick( bGetValues )

    oBrowse:Activate()

    //Exibe a tela
    oDlg:Activate(,,, .T., {|| .T.})

return

/*/{Protheus.doc} CreateColuns----------------------------------------------------------------------
description Teste da classe FWBROWSE com uma tabela padrao
@type function
@version  12
@author Eduardo Paro de SImoni
@since 19/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
static function CreateColuns()

    private oColum := nil
 
    // Adiciona legenda no Browse
    oBrowse:AddLegend('B1_TIPO $ "AI|AR"',"GREEN","Chave teste 1")
    oBrowse:AddLegend('!(B1_TIPO $ "PA|PI")',"RED","Chave teste 2")
    
    // Adiciona as colunas do Browse
    oColumn := FWBrwColumn():New()
    oColumn:SetData({||B1_COD})
    oColumn:SetTitle(RetTitle("B1_COD"))
    oColumn:SetSize(3)
    oBrowse:SetColumns({oColumn})
    
    oColumn := FWBrwColumn():New()
    oColumn:SetData({||B1_DESC})
    oColumn:SetTitle(RetTitle("B1_DESC"))
    oColumn:SetSize(10)
    oBrowse:SetColumns({oColumn})
    
    oColumn := FWBrwColumn():New()
    oColumn:SetData({||B1_TIPO})
    oColumn:SetTitle(RetTitle("B1_TIPO"))
    oColumn:SetSize(40)
    oBrowse:SetColumns({oColumn})
    
    oColumn := FWBrwColumn():New()
    oColumn:SetData({||B1_UM})
    oColumn:SetTitle(RetTitle("B1_UM"))
    oColumn:SetSize(1)
    oBrowse:SetColumns({oColumn})

return 

/*/{Protheus.doc} GeraDebug----------------------------------------------------------------------
description Teste da classe FWBROWSE com uma tabela padrao
@type function
@version  12
@author Eduardo Paro de SImoni
@since 19/05/2021
@return return_type, return_description
//---------------------------------------------------------------------------------------------------/*/
static function GeraDebug()
    fwAlertInfo("Coluna posicionada : " + cValToChar(oBrowse:Colpos()))
    fwAlertInfo("Conteudo da Coluna : " + oBrowse:GetColumnData(oBrowse:Colpos()))
    oBrowse:GoTo( 2, .T. )
return


