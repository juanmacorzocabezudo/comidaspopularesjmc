table 53156 "JMC Payroll Import Entry"
{
    Caption = 'Payroll Import Entry', Comment = 'ESP="Propuesta asiento nómina"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Import No."; Integer)
        {
            Caption = 'Import No.', Comment = 'ESP="Nº importación"';
            ToolTip = 'Specifies the payroll import the entry line belongs to.', Comment = 'ESP="Especifica la importación de nóminas a la que pertenece la línea de asiento."';
            TableRelation = "JMC Payroll Import Header"."JMC No.";
            Editable = false;
        }
        field(2; "JMC Import Line No."; Integer)
        {
            Caption = 'Payroll Line No.', Comment = 'ESP="Nº línea nómina"';
            ToolTip = 'Specifies the payroll line the entry line belongs to.', Comment = 'ESP="Especifica la nómina a la que pertenece la línea de asiento."';
            TableRelation = "JMC Payroll Import Line"."JMC Line No." where("JMC Import No." = field("JMC Import No."));
            Editable = false;
        }
        field(3; "JMC Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
            ToolTip = 'Specifies the line number.', Comment = 'ESP="Especifica el número de línea."';
            Editable = false;
        }
        field(4; "JMC Concept Type"; Enum "JMC Payroll Concept Type")
        {
            Caption = 'Concept Type', Comment = 'ESP="Tipo concepto"';
            ToolTip = 'Specifies the concept of the entry line. When it changes, the G/L account and the description are proposed from the setup.', Comment = 'ESP="Especifica el concepto de la línea de asiento. Al cambiarlo, se proponen la cuenta y la descripción desde la configuración."';

            trigger OnValidate()
            begin
                if "JMC Concept Type" <> "JMC Concept Type"::Garnishment then begin
                    "JMC Garnishment Authority" := "JMC Garnishment Authority"::" ";
                    "JMC Garnishment File No." := '';
                end;
                ProposeAccountAndDescription();
            end;
        }
        field(5; "JMC Garnishment Authority"; Enum "JMC Garnishment Authority")
        {
            Caption = 'Garnishment Authority', Comment = 'ESP="Organismo embargante"';
            ToolTip = 'Specifies the authority that orders the garnishment. The G/L account is proposed from the garnishment account setup.', Comment = 'ESP="Especifica el organismo que ordena el embargo. La cuenta se propone desde la configuración de cuentas por organismo."';

            trigger OnValidate()
            begin
                if "JMC Garnishment Authority" <> "JMC Garnishment Authority"::" " then
                    TestField("JMC Concept Type", "JMC Concept Type"::Garnishment);
                ProposeAccountAndDescription();
            end;
        }
        field(6; "JMC Garnishment File No."; Text[50])
        {
            Caption = 'Garnishment File No.', Comment = 'ESP="Nº expediente embargo"';
            ToolTip = 'Specifies the file number or reference of the garnishment.', Comment = 'ESP="Especifica el nº de expediente o referencia del embargo."';

            trigger OnValidate()
            begin
                if "JMC Garnishment File No." <> '' then
                    TestField("JMC Concept Type", "JMC Concept Type"::Garnishment);
                "JMC Description" := GetDefaultDescription();
            end;
        }
        field(7; "JMC Source Column"; Enum "JMC Payroll Excel Column")
        {
            Caption = 'Source Column', Comment = 'ESP="Columna origen"';
            ToolTip = 'Specifies the Excel column the amount comes from. It is used to check that the manual split of a column adds up to the Excel amount.', Comment = 'ESP="Especifica la columna del Excel de la que viene el importe. Se usa para comprobar que el reparto manual de una columna suma el importe del Excel."';
        }
        field(8; "JMC Balancing"; Boolean)
        {
            Caption = 'Balancing Line', Comment = 'ESP="Línea contrapartida"';
            ToolTip = 'Specifies that the line is the balancing line generated from the column mapping.', Comment = 'ESP="Especifica que la línea es la contrapartida generada desde el mapeo de columnas."';
            Editable = false;
        }
        field(9; "JMC G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.', Comment = 'ESP="Nº cuenta"';
            ToolTip = 'Specifies the G/L account of the entry line. The dimensions are the default dimensions of the account.', Comment = 'ESP="Especifica la cuenta contable de la línea de asiento. Las dimensiones son las predeterminadas de la cuenta."';
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting));

            trigger OnValidate()
            begin
                UpdateGlobalDimensions();
            end;
        }
        field(10; "JMC G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name', Comment = 'ESP="Nombre cuenta"';
            ToolTip = 'Specifies the name of the G/L account.', Comment = 'ESP="Especifica el nombre de la cuenta contable."';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("JMC G/L Account No.")));
            Editable = false;
        }
        field(11; "JMC Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            ToolTip = 'Specifies the description of the journal line.', Comment = 'ESP="Especifica la descripción de la línea del diario."';
        }
        field(12; "JMC Amount"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
            ToolTip = 'Specifies the amount of the entry line. Positive amounts are debit and negative amounts are credit.', Comment = 'ESP="Especifica el importe de la línea de asiento. Los importes positivos son debe y los negativos haber."';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                "JMC Amount" := Round("JMC Amount");
                UpdateDebitCredit();
            end;
        }
        field(13; "JMC Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount', Comment = 'ESP="Importe debe"';
            ToolTip = 'Specifies the debit amount of the entry line.', Comment = 'ESP="Especifica el importe al debe de la línea de asiento."';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                Validate("JMC Amount", "JMC Debit Amount");
            end;
        }
        field(14; "JMC Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount', Comment = 'ESP="Importe haber"';
            ToolTip = 'Specifies the credit amount of the entry line.', Comment = 'ESP="Especifica el importe al haber de la línea de asiento."';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                Validate("JMC Amount", -"JMC Credit Amount");
            end;
        }
        field(15; "JMC Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code', Comment = 'ESP="Cód. dimensión global 1"';
            ToolTip = 'Specifies the default value of global dimension 1 of the G/L account. It is for information only.', Comment = 'ESP="Especifica el valor predeterminado de la dimensión global 1 de la cuenta. Es solo informativo."';
            Editable = false;
        }
        field(16; "JMC Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code', Comment = 'ESP="Cód. dimensión global 2"';
            ToolTip = 'Specifies the default value of global dimension 2 of the G/L account. It is for information only.', Comment = 'ESP="Especifica el valor predeterminado de la dimensión global 2 de la cuenta. Es solo informativo."';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "JMC Import No.", "JMC Import Line No.", "JMC Line No.")
        {
            Clustered = true;
        }
        key(Column; "JMC Import No.", "JMC Import Line No.", "JMC Source Column", "JMC Balancing")
        {
            SumIndexFields = "JMC Amount";
        }
    }

    trigger OnInsert()
    begin
        SetPayrollLinePending();
    end;

    trigger OnModify()
    begin
        SetPayrollLinePending();
    end;

    trigger OnDelete()
    begin
        SetPayrollLinePending();
    end;

    procedure ProposeAccountAndDescription()
    var
        jmcConceptSetup: Record "JMC Payroll Concept Setup";
        jmcGarnishmentAccount: Record "JMC Garnishment Account Setup";
        jmcAccountNo: Code[20];
    begin
        if jmcConceptSetup.Get("JMC Concept Type") then
            jmcAccountNo := jmcConceptSetup."JMC G/L Account No.";
        if ("JMC Concept Type" = "JMC Concept Type"::Garnishment) and ("JMC Garnishment Authority" <> "JMC Garnishment Authority"::" ") then
            if jmcGarnishmentAccount.Get("JMC Garnishment Authority") then
                if jmcGarnishmentAccount."JMC G/L Account No." <> '' then
                    jmcAccountNo := jmcGarnishmentAccount."JMC G/L Account No.";
        Validate("JMC G/L Account No.", jmcAccountNo);
        "JMC Description" := GetDefaultDescription();
    end;

    procedure GetDefaultDescription(): Text[100]
    var
        jmcPayrollLine: Record "JMC Payroll Import Line";
        jmcConceptText: Text;
        jmcDescriptionTok: Label '%1 - %2', Locked = true;
        jmcGarnishmentTok: Label '%1 %2 %3', Locked = true;
    begin
        jmcConceptText := Format("JMC Concept Type");
        if "JMC Concept Type" = "JMC Concept Type"::Garnishment then
            jmcConceptText := DelChr(StrSubstNo(jmcGarnishmentTok, jmcConceptText, Format("JMC Garnishment Authority"), "JMC Garnishment File No."), '>', ' ');
        if jmcPayrollLine.Get("JMC Import No.", "JMC Import Line No.") then
            if jmcPayrollLine."JMC Description" <> '' then
                exit(CopyStr(StrSubstNo(jmcDescriptionTok, jmcConceptText, jmcPayrollLine."JMC Description"), 1, MaxStrLen("JMC Description")));
        exit(CopyStr(jmcConceptText, 1, MaxStrLen("JMC Description")));
    end;

    local procedure UpdateDebitCredit()
    begin
        if "JMC Amount" >= 0 then begin
            "JMC Debit Amount" := "JMC Amount";
            "JMC Credit Amount" := 0;
        end else begin
            "JMC Debit Amount" := 0;
            "JMC Credit Amount" := -"JMC Amount";
        end;
    end;

    local procedure UpdateGlobalDimensions()
    var
        jmcGLSetup: Record "General Ledger Setup";
    begin
        "JMC Global Dimension 1 Code" := '';
        "JMC Global Dimension 2 Code" := '';
        if "JMC G/L Account No." = '' then
            exit;
        jmcGLSetup.Get();
        "JMC Global Dimension 1 Code" := GetDefaultDimensionValue(jmcGLSetup."Global Dimension 1 Code");
        "JMC Global Dimension 2 Code" := GetDefaultDimensionValue(jmcGLSetup."Global Dimension 2 Code");
    end;

    local procedure GetDefaultDimensionValue(jmcDimensionCode: Code[20]): Code[20]
    var
        jmcDefaultDimension: Record "Default Dimension";
    begin
        if jmcDimensionCode = '' then
            exit('');
        if jmcDefaultDimension.Get(Database::"G/L Account", "JMC G/L Account No.", jmcDimensionCode) then
            exit(jmcDefaultDimension."Dimension Value Code");
        exit('');
    end;

    local procedure SetPayrollLinePending()
    var
        jmcPayrollLine: Record "JMC Payroll Import Line";
    begin
        if not jmcPayrollLine.Get("JMC Import No.", "JMC Import Line No.") then
            exit;
        jmcPayrollLine.TestHeaderEditable();
        jmcPayrollLine.SetPendingValidation();
        jmcPayrollLine.Modify(false);
    end;
}
