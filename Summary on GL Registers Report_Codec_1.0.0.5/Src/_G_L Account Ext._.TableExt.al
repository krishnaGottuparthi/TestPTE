tableextension 80014 "G/L Account Ext." extends "G/L Account"
{
    fields
    {
        field(80000; "Show in Summary"; Boolean)
        {
            Caption = 'Show in Summary';
            DataClassification = ToBeClassified;
        }
    }
}
