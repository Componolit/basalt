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
   Null_Element : T;
package Basalt.Queue with
   SPARK_Mode,
   Pure,
   Annotate => (GNATprove, Always_Return)
is

   --  Queue storage type
   --
   --  As the queue elements are stored in this type
   --  its objects can become considerably large for a
   --  large type T or large queue sizes.
   --
   --  @param Size  Length of the queue
   type Context (Size : Positive) is private;

   --  Returns the size of the queue given when instantiated
   --
   --  @param C  Queue context
   --  @return   Number of Elements the queue can hold
   function Size (C : Context) return Positive;

   --  Returns the current length of the queue
   --
   --  @param C  Queue context
   --  @return   Number of elements currently in the queue
   function Count (C : Context) return Natural;

   --  Initializes the queue
   --
   --  @param C  Queue context
   procedure Initialize (C : in out Context) with
      Post => Count (C) = 0;

   --  Puts an element in the queue.
   --
   --  @param C        Queue context
   --  @param Element  Element
   procedure Put (C       : in out Context;
                  Element :        T) with
      Pre  => Count (C) < Size (C),
      Post => Count (C) = Count (C'Old) + 1;

   --  Puts an element in the queue.
   --
   --  @param C  Queue context
   generic
      with procedure Put (Element : out T);
   procedure Generic_Put (C : in out Context) with
      Pre  => Count (C) < Size (C),
      Post => Count (C) = Count (C'Old) + 1;

   --  Check the current first element, does not alter the queue
   --
   --  @param C        Queue context
   --  @param Element  Head of the queue
   procedure Peek (C       :     Context;
                   Element : out T) with
      Pre => Count (C) > 0;

   --  Check the current first element, does not alter the queue
   --
   --  @param C  Queue context
   generic
      with procedure Peek (Element : T);
   procedure Generic_Peek (C : Context) with
      Pre => Count (C) > 0;

   --  Drop the current first element
   --
   --  @param C  Queue context
   procedure Drop (C : in out Context) with
      Pre  => Count (C) > 0,
      Post => Count (C) = Count (C'Old) - 1;

   --  Get the first element of the queue and drop it,
   --  equivalent to subsequent calls to Peek and Drop
   --
   --  @param C        Queue context
   --  @param Element  First element of the queue, will be dropped
   procedure Pop (C       : in out Context;
                  Element :    out T) with
      Pre  => Count (C) > 0,
      Post => Count (C) = Count (C'Old) - 1;

   generic
      with procedure Pop (Element : T);
   procedure Generic_Pop (C : in out Context) with
      Pre  => Count (C) > 0,
      Post => Count (C) = Count (C'Old) - 1;

private

   type List_Element is record
      Value : T := Null_Element;
   end record;

   type Simple_List is array (Natural range <>) of List_Element;
   subtype Long_Natural is Long_Integer range 0 .. Long_Integer'Last;
   subtype Long_Positive is Long_Integer range 1 .. Long_Integer'Last;

   type Context (Size : Positive) is record
      Index  : Long_Natural := Long_Natural'First;
      Length : Long_Natural := Long_Natural'First;
      List   : Simple_List (1 .. Size);
   end record with
      Dynamic_Predicate => Long_Natural'Last - Context.Index > Long_Positive (Context.List'First)
                           and then Context.Index + Long_Positive (Context.List'First) in
                              Long_Positive (Context.List'First) .. Long_Positive (Context.List'Last)
                           and then Long_Positive'Last - Long_Positive (Context.List'Length) >= Context.Index
                           and then Context.Length <= Context.List'Length;

end Basalt.Queue;
