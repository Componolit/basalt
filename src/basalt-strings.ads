--
--  @summary String operation instances for common types
--  @author  Johannes Kliemann
--  @date    2019-11-19
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of Basalt, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with Interfaces;
with Basalt.Strings_Generic;

package Basalt.Strings with
   SPARK_Mode,
   Pure,
   Annotate => (GNATprove, Always_Return)
is

   --  Image instances for the most common ranged and modular types
   function Image is new Strings_Generic.Image_Ranged (Integer);
   function Image is new Strings_Generic.Image_Ranged (Long_Integer);
   function Image is new Strings_Generic.Image_Modular (Standard.Interfaces.Unsigned_8);
   function Image is new Strings_Generic.Image_Modular (Standard.Interfaces.Unsigned_16);
   function Image is new Strings_Generic.Image_Modular (Standard.Interfaces.Unsigned_32);
   function Image is new Strings_Generic.Image_Modular (Standard.Interfaces.Unsigned_64);

   --  Image function for Boolean
   --
   --  @param V  Boolean value
   --  @return   String "True" or "False"
   function Image (V : Boolean) return String with
      Post => Image'Result'Length <= 5 and Image'Result'First = 1;

   --  Image function for Duration
   --
   --  @param V  Duration value
   --  @param    Duration as string with 6 decimals
   function Image (V : Duration) return String with
      Post => Image'Result'Length <= 28 and Image'Result'First = 1;

   package Value_U8 is new Strings_Generic.Value_Option_Modular (Interfaces.Unsigned_8);
   package Value_U16 is new Strings_Generic.Value_Option_Modular (Interfaces.Unsigned_16);
   package Value_U32 is new Strings_Generic.Value_Option_Modular (Interfaces.Unsigned_32);
   package Value_U64 is new Strings_Generic.Value_Option_Modular (Interfaces.Unsigned_64);

   package Value_Integer is new Strings_Generic.Value_Option_Ranged (Integer);
   package Value_Long_Integer is new Strings_Generic.Value_Option_Ranged (Long_Integer);
   package Value_Natural is new Strings_Generic.Value_Option_Ranged (Natural);
   package Value_Positive is new Strings_Generic.Value_Option_Ranged (Positive);

   type String_Slice (Valid : Boolean := False) is record
      case Valid is
         when True =>
            First : Natural;
            Last  : Natural;
         when False =>
            null;
      end case;
   end record;

   --  Split a string into a head and tail part based on a delimiting character
   --
   --  @param Value  String to split
   --  @param Delimiter  Delimiting character
   --  @param Head Range in Value before Delimiter, excluding Delimiter
   --  @param Tail Range in Value after Delimiter, excluding first Delimiter
   procedure Split (Value     :     String;
                    Delimiter :     Character;
                    Head      : out String_Slice;
                    Tail      : out String_Slice) with
      Pre  => not Head'Constrained and not Tail'Constrained,
      Post => (Value'Length > 0 and then Delimiter /= Value (Value'First)) = Head.Valid
              and then (for some I in Value'Range => Value (I) = Delimiter and then I /= Value'Last) = Tail.Valid
              and then (if Tail.Valid then Tail.First in Value'Range and then Tail.Last in Value'Range)
              and then (if Head.Valid then Head.First in Value'Range and then Head.Last in Value'Range);

end Basalt.Strings;
