--
--  @summary Generic string operations
--  @author  Johannes Kliemann
--  @date    2019-11-19
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of Basalt, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with Interfaces;

package body Basalt.Strings_Generic with
   SPARK_Mode
is
   package SI renames Standard.Interfaces;
   use type SI.Unsigned_8;
   use type SI.Unsigned_64;

   generic
      type T is (<>);
   function Character_Value (C : Character) return T with
      Pre => C in '0' .. '9' | 'a' .. 'f' | 'A' .. 'F';

   function Digit (U : SI.Unsigned_8;
                   C : Boolean) return Character
   is
      (if
          U < 10
       then
          Character'Val (U + 48)
       else
          (if C then Character'Val (U + 55) else Character'Val (U + 87))) with
      Pre => U <= 16;

   function Image_Ranged (V : I;
                          B : Base    := 10;
                          C : Boolean := True) return String
   is
      function Image_Unsigned is new Image_Modular (SI.Unsigned_64);
      L : constant Long_Integer := Long_Integer (V);
      U : SI.Unsigned_64;
   begin
      if L = Long_Integer'First then
         U := SI.Unsigned_64 (abs (L + 1)) + 1;
      else
         U := SI.Unsigned_64 (abs (L));
      end if;
      if V >= 0 then
         return Image_Unsigned (U, B, C);
      else
         return "-" & Image_Unsigned (U, B, C);
      end if;
   end Image_Ranged;

   procedure Lemma_U64_Le16 (B : Base) with
     Ghost,
     Post => SI.Unsigned_64 (B) <= 16;

   procedure Lemma_U64_Le16 (B : Base) is
   begin
      null;
   end Lemma_U64_Le16;

   function Image_Modular (V : U;
                           B : Base    := 10;
                           C : Boolean := True) return String
   is
      Image : String (1 .. Base_Length (B)) := (others => '_');
      T     : SI.Unsigned_64                := SI.Unsigned_64 (V);
   begin
      for I in reverse Image'First .. Image'Last loop
         Lemma_U64_Le16 (B);
         Image (I) := Digit (SI.Unsigned_8 (T rem SI.Unsigned_64 (B)), C);
         T         := T / SI.Unsigned_64 (B);
         if T = 0 then
            return
               R : constant String (1 .. Image'Last - I + 1) := Image (I .. Image'Last)
            do
               null;
            end return;
         end if;
      end loop;
      return Image;
   end Image_Modular;

   function Character_Value (C : Character) return T
   is
      pragma Compile_Time_Error (T'Pos (T'First) > 0 and then T'Pos (T'Last) < 16,
                                 "Type must contain positions 0 - 16");
   begin
      case C is
         when '0' .. '9' =>
            return T'Val (Character'Pos (C) - 48);
         when 'a' .. 'f' =>
            return T'Val (Character'Pos (C) - 87);
         when 'A' .. 'F' =>
            return T'Val (Character'Pos (C) - 55);
         when others =>
            raise Constraint_Error;
      end case;
   end Character_Value;

   package body Value_Option_Modular
   is
      function Char_Value is new Character_Value (T);

      function Value (S : String;
                      B : Base) return Optional
      is
         C_Val : T;
         Val : T := 0;
      begin
         if S'Length < 1 then
            return Optional'(Valid => False);
         end if;
         for I in S'Range loop
            if
               S (I) not in '0' .. (if B <= 10 then Lowercase (Residue_Class_Ring (B) - 1) else '9')
               and then (if B > 10 then S (I) not in 'a' .. Lowercase (Residue_Class_Ring (B) - 1)
                                                   | 'A' .. Uppercase (Residue_Class_Ring (B) - 1))
            then
               return Optional'(Valid => False);
            end if;
            C_Val := Char_Value (S (I));
            if Val > T'Last - C_Val then
               return Optional'(Valid => False);
            end if;
            Val := Val + C_Val;
            exit when I = S'Last;
            if Val > T'Last / T (B) then
               return Optional'(Valid => False);
            end if;
            Val := Val * T (B);
         end loop;
         return Optional'(Valid => True, Value => Val);
      end Value;

      function Value (S : String) return Optional
      is
         Ada_Base       : Boolean  := False;
         Ada_Base_Begin : Positive := Positive'Last;
         Ada_Base_Opt   : Optional := Optional'(Valid => False);
      begin
         if S'Length < 3 then
            return Value (S, 10);
         end if;
         if S (S'First .. S'First + 1) = "0x" then -- C base 16
            return Value (S (S'First + 2 .. S'Last), 16);
         elsif S (S'First .. S'First + 1) = "0o" then -- C base 8
            return Value (S (S'First + 2 .. S'Last), 8);
         elsif S (S'First .. S'First + 1) = "0b" then -- C base 2
            return Value (S (S'First + 2 .. S'Last), 2);
         else
            for I in S'Range loop
               if
                  S (I) = '#'
                  and then I > S'First
                  and then S (S'Last) = '#'
                  and then I < S'Last - 1
               then
                  Ada_Base := True;
                  Ada_Base_Begin := I;
                  exit;
               end if;
            end loop;
            if Ada_Base then
               Ada_Base_Opt := Value (S (S'First .. Ada_Base_Begin - 1), 10);
            end if;
            if
               Ada_Base_Opt.Valid
               and then Ada_Base_Opt.Value in T (Base'First) .. T (Base'Last)
            then
               return Value (S (Ada_Base_Begin + 1 .. S'Last - 1), Base (Ada_Base_Opt.Value));
            else
               return Value (S, 10);
            end if;
         end if;
      end Value;

   end Value_Option_Modular;

end Basalt.Strings_Generic;
