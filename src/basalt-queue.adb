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

   function Size (C : Context) return Positive is (C.List'Length);

   function Count (C : Context) return Natural is (Natural (C.Length));

   function Put_Index (C : Context) return Positive is
      (Positive ((C.Index + C.Length - 1) mod C.List'Length + Long_Positive (C.List'First)));

   procedure Initialize (C : in out Context)
   is
   begin
      C.Length := Long_Natural'First;
      C.Index  := Long_Natural'First;
   end Initialize;

   procedure Put (C       : in out Context;
                  Element :        T)
   is
   begin
      C.Length                     := C.Length + 1;
      C.List (Put_Index (C)).Value := Element;
   end Put;

   procedure Generic_Put (C : in out Context)
   is
   begin
      C.Length := C.Length + 1;
      Put (C.List (Put_Index (C)).Value);
   end Generic_Put;

   procedure Peek (C       :     Context;
                   Element : out T)
   is
   begin
      Element := C.List (Positive (C.Index + Long_Positive (C.List'First))).Value;
   end Peek;

   procedure Generic_Peek (C : Context)
   is
   begin
      Peek (C.List (Positive (C.Index + Long_Positive (C.List'First))).Value);
   end Generic_Peek;

   procedure Drop (C : in out Context)
   is
   begin
      C.Index  := (C.Index + 1) mod C.List'Length;
      C.Length := C.Length - 1;
   end Drop;

   procedure Pop (C       : in out Context;
                  Element :    out T)
   is
   begin
      Peek (C, Element);
      Drop (C);
   end Pop;

   procedure Generic_Pop (C : in out Context)
   is
      procedure Local_Peek is new Generic_Peek (Pop);
   begin
      Local_Peek (C);
      Drop (C);
   end Generic_Pop;

end Basalt.Queue;
