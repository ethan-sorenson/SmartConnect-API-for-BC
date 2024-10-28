codeunit 66100 SmartConnectInstallCode
{
    // Set the codeunit to be an install codeunit. 
    Subtype = Install;

    // This trigger includes code for company-related operations. 
    trigger OnInstallAppPerCompany();
    var
        Setup: Record "SmartConnect Setup";
    begin
        // If the "SmartConnect Config" table is empty, insert the default values.
        if Setup.IsEmpty() then begin
            InsertSetupLines();
        end;
    end;

    // Create and insert a record in the "SmartConnect Config" table.
    procedure InsertSetupLines();
    var
        Setup: Record "SmartConnect Setup";

    begin
        Setup.Init();
        Setup."Service URL" := 'https://apieuw.smartconnect.com';
        Setup.Insert();
    end;

}