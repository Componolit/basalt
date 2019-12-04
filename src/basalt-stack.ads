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
package Basalt.Stack with
   SPARK_Mode,
   Pure
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

   --  Pop an element off the stack
   --
   --  @param S  Stack
   --  @param E  Result element
   procedure Pop (S : in out Context;
                  E :    out Element_Type) with
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
   procedure Initialize (S            : out Context;
                         Null_Element :     Element_Type) with
     Post => Is_Empty (S)
             and then not Is_Full (S);

   pragma Annotate (GNATprove, False_Positive,
                    """S.List"" might not be initialized*",
                    "Initialized in complete loop");

private

   type Simple_List is array (Positive range <>) of Element_Type;

   type Context (Size : Positive) is record
      Index : Natural;
      List  : Simple_List (1 .. Size);
   end record with
     Predicate => Index <= List'Last;

end Basalt.Stack;
