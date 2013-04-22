with Ada.Text_Io ;
use Ada.Text_Io ;

procedure ParcourirCodesPostaux(NomFichier: String) is
   Fichier: File_Type ;
   CodePostal: String(1..5) ;
   Cour: Character ;
   Index: Natural ;
begin
   Open(Fichier, In_File, NomFichier) ;
   while not End_Of_File(Fichier) loop
      -- invariant: on est au debut d'une ligne.
      Index := 0 ;
      while not End_Of_File(Fichier) loop
         -- invariant:
         --   on lit le code postal dans la ligne courante
         --   Index: nombre de chiffres deja lus.
         Get_Immediate(Fichier,Cour) ;
         if Cour in '0'..'9' then
            Index:=Index+1 ;
            CodePostal(Index) := Cour ;
         elsif Cour = ' ' and then Index = CodePostal'Last then
            exit ;
         else
            raise Constraint_Error ;
         end if ;
      end loop ;
      -- il reste le nom de ville a lire dans la ligne
      declare
         NomVille: String := Get_Line(Fichier) ;
      begin
         if NomVille'Length <= 0 then
            raise Constraint_Error ;
         else
            Traiter(CodePostal,NomVille) ;
         end if ;
      end ;
   end loop ;
   Close(Fichier) ;
end ;
