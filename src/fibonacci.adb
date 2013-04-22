with Memoize ;

procedure Fibonacci is

   function DeplieFib(N: Natural) return Natural ;

   package Fib is new Memoize(DeplieFib) ;

   function DeplieFib(N: Natural) return Natural is
   begin
      if N <= 1 then
         return 1 ;
      else
         return Fib.Eval(N-2)+Fib.Eval(N-1) ;
      end if ;
   end ;

   R: Natural := Fib.Eval(6);
begin
   Fib.GrapheAppels ;
end ;
