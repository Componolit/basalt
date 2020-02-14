with Aunit.Assertions;
with Basalt.Stack;

package body Stack_Tests
is
   package F is new Basalt.Stack (Integer, 0);

   procedure Test_Stack (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (100);
      J : Integer;
   begin
      F.Initialize (Q);
      for I in 70 .. 120 loop
         F.Push (Q, I);
      end loop;
      for I in reverse 70 .. 120 loop
         F.Pop (Q, J);
         Aunit.Assertions.Assert (J = I, "Invalid order");
      end loop;
   end Test_Stack;

   procedure Test_Full_Empty (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (2);
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count not 0");
      F.Push (Q, 1);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count not 1 after Push");
      F.Push (Q, 2);
      Aunit.Assertions.Assert (F.Count (Q) = 2, "Count not 2 after Push");
      F.Drop (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count not 1 after Drop");
      F.Drop (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count not 0 after Drop");
   end Test_Full_Empty;

   procedure Test_Single_Element (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (1);
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Is_Empty (Q), "Stack not empty");
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Stack not empty");
      F.Push (Q, 1);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Stack not full");
      Aunit.Assertions.Assert (F.Is_Full (Q), "Stack not full");
      F.Drop (Q);
      Aunit.Assertions.Assert (F.Is_Empty (Q), "Stack not empty");
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Stack not empty after drop");
   end Test_Single_Element;

   procedure Test_Count (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (100);
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
      for I in Integer range 1 .. 20 loop
         F.Push (Q, I);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 20, "Count should be 20");
      for I in Integer range 1 .. 40 loop
         F.Push (Q, I);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 60, "Count should be 60");
      for I in Integer range 1 .. 50 loop
         F.Drop (Q);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 10, "Count should be 10");
      for I in Integer range 1 .. 80 loop
         F.Push (Q, I);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 90, "Count should be 90");
      for I in Integer range 1 .. 90 loop
         F.Drop (Q);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
   end Test_Count;

   procedure Test_Size (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q1 : F.Context (1);
      Q2 : F.Context (50);
      Q3 : F.Context (200);
      Q4 : F.Context (13000);
   begin
      F.Initialize (Q1);
      F.Initialize (Q2);
      F.Initialize (Q3);
      F.Initialize (Q4);
      Aunit.Assertions.Assert (F.Size (Q1) = 1, "Size of Q1 should be 1");
      Aunit.Assertions.Assert (F.Size (Q2) = 50, "Size of Q2 should be 50");
      Aunit.Assertions.Assert (F.Size (Q3) = 200, "Size of Q3 should be 200");
      Aunit.Assertions.Assert (F.Size (Q4) = 13000, "Size of Q4 should be 13000");
   end Test_Size;

   procedure Test_Generic (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      procedure Push (I : out Integer);
      procedure Peek (I : Integer);
      Q : F.Context (1);
      procedure Push is new F.Generic_Push (Push);
      procedure Pop is new F.Generic_Pop (Peek);
      procedure Push (I : out Integer)
      is
      begin
         I := 42;
      end Push;
      procedure Peek (I : Integer)
      is
      begin
         Aunit.Assertions.Assert (I = 42, "I should be 42");
      end Peek;
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
      Push (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count should be 1");
      Pop (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
   end Test_Generic;


   procedure Register_Tests (T : in out Test_Case)
   is
      use Aunit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Stack'Access, "Test stack");
      Register_Routine (T, Test_Full_Empty'Access, "Test full and emtpy");
      Register_Routine (T, Test_Single_Element'Access, "Test single element");
      Register_Routine (T, Test_Count'Access, "Test count");
      Register_Routine (T, Test_Size'Access, "Test size");
      Register_Routine (T, Test_Generic'Access, "Test generic");
   end Register_Tests;

   function Name (T : Test_Case) return Aunit.Message_String
   is
   begin
      return Aunit.Format ("Basalt.Stack");
   end Name;

end Stack_Tests;
