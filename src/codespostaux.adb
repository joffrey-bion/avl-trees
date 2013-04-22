with Ada.Text_Io, Algo1Pools, Comparaisons, ParcourirCodesPostaux, Dictionnaire, EnsString, Ada.Unchecked_Deallocation ;
use Ada.Text_Io, Comparaisons, EnsString ;

procedure CodesPostaux is

   NomDuFichier: constant String := "codes_postaux.txt" ;
   NbLignes : Natural := 1 ;

   type PEnsemble is access Ensemble ;
   procedure Liberer is new Ada.Unchecked_Deallocation(Ensemble,PEnsemble) ;

   package VilleCodes is new Dictionnaire(Element,Compare,PEnsemble) ;
   use VilleCodes ;

  VC,CV: Dico ;

   Anomalie: exception ;

   -- Insère la ville N et le code C dans l'arbre
   procedure InsererNouveau(C,N: String) is
      -- A MODIFIER EVENTUELLEMENT ! 
      VillePresente, CodePresent: Boolean ;
      Aux, Temp, Codes, Villes : PEnsemble ;
   begin
      NbLignes:= NbLignes + 1 ; -- compteur pour afficher le numéro de ligne en cas d'erreur
      if NbLignes mod 1000 = 0 then
         Put(".") ;
      end if ;
      Aux := new Ensemble ;
      Temp := new Ensemble ;
      Codes := Aux ;
      Villes := Temp ;
      Inserer(VC,Centralise(N),VillePresente,Codes) ; -- on insère dans le dico le nom de ville N
      -- si la ville y figurée déjà ça retourne l'ensemble des codes postaux déjà enregistrés "Codes"
      Inserer(Codes.all,Centralise(C)) ; -- on insère dans l'ensemble "Codes.all" le nouveau code postal C. 
      -- on fait de même pour remplir l'arbre ayant pour clef les codes postaux cette fois
      Inserer(CV,Centralise(C),CodePresent,Villes) ;
      Inserer(Villes.all,Centralise(N)) ;
      
      if VillePresente then
         Liberer(Aux) ;
      end if ;
      if CodePresent then
         Liberer(Temp) ;
      end if ;
   exception
      -- pour eviter de confondre avec les Constraint_Error de ParcourirCodesPostaux.
      when Constraint_Error => raise Anomalie ;
   end ;

   -- On va appeler InsererNouveau sur chaque ligne du fichier texte codepostal
   -- de façon à créer le dictionnaire (la base de donnée structurée qui nous intéresse)
   procedure Analyser is new ParcourirCodesPostaux(InsererNouveau) ;

   C: Character ;
begin
   Put("Initialisation");
   begin
      Analyser(NomDuFichier) ;
   exception
      when Constraint_Error =>
         New_Line ;
         Put_Line(NomDuFichier & ": erreur sur la ligne" & Integer'Image(NbLignes)) ;
         raise ;
   end ;
   New_Line ;
   Put_Line("Fichier " & NomDuFichier & " correct.") ;
   Verif(CV) ;
   Verif(VC) ;                          -- TEST DEFENSIF
   Algo1Pools.Print_Info(PoolDico) ;    -- INFO SUR TAILLE DU TAS
   loop
      Put_Line("---- Menu ----") ;
      Put_Line("0. quitter") ;
      Put_Line("1. recherche de code postal") ;
      Put_Line("2. recherche de nom de ville") ;
      Put("--- Votre choix:") ;
      Get_Immediate(C) ;
      Put(C) ; New_Line ;
      case C is
         when '0' => exit ;
         when '1' =>
            Put("Prefixe de nom de ville:") ;
            declare
               Prefixe: Element := new String'(Get_Line) ;
               Fin: Element := new String'(Prefixe.all) ;
               Sentinelle: Character ;

               procedure AfficherCodes(N: Element; C: in out PEnsemble) is
               begin
                  Put_Line("+++ Codes Postaux de " & N.all & ":") ;
                  Afficher(C.all) ;
               end ;

               procedure AfficherCodesX(N: Element; C: in out PEnsemble) is
               begin
                  if N(Fin'Last) /= Sentinelle then
                     AfficherCodes(N,C) ;
                  end if ;
               end ;

               procedure ParcourirNom is new ParcourirInterv(AfficherCodesX) ;
               procedure ParcourirNom is new Parcourir(AfficherCodes) ;

            begin
               if Fin'Length /= 0 then
                  -- fonctionne, car les noms de villes n'ont pas
                  -- de caracteres de code ASCII 254 !
                  Sentinelle := Character'Succ(Prefixe(Fin'Last)) ;
                  Fin(Fin'Last):=Sentinelle ;
                  ParcourirNom(VC,Prefixe,Fin) ;
                  Liberer(Fin) ;
                  Liberer(Prefixe) ;
               else
                  ParcourirNom(VC) ;
               end if ;
            end ;
         when '2' =>
            Put("Prefixe de code postal:") ;
            declare
               Prefixe: Element := new String'(Get_Line) ;
               Fin: Element := new String'(Prefixe.all) ;
               Sentinelle: Character ;

               -- Les deux procédures suivantes instancient les procédures de
               -- parcours des clefs de l'arbre ParcourirInterv et Parcourir
               procedure AfficherVilles(C: Element; N: in out PEnsemble) is
               begin
                  Put_Line("+++ Villes correspondant au code postal " & C.all & ":") ;
                  Afficher(N.all) ;
               end ;

               procedure AfficherVillesX(C: Element; N: in out PEnsemble) is
               begin
                  if C(Fin'Last) /= Sentinelle then
                     AfficherVilles(C,N) ;
                  end if ;
               end ;

               procedure ParcourirNom is new ParcourirInterv(AfficherVillesX) ;
               procedure ParcourirNom is new Parcourir(AfficherVilles) ;

            begin
               if Fin'Length /= 0 then
                  -- fonctionne, car les noms de villes n'ont pas
                  -- de caracteres de code ASCII 254 !
                  Sentinelle := Character'Succ(Prefixe(Fin'Last)) ;
                  Fin(Fin'Last):=Sentinelle ;
                  ParcourirNom(CV,Prefixe,Fin) ; 
                  Liberer(Fin) ;
                  Liberer(Prefixe) ;
               else
                  ParcourirNom(CV) ;
               end if ;
            end ;
         when others =>
            Put_Line("*** Choix incorrect: recommencez !") ;
      end case ;
   end loop ;
end ;
