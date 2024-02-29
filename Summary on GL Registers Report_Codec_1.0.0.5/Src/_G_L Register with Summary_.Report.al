report 80001 "G/L Register with Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Src/reports/layouts/80001_GL_Register_Summary.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'G/L Register with Summary';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No."; //SJ220210

            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(ShowLines; ShowDetails)
            {
            }
            column(ShowSummary; ShowSummary)
            {
            } //SJ220210
            column(G_L_Register__TABLECAPTION__________GLRegFilter; TableCaption + ': ' + GLRegFilter)
            {
            }
            column(GLRegFilter; GLRegFilter)
            {
            }
            column(G_L_Register__No__; "No.")
            {
            }
            column(G_L_RegisterCaption; G_L_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Entry__Posting_Date_Caption; G_L_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(G_L_Entry__Document_Type_Caption; G_L_Entry__Document_Type_CaptionLbl)
            {
            }
            column(G_L_Entry__Document_No__Caption; "G/L Entry".FieldCaption("Document No."))
            {
            }
            column(G_L_Entry__G_L_Account_No__Caption; "G/L Entry".FieldCaption("G/L Account No."))
            {
            }
            column(GLAcc_NameCaption; GLAcc_NameCaptionLbl)
            {
            }
            column(G_L_Entry_DescriptionCaption; "G/L Entry".FieldCaption(Description))
            {
            }
            column(G_L_Entry__VAT_Amount_Caption; "G/L Entry".FieldCaption("VAT Amount"))
            {
            }
            column(G_L_Entry__Gen__Posting_Type_Caption; G_L_Entry__Gen__Posting_Type_CaptionLbl)
            {
            }
            column(G_L_Entry__Gen__Bus__Posting_Group_Caption; G_L_Entry__Gen__Bus__Posting_Group_CaptionLbl)
            {
            }
            column(G_L_Entry__Gen__Prod__Posting_Group_Caption; G_L_Entry__Gen__Prod__Posting_Group_CaptionLbl)
            {
            }
            column(G_L_Entry_AmountCaption; "G/L Entry".FieldCaption(Amount))
            {
            }
            column(G_L_Entry__Entry_No__Caption; "G/L Entry".FieldCaption("Entry No."))
            {
            }
            column(G_L_Register__No__Caption; G_L_Register__No__CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                RequestFilterFields = "Posting Date", "G/L Account No."; //SJ220210

                column(G_L_Entry__Posting_Date_; Format("Posting Date"))
                {
                }
                column(G_L_Entry__Document_Type_; "Document Type")
                {
                }
                column(G_L_Entry__Document_No__; "Document No.")
                {
                }
                column(G_L_Entry__G_L_Account_No__; "G/L Account No.")
                {
                }
                column(GLAcc_Name; GLAcc.Name)
                {
                }
                column(GLAccountRec_ShowSummary; GLAccountRec."Show in Summary")
                {
                }
                column(G_L_Entry_Description; Description)
                {
                }
                column(G_L_Entry__VAT_Amount_; DetailedVATAmount)
                {
                    AutoCalcField = true;
                }
                column(G_L_Entry__Gen__Posting_Type_; "Gen. Posting Type")
                {
                }
                column(G_L_Entry__Gen__Bus__Posting_Group_; "Gen. Bus. Posting Group")
                {
                }
                column(G_L_Entry__Gen__Prod__Posting_Group_; "Gen. Prod. Posting Group")
                {
                }
                column(G_L_Entry_Amount; Amount)
                {
                }
                column(G_L_Entry__Entry_No__; "Entry No.")
                {
                }
                column(G_L_Entry_Amount_Control41; Amount)
                {
                }
                column(G_L_Entry_Amount_Control41Caption; G_L_Entry_Amount_Control41CaptionLbl)
                {
                }
                dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                {
                    DataItemLink = "Document No." = FIELD("Document No."), "No." = FIELD("G/L Account No.");
                    UseTemporary = true;
                    DataItemTableView = SORTING("Document No.");

                    column(Purch__Inv__Line_Description; Description)
                    {
                    }
                    column(Purch__Inv__Line_Amount; Amount)
                    {
                    }
                    column(Purch__Inv__Line_Document_No_; "Document No.")
                    {
                    }
                    column(Purch__Inv__Line_Line_No_; "Line No.")
                    {
                    }
                    column(Purch__Inv__Line_No_; "No.")
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        DetailedVATAmount := "Amount Including VAT" - "VAT Base Amount";
                    end;
                }
                //SJ220210 (SL.)
                dataitem("G/L Account"; "G/L Account")
                {
                    DataItemTableView = WHERE("Show in Summary" = const(true));

                    column(Name_2; Name)
                    {
                    }
                    column(GLAccountNo_2; "No.")
                    {
                    }
                    column(OpeningBalance; OpeningBalance)
                    {
                    }
                    column(TotalPosted; TotalPosted)
                    {
                    }
                    column(ClosingBalance; ClosingBalance)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        Clear(OpeningBalance);
                        Clear(TotalPosted);
                        Clear(ClosingBalance);
                        GLAccountRec.Reset();
                        GLAccountRec.CopyFilters("G/L Account");
                        //if SetPostingDateFilter then For Import Vision Task
                        GLAccountRec.SetRange("Date Filter", 0D, StartDateFilter - 1);
                        //else For Import Vision Task
                        //    GLAccountRec.SetRange("Date Filter", 0D, WorkDate() - 1); For Import Vision Task
                        if GLAccountRec.FindFirst() then;
                        GLAccountRec.CalcFields("Net Change");
                        OpeningBalance := GLAccountRec."Net Change";
                        GLAccountRec.Reset();
                        GLAccountRec.CopyFilters("G/L Account");
                        //if SetPostingDateFilter then For Import Vision Task
                        GLAccountRec.SetRange("Date Filter", StartDateFilter, EndDateFilter);
                        //else For Import Vision Task
                        //   GLAccountRec.SetRange("Date Filter", 0D, WorkDate()); For Import Vision Task
                        if GLAccountRec.FindFirst() then;
                        GLAccountRec.CalcFields("Net Change");
                        TotalPosted := GLAccountRec."Net Change";
                        GLAccountRec.Reset();
                        GLAccountRec.CopyFilters("G/L Account");
                        //if SetPostingDateFilter then For Import Vision Task
                        GLAccountRec.SetRange("Date Filter", EndDateFilter);
                        //else For Import Vision Task
                        // GLAccountRec.SetRange("Date Filter", 0D, WorkDate()); For Import Vision Task
                        if GLAccountRec.FindFirst() then;
                        GLAccountRec.CalcFields("Balance at date");
                        ClosingBalance := GLAccountRec."Balance at date";
                    end;

                    trigger OnPreDataItem()
                    begin
                        "G/L Account".SetRange("No.", "G/L Entry"."G/L Account No."); //SJ220210
                    end;
                }
                //SJ220210 (EL.)
                trigger OnAfterGetRecord()
                var
                    PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                    PurchCrMemoLine: Record "Purch. Cr. Memo Line";
                    PurchInvHeader: Record "Purch. Inv. Header";
                    PurchInvLine: Record "Purch. Inv. Line";
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    SalesCrMemoLine: Record "Sales Cr.Memo Line";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    SalesInvoiceLine: Record "Sales Invoice Line";
                    CurrancyFactor: Decimal;
                    Pos: Integer; //SJ220212
                begin
                    //SJ220212 (SL.)
                    if "G/L Entry".GetFilter("Posting Date") <> '' then begin
                        //SetPostingDateFilter := true; //SJ220212 For Import Vision Task
                        Pos := StrPos(GETFILTER("Posting Date"), '..');
                        if (Pos < 2) then
                            StartDateFilter := GetRangeMin("Posting Date")
                        else
                            if Pos = StrLen(Format(GetFilter("Posting Date"))) - 1 then
                                EndDateFilter := getrangemin("Posting Date")
                            else begin
                                EndDateFilter := getrangemax("Posting Date");
                                StartDateFilter := getrangemin("Posting Date");
                            end;
                    end;
                    if EndDateFilter = 0D then EndDateFilter := WorkDate();
                    if StartDateFilter = 0D then StartDateFilter := WorkDate();
                    //SJ220212 (EL.)
                    if not GLAcc.Get("G/L Account No.") then GLAcc.Init();
                    DetailedVATAmount := "VAT Amount";
                    if not ShowDetails then exit;
                    "Purch. Inv. Line".DeleteAll();
                    PurchInvLine.SetRange("Document No.", "Document No.");
                    PurchInvLine.SetRange("No.", "G/L Account No.");
                    PurchInvLine.SetRange("VAT Prod. Posting Group", "VAT Prod. Posting Group");
                    if PurchInvLine.FindSet() then begin
                        if not PurchInvHeader.Get("Document No.") then exit;
                        CurrancyFactor := SetCurrancyFactor(PurchInvHeader."Currency Factor");
                        Amount := 0;
                        repeat
                            PopulateRecFromPurchInvLine(PurchInvLine, CurrancyFactor, PurchInvHeader."Prices Including VAT");
                        until PurchInvLine.Next() = 0;
                        exit;
                    end;
                    PurchCrMemoLine.SetRange("Document No.", "Document No.");
                    PurchCrMemoLine.SetRange("No.", "G/L Account No.");
                    PurchCrMemoLine.SetRange("VAT Prod. Posting Group", "VAT Prod. Posting Group");
                    if PurchCrMemoLine.FindSet() then begin
                        if not PurchCrMemoHdr.Get("Document No.") then exit;
                        CurrancyFactor := SetCurrancyFactor(PurchCrMemoHdr."Currency Factor");
                        Amount := 0;
                        repeat
                            PopulateRecFromPurchCrMemoLine(PurchCrMemoLine, CurrancyFactor, PurchCrMemoHdr."Prices Including VAT");
                        until PurchCrMemoLine.Next() = 0;
                        exit;
                    end;
                    SalesInvoiceLine.SetRange("Document No.", "Document No.");
                    SalesInvoiceLine.SetRange("No.", "G/L Account No.");
                    SalesInvoiceLine.SetRange("VAT Prod. Posting Group", "VAT Prod. Posting Group");
                    if SalesInvoiceLine.FindSet() then begin
                        if not SalesInvoiceHeader.Get("Document No.") then exit;
                        CurrancyFactor := SetCurrancyFactor(SalesInvoiceHeader."Currency Factor");
                        Amount := 0;
                        repeat
                            PopulateRecFromSalesInvoiceLine(SalesInvoiceLine, CurrancyFactor, SalesInvoiceHeader."Prices Including VAT");
                        until SalesInvoiceLine.Next() = 0;
                        exit;
                    end;
                    SalesCrMemoLine.SetRange("Document No.", "Document No.");
                    SalesCrMemoLine.SetRange("No.", "G/L Account No.");
                    SalesCrMemoLine.SetRange("VAT Prod. Posting Group", "VAT Prod. Posting Group");
                    if SalesCrMemoLine.FindSet() then begin
                        if not SalesCrMemoHeader.Get("Document No.") then exit;
                        CurrancyFactor := SetCurrancyFactor(SalesCrMemoHeader."Currency Factor");
                        Amount := 0;
                        repeat
                            PopulateRecFromSalesCrMemoLine(SalesCrMemoLine, CurrancyFactor, SalesCrMemoHeader."Prices Including VAT");
                        until SalesCrMemoLine.Next() = 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                end;
            }
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control3)
                {
                    Caption = 'Options';

                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show details';
                        ToolTip = 'Specifies if the report displays all lines in detail.';
                    }
                    field(ShowSummary; ShowSummary)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Summary';
                        ToolTip = 'Specifies if the report displays summary section.';
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        GLRegFilter := "G/L Register".GetFilters();
        TempPurchInvLinePrinted.DeleteAll();
        //SetPostingDateFilter := false; //SJ220212 For Import Vision Task
        //ShowSummary := true; //SJ220212
    end;

    var
        GLAcc: Record "G/L Account";
        GLAccountRec: Record "G/L Account"; //SJ220210
        TempPurchInvLinePrinted: Record "Purch. Inv. Line" temporary;
        SetPostingDateFilter: Boolean;
        ShowDetails: Boolean;
        ShowSummary: Boolean; //SJ220210
        EndDateFilter: Date; //SJ220210
        StartDateFilter: Date; //SJ220210
        ClosingBalance: Decimal; //SJ220210
        DetailedVATAmount: Decimal;
        OpeningBalance: Decimal; //SJ220210
        TotalPosted: Decimal; //SJ220210
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        G_L_Entry__Document_Type_CaptionLbl: Label 'Document Type';
        G_L_Entry__Gen__Bus__Posting_Group_CaptionLbl: Label 'Gen. Bus. Posting Group';
        G_L_Entry__Gen__Posting_Type_CaptionLbl: Label 'Gen. Posting Type';
        G_L_Entry__Gen__Prod__Posting_Group_CaptionLbl: Label 'Gen. Prod. Posting Group';
        G_L_Entry__Posting_Date_CaptionLbl: Label 'Posting Date';
        G_L_Entry_Amount_Control41CaptionLbl: Label 'Total';
        G_L_Register__No__CaptionLbl: Label 'Register No.';
        G_L_RegisterCaptionLbl: Label 'G/L Register';
        GLAcc_NameCaptionLbl: Label 'Name';
        TotalCaptionLbl: Label 'Total';
        GLRegFilter: Text;

    local procedure DetailsPrinted(PurchInvLine: Record "Purch. Inv. Line"): Boolean
    begin
        if TempPurchInvLinePrinted.get(PurchInvLine."Document No.", PurchInvLine."Line No.") then exit(true);
        TempPurchInvLinePrinted."Document No." := PurchInvLine."Document No.";
        TempPurchInvLinePrinted."Line No." := PurchInvLine."Line No.";
        TempPurchInvLinePrinted.Insert();
    end;

    local procedure PopulateRecFromPurchInvLine(PurchInvLine: Record "Purch. Inv. Line"; CurrancyFactor: Decimal; PricesInclVAT: Boolean)
    begin
        if PricesInclVAT then
            PurchInvLine.Amount := Round(PurchInvLine."VAT Base Amount" / CurrancyFactor)
        else
            PurchInvLine.Amount := Round(PurchInvLine."Line Amount" / CurrancyFactor);
        "Purch. Inv. Line".Init();
        "Purch. Inv. Line".TransferFields(PurchInvLine);
        if not DetailsPrinted("Purch. Inv. Line") then "Purch. Inv. Line".Insert();
    end;

    local procedure PopulateRecFromPurchCrMemoLine(PurchCrMemoLine: Record "Purch. Cr. Memo Line"; CurrancyFactor: Decimal; PricesInclVAT: Boolean)
    begin
        "Purch. Inv. Line".Init();
        if PricesInclVAT then
            PurchCrMemoLine.Amount := Round(PurchCrMemoLine."VAT Base Amount" / CurrancyFactor)
        else
            PurchCrMemoLine.Amount := Round(PurchCrMemoLine."Line Amount" / CurrancyFactor);
        "Purch. Inv. Line".Description := PurchCrMemoLine.Description;
        "Purch. Inv. Line".Amount := -PurchCrMemoLine.Amount;
        "Purch. Inv. Line"."Document No." := PurchCrMemoLine."Document No.";
        "Purch. Inv. Line"."Line No." := PurchCrMemoLine."Line No.";
        "Purch. Inv. Line"."No." := PurchCrMemoLine."No.";
        "Purch. Inv. Line"."Amount Including VAT" := -PurchCrMemoLine."Amount Including VAT";
        "Purch. Inv. Line"."VAT Base Amount" := -PurchCrMemoLine."VAT Base Amount";
        if not DetailsPrinted("Purch. Inv. Line") then "Purch. Inv. Line".Insert();
    end;

    local procedure PopulateRecFromSalesInvoiceLine(SalesInvoiceLine: Record "Sales Invoice Line"; CurrancyFactor: Decimal; PricesInclVAT: Boolean)
    begin
        "Purch. Inv. Line".Init();
        if PricesInclVAT then
            SalesInvoiceLine.Amount := Round(SalesInvoiceLine."VAT Base Amount" / CurrancyFactor)
        else
            SalesInvoiceLine.Amount := Round(SalesInvoiceLine."Line Amount" / CurrancyFactor);
        "Purch. Inv. Line".Description := SalesInvoiceLine.Description;
        "Purch. Inv. Line".Amount := -SalesInvoiceLine.Amount;
        "Purch. Inv. Line"."Document No." := SalesInvoiceLine."Document No.";
        "Purch. Inv. Line"."Line No." := SalesInvoiceLine."Line No.";
        "Purch. Inv. Line"."No." := SalesInvoiceLine."No.";
        "Purch. Inv. Line"."Amount Including VAT" := -SalesInvoiceLine."Amount Including VAT";
        "Purch. Inv. Line"."VAT Base Amount" := -SalesInvoiceLine."VAT Base Amount";
        if not DetailsPrinted("Purch. Inv. Line") then "Purch. Inv. Line".Insert();
    end;

    local procedure PopulateRecFromSalesCrMemoLine(SalesCrMemoLine: Record "Sales Cr.Memo Line"; CurrancyFactor: Decimal; PricesInclVAT: Boolean)
    begin
        "Purch. Inv. Line".Init();
        if PricesInclVAT then
            SalesCrMemoLine.Amount := Round(SalesCrMemoLine."VAT Base Amount" / CurrancyFactor)
        else
            SalesCrMemoLine.Amount := Round(SalesCrMemoLine."Line Amount" / CurrancyFactor);
        "Purch. Inv. Line".Description := SalesCrMemoLine.Description;
        "Purch. Inv. Line".Amount := SalesCrMemoLine.Amount;
        "Purch. Inv. Line"."Document No." := SalesCrMemoLine."Document No.";
        "Purch. Inv. Line"."Line No." := SalesCrMemoLine."Line No.";
        "Purch. Inv. Line"."No." := SalesCrMemoLine."No.";
        "Purch. Inv. Line"."Amount Including VAT" := SalesCrMemoLine."Amount Including VAT";
        "Purch. Inv. Line"."VAT Base Amount" := SalesCrMemoLine."VAT Base Amount";
        if not DetailsPrinted("Purch. Inv. Line") then "Purch. Inv. Line".Insert();
    end;

    local procedure SetCurrancyFactor(HeaderCurrancyFactor: Decimal): Decimal
    begin
        if HeaderCurrancyFactor = 0 then exit(1);
        exit(HeaderCurrancyFactor);
    end;
}
