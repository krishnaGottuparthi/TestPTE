pageextension 80001 "Codec Vendor Card" extends "Vendor Card"
{
    actions
    {
        addafter(ContactBtn)
        {
            action("Codec EditPage")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Visible = ShowVendAction;
                Image = Edit;
                Caption = 'Edit Vendor';
                ToolTip = 'Executes the EditPage action.';
                trigger OnAction()
                begin
                    SingleInstance.SetValueVend(true);
                    Page.RunModal(Page::"Vendor Card", Rec);
                    SingleInstance.SetValueVend(false);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if (Rec."No." = '') and ((xRec."No." = '')) then //Only if new Vendor is created then the card page would editable. In other cases, Action "Codec EditPage" should be used to edit the page.
            SingleInstance.SetValueVend(true);

        if CurrPage.Editable(SingleInstance.GetValueVend()) = false then
            ShowVendAction := true;
    end;

    trigger OnClosePage()
    begin
        SingleInstance.SetValueVend(false);
    end;

    var
        SingleInstance: Codeunit "Codec SingleInstance";
        ShowVendAction: Boolean;
}
