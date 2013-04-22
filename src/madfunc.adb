with Memoize, Ada.Text_Io ;
use Ada.Text_Io ;

procedure MadFunc is

   function DeplieMad(N: Natural) return Natural ;

   package Mad is new Memoize(DeplieMad) ;

   function DeplieMad(N: Natural) return Natural is
   begin
      if N=997 then
         return 1004 ;
      elsif N > 997 then
         return Mad.Eval(Mad.Eval(N-1)-7)+1 ;
      else
         return Mad.Eval(Mad.Eval(N+1)+7)-1 ;
      end if ;
   end ;

begin
    for I in 0..10000 loop
      Put_Line("Memoize.Eval" & Integer'Image(I) & ":" & Integer'Image(Mad.Eval(I))) ;
   end loop ; 
end ;

-- Résultats en temps d'exécution :
--
--    * Sans mémoization, simple récursion :
--      Comportant trop chaotique, cette fonction porte bien son nom !
--
--    * Avec mémoization & Sans équilibrage : 
-- 	real	2m2.886s
-- 	user	1m58.859s
-- 	sys	0m3.872s
--
--    *  Avec mémoization & Avec équilibrage :
-- 	real	0m0.894s
-- 	user	0m0.512s
-- 	sys	0m0.040s
