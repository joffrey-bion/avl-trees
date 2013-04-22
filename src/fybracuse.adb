with Memoize, Ada.Text_Io ;
use Ada.Text_Io ;

procedure Fybracuse is

   function DeplieFyb(N: Natural) return Natural ;

   package Fyb is new Memoize(DeplieFyb) ;

   function DeplieFyb(N: Natural) return Natural is
   begin
      if N <= 1 then
         return 1 ;
      elsif N mod 4 = 0 then
         return Fyb.Eval(N/4)+Fyb.Eval(N/2) ;
      elsif N mod 2 = 0 then
         return Fyb.Eval(N/2)+1 ;
      else
         return Fyb.Eval(3*N+1)/2 ;
      end if ;
   end ;

begin
   for I in 0..10000 loop
      Put_Line("Memoize.Eval" & Integer'Image(I) & ":" & Integer'Image(Fyb.Eval(I))) ;
   end loop ; 
end ;

-- Résultats en temps d'exécution :
--
--    * Sans mémoization, simple récursion :
--      Rien que le calcul des 200 premières valeurs prend plus d'une minute...
--
--    * Avec mémoization & Sans équilibrage : 
-- 	real	0m2.335s
--	user	0m2.308s
--      sys	0m0.024s
--
--    * Avec mémoization & Avec équilibrage :
--	real	0m1.158s
--	user	0m1.108s
--	sys	0m0.048s

