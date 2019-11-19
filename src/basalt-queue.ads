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

generic
   type T is private;
package Basalt.Queue with
   SPARK_Mode
is

   type Queue (Size : Positive) is private;

   function Valid (Q : Queue) return Boolean with
      Ghost;

   function Size (Q : Queue) return Positive with
      Pre => Valid (Q);

   function Count (Q : Queue) return Natural with
      Pre => Valid (Q);

   procedure Initialize (Q            : out Queue;
                         Null_Element :     T) with
      Post => Valid (Q) and then Count (Q) = 0;

   procedure Put (Q       : in out Queue;
                  Element :        T) with
      Pre  => Valid (Q) and then Count (Q) < Size (Q),
      Post => Valid (Q) and then Count (Q) = Count (Q'Old) + 1;

   procedure Peek (Q       :     Queue;
                   Element : out T) with
      Pre => Valid (Q) and then Count (Q) > 0;

   procedure Drop (Q : in out Queue) with
      Pre  => Valid (Q) and then Count (Q) > 0,
      Post => Valid (Q) and then Count (Q) = Count (Q'Old) - 1;

   procedure Pop (Q       : in out Queue;
                  Element :    out T) with
      Pre  => Valid (Q) and then Count (Q) > 0,
      Post => Valid (Q) and then Count (Q) = Count (Q'Old) - 1;

private

   type Simple_List is array (Natural range <>) of T;
   subtype Long_Natural is Long_Integer range 0 .. Long_Integer'Last;
   subtype Long_Positive is Long_Integer range 1 .. Long_Integer'Last;

   type Queue (Size : Positive) is record
      Index  : Long_Natural;
      Length : Long_Natural;
      List   : Simple_List (1 .. Size);
   end record;

end Basalt.Queue;
