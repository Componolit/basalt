
with Ada.Command_Line;
with Aunit;
with Aunit.Reporter.Text;
with Aunit.Run;
with Suite;

procedure Test
is
   use type Aunit.Status;
   function Run is new Aunit.Run.Test_Runner_With_Status (Suite.Suite);
   Reporter : Aunit.Reporter.Text.Text_Reporter;
   S        : Aunit.Status;
begin
   Reporter.Set_Use_ANSI_Colors (True);
   S := Run (Reporter);
   if S = Aunit.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
   else
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Test;
