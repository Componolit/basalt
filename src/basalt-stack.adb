--
--  @summary Generic stack implementation
--  @author  Alexander Senier
--  @date    2019-12-02
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of Basalt, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

package body Basalt.Stack
is
   pragma Annotate (GNATprove, Terminating, Basalt.Stack);

   ----------
   -- Size --
   ----------

   function Size (S : Context) return Positive is
     (S.List'Last);

   -----------
   -- Count --
   -----------

   function Count (S : Context) return Natural is
     (S.Index);

   ----------
   -- Push --
   ----------

   procedure Push (S : in out Context;
                   E :        Element_Type) is
   begin
      S.Index := S.Index + 1;
      S.List (S.Index) := E;
   end Push;

   ------------------
   -- Generic_Push --
   ------------------

   procedure Generic_Push (S : in out Context)
   is
   begin
      S.Index := S.Index + 1;
      Push (S.List (S.Index));
   end Generic_Push;

   ---------
   -- Pop --
   ---------

   procedure Pop (S : in out Context;
                  E :    out Element_Type) is
   begin
      E := S.List (S.Index);
      Drop (S);
   end Pop;

   -----------------
   -- Generic_Pop --
   -----------------

   procedure Generic_Pop (S : in out Context)
   is
   begin
      Pop (S.List (S.Index));
      Drop (S);
   end Generic_Pop;

   ----------
   -- Drop --
   ----------

   procedure Drop (S : in out Context) is
   begin
      S.Index := S.Index - 1;
   end Drop;

   -----------
   -- Reset --
   -----------

   procedure Reset (S : in out Context) is
   begin
      S.Index := 0;
   end Reset;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (S            : out Context;
                         Null_Element :     Element_Type)
   is
   begin
      S.Index := 0;
      --  This would be the correct way to initialize S.List:
      --     S.List  := (others => Null_Element);
      --  As this creates a (potentially large) object on the stack, we initialize in a loop. The resulting flow
      --  error is justified in the spec.
      for E of S.List loop
         pragma Loop_Invariant (S.Index = 0);
         E := Null_Element;
      end loop;
   end Initialize;

end Basalt.Stack;
