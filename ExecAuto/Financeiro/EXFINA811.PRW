#include "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} 
ExecAuto Fina811()

@author Eduardo Paro de Simoni
@since 25/07/2020
@version 12.1.27
/*/
//-------------------------------------------------------------------

user function xFina811()

  local a811Param          := {}
  private lMsErroAuto     := .F.
  private lAutoErrNoFile  := .T.
  aRetorno :={}

  //Preparação do Ambiente
  RpcSetEnv("99","01","Administrador","","FIN","FINA811",{"SA1"})
    
  aAdd( a811Param,  PadR('000000',TamSX3('A1_COD')[1])           )   //Código do cliente De (tipo caracter)
  aAdd( a811Param,  PadR('01',TamSX3('A1_LOJA')[1])              )   //Loja do cliente De (tipo caracter)
  aAdd( a811Param,  Repl('Z',TamSX3('A1_COD')[1])                )   //Código do cliente Até (tipo caracter)
  aAdd( a811Param,  Repl('Z',TamSX3('A1_LOJA')[1])               )   //Loja do cliente Até (tipo caracter)
  aAdd( a811Param,  dDataBase - 999                              )   //Data de emissão De (tipo data)        
  aAdd( a811Param,  dDataBase + 180                              )   //Data de emissão Até (tipo data)  
  aAdd( a811Param,  dDataBase                                    )   //Data de referência (tipo data)     
  aAdd( a811Param,  0                                            )   //Valor de (tipo numérico)     
  aAdd( a811Param,  99.99999                                       )   //Valor Até (tipo numérico)        
  aAdd( a811Param,  '1'                                         )   //"2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE FILIAIS
  aAdd( a811Param,  '1'                                         )   //Títulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = Não)
  aAdd( a811Param,  '1'                                          )   //Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
  aAdd( a811Param,  '2'                                          )   //2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE SITUAÇÃO DE COBRANÇA
  aAdd( a811Param,  {}                                          )   //{} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
  aAdd( a811Param,  ''                                          )   //"" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
  aAdd( a811Param,  '000000'                                     )   //Código do layout da carta a ser utilizado (tipo caracter) 
                  
   // VOU CHAMAR NOVAMENTE A EXECAUTO POREM VOU MANIPULAR AQUELA CONDICAO            
  MSExecAuto({|x,y| Fina811(x,y)},0,a811Param)
// VEJA QUE RETORNOU PARA A EXECAUTO POREM ENVIOU O EMAIL AGORA
  if lMsErroAuto
    ConOut("Erro !")
  	MostraErro()
    aLog := GetAutoGRLog()
		if !Empty(aLog)
        for nX:= 1 to Len(aLog)
            cLog:=(''+aLog[nX] +CHR(13)+CHR(10))
         next
            FwAlertInfo(cLog)
    endIf
  else
  // RETORNOU SEM ERRO, MAS NÃO CHAMAOU A FUNÇÃO PARA REALIZAR O ENVIO DO EMAIL
  	FwAlertSucess("Sucesso!")
  endif

  RpcClearEnv()

Return

/*
a811Param[01] := Código do cliente De (tipo caracter)
a811Param[02] := Loja do cliente De (tipo caracter)
a811Param[03] := Código do cliente Até (tipo caracter)
a811Param[04] := Loja do cliente Até (tipo caracter)
a811Param[05] := Data de emissão De (tipo data)        
a811Param[06] := Data de emissão Até (tipo data)  
a811Param[07] := Data de referência (tipo data)     
a811Param[08] := Valor de (tipo numérico)     
a811Param[09] := Valor Até (tipo numérico)        
a811Param[10] := "2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE FILIAIS
a811Param[11] := Títulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = Não)
a811Param[12] := Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
a811Param[13] :="2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE SITUAÇÃO DE COBRANÇA
a811Param[14] := {} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
a811Param[15] := "" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
a811Param[16] := Código do layout da carta a ser utilizado (tipo caracter) 
*/

