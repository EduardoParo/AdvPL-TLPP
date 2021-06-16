#include 'totvs.ch'
/*/{Protheus.doc} u_zXPilha----------------------------------------------------------------------
description
@type function
@version  12
@author Eduardo Paro de SImoni
@since 08/02/2021
//---------------------------------------------------------------------------------------------------/*/
function u_zXPilha() as undefined
    local oPilha := nil as object
  

    oPilha := Pilha():new()

    oPilha:inserir("A")
    oPilha:inserir("B")
    oPilha:inserir("C")
    oPilha:inserir("D")
    oPilha:inserir("R")
    
    
return
