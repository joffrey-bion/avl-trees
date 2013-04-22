
separate(Dictionnaire)
procedure AfficherArbre(A : Dico; Taille : Integer) is
   procedure Puts(S : String ; N : Integer) is
   begin
      for I in 1..N loop
         Put(S);
      end loop ;
   end ;

   procedure AfficherNoeud(A : Dico ; H : Integer) is
   begin
      Puts(" ", 2**H/4*(Taille+1)-(Taille-1)/2-1) ;
      if A /= null then
         Afficher(A.C,A.D) ;
      else
         Puts(" ",Taille);
      end if ;
      Puts(" ",2**H/4*(Taille+1)-(Taille-1)/2+(Taille mod 2)-2) ;
   end ;

   procedure AfficherLignes(Gauche,Droit : Boolean; H : Integer) is
      L,Lmod : Integer := 2**H/8*(Taille+1)-1 ;
   begin
      if H = 2 then
         L := Taille/2 ;
         Lmod := Taille/2 - 1 + (Taille mod 2) ;
      end if ;
      Puts(" ",Lmod) ;
      if Gauche then
         Put("┌");
         Puts("─",L) ;
      else
         Puts(" ",L+1) ;
      end if ;
      if Gauche then
         if Droit then
            Put("┴");
         else
            Put("┘");
         end if ;
      else
         if Droit then
            Put("└");
         else
            Put(" ");
         end if ;
      end if ;
      if Droit then
         Puts("─",Lmod) ;
         Put("┐");
      else
         Puts(" ",Lmod+1) ;
      end if ;
      Puts(" ",L) ;
   end ;

   procedure AfficherNiveau(H : Natural) is
      T : array(1..2**H) of Dico ;
      Top : Integer := T'First ;
      procedure ParcourirNiveau(X : Dico ; N : Integer) is
      begin
         if X = null then
            for I in 1..2**N loop
               T(Top) := null ;
               Top := Top + 1 ;
            end loop ;
         elsif N = 0 then
            T(Top) := X ;
            Top := Top + 1 ;
         else
            ParcourirNiveau(X.Fils(Gauche),N-1) ;
            ParcourirNiveau(X.Fils(Droit),N-1) ;
         end if ;
      end ;
   begin
      ParcourirNiveau(A,H) ;
      for I in T'Range loop
         AfficherNoeud(T(I),Hauteur(A)-H) ;
         Put(" ") ;
      end loop ;
      New_Line ;
      for I in T'Range loop
         if T(I) /= null then
            AfficherLignes(T(I).Fils(Gauche)/=null,T(I).Fils(Droit)/=null,Hauteur(A)-H);
            Put(" ") ;
         else
            AfficherLignes(False,False,Hauteur(A)-H) ;
            Put(" ") ;
         end if ;
      end loop ;
      New_Line ;
   end ;
begin
   for I in 0..Hauteur(A)-1 loop
      AfficherNiveau(I) ;
   end loop ;
end ;
