
with Basalt.Stack;

package body Proof_Stack with
   SPARK_Mode
is

   package Stack is new Basalt.Stack (Integer, 0);
   S : Stack.Context (10);

   procedure Prove
   is
      procedure Push (I : out Integer);
      procedure Pop (I : Integer);
      procedure Push is new Stack.Generic_Push (Push);
      procedure Pop is new Stack.Generic_Pop (Pop);
      J_Ignore : Integer := 42;
      procedure Push (I : out Integer)
      is
      begin
         I := J_Ignore;
      end Push;
      procedure Pop (I : Integer)
      is
      begin
         J_Ignore := I;
      end Pop;
   begin
      Stack.Initialize (S);
      for I in Integer range 7 .. 13 loop
         Stack.Push (S, I);
         exit when Stack.Count (S) >= Stack.Size (S);
      end loop;
      pragma Assert (Stack.Count (S) = 7);
      for I in Integer range 1 .. 7 loop
         Stack.Drop (S);
      end loop;
      pragma Assert (Stack.Is_Empty (S));
      Push (S);
      Pop (S);
      pragma Assert (Stack.Is_Empty (S));
   end Prove;

end Proof_Stack;
