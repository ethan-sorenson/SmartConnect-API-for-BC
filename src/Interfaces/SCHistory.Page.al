page 66101 "SmartConnect History"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SmartConnect History";
    AnalysisModeEnabled = true;
    Editable = false;
    DeleteAllowed = true;
    SourceTableView = sorting("SystemCreatedAt") order(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Id; rec.Id) { }
                field("Run Number"; rec."Run Number") { }
                field(Successful; rec.Successful) { }
                field("Record Count"; rec."Record Count") { }
                field("Error Count"; rec."Error Count") { }
                field("Global Variable"; rec."Global Variable") { }
                field("Global Value"; rec."Global Value") { }
                field("Run User"; GetUserNameFromSecurityId(rec.SystemCreatedBy)) { }
                field("Error Message"; rec."Error Message")
                {
                    MultiLine = true;
                }
            }
        }
    }
    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        User.Get(UserSecurityID);
        exit(User."User Name");
    end;
}