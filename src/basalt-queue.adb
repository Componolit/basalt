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

   procedure Initialize (C            : out Context;
                         Null_Element :     T)
   is
   begin
      --  This would be the correct way to initialize S.List:
      --     C.List  := (others => Null_Element);
      --  As this creates a (potentially large) object on the stack, we initialize in a loop. The resulting flow
      --  error is justified in the spec.
      for E of C.List loop
         E := Null_Element;
      end loop;
      C.Length := Long_Natural'First;
      C.Index  := Long_Natural'First;
   end Initialize;

   procedure Put (C       : in out Context;
                  Element :        T)
   is
      Index : Positive;
   begin
      Index          := Positive ((C.Index + C.Length) mod
                                     C.List'Length + Long_Positive (C.List'First));
      C.Length       := C.Length + 1;
      C.List (Index) := Element;
   end Put;

   procedure Peek (C       :     Context;
                   Element : out T)
   is
   begin
      Element := C.List (Positive (C.Index + Long_Positive (C.List'First)));
   end Peek;

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

end Basalt.Queue;
