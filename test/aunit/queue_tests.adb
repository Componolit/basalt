
with Aunit.Assertions;
with Basalt.Queue;

package body Queue_Tests
is
   package F is new Basalt.Queue (Integer, 0);

   procedure Test_Fifo (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (100);
      J : Integer;
   begin
      F.Initialize (Q);
      for I in 70 .. 120 loop
         F.Put (Q, I);
      end loop;
      for I in 70 .. 120 loop
         F.Pop (Q, J);
         Aunit.Assertions.Assert (J = I, "Invalid order");
      end loop;
   end Test_Fifo;

   procedure Test_Full_Empty (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (2);
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count not 0");
      F.Put (Q, 1);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count not 1 after Put");
      F.Put (Q, 2);
      Aunit.Assertions.Assert (F.Count (Q) = 2, "Count not 2 after Put");
      F.Drop (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count not 1 after Drop");
      F.Drop (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count not 0 after Drop");
   end Test_Full_Empty;

   procedure Test_Single_Element (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (1);
      J : Integer;
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Queue not empty");
      F.Put (Q, 1);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Queue not full");
      F.Peek (Q, J);
      Aunit.Assertions.Assert (J = 1, "Invalid item value");
      F.Drop (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Queue not empty after drop");
   end Test_Single_Element;

   procedure Test_Count (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (100);
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
      for I in Integer range 1 .. 20 loop
         F.Put (Q, I);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 20, "Count should be 20");
      for I in Integer range 1 .. 40 loop
         F.Put (Q, I);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 60, "Count should be 60");
      for I in Integer range 1 .. 50 loop
         F.Drop (Q);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 10, "Count should be 10");
      for I in Integer range 1 .. 80 loop
         F.Put (Q, I);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 90, "Count should be 90");
      for I in Integer range 1 .. 90 loop
         F.Drop (Q);
      end loop;
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
   end Test_Count;

   procedure Test_Peek (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q      : F.Context (1);
      Unused : Integer;
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
      F.Put (Q, 1);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count should be 1");
      F.Peek (Q, Unused);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count should be 1 after Peek");
   end Test_Peek;

   procedure Test_Generic (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      procedure Put (I : out Integer);
      procedure Peek (I : Integer);
      Q : F.Context (1);
      procedure Put is new F.Generic_Put (Put);
      procedure Peek is new F.Generic_Peek (Peek);
      procedure Pop is new F.Generic_Pop (Peek);
      procedure Put (I : out Integer)
      is
      begin
         I := 42;
      end Put;
      procedure Peek (I : Integer)
      is
      begin
         Aunit.Assertions.Assert (I = 42, "I should be 42");
      end Peek;
   begin
      F.Initialize (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
      Put (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count should be 1");
      Peek (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 1, "Count should be 1 after Peek");
      Pop (Q);
      Aunit.Assertions.Assert (F.Count (Q) = 0, "Count should be 0");
   end Test_Generic;

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

   procedure Test_Overflow (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Q : F.Context (10);
      J : Integer;
   begin
      F.Initialize (Q);
      for I in Integer range 1 .. 7 loop
         F.Put (Q, I);
      end loop;
      for I in Integer range 1 .. 3 loop
         F.Pop (Q, J);
         Aunit.Assertions.Assert (I = J, "Invalid order before overflow");
      end loop;
      for I in Integer range 8 .. 13 loop
         F.Put (Q, I);
      end loop;
      for I in Integer range 4 .. 13 loop
         F.Pop (Q, J);
         Aunit.Assertions.Assert (I = J, "Invalid order after overflow");
      end loop;
   end Test_Overflow;

   procedure Register_Tests (T : in out Test_Case)
   is
      use Aunit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Fifo'Access, "Test fifo");
      Register_Routine (T, Test_Full_Empty'Access, "Test full and emtpy");
      Register_Routine (T, Test_Single_Element'Access, "Test single element");
      Register_Routine (T, Test_Overflow'Access, "Test overflow");
      Register_Routine (T, Test_Count'Access, "Test count");
      Register_Routine (T, Test_Size'Access, "Test size");
      Register_Routine (T, Test_Peek'Access, "Test peek");
      Register_Routine (T, Test_Generic'Access, "Test generic");
   end Register_Tests;

   function Name (T : Test_Case) return Aunit.Message_String
   is
   begin
      return Aunit.Format ("Basalt.Queue");
   end Name;

end Queue_Tests;
