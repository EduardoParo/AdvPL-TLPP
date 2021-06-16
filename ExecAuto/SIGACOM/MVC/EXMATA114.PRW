#include 'TOTVS.ch'
#include 'FWMVCDef.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} ExMata114                                                                              
@author Eduardo Paro de Simoni
@version P12
//-------------------------------------------------------------------*/
function U_Incluir1() as undefined
    local oModel    := nil as object
    
    //Preparação do Ambiente
    RpcSetEnv("99","01","Administrador","","COM","MATA114",{"SAL","DBL",""})
    
    oModel := FwLoadModel("MATA114")
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()
    
    //MASTER ModelSAL
    oModel:SetValue("ModelSAL" ,"AL_COD"       ,"000002")
    oModel:SetValue("ModelSAL" ,"AL_DESC"      ,"TESTE02             ")
    
    //DETAIL DetailSAL
    oModel:SetValue("DetailSAL","AL_ITEM"     ,"01")
    oModel:SetValue("DetailSAL","AL_APROV"     ,"000001")
    oModel:SetValue("DetailSAL" ,"AL_PERFIL"    ,"PERFIL")
    oModel:SetValue("DetailSAL" ,"AL_USER"      ,"000000")
    oModel:SetValue("DetailSAL" ,"AL_NIVEL"     ,"1 ")
    
    //DETAIL DetailDBL
    oModel:SetValue("DetailDBL" , "DBL_GRUPO"    , "000001")
    oModel:SetValue("DetailDBL" , "DBL_ITEM"     , "01")
    oModel:SetValue("DetailDBL" , "DBL_CC"       , "CENTR0001")
    
    //DETAIL DetailDHM
    oModel:SetValue("DetailDHM" , "DHM_GRUPO"   , "")
    oModel:SetValue("DetailDHM" , "DHM_APROV"   , "")
    oModel:SetValue("DetailDHM" , "DHM_TIPCOM"  , "")

    If oModel:VldData()
        oModel:CommitData()
        conout("Registro INCLUIDO!")
    Else
        VarInfo("Erro ao incluir",oModel:GetErrorMessage())
    EndIf
    oModel:DeActivate()
    oModel:Destroy()
    oModel := nil
  
return 
