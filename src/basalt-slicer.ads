--
--  @summary Generic slice generator
--  @author  Johannes Kliemann
--  @date    2019-11-19
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of Basalt, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

generic
   type Index is range <>;
package Basalt.Slicer with
   SPARK_Mode
is

   type Context is private;

   type Slice is record
      First : Index;
      Last  : Index;
   end record with
      Dynamic_Predicate => Slice.First <= Slice.Last;

   function Create (Range_First  : Index;
                    Range_Last   : Index;
                    Slice_Length : Index) return Context with
      Pre  => Range_First < Range_Last
              and then Slice_Length > 0,
      Post => Get_Range (Create'Result).First = Range_First
              and then Get_Range (Create'Result).Last = Range_Last
              and then Get_Length (Create'Result) = Slice_Length;

   function Get_Slice (C : Context) return Slice with
      Post => Get_Slice'Result.Last - Get_Slice'Result.First < Get_Length (C)
              and then Get_Slice'Result.First in Get_Range (C).First .. Get_Range (C).Last
              and then Get_Slice'Result.Last in Get_Range (C).First .. Get_Range (C).Last;

   function Get_Range (C : Context) return Slice;

   function Get_Length (C : Context) return Index;

   function Has_Next (C : Context) return Boolean;

   procedure Next (C : in out Context) with
      Pre  => Has_Next (C),
      Post => Get_Range (C'Old) = Get_Range (C)
              and then Get_Length (C'Old) = Get_Length (C);

private

   type Context is record
      Full_Range   : Slice;
      Slice_Range  : Slice;
      Slice_Length : Index;
   end record with
      Dynamic_Predicate => Slice_Range.First in Full_Range.First .. Full_Range.Last
                           and then Slice_Range.Last in Full_Range.First .. Full_Range.Last
                           and then Slice_Range.Last - Slice_Range.First + 1 <= Slice_Length;

end Basalt.Slicer;
