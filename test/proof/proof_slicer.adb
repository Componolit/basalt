
with Basalt.Slicer;

package body Proof_Slicer with
   SPARK_Mode
is

   package Slicer is new Basalt.Slicer (Positive);
   Alphabet : String (1 .. 26);

   procedure Prove
   is
      S : Slicer.Context := Slicer.Create (Alphabet'First, Alphabet'Last, 5);
      R : Slicer.Slice;
   begin
      for I in Alphabet'Range loop
         Alphabet (I) := Character'Val (I + 64);
      end loop;
      --  As this is only a test the commented out lines are kept
      --  to help proving the test in case the proof fails in the future.
      --
      --  R := Slicer.Get_Range (S);
      --  pragma Assert (R.First = Alphabet'First);
      --  pragma Assert (R.Last = Alphabet'Last);
      --  pragma Assert (Slicer.Get_Length (S) = 5);
      --  R := Slicer.Get_Slice (S);
      --  pragma Assert (R.Last - R.First + 1 <= Slicer.Get_Length (S));
      --  pragma Assert (Alphabet (R.First .. R.Last)'Length <= Slicer.Get_Length (S));
      loop
         pragma Loop_Invariant (Slicer.Get_Range (S).First = Alphabet'First);
         pragma Loop_Invariant (Slicer.Get_Range (S).Last = Alphabet'Last);
         pragma Loop_Invariant (Slicer.Get_Length (S) = 5);
         --  pragma Loop_Invariant (Slicer.Get_Length (S) = 5);
         --  pragma Loop_Invariant (Alphabet (R.First .. R.Last)'Length <= Slicer.Get_Length (S));
         R := Slicer.Get_Slice (S);
         pragma Assert (Alphabet (R.First .. R.Last)'Length <= 5);
         exit when not Slicer.Has_Next (S);
         Slicer.Next (S);
      end loop;
   end Prove;

end Proof_Slicer;
