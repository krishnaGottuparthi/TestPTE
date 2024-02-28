codeunit 80000 "Codec SingleInstance"
{
    SingleInstance = true;
    procedure SetValueGL(Value: Boolean)
    begin
        GLEditable := Value;
    end;

    procedure GetValueGL(): Boolean
    begin
        exit(GLEditable);
    end;

    procedure SetValueVend(Value: Boolean)
    begin
        VendorEditable := Value;
    end;

    procedure GetValueVend(): Boolean
    begin
        exit(VendorEditable);
    end;

    var
        GLEditable: Boolean;
        VendorEditable: Boolean;
}
