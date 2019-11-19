--
--  @summary Generic fifo queue
--  @author  Johannes Kliemann
--  @date    2019-11-19
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of Basalt, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

package body Basalt.Queue with
   SPARK_Mode
is

   function Valid (Q : Queue) return Boolean is
      (Long_Natural'Last - Q.Index > Long_Positive (Q.List'First)
       and then Q.Index + Long_Positive (Q.List'First) in
             Long_Positive (Q.List'First) .. Long_Positive (Q.List'Last)
       and then Long_Positive'Last - Long_Positive (Q.List'Length) >= Q.Index
       and then Q.Length <= Q.List'Length);

   function Size (Q : Queue) return Positive is (Q.List'Length);

   function Count (Q : Queue) return Natural is (Natural (Q.Length));

   procedure Initialize (Q            : out Queue;
                         Null_Element :     T)
   is
   begin
      Q.List   := (Q.List'Range => Null_Element);
      Q.Index  := Long_Natural'First;
      Q.Length := Long_Natural'First;
   end Initialize;

   procedure Put (Q       : in out Queue;
                  Element :        T)
   is
      Index : Positive;
   begin
      Index          := Positive ((Q.Index + Q.Length) mod
                                     Q.List'Length + Long_Positive (Q.List'First));
      Q.Length       := Q.Length + 1;
      Q.List (Index) := Element;
   end Put;

   procedure Peek (Q       :     Queue;
                   Element : out T)
   is
   begin
      Element := Q.List (Positive (Q.Index + Long_Positive (Q.List'First)));
   end Peek;

   procedure Drop (Q : in out Queue)
   is
   begin
      Q.Index  := (Q.Index + 1) mod Q.List'Length;
      Q.Length := Q.Length - 1;
   end Drop;

   procedure Pop (Q       : in out Queue;
                  Element :    out T)
   is
   begin
      Peek (Q, Element);
      Drop (Q);
   end Pop;

end Basalt.Queue;
