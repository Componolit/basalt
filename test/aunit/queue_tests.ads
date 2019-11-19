
with Aunit;
with Aunit.Test_Cases;

package Queue_Tests
is
   type Test_Case is new Aunit.Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Test_Case);

   function Name (T : Test_Case) return Aunit.Message_String;

end Queue_Tests;
