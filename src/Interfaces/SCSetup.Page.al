
namespace eOneSolutions.SmartConnect.API;

page 66100 "SmartConnect Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SmartConnect Setup";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Service URL"; rec."Service URL")
                {
                    ApplicationArea = All;
                }
                field("Client Id"; rec."Client Id")
                {
                    ApplicationArea = All;
                }
                field("Client Secret"; ClientSecret)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        IsolatedStorage.Set('SmartConnectClientSecret', ClientSecret)
                    end;
                }
                field("Username"; rec.Username)
                {
                    ApplicationArea = All;
                }
                field("Password"; Password)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        IsolatedStorage.Set('SmartConnectPassword', Password)
                    end;
                }
                field("Token Expiry"; rec."Token Expiry")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Refresh Token Expiry"; rec."Refresh Token Expiry")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Created Date"; rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Modified Date"; rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("New Token")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = New;
                trigger OnAction()
                begin
                    Update();
                    SCAuthMgt.GetToken();
                    Message('Token Successfully Retrieved');
                end;
            }
            action("Refresh Token")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Refresh;
                trigger OnAction()
                begin
                    SCAuthMgt.RefreshToken();
                    Message('Token Successfully Refreshed');
                end;
            }
            action("Validate Token")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Approval;
                trigger OnAction()
                begin
                    SCAuthMgt.ValidateToken();
                    Message('Token is Valid');
                end;
            }
            action("View History")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = ListPage;
                RunObject = Page "SmartConnect History";
                ToolTip = 'View historical integration runs';
            }
        }
    }
    var
        ClientSecret: Text;
        Password: Text;
        SCAuthMgt: Codeunit "SmartConnect Auth. Mgt.";
}