#include 'TOTVS.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} @author Eduardo Paro de Simoni
    Exemplo de FwCalendar
-------------------------------------------------------------------*/
function U_zFwCalendar()
        local oDlg      := nil
        local oCalend   := nil
        local aCoors    := FwGetDialogSize()
        local cTxtCel   :=''
        Define MsDialog oDlg Title 'Calendário de Edu' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

        cTxtCel:= '<h3>Teste de Estilo .css </h3> '
        cTxtCel+= '<font color="red">Este texto é vermelho!</font> <br> '
        cTxtCel+= '<font color="blue">Este texto é azul!</font><br>     '
        cTxtCel+= '<font color="yellow">Este texto é amarelo!</font><br> '
        cTxtCel+= '<font color="green">Este texto é verde!</font>'

        oCalend := FwCalendar():New(Month(dDataBase), Year(dDataBase))
        oCalend:aNomeCol := {'Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Semana'}
        oCalend:lWeekColumn := .F.
        oCalend:lFooterLine := .F.
        oCalend:Activate( oDlg ) 
        
        For nI := 1 To Len( oCalend:aCell ) 
                If oCalend:aCell[nI][4] 
                        //oCalend:SetInfo( oCalend:aCell[nI][1], '<h1 style="background:red">Eduardo</h1>' )
                        oCalend:SetInfo( oCalend:aCell[nI][1], cTxtCel )
                endif            
        Next
        Activate MsDialog oDlg Centered
Return
