pageextension 80021 "G/L Account Card Sum" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            // field("Show in Summary "; Rec."Show in Summary")
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the value of the Show in Summary field.';
            // }
        }
    }
    actions
    {
        addafter(DocsWithoutIC)
        {
            action("Codec EditPage")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Visible = ShowGlAction;
                Image = Edit;
                Caption = 'Edit G/L Account';
                ToolTip = 'Executes the EditPage action.';
                trigger OnAction()
                begin
                    SingleInstance.SetValueGL(true);
                    Page.RunModal(Page::"G/L Account Card", Rec);
                    SingleInstance.SetValueGL(false);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if (Rec."No." = '') and ((xRec."No." = '')) then //Only if new GLAcc is created then the card page would editable. In other cases, Action "Codec EditPage" should be used to edit the page.
            SingleInstance.SetValueGL(true);

        if CurrPage.Editable(SingleInstance.GetValueGL()) = false then
            ShowGlAction := true;
    end;

    trigger OnClosePage()
    begin
        SingleInstance.SetValueGL(false);
    end;

    var
        SingleInstance: Codeunit "Codec SingleInstance";
        ShowGlAction: Boolean;
}