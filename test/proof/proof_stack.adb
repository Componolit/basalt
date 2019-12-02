
with Basalt.Stack;

package body Proof_Stack with
   SPARK_Mode
is

   package Stack is new Basalt.Stack (Integer);
   S : Stack.Context (10);

   procedure Prove
   is
   begin
      Stack.Initialize (S, 0);
      for I in Integer range 7 .. 13 loop
         Stack.Push (S, I);
         exit when Stack.Count (S) >= Stack.Size (S);
      end loop;
      pragma Assert (Stack.Count (S) = 7);
      for I in Integer range 1 .. 7 loop
         Stack.Drop (S);
      end loop;
      pragma Assert (Stack.Is_Empty (S));
   end Prove;

end Proof_Stack;
