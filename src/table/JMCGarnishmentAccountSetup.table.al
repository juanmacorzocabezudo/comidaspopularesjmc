table 53153 "JMC Garnishment Account Setup"
{
    Caption = 'Garnishment Account Setup', Comment = 'ESP="Cuentas por organismo embargante"';
    DataClassification = CustomerContent;
    DrillDownPageId = "JMC Garnishment Account Setup";
    LookupPageId = "JMC Garnishment Account Setup";

    fields
    {
        field(1; "JMC Authority"; Enum "JMC Garnishment Authority")
        {
            Caption = 'Authority', Comment = 'ESP="Organismo"';
            ToolTip = 'Specifies the authority that orders the garnishment.', Comment = 'ESP="Especifica el organismo que ordena el embargo."';
        }
        field(2; "JMC G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.', Comment = 'ESP="Nº cuenta"';
            ToolTip = 'Specifies the G/L account proposed for garnishments of this authority.', Comment = 'ESP="Especifica la cuenta contable que se propone para los embargos de este organismo."';
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting));
        }
        field(3; "JMC G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name', Comment = 'ESP="Nombre cuenta"';
            ToolTip = 'Specifies the name of the G/L account.', Comment = 'ESP="Especifica el nombre de la cuenta contable."';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("JMC G/L Account No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "JMC Authority")
        {
            Clustered = true;
        }
    }
}
