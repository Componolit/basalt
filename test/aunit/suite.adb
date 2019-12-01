
with Basalt.Strings.Tests;
with Queue_Tests;
with Slicer_Tests;
with Stack_Tests;

package body Suite
is

   Result : aliased Aunit.Test_Suites.Test_Suite;

   Strings_Case : aliased Basalt.Strings.Tests.Test_Case;
   Queue_Case   : aliased Queue_Tests.Test_Case;
   Slicer_Case  : aliased Slicer_Tests.Test_Case;
   Stack_Case   : aliased Stack_Tests.Test_Case;

   function Suite return Aunit.Test_Suites.Access_Test_Suite
   is
   begin
      Result.Add_Test (Strings_Case'Access);
      Result.Add_Test (Queue_Case'Access);
      Result.Add_Test (Slicer_Case'Access);
      Result.Add_Test (Stack_Case'Access);
      return Result'Access;
   end Suite;

end Suite;
