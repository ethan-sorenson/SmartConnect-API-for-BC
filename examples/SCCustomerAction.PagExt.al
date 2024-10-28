pageextension 66100 "SmartConnect Cust. Run Map" extends "Customer Card"
{
    actions
    {
        addafter(ApprovalEntries)
        {
            action("Run SmartConnect Map")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Action;
                trigger OnAction()
                var
                    SCRunMap: Codeunit "SmartConnect Run Map";
                begin
                    Update();
                    SCRunMap.RunIntegration('e1e6ea73-d5d8-4ebd-86e6-b21600a189e7', 'GBL_BC_NO', Rec."No.");
                end;
            }
        }
    }
}