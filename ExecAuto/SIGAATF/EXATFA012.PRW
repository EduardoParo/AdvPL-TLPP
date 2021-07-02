#include "rwmake.ch"
#include "TOTVS.ch"
#include "TBICONN.ch"

/*--------------------------------------------------------------
select * from SN1990 order by R_E_C_N_O_ desc 
select * from SN3990 order by R_E_C_N_O_ desc 
https://tdn.totvs.com/pages/releaseview.action?pageId=551440375 //doc
N1_FILIAL, N1_CBASE, N1_ITEM, R_E_C_N_O_, D_E_L_E_T_
N3_FILIAL, N3_CBASE, N3_ITEM, N3_TIPO, N3_BAIXA, N3_SEQ, R_E_C_N_O_, D_E_L_E_T_
*/

/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@since 09/06/2021
//---------------------------------------------------------------------------------------------------/*/
function u_MyA012
	//<<NAO MANIPULAR O FONTE>> APENAS CHUMBE OS VALORES NAS VARIAVEIS
  local aArea
  local cBase, cItem ,cGrupo, cChapa , cDescric:= " "
  local cTipo := "13"
  local cPatrim := "N"
  local dIndDepr 
  local cHistor := "TESTE EXEC"
  local cContab := "02       "

  local cCusto := "02       "
  local cSubCon :=""
  local cClvlCon:=""

  local nQtd := 1
  local nValor := 10
  local nTaxa := 1
  local nTaxa2:= 1  

  local nX
  local aParam := {}
  local aCab := {}
  local aItens := {}
  private lMsErroAuto := .F.
  private lMsHelpAuto := .T.

  	//<<NAO MANIPULAR O FONTE>> APENAS CHUMBE OS VALORES DE SEU AMBIENTE
  RpcSetEnv("99","01","Administrador","","ATF","Atfa012",{"SN1","SN3"})
        
    /*Laço para inclusao de mais Ativos 
    ----------------------------------------------*/
    For nX :=1 To 1

      aArea := GetArea()

      cBase   :=PadR("AG"+cValToChar(nX),TamSX3("A3_COD")[1])
      cItem   :=PadR("AG"+cValToChar(nX),TamSX3("N1_ITEM")[1])
      cChapa  :=PadR("AG"+cValToChar(nX),TamSX3("N1_CHAPA")[1])
      cDescric:=PadR("EXECAUT : "+ cValToChar(nX), TamSX3("N1_CHAPA")[1])
      dIndDepr := RetDinDepr(dDataBase)

      aCab := {}
      AAdd(aCab,{"N1_CBASE"   , cBase     ,NIL})
      AAdd(aCab,{"N1_ITEM"    , cItem     ,NIL})
      AAdd(aCab,{"N1_AQUISIC" , dDataBase ,NIL})
      AAdd(aCab,{"N1_DESCRIC" , cDescric  ,NIL})
      AAdd(aCab,{"N1_QUANTD"  , nQtd      ,NIL})
      AAdd(aCab,{"N1_CHAPA"   , cChapa    ,NIL})
      AAdd(aCab,{"N1_PATRIM"  , cPatrim   ,NIL})
      AAdd(aCab,{"N1_GRUPO"   , cGrupo    ,NIL})
      AAdd(aCab,{"N1_MARGEM"   ,""  ,NIL})
      
      aItens := {}
      //-- Preenche item 1
      AAdd(aItens,{;
                  {"N3_CBASE"   , cBase       ,NIL},;
                  {"N3_ITEM"    , cItem       ,NIL},;
                  {"N3_TIPO"    , cTipo       ,NIL},;
                  {"N3_BAIXA"   , "0"         ,NIL},;
                  {"N3_HISTOR"  , cHistor     ,NIL},;
                  {"N3_CCONTAB" , cContab     ,NIL},;
                  {"N3_CUSTBEM" , cCusto      ,NIL},;
                  {"N3_CDEPREC" , cContab     ,NIL},;
                  {"N3_CDESP"   , cContab     ,NIL},;
                  {"N3_CCORREC" , cContab     ,NIL},;
                  {"N3_CCUSTO"  , cCusto      ,NIL},;
                  {"N3_DINDEPR" , dIndDepr    ,NIL},;
                  {"N3_VORIG1"  , nValor      ,NIL},;
                  {"N3_TXDEPR1" , nTaxa       ,NIL},;
                  {"N3_VORIG2"  , nValor      ,NIL},;
                  {"N3_TXDEPR2" , nTaxa       ,NIL},;
                  {"N3_VORIG3"  , nValor      ,NIL},;
                  {"N3_TXDEPR3" , nTaxa       ,NIL},;
                  {"N3_VORIG4"  , nValor      ,NIL},;
                  {"N3_TXDEPR4" , nTaxa       ,NIL},;
                  {"N3_VORIG5"  , nValor      ,NIL},;
                  {"N3_TXDEPR5" , nTaxa       ,NIL},;
                  {"N3_VRDACM1" , nTaxa2      ,NIL},;
                  {"N3_SUBCCON" , cSubCon     ,NIL},;
                  {"N3_CLVLCON" , cClvlCon    ,NIL};
                   })

      //Controle de transaçao informado na docuemntação da ExecAuto
      Begin Transaction

        conOut('Inicio da rotina Automatica '+ Time())
        MSExecAuto({|x,y,z| Atfa012(x,y,z)},aCab,aItens,3,aParam)
        conOut('FIM' +Time())

        If lMsErroAuto 
             MostraErro()
             DisarmTransaction()
        else
          ConfirmSx8()
          fwAlertSuccess('INCLUIDO ATIVO N3_CBASE: '+ cBase + ", N3_ITEM : "+cItem+ ", N3_CUSTBEM : "+cCusto+ ", N3_SUBCCON : "+cSubCon+ ", N3_CLVLCON : "+cClvlCon)
        ENDIF    

        RestArea(aArea)
      End Transaction

      ////A SEGUNDA EXECUÇAO MUDEI OS CAMPOS SOLICITADOS
      //cCusto  :="CENTR0002"
      //cSubCon :="000000002"
      //cClvlCon:="000000002"
        
    Next nX

  RpcClearEnv()

Return 
