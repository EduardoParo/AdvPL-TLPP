#include'totvs.ch'
/*/{Protheus.doc}----------------------------------------------------------------------
@version  12
@author Eduardo Paro de SImoni
@since 08/02/2021
//---------------------------------------------------------------------------------------------------/*/
 /*--------------------------------------------------------------------------------
 Classe No
 --------------------------------------------------------------------------------*/
class NoPilha

    // Declaracao das propriedades da Classe
    data oNoProximo
    data oNoAnterior
    data xConteudo

    // Declaração dos Métodos da Classe
    method new(xConteudo) constructor
    method __get(xAtributo) 
    method __set(xAtributo, xValor) 

endClass

/*--------------------------------------------------------------------------------
 Methodo New
 --------------------------------------------------------------------------------*/
method new(xConteudo) class NoPilha
    ::oNoProximo    :=nil
    ::oNoAnterior   :=nil
    ::xConteudo     :=xConteudo

return self

/*--------------------------------------------------------------------------------
 Classe GET atributos
 --------------------------------------------------------------------------------*/
method __get(cAtributo) class NoPilha
return &(cAtributo)

/*--------------------------------------------------------------------------------
 Classe Set Atributos
 --------------------------------------------------------------------------------*/
method __set(cAtributo, oNo) class NoPilha
    &(cAtributo) := oNo
return

