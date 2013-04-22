with Ada.Text_Io, ParcourirCodesPostaux ;
use Ada.Text_Io ;

procedure TestP is

   NomDuFichier: constant String := "codes_postaux.txt" ;
   NbLignes : Natural := 1 ;

   procedure InsererNouveau(C,N: String) is
   begin
      NbLignes:= NbLignes + 1 ;
      Put_Line(C & " " & N) ;
   end ;

   procedure Analyser is new ParcourirCodesPostaux(InsererNouveau) ;

begin
   Analyser(NomDuFichier) ;
exception
   when Constraint_Error =>
      New_Line ;
      Put_Line(NomDuFichier
               & ": erreur sur la ligne" & Integer'Image(NbLignes)) ;
      raise ;
end ;
