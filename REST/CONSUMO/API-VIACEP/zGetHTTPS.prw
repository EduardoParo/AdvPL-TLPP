#Include "TOTVS.ch"
#INCLUDE'TBICONN.CH'

/*/{Protheus.doc}----------------------------------------------------------------------
@type function 
@version  12
@author Eduardo Paro de SImoni
@since 16/06/2021
github.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
Function U_zget() as undefined
	local cURl      :="https://viacep.com.br" as string
        local oRest     := FwRest():New(cURl) as object
	local cResource := "/ws/"+ALLTRIM('02511000')+"/json/unicode/" as string
	local aHeader   := {} as array
        local cErro, nErro, cRest  as undefined

	//HEADER
	AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
	AAdd(aHeader, "Accept: application/json")
	AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")

    //TESTE HTTPGET
    cRest  := HTTPGet( cURL+cResource, "", 10, aHeader )
    If !empty(cRest )
		conOut("VERBO: GET ", cRest )
		nErro := HttpGetStatus(@cErro)
    EndIf

    //TESTE COM FWREST
    oRest:NTIMEOUT:=10
	oRest:SetPath(cResource)

	If (oRest:Get(aHeader))
		ConOut("GET: " + oRest:GetResult())
        nStatus:= HttpGetStatus(@cErro)

	Else
		nStatus:= HttpGetStatus(@cErro)
		ConOut("GET: " + oRest:GetLastError())
	EndIf

return
