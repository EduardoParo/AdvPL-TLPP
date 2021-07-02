#INCLUDE "Protheus.ch"
/*-------------------------------------------
https://tdn.totvs.com/pages/viewpage.action?pageId=223912171
SELECT N3_BAIXA,* FROM SN3990 WHERE N3_CBASE ='0000024   ' order by R_E_C_N_O_ desc 
SELECT FN6_NUMNF,* FROM FN6990 order by R_E_C_N_O_ desc  
---------------------------------------------*/
Function U_MyATF036()
    local aArea := GetArea()
    local cBase := "0000024   "
    local cItem := "0011"
    local cTipo := "13"
    local cBaixa := "0"
    local nQtdBaixa := 1
    local cMotivo := "01"
    local cMetDepr := ''
    local cNumNF := "NFATV0001"
    local cSerieNF := "1"
    local nValNF := 100

    local aCab := {}
    local aAtivo := {}
    local aParam := {}

    private lMsErroAuto := .F.
    private lMsHelpAuto := .T.

    RpcSetEnv("99","01","Administrador","","ATF","ATFA036",{"FN6","SN3"})

    SN3->(dbGoTop())
    SN3->(dbSetOrder(1)) //N3_FILIAL, N3_CBASE, N3_ITEM, N3_TIPO, N3_BAIXA, N3_SEQ, R_E_C_N_O_, D_E_L_E_T_
    if !SN3->(DbSeek(xFilial("SN3") + cBase + cItem + cTipo + cBaixa ))
        fwAlertInfo("Não foi localizado o ativo")
        return .F.
    EndIf

    cMetDepr := GetMV('MV_ATFDPBX')

    aCab := {  {"FN6_FILIAL" ,XFilial("FN6")    ,nil},;
               {"FN6_CBASE"  ,SN3->N3_CBASE     ,nil},;
               {"FN6_CITEM"  ,SN3->N3_ITEM      ,nil},;
               {"FN6_MOTIVO" ,cMotivo           ,nil},;
               {"FN6_BAIXA"  ,SN3->N3_BAIXA     ,nil},;
               {"FN6_QTDBX"  ,nQtdBaixa         ,nil},;
               {"FN6_DTBAIX" ,dDatabase         ,nil},;
               {"FN6_NUMNF"  ,cNumNF            ,nil},;
               {"FN6_SERIE"  ,cSerieNF          ,nil},;
               {"FN6_VALNF"  ,nValNF            ,nil}}

    aAtivo := { {"N3_FILIAL" ,XFilial("SN3")        ,nil},;
                {"N3_CBASE"  ,SN3->N3_CBASE         ,nil},;
                {"N3_ITEM"   ,SN3->N3_ITEM          ,nil},;
                {"N3_TIPO"   ,SN3->N3_TIPO          ,nil},;
                {"N3_BAIXA"  ,SN3->N3_BAIXA         ,nil},;
                {"N3_TPSALDO",SN3->N3_TPSALDO       ,nil}}

    Begin Transaction //está na documentação

        MsExecAuto({|a,b,c,d,e,f|ATFA036(a,b,c,d,e,f)},aCab,aAtivo,3,,.T./*lBaixaTodos*/,aParam)
        If !lMsErroAuto
            fwAlertSuccess("Sucesso!")
        else
            MostraErro()
            DisarmTransaction()
        EndIf
    End Transaction

    RestArea(aArea)

Return

