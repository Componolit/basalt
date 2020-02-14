
with Basalt.Queue;

package body Proof_Queue with
   SPARK_Mode
is

   package Fifo is new Basalt.Queue (Integer, 0);
   Queue : Fifo.Context (10);

   procedure Prove
   is
      J_Ignore : Integer;
      procedure Put (I : out Integer);
      procedure Peek (I : Integer);
      procedure Put is new Fifo.Generic_Put (Put);
      procedure Peek is new Fifo.Generic_Peek (Peek);
      procedure Pop is new Fifo.Generic_Pop (Peek);
      procedure Put (I : out Integer)
      is
      begin
         I := 42;
      end Put;
      procedure Peek (I : Integer)
      is
      begin
         J_Ignore := I;
      end Peek;
   begin
      Fifo.Initialize (Queue);
      for I in Integer range 7 .. 13 loop
         Fifo.Put (Queue, I);
         exit when Fifo.Count (Queue) >= Fifo.Size (Queue);
      end loop;
      pragma Assert (Fifo.Count (Queue) = 7);
      for I in Integer range 1 .. 7 loop
         Fifo.Pop (Queue, J_Ignore);
      end loop;
      for I in Integer range 1 .. 7 loop
         Put (Queue);
      end loop;
      pragma Warnings (Off, "statement has no effect");
      for I in Integer range 1 .. 7 loop
         Peek (Queue);
      end loop;
      pragma Warnings (On, "statement has no effect");
      for I in Integer range 1 .. 7 loop
         Pop (Queue);
      end loop;
   end Prove;

end Proof_Queue;
