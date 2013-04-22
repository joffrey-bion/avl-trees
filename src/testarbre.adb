with Ada.Text_Io, Ada.Integer_Text_Io, Comparaisons, Dictionnaire, Ada.Unchecked_Deallocation ;
use Ada.Text_Io, Ada.Integer_Text_Io, Comparaisons ;

procedure TestArbre is

   AfficherDonnees : constant Boolean := True ;

   package ArbresAVL is new Dictionnaire(Integer,Compare,Integer) ;
   use ArbresAVL ;

   Arbre : Dico ;

   T_Ajout : array(1..16) of Integer := (27,24,17,32,10,36,12,35,30,28,29,31,34,7,50,97) ;
   T_Suppr : array(1..12) of Integer := (24,28,17,35,34,29,36,27,12,10,30,97) ;

   --T_Ajout : array(1..16) of Integer := (30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15) ;
   --T_Suppr : array(1..12) of Integer := (24,15,25,17,26,16,19,29,23,30,20,18) ;

   N : Integer ; -- Nb de caractères pour afficher un noeud

   procedure Afficher(A,B :Integer) is
   begin
      if AfficherDonnees then
         if A < 10 then Put(" ") ; end if ;
         Put(A,0);
         Put("-");Put(B,0) ;
         if B < 100 then Put(" "); end if ;
      else
         Put(A,0);
         if A < 10 then Put(" ") ; end if ;
      end if ;
   end ;

   procedure Print is new AfficherArbre(Afficher) ;

   procedure PutHauteur is
   begin
      Put_Line("   => Nouvelle arbre de hauteur" & Integer'Image(Hauteur(Arbre)) & " :") ;
      New_Line ;
   end ;

   Present : Boolean ;
   D : Integer ;

begin
   -- Calcul de la taille d'affichage d'un noeud
   if AfficherDonnees then
      N := 6 ;
   else
      N := 2 ;
   end if ;

   -- Insertion des éléments de T_Ajout
   Put_Line("**** INSERTION DES ELEMENTS DE T_AJOUT : ****") ;
   New_Line ;
   for I in T_Ajout'Range loop
      D := 10*T_Ajout(I) ; -- pour voir facilement si la donnée correspond
                           -- bien à la clef lors des suppressions
      Inserer(Arbre,T_Ajout(I),Present,D) ;
      Put("=> Insertion de ") ;
      Afficher(T_Ajout(I),D) ;
      New_Line ;
      PutHauteur ;
      Print(Arbre,N);
      Verif(Arbre);
      New_Line ;
   end loop ;

   -- Suppression des éléments de T_Suppr
   Put_Line("**** SUPPRESSION DES ELEMENTS DE T_SUPPR : ****") ;
   New_Line ;
   for I in T_Suppr'Range loop
      Supprimer(Arbre,T_Suppr(I)) ;
      Put("=> Suppression de ") ;
      Put(T_Suppr(I),0) ;
      New_Line ;
      PutHauteur ;
      Print(Arbre,N);
      Verif(Arbre) ;
      New_Line ;
   end loop ;
end ;
