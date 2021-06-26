#include "protheus.ch"
#include "rptdef.ch"

/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@GitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
function u_myTReport()
    local oReport as object
    local oSection as object
    local cAlias := "SED" as string
    local cTitle := "Naturezas" as string
    local cFile := "SED_Nat" as string
    
    RpcSetEnv("99","01","Administrador","","FIN","",{"SED"})

    oReport := TReport():New(cFile, cTitle, /*uParam*/, {|oReport| oSection:print()} )

    oSection := TRSection():New(oReport, cTitle, cAlias, /*aOrder*/, .T.)

    oReport:lPreview:= .F.
    oReport:setFile(cFile)
    
    oReport:nDevice := 8 	//1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
    oReport:cEmail  		:= "EDUARDO.PARO@HOTMAIL.COM;EDUARDO.SYSTEM96@GMAIL.COM;eduardo.paro@aluno.unip.com"
	
    oReport:nEnvironment:= 1 // 1 -Server / 2- Cliente
    oReport:nRemoteType:= NO_REMOTE
    oReport:cDescription 	:= "TESTE E-MAIL"
    oReport:cFile 			:= "TESTE_"+ StrTran(Time(),":","")
	oReport:cPathPDF 		:= "\spool\"
	oReport:cTitle			:= "TESTE E-MAIL"
	oReport:lParamPage 		:= .F.
    
    oReport:print()
    
    FreeObj(oReport)
    FreeObj(oSection)
    
    rpcClearEnv()
return nil
