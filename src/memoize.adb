with Ada.Text_Io, Comparaisons, Dictionnaire, Ada.Unchecked_Deallocation ;
use Ada.Text_Io, Comparaisons ;

package body Memoize is

   package Graphe is new Dictionnaire(Natural,Compare,Natural) ;
   use Graphe ;

   G : Dico ;

   function Eval(N: Natural) return Natural is
      R,Aux : Natural ;
      Present : Boolean ;
   begin
      R := Cherche(G,N) ; 
      return R ;          
   exception
      when ClefAbsente => 
         Aux := F(N) ;    
         Inserer(G,N,Present,Aux) ; 
         return Aux ;
   end ;

   procedure AfficherCouple(N : Natural ; Val : in out Natural) is
   begin
      Put_Line("Memoize.Eval" & Integer'Image(N) & ":" & Integer'Image(Val)) ;
   end ;

   procedure ParcourirGraphe is new Parcourir(AfficherCouple) ;
   procedure ParcourirGraphe is new ParcourirInterv(AfficherCouple) ;

   procedure GrapheAppels is
   begin
      ParcourirGraphe(G) ;
   end ;

   procedure GrapheAppels(A,B:Natural) is
   begin
      ParcourirGraphe(G,A,B) ;
   end ;
end ;

