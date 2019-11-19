
with Basalt.Queue;

package body Proof_Queue with
   SPARK_Mode
is

   package Fifo is new Basalt.Queue (Integer);
   Queue : Fifo.Queue (10);

   procedure Prove
   is
      J : Integer;
   begin
      Fifo.Initialize (Queue, 0);
      for I in Integer range 7 .. 13 loop
         --  Componolit/Workarounds#2
         Fifo.Put (Queue, I);
         exit when Fifo.Count (Queue) >= Fifo.Size (Queue);
      end loop;
      pragma Assert (Fifo.Count (Queue) = 7);
      for I in Integer range 1 .. 7 loop
         Fifo.Pop (Queue, J);
         --  Componolit/Workarounds#2
      end loop;
   end Prove;

end Proof_Queue;
