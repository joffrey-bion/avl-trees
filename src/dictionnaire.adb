with Ada.Unchecked_Deallocation ;
with Ada.Text_Io ; use Ada.Text_Io ;

package body Dictionnaire is

   -- =========================================================
   -- parametrage de la version "ABR non equilibre" versus AVL.
   -- => le code specifique AVL apparait des "if VersionAVL then"
   -- => en principe, ces "if" sur des constantes booleennes
   --    sont elimines par le compilo.

   VersionAVL: constant Boolean := False ;

   -- =========================================================
   -- manipulation des fils par leur nom
   subtype NomFils is Comparaison range INF..SUP ;

   -- constantes introduites pour expliciter la convention
   Gauche: constant NomFils := INF ;
   Droit: constant NomFils := SUP ;

   function Autre(F: NomFils) return NomFils is
      -- retourne l'autre fils que "F"
   begin
      return Comparaison'Val(3-Comparaison'Pos(F)) ;
   end Autre ;
   pragma Inline(Autre) ;

   procedure Trace(F: NomFils) is
      -- pour deboggage
   begin
      Put_Line("Trace fils courant = " & NomFils'Image(F)) ;
   end ;

   -- =========================================================
   -- type des arbres.

   type TabFils is array(NomFils) of Dico ;

   type Noeud is record
      Hauteur: Positive ;
      C: Clef ;
      D: Donnee ;
      Fils: TabFils ;
   end record ;

   procedure Liberer is new Ada.Unchecked_Deallocation(Noeud,Dico) ;

   -- INVARIANT:
   --   Tous les elements du type Dico sont des ABR.
   --   Si A: Dico est un AVL,
   --     alors A.Hauteur represente bien la hauteur de l'arbre.
   --   (Autrement dit, si A n'est pas un AVL,
   --    l'information A.Hauteur n'est pas pertinente).

   type OptionClef is record
      Present: Boolean ;
      Valeur: Clef ;  -- a du sens uniquement si Present=True
   end record ;

   type Interv is array(NomFils) of OptionClef ;

   function Hauteur(A: Dico) return Natural is
      -- requiert: A AVL
   begin
      if A = null
      then
         return 0 ;
      else
         return (A.Hauteur) ;
      end if;
   end ;
   pragma Inline(Hauteur) ;

   procedure Verif(A: Dico; Borne: Interv) is
      -- requiert A /= null
      -- garantit
      --    A.Hauteur = Max{Hauteur(A.Fils(F)) | F in NomFils} + 1
      --    A.Hauteur - 2 <= Min{Hauteur(A.Fils(F)) | F in NomFils}
      --    Borne(INF) < Cles(A.Fils(Gauche)) < A.C < Cles(A.Fils(Droit)) < Borne(SUP)

      Aux: Interv ;
   begin
      -- verification que A.C est dans les bornes
      for F in NomFils loop
         if Borne(F).Present and then Compare(Borne(F).Valeur,A.C) /= F then
            Trace(F) ;
            raise Anomalie ;
         end if ;
      end loop ;
      -- verification recursive sur les fils
      for F in NomFils loop
         if A.Fils(F) /= null then
            Aux(F):=Borne(F) ;
            Aux(Autre(F)):=(Present => True, Valeur => A.C) ;
            Verif(A.Fils(F), Aux) ;
         end if ;
      end loop ;

      if VersionAVL then
         if A/=null and then abs(Hauteur(A.Fils(Gauche)) - Hauteur(A.Fils(Droit)))>1 then
            raise Anomalie ;
         end if ;
      end if ;
   end Verif ;

   -- verif defensive que A est un AVL.
   procedure Verif(A: Dico) is
   begin
      if A /= null then
         Verif(A,(others => (Present => False, Valeur => A.C))) ;
      end if ;
   end Verif ;

   -- =========================================================

   procedure Vider(A: in out Dico) is
      -- parcourt A en profondeur pour liberer d'abord les feuilles puis remonter
   begin
      if A=null then return ;
      else
         Vider(A.Fils(Gauche)) ;
         Vider(A.Fils(Droit)) ;
         Liberer(A);
      end if ;
   end ;

   procedure Parcourir(A: Dico) is
   begin
      if A /= null
      then
         Parcourir(A.Fils(Gauche)) ;
         Traiter(A.C,A.D) ;
         Parcourir(A.Fils(Droit)) ;
      end if ;
   end ;

   procedure ParcourirInterv(A: Dico; CI,CS:Clef) is
   begin
      if A /= null
      then
         if Compare(A.C,CI)=SUP then
            ParcourirInterv(A.Fils(Gauche),CI,CS) ;
         end if ;
         if (Compare(A.C,CI)/=INF) and (Compare(A.C,CS)/=SUP) then
            Traiter(A.C,A.D) ;
         end if ;
         if Compare(A.C,CS)=INF then
            ParcourirInterv(A.Fils(Droit),CI,CS) ;
         end if ;
      end if ;
   end ;

   procedure AfficherArbre(A : Dico; Taille : Integer) is separate ;
   -- Pour tests visuels

   function Cherche(A: Dico; C: Clef) return Donnee is
   begin
      if A = null then raise ClefAbsente ;
      elsif Compare(A.C,C) = EQ then return A.D ;
      else return Cherche(A.Fils(Compare(C,A.C)),C) ;
      end if ;
   end ;

   function EstPresente(A: Dico; C:Clef) return Boolean is
   begin
      if A = null then return False ;
      elsif Compare(A.C,C) = EQ then return True ;
      else return EstPresente(A.Fils(Compare(C,A.C)),C) ;
      end if ;
   end ;

   procedure AjusteHauteur(A: Dico) is
      -- requiert: A /= null et  A.Fils(Gauche), A.Fils(Droit) AVLs
      -- garantit:
      --   Si abs(Hauteur(A.Fils(Gauche),A.Fils(Droit))) <= 1 alors A AVL.
   begin
      A.Hauteur:=Integer'Max(Hauteur(A.Fils(Gauche)),Hauteur(A.Fils(Droit)))+1 ;
   end ;
   pragma Inline(AjusteHauteur) ;

   procedure Rotation(Sens : NomFils; A : in out Dico) is
      Fg : Dico := A.Fils(Autre(Sens));
   begin
      A.Fils(Autre(Sens)) := Fg.Fils(Sens) ;
      AjusteHauteur(A) ;
      Fg.Fils(Sens) := A ;
      AjusteHauteur(Fg) ;
      A := Fg ;
   end Rotation ;

   procedure Equilibrer(Sens : NomFils; A : in out Dico) is
      -- requiert:
      --    A non null ; A.Fils(Gauche) et A.Fils(Droit) AVLs
      --    -1 <= Hauteur(A.Fils(Sens)) - Hauteur(A.Fils(Autre(Sens)) <= 2
      -- garantit : A AVL
      F : Dico := A.Fils(Sens) ;
   begin
      if Hauteur(F) > Hauteur(A.Fils(Autre(Sens))) + 1 then
         if Hauteur(F.Fils(Autre(Sens))) > Hauteur(F.Fils(Sens)) then
            Rotation(Sens,A.Fils(Sens)) ;
         end if ;
         Rotation(Autre(Sens),A) ;
      end if ;
      AjusteHauteur(A) ;
   end ;

   procedure Inserer(A: in out Dico;
                     C: Clef;
                     Present: out Boolean;
                     D: in out Donnee) is
      Cmp: Comparaison ;
   begin
      if A = null
      then
         A := new Noeud'(1,C,D,(others => null)) ;
         Present := False ;
      else
         Cmp:=Compare(C,A.C) ;
         if Cmp=EQ then
            Present:=True ;
            D := A.D ;
         else
            Inserer(A.Fils(Cmp),C,Present,D) ;
            if VersionAVL and then not Present then
               Equilibrer(Cmp,A) ;
            end if ;
         end if ;
      end if ;
   end Inserer ;

   procedure SupprimerMin(A: in out Dico; C: out Clef; D: out Donnee) is
      Temp : Dico ;
   begin
      if A.Fils(Gauche) = null then -- A.C est dans ce cas la clef minimum
         C := A.C ;
         D := A.D ;
         -- on remplace donc A par son fils droit (eventuellement "null")
         Temp := A ;
         A := A.Fils(Droit) ;
         Liberer(Temp) ;
      else -- on va dans ce cas chercher le minimum dans le sous-arbre gauche
         SupprimerMin(A.Fils(Gauche),C,D) ;
         if VersionAVL then
            Equilibrer(Droit,A) ;
         end if ;
      end if ;
   end SupprimerMin ;

   procedure Supprimer(A: in out Dico; C: Clef) is
      Temp : Dico ;
      NouvelleClef : Clef ;
      NouvelleDonnee : Donnee ;
   begin
      if A = null then raise ClefAbsente ; end if ;
      if Compare(A.C,C)=EQ then -- A est a supprimer
         if A.Fils(Droit) = null then -- si pas de fils droit, on remplace A par son fils gauche
            Temp := A ;
            A := A.Fils(Gauche) ;
            Liberer(Temp) ;
         else -- sinon on remplace A par le plus petit element de son sous-arbre droit
            SupprimerMin(A.Fils(Droit),NouvelleClef,NouvelleDonnee) ;
            A.C := NouvelleClef ;
            A.D := NouvelleDonnee ;
            if VersionAVL then
               Equilibrer(Gauche,A) ;
            end if ;
         end if;
      else -- sinon on cherche l'element a supprimer dans le sous-arbre correspondant
         Supprimer(A.Fils(Compare(C,A.C)),C) ;
         if VersionAVL then
            Equilibrer(Compare(A.C,C),A) ;
         end if ;
      end if ;
   end ;

end ;
