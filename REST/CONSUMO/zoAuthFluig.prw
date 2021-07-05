#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include 'RestFul.CH'
#Include 'tbiconn.ch'
#Include "TopConn.ch"

/*/{Protheus.doc}----------------------------------------------------------------------
@type function 
@version  12
@author Eduardo Paro de SImoni
@since 16/06/2021
@gitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
Function u_StatWsFl() as undefined
   // //Endereco
   local cEnderWS       := "http://paladino:8083"           as string
   local cPath          := "/api/public/ecm/dataset/search" as string
   local cParams        := "&datasetId=colleague"           as string //DEVE SER INFORMADO O '&'  AO INVES DO '?'
   
   //FWoAuthURL
   local cRequest       := "http://paladino:8083/portal/api/rest/oauth/access_token"   as string
   local cAuthorize     := "http://paladino:8083/portal/api/rest/oauth/authorize"      as string
   local cAccess        := "http://paladino:8083/portal/api/rest/oauth/request_token"  as string
   local cCallback      := cEnderWS+cPath

   //FWoAuthClient
   local cConsumer      := "chaveEdu" as string //CONSUMER KEY 
   local cSecret        := "chaveEdu"as string //Consumer Secret
   local cToken         := "4ba21a47-d9cd-4a38-8ca6-3b02e73463ce804d1fe2-61b6-4c52-ac6a-0f090452fc15" as string//TOKEN
   local cAccToken      := "bc5ecacc-24ea-4063-a3ae-24b0d94249a9" as string//secret token, ou access token
   
   local aHeadOut:={} as array
   local CHEADRET, cBody:=""as string

   oURL     := FWoAuthURL():New( cRequest , cAuthorize , cAccess )
   oClient  := FWoAuthClient():New( cConsumer , cSecret , oURL , "" )

   oClient:cOAuthVersion   := "1.0" 
   oClient:cContentType    := "Content-Type: application/json"   
   
   oClient:SetMethodSignature("HMAC-SHA1")
   oClient:setToken(cAccToken)
   oClient:SetSecretToken(cToken)
   oClient:SetConsumerKey(cConsumer)
   oClient:SetSecretKey(cSecret)
   
   //MONTAGEM DO HEADER
   For nX := 1 To Len(oClient:aParametros)
        AAdd(aHeadOut, oClient:aParametros[nX][1] + ':' + oClient:aParametros[nX][2] )
    Next
 
   oClient:SetURLAuthorize(cAuthorize)
   oClient:SetURLRequestToken(cAccess)
   oClient:SetContentType("Content-Type: application/json")

   oClient:MakeSignBaseString('GET',cCallback)
   oClient:MakeSignature()

    cUrl:=cEnderWS+cPath
     //FWOAUTHCLIENT():Get( cURL, cQuery, cBody, aHeadOut, cHeadRet, lUTF8 )->cResponse
   cRetPost := oClient:Get(cUrl, cParams, cBody, aHeadOut, @cHeadRet, .T.)

Return



