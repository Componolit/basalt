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
   type Queue (Size : Positive) is private;

   --  Checks if a queue is valid, proof only
   --
   --  @param Q  Queue
   --  @return   Q is valid
   function Valid (Q : Queue) return Boolean with
      Ghost;

   --  Returns the size of the queue given when instantiated
   --
   --  @param Q  Queue
   --  @return   Number of Elements the queue can hold
   function Size (Q : Queue) return Positive with
      Pre => Valid (Q);

   --  Returns the current length of the queue
   --
   --  @param Q  Queue
   --  @return   Number of elements currently in the queue
   function Count (Q : Queue) return Natural with
      Pre => Valid (Q);

   --  Initializes the queue with a default element value
   --
   --  This procedure is only needed to proof the data flow. It is
   --  the only way to assign a Queue object. The object will automatically
   --  be initialized with the given element. The initialized queue will be empty.
   --
   --  @param Q             Queue
   --  @param Null_Element  Default element to initialize the queue with
   procedure Initialize (Q            : out Queue;
                         Null_Element :     T) with
      Post => Valid (Q) and then Count (Q) = 0;

   --  Puts an element in the queue.
   --
   --  @param Q        Queue
   --  @param Element  Element
   procedure Put (Q       : in out Queue;
                  Element :        T) with
      Pre  => Valid (Q) and then Count (Q) < Size (Q),
      Post => Valid (Q) and then Count (Q) = Count (Q'Old) + 1;

   --  Check the current first element, does not alter the queue
   --
   --  @param Q        Queue
   --  @param Element  Head of the queue
   procedure Peek (Q       :     Queue;
                   Element : out T) with
      Pre => Valid (Q) and then Count (Q) > 0;

   --  Drop the current first element
   --
   --  @param Q  Queue
   procedure Drop (Q : in out Queue) with
      Pre  => Valid (Q) and then Count (Q) > 0,
      Post => Valid (Q) and then Count (Q) = Count (Q'Old) - 1;

   --  Get the first element of the queue and drop it,
   --  equivalent to subsequent calls to Peek and Drop
   --
   --  @param Q        Queue
   --  @param Element  First element of the queue, will be dropped
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
