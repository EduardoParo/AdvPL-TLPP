#include 'totvs.ch'

/*/{Protheus.doc}----------------------------------------------------------------------
@version  12
@author Eduardo Paro de SImoni
@since 08/02/2021
//---------------------------------------------------------------------------------------------------/*/
/*----------------------------------------------
Classe  Pilha
------------------------------------------------*/
class Pilha
    // Declaracao das propriedades da Classe
    data oPilIni
    data oPilFim  
    data nCont 

    // Declaração dos Métodos da Classe
    method new() constructor
 
    method inserir(xConteudo)
    method inicializa(oNoNovo)


endClass

method new() class Pilha
return self

method inicializa(oNoNovo) class Pilha
    ::oPilIni :=oNoNovo
    
    ::oPilFim := oNoNovo
    
return

method inserir(xConteudo) class Pilha
    local oNoNovo := NoPilha():New(xConteudo)
        if ::oPilFim == nil
            self:inicializa(oNoNovo)
            ::nCont:=1
        else
            ::oPilFim:__set("self:oNoProximo",oNoNovo)
            oNoNovo:__set("self:oNoAnterior",::oPilFim)
            ::oPilFim:= oNoNovo
            ::nCont++
        endIf
 
    
return

