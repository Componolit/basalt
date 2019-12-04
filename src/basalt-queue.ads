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

--  Basalt.Queue is a generic fifo queue implementation. It can use elements
--  of any definite non-limited type.

generic
   type T is private;
package Basalt.Queue with
   SPARK_Mode,
   Pure
is

   --  Queue storage type
   --
   --  As the queue elements are stored in this type
   --  its objects can become considerably large for a
   --  large type T or large queue sizes.
   --
   --  @param Size  Length of the queue
   type Context (Size : Positive) is private;

   --  Checks if a queue is valid, proof only
   --
   --  @param C  Queue context
   --  @return   C is valid
   function Valid (C : Context) return Boolean with
      Ghost;

   --  Returns the size of the queue given when instantiated
   --
   --  @param C  Queue context
   --  @return   Number of Elements the queue can hold
   function Size (C : Context) return Positive with
      Pre => Valid (C);

   --  Returns the current length of the queue
   --
   --  @param C  Queue context
   --  @return   Number of elements currently in the queue
   function Count (C : Context) return Natural with
      Pre => Valid (C);

   --  Initializes the queue with a default element value
   --
   --  This procedure is only needed to proof the data flow. It is
   --  the only way to assign a Queue object. The object will automatically
   --  be initialized with the given element. The initialized queue will be empty.
   --
   --  @param C             Queue context
   --  @param Null_Element  Default element to initialize the queue with
   procedure Initialize (C            : out Context;
                         Null_Element :     T) with
      Post => Valid (C) and then Count (C) = 0;

   --  Puts an element in the queue.
   --
   --  @param C        Queue context
   --  @param Element  Element
   procedure Put (C       : in out Context;
                  Element :        T) with
      Pre  => Valid (C) and then Count (C) < Size (C),
      Post => Valid (C) and then Count (C) = Count (C'Old) + 1;

   --  Check the current first element, does not alter the queue
   --
   --  @param C        Queue context
   --  @param Element  Head of the queue
   procedure Peek (C       :     Context;
                   Element : out T) with
      Pre => Valid (C) and then Count (C) > 0;

   --  Drop the current first element
   --
   --  @param C  Queue context
   procedure Drop (C : in out Context) with
      Pre  => Valid (C) and then Count (C) > 0,
      Post => Valid (C) and then Count (C) = Count (C'Old) - 1;

   --  Get the first element of the queue and drop it,
   --  equivalent to subsequent calls to Peek and Drop
   --
   --  @param C        Queue context
   --  @param Element  First element of the queue, will be dropped
   procedure Pop (C       : in out Context;
                  Element :    out T) with
      Pre  => Valid (C) and then Count (C) > 0,
      Post => Valid (C) and then Count (C) = Count (C'Old) - 1;

private

   type Simple_List is array (Natural range <>) of T;
   subtype Long_Natural is Long_Integer range 0 .. Long_Integer'Last;
   subtype Long_Positive is Long_Integer range 1 .. Long_Integer'Last;

   type Context (Size : Positive) is record
      Index  : Long_Natural;
      Length : Long_Natural;
      List   : Simple_List (1 .. Size);
   end record;

end Basalt.Queue;
