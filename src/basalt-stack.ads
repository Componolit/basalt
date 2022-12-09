--
--  @summary Generic stack specification
--  @author  Alexander Senier
--  @date    2019-12-02
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of Basalt, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

generic
   type Element_Type is private;
   Null_Element : Element_Type;
package Basalt.Stack with
   SPARK_Mode,
   Pure,
   Annotate => (GNATprove, Terminating)
is
   pragma Unevaluated_Use_Of_Old (Allow);

   type Context (Size : Positive) is private;

   --  Size of stack
   --
   --  @param S  Stack
   --  @return   Size of stack S
   function Size (S : Context) return Positive with
     Annotate => (GNATprove, Inline_For_Proof);

   --  Number of elements on stack
   --
   --  @param S  Stack
   --  @return   Current elements in stack S
   function Count (S : Context) return Natural with
     Annotate => (GNATprove, Inline_For_Proof);

   --  Stack is empty
   --
   --  @param S  Stack
   --  @return   Stack is empty
   function Is_Empty (S : Context) return Boolean is (Count (S) = 0) with
     Annotate => (GNATprove, Inline_For_Proof);

   --  Stack is full
   --
   --  @param S  Stack
   --  @return   Stack is valid
   function Is_Full (S : Context) return Boolean is (Count (S) >= Size (S)) with
     Annotate => (GNATprove, Inline_For_Proof);

   --  Push element onto stack
   --
   --  @param S  Stack
   --  @param E  Element to push onto stack S
   procedure Push (S : in out Context;
                   E :        Element_Type) with
     Pre  => not Is_Full (S),
     Post => Count (S) = Count (S)'Old + 1
             and then not Is_Empty (S);

   --  Push element onto stack
   --
   --  @param S  Stack
   generic
      with procedure Push (E : out Element_Type);
   procedure Generic_Push (S : in out Context) with
      Pre  => not Is_Full (S),
      Post => Count (S) = Count (S)'Old + 1
              and then not Is_Empty (S);

   --  Pop an element off the stack
   --
   --  @param S  Stack
   --  @param E  Result element
   procedure Pop (S : in out Context;
                  E :    out Element_Type) with
     Pre  => not Is_Empty (S),
     Post => Count (S) = Count (S)'Old - 1
             and then not Is_Full (S);

   --  Pop an element off the stack
   --
   --  @param S  Stack
   generic
      with procedure Pop (E : Element_Type);
   procedure Generic_Pop (S : in out Context) with
      Pre  => not Is_Empty (S),
      Post => Count (S) = Count (S)'Old - 1
              and then not Is_Full (S);

   --  Drop an element from stack
   --
   --  @param S  Stack
   procedure Drop (S : in out Context) with
     Pre  => not Is_Empty (S),
     Post => Count (S) = Count (S)'Old - 1
             and then not Is_Full (S);

   --  Reset stack without erasing data
   --
   --  @param S  Stack
   procedure Reset (S : in out Context) with
     Post => Is_Empty (S)
             and then not Is_Full (S);

   --  Initialize stack and clear stack buffer
   --
   --  @param S  Stack
   procedure Initialize (S : in out Context) with
     Post => Is_Empty (S)
             and then not Is_Full (S);

   --  Reverse the order of all elements on the stack
   --
   --  @param S  Stack
   procedure Reversed (S : in out Context) with
     Post => Is_Empty (S) = Is_Empty (S)'Old
             and then Is_Full (S) = Is_Full (S)'Old
             and then Count (S) = Count (S)'Old
             and then Size (S) = Size (S)'Old;

private

   type List_Element is record
      Value : Element_Type := Null_Element;
   end record;

   type Simple_List is array (Positive range <>) of List_Element;

   type Context (Size : Positive) is record
      Index : Natural := 0;
      List  : Simple_List (1 .. Size);
   end record with
     Predicate => Index <= List'Last;

end Basalt.Stack;
