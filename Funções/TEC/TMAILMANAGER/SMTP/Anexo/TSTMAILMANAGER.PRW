#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TOTVS.CH"

#DEFINE EMAIL_ACCOUNT   "contato@.com.br"
#DEFINE EMAIL_PASSWORD  "*******"
#DEFINE EMAIL_SERVER    "smtp.com.br"

/*/{Protheus.doc}----------------------------------------------------------------------
@type function 
@version  12
@author Eduardo Paro de SImoni
@since 08/06/2021
//---------------------------------------------------------------------------------------------------/*/
function U_tsTovs() //ok teste com anexo e body
//<<NAO MANIPULAR O FONTE>> <<APENAS CHUMBE OS VALORES DE SEU AMBIENTE NAS VARIAVERIS>>
	local oMail, oMessage := nil as object
	local nErro as numeric
	local aFiles:={} as Array 
	local cPath as string

	cPath := IIf(IsSrvUnix(),"/spool/", "\spool\")//diretorio na rede

	Aadd(aFiles,cPath + "teste.txt"     )
	//cFile:= GetSrvProfString('RootPath','') + cFile

	//Configuração dos dados do e-mail
	oMail := TMailManager():New()
	//oMail:SetUseSSL( .F. )
	//oMail:SetUseTLS( .T. )
	oMail:Init( '', EMAIL_SERVER , EMAIL_ACCOUNT, EMAIL_PASSWORD, 0, 587 )
	oMail:SetSmtpTimeOut( 120 )

	//Verifica conexão SMTP
	conout( 'Conectando do SMTP' )
	nErro := oMail:SmtpConnect()
	If nErro <> 0
		conout( "ERROR:" + oMail:GetErrorString( nErro ) )
		oMail:SMTPDisconnect()
		return .F.
	Endif

	//Verifica autenticação
	nErro := oMail:SmtpAuth( EMAIL_ACCOUNT ,EMAIL_PASSWORD )
	If nErro <> 0
		conout( "ERROR:" + oMail:GetErrorString( nErro ) )
		oMail:SMTPDisconnect()
		return .F.
	Endif

	//Configuração da mensagem do e-mail
    /*xRet := MemoWrite( cFile, "attachment 1 e-mail" )// Escreve no arquivo
	If !xRet
    cMsg := "Could not create attachment " + cFile
    conout( cMsg )
    return
	endif*/

  	oMessage := TMailMessage():New()
  	oMessage:Clear()
  	oMessage:cFrom                  := EMAIL_ACCOUNT
  	oMessage:cTo                    := "eduardo.paro@totvs.com.br"
  	oMessage:cCc                    := ""
  	oMessage:cSubject               := "Teste de Envio de E-mail " + time()
  	oMessage:cBody                  := "<hr>Envio de e-mail via Protheus<hr>"
  

	for nX = 1 to len(aFiles)
		if file(aFiles[nX])//verifica a existencia do arquivo //IMPORTANTE
   			xRet := oMessage:AttachFile( aFiles[nX] )
			if xRet < 0
   			    	cMsg := "Could not attach file " + cFile
   			   		conout( cMsg )
   			   		return
			endif
		endif
	next

    //Envia e-mail
  nErro := oMessage:Send( oMail )

    //Verifica se o e-mail foi enviado
	if nErro <> 0
       conout( "ERROR:" + oMail:GetErrorString( nErro ) )
          oMail:SMTPDisconnect()
          return .F.
	Endif

  conout( 'Desconectando do SMTP' )
  oMail:SMTPDisconnect()

return .T.
