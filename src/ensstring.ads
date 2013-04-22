-- codage d'ensembles de chaines.

with Comparaisons, Dictionnaire, Ada.Unchecked_Deallocation ;
use Comparaisons ;

package EnsString is

   type Element is access String ;
   -- Les elements dans les ensembles sont des pointeurs sur des chaines.

   function Compare(X,Y: Element) return Comparaison ;
   -- ordre <= sur les String.

   function Centralise(S: String) return Element ;
   -- retourne un pointeur unique pour la chaine S.
   -- (cette fonction maintient un dico associant a chaque String
   --  un "Element" unique).

   procedure Liberer is new Ada.Unchecked_Deallocation(String, Element) ;
   -- liberer un pointeur de type Element.
   -- ATTENTION: NE PAS LIBERER UN POINTEUR RECUPERE VIA Centralise !

   type Ensemble is private ;
   -- represente un ensemble de "Element" initialement vide.

   procedure Inserer(E: in out Ensemble; X: Element) ;

   procedure Afficher(E: Ensemble) ;

private

   package Dicos is new Dictionnaire(Element,Compare,Element) ;
   -- Clef et Donnee sont des Element, car String interdit de toute facon !

   use Dicos ;

   type Ensemble is new Dico ;

end ;
