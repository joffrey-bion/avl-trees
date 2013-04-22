with Ada.Text_Io ;
use Ada.Text_Io ;

package body EnsString is

   Global: Ensemble ;
   -- ensemble global contenant toutes les chaines de "Centralise"

   function Compare(X,Y: Element) return Comparaison is
   begin
      if X=Y then
         -- en cas d'egalite de pointeur les chaines sont egales.
         return EQ ;
      else
         return Compare(X.all,Y.all) ;
      end if ;
   end ;

   procedure Inserer(E: in out Ensemble; S: String; X: out Element) is
      P: Boolean ;
      Aux: Element := new String'(S) ;
   begin
      X:=Aux ;
      Inserer(E, Aux, P, X) ;
      if P then
         Liberer(Aux) ;
      end if ;
      -- Put_Line("Ajout " & X.all) ;
   end ;

   function Centralise(S: String) return Element is
      Res: Element ;
   begin
      Inserer(Global,S,Res) ;
      return Res ;
   end ;

   procedure Inserer(E: in out Ensemble; X: Element) is
      P: Boolean ;
      D: Element := X ;
   begin
      Inserer(E,X,P,D) ;
   end ;

   procedure Traiter(X: Element; Y: in out Element) is
   begin
      Put_Line(X.all) ;
   end ;

   procedure AfficherAux is new Parcourir(Traiter) ;

   procedure Afficher(E: Ensemble) is
   begin
      AfficherAux(Dico(E)) ;
   end ;

end ;
