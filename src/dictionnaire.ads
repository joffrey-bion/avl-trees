-- paquetage dictionnaire generique
-- les clefs sont munies d'un ordre total.

with Comparaisons, Algo1Pools ;
use Comparaisons ;

generic

   type Clef is private ;
   with function Compare(C1,C2: Clef) return Comparaison ;

   type Donnee is private ;

   -- with procedure Trace(C: Clef) ; -- a ajouter eventuellement pour debogguer.

package Dictionnaire is

   type Dico is private ;
   -- par toute variable de type Dico est initialement un dico vide.

   procedure Vider(A: in out Dico) ;
   -- vide A en recuperant la memoire utilisee.

   function EstPresente(A: Dico; C:Clef) return Boolean ;
   -- retourne True ssi C est dans A.

   ClefAbsente: exception ;
   function Cherche(A: Dico; C: Clef) return Donnee ;
   -- si EstPresente(A,C)
   --   retourne la donnee associee a C dans A.
   -- sinon
   --   leve ClefAbsente.

   procedure Inserer(A: in out Dico; C: Clef; Present: out Boolean; D: in out Donnee) ;
   -- garantit:
   --   si EstPresente(A,C) alors
   --      D=Cherche(A,C) et Present=True
   --   sinon
   --      Le couple C/D est ajoute dans A et Present=False.


   procedure SupprimerMin(A: in out Dico; C: out Clef; D: out Donnee) ;
   -- requiert A dictionnaire non vide.
   -- garantit le couple C/D est supprime de A et C est inferieure a toute clef de A.

   procedure Supprimer(A: in out Dico; C: Clef) ;
   -- garantit:
   --   si EstPresente(A,C) alors
   --      supprime le couple C/Cherche(A,C) de A.
   --   sinon
   --      leve ClefAbsente

   generic
      with procedure Traiter(C: Clef; D: in out Donnee) ;
   procedure Parcourir(A: Dico) ;
   -- parcours l'ensemble des clefs de A.

   generic
      with procedure Traiter(C: Clef; D: in out Donnee) ;
   procedure ParcourirInterv(A: Dico; CI,CS: Clef) ;
   -- parcours l'ensemble des clefs de A de l'intervalle [CI,CS].


   ----------------------------------------
   -- pour validation du paquetage:

   Anomalie: exception ;
   procedure Verif(A: Dico) ;

   PoolDico: Algo1Pools.Algo1Pool;

   -- pour tests visuels
   function Hauteur(A : Dico) return Natural ;
   generic
      with procedure Afficher(C : Clef; D: Donnee) ;
   procedure AfficherArbre(A : Dico; Taille : Integer) ;

private

   type Noeud ;
   type Dico is access Noeud ;

   -- LIGNE CI-DESSOUS UTILE AU DEBOGAGE.
  -- for Dico'Storage_Pool use PoolDico;  -- A COMMENTER POUR GAGNER EN TEMPS D'EXEC !!

end ;
