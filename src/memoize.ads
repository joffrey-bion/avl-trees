generic

   with function F(N: Natural) return Natural ;

package Memoize is

   function Eval(N: Natural) return Natural ;
   -- retourne F(N)
   -- utilisez "Eval(N)" au lieu de "F(N)" pour beneficier de la memoization.

   procedure GrapheAppels ;
   -- affiche la liste des (N,F(N))
   -- pour tous les N pour lesquels il y a eu appel a "Eval(N)".

   procedure GrapheAppels(A,B:Natural) ;
   -- meme chose que ci-dessus mais uniquement pour les N de l'interv. [A,B].

end ;
