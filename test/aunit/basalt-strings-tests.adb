
with Aunit.Assertions;
with Interfaces;

package body Basalt.Strings.Tests
is

   package SI renames Standard.Interfaces;

   procedure Test_Image_Integer (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert ( Image (Integer'(0)), "0",  "Invalid Integer Image");
      Aunit.Assertions.Assert ( Image (Integer'First), "-2147483648",  "Invalid Integer Image");
      Aunit.Assertions.Assert ( Image (Integer'Last), "2147483647",  "Invalid Integer Image");
      Aunit.Assertions.Assert ( Image (Integer'(-42)), "-42",  "Invalid Integer Image");
      Aunit.Assertions.Assert ( Image (Integer'(42)), "42",  "Invalid Integer Image");
   end Test_Image_Integer;

   procedure Test_Image_Natural (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert ( Image (Natural'First), "0",  "Invalid Natural Image");
      Aunit.Assertions.Assert ( Image (Natural'(42)), "42",  "Invalid Natural Image");
      Aunit.Assertions.Assert ( Image (Natural'Last), "2147483647",  "Invalid Natural Image");
   end Test_Image_Natural;

   procedure Test_Image_Long_Integer (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert ( Image (Long_Integer'(0)), "0",  "Invalid Long_Integer Image");
      Aunit.Assertions.Assert ( Image (Long_Integer'Last), "9223372036854775807",  "Invalid Long_Integer Image");
      Aunit.Assertions.Assert ( Image (Long_Integer'First), "-9223372036854775808",  "Invalid Long_Integer Image");
   end Test_Image_Long_Integer;

   procedure Test_Image_Unsigned_8 (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert ( Image (SI.Unsigned_8'First), "0",  "Invalid Unsigned_8 Image");
      Aunit.Assertions.Assert ( Image (SI.Unsigned_8'Last), "255",  "Invalid Unsigned_8 Image");
      Aunit.Assertions.Assert ( Image (SI.Unsigned_8'(42)), "42",  "Invalid Unsigned_8 Image");
   end Test_Image_Unsigned_8;

   procedure Test_Image_Unsigned_64 (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (Image (SI.Unsigned_64'First), "0",  "Invalid Unsigned_64 Image");
      Aunit.Assertions.Assert (Image (SI.Unsigned_64'(42)), "42",  "Invalid Unsigned_64 Image");
      Aunit.Assertions.Assert (Image (SI.Unsigned_64'Last), "18446744073709551615",  "Invalid Unsigned_64 Image");
   end Test_Image_Unsigned_64;

   procedure Test_Image_Base_2 (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (Image (SI.Unsigned_64'Last, 2), "1111111111111111111111111111111111111111111111111111111111111111", "Invalid Base 2 Image");
      Aunit.Assertions.Assert (Image (Long_Integer'First, 2), "-1000000000000000000000000000000000000000000000000000000000000000", "Invalid Base 2 Image");
      Aunit.Assertions.Assert (Image (Long_Integer'Last, 2), "111111111111111111111111111111111111111111111111111111111111111", "Invalid Base 2 Image");
      Aunit.Assertions.Assert (Image (Long_Integer'(42), 2), "101010", "Invalid Base 2 Image");
      Aunit.Assertions.Assert (Image (Long_Integer'(-42), 2), "-101010", "Invalid Base 2 Image");
   end Test_Image_Base_2;

   procedure Test_Image_Base_16 (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (Image (SI.Unsigned_64'First, 16), "0", "Invalid Base 16 Image");
      Aunit.Assertions.Assert (Image (SI.Unsigned_64'(42), 16), "2A", "Invalid Base 16 Image");
      Aunit.Assertions.Assert (Image (SI.Unsigned_64'Last, 16), "FFFFFFFFFFFFFFFF", "Invalid Base 16 Image");
      Aunit.Assertions.Assert (Image (Long_Integer'First, 16), "-8000000000000000", "Invalid Base 16 Image");
      Aunit.Assertions.Assert (Image (Long_Integer'Last, 16), "7FFFFFFFFFFFFFFF", "Invalid Base 16 Image");
      Aunit.Assertions.Assert (Image (Long_Integer'(42), 16, False), "2a", "Invalid Base 16 Image");
   end Test_Image_Base_16;

   procedure Test_Image_Boolean (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (Image (True), "True",  "Invalid Boolean Image");
      Aunit.Assertions.Assert (Image (False), "False",  "Invalid Boolean Image");
   end Test_Image_Boolean;

   procedure Test_Image_Duration (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (Image (Duration'(9223372036.0)), "9223372036.000000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(-9223372036.0)), "-9223372036.000000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'Last), "9223372036.000000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'First), "-9223372036.000000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(0.0)), "0.000000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(42.0)), "42.000000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(-42.0)), "-42.000000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(0.123)), "0.123000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(42.123)), "42.123000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(-42.123)), "-42.123000",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(0.000123)), "0.000123",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(42.000123)), "42.000123",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(-42.000123)), "-42.000123",  "Invalid Duration Image");
      Aunit.Assertions.Assert (Image (Duration'(-0.0042)), "-0.004200", "Invalid Duration Image");
   end Test_Image_Duration;

   procedure Test_Value_Modular_8 (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (not Value_U8.Value ("-1").Valid, "Invalid True: -1");
      Aunit.Assertions.Assert (not Value_U8.Value ("256").Valid, "Invalid True: 256");
      Aunit.Assertions.Assert (not Value_U8.Value ("Hello").Valid, "Invalid True: Hello");
      Aunit.Assertions.Assert (not Value_U8.Value ("0x").Valid, "Invalid True: 0x");
      Aunit.Assertions.Assert (not Value_U8.Value ("##").Valid, "Invalid True: ##");
      Aunit.Assertions.Assert (not Value_U8.Value ("16##").Valid, "Invalid True: 16##");
      Aunit.Assertions.Assert (Value_U8.Value ("0").Value'Img, " 0", "Invalid Value");
      Aunit.Assertions.Assert (Value_U8.Value ("255").Value'Img, " 255", "Invalid Value");
      Aunit.Assertions.Assert (Value_U8.Value ("42").Value'Img, " 42", "Invalid Value");
      Aunit.Assertions.Assert (Value_U8.Value ("0xff").Value'Img, " 255", "Invalid C Hex Value");
      Aunit.Assertions.Assert (Value_U8.Value ("0x42").Value'Img, " 66", "Invalid C Hex Value");
      Aunit.Assertions.Assert (Value_U8.Value ("0b101010").Value'Img, " 42", "Invalid C Bin Value");
      Aunit.Assertions.Assert (Value_U8.Value ("0o42").Value'Img, " 34", "Invalid C Oct Value");
      Aunit.Assertions.Assert (Value_U8.Value ("10#42#").Value'Img, " 42", "Invalid Ada Value");
      Aunit.Assertions.Assert (Value_U8.Value ("16#42#").Value'Img, " 66", "Invalid Ada Hex Value");
      Aunit.Assertions.Assert (Value_U8.Value ("8#31#").Value'Img, " 25", "Invalid Ada Oct Value");
   end Test_Value_Modular_8;

   procedure Test_Value_Modular_32 (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (not Value_U32.Value ("-1").Valid, "Invalid True: -1");
      Aunit.Assertions.Assert (not Value_U32.Value ("4294967296").Valid, "Invalid True: 4294967296");
      Aunit.Assertions.Assert (not Value_U32.Value ("blubb").Valid, "Invalid True: blubb");
      Aunit.Assertions.Assert (not Value_U32.Value ("10#-1#").Valid, "Invalid True: 10#-1#");
      Aunit.Assertions.Assert (Value_U32.Value ("2147483647").Value'Img, " 2147483647", "Invalid Value");
      Aunit.Assertions.Assert (Value_U32.Value ("0x7fffffff").Value'Img, " 2147483647", "Invalid C Hex Value");
      Aunit.Assertions.Assert (Value_U32.Value ("0x7FFFFFFF").Value'Img, " 2147483647", "Invalid C Hex Value (Upper)");
      Aunit.Assertions.Assert (Value_U32.Value ("16#7fffffff#").Value'Img, " 2147483647", "Invalid Ada Hex Value");
      Aunit.Assertions.Assert (Value_U32.Value ("0x7fffffff").Value'Img, " 2147483647", "Invalid C Hex Value");
      Aunit.Assertions.Assert (Value_U32.Value ("0xffffffff").Value'Img, " 4294967295", "Invalid C Hex Value");
   end Test_Value_Modular_32;

   procedure Test_Value_Modular_64 (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Aunit.Assertions.Assert (not Value_U64.Value ("-1").Valid, "Invalid True: -1");
      Aunit.Assertions.Assert (not Value_U64.Value ("18446744073709551970").Valid, "Invalid True: 18446744073709551970");
      Aunit.Assertions.Assert (Value_U64.Value ("18446744073709551615").Value'Img, " 18446744073709551615", "Invalid Value");
      Aunit.Assertions.Assert (Value_U64.Value ("2844674779565").Value'Img, " 2844674779565", "Invalid Value");
   end Test_Value_Modular_64;

   procedure Register_Tests (T : in out Test_Case)
   is
      use Aunit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Image_Integer'Access, "Test Image Integer");
      Register_Routine (T, Test_Image_Natural'Access, "Test Image Natural");
      Register_Routine (T, Test_Image_Long_Integer'Access, "Test Image Long_Integer");
      Register_Routine (T, Test_Image_Unsigned_8'Access, "Test Image Unsigned_8");
      Register_Routine (T, Test_Image_Unsigned_64'Access, "Test Image Unsigned_64");
      Register_Routine (T, Test_Image_Boolean'Access, "Test Image Boolean");
      Register_Routine (T, Test_Image_Duration'Access, "Test Image Duration");
      Register_Routine (T, Test_Image_Base_2'Access, "Test Image Base 2");
      Register_Routine (T, Test_Image_Base_16'Access, "Test Image Base 16");
      Register_Routine (T, Test_Value_Modular_8'Access, "Test Value Unsigned_8");
      Register_Routine (T, Test_Value_Modular_32'Access, "Test Value Unsigned_32");
      Register_Routine (T, Test_Value_Modular_64'Access, "Test Value Unsigned_64");
   end Register_Tests;

   function Name (T : Test_Case) return Aunit.Message_String
   is
   begin
      return Aunit.Format ("Basalt.Strings");
   end Name;

end Basalt.Strings.Tests;
