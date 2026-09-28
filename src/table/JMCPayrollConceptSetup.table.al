table 53151 "JMC Payroll Concept Setup"
{
    Caption = 'Payroll Concept Setup', Comment = 'ESP="Configuración conceptos nómina"';
    DataClassification = CustomerContent;
    DrillDownPageId = "JMC Payroll Concept Setup";
    LookupPageId = "JMC Payroll Concept Setup";

    fields
    {
        field(1; "JMC Concept Type"; Enum "JMC Payroll Concept Type")
        {
            Caption = 'Concept Type', Comment = 'ESP="Tipo concepto"';
            ToolTip = 'Specifies the payroll concept.', Comment = 'ESP="Especifica el concepto de la nómina."';
        }
        field(2; "JMC G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.', Comment = 'ESP="Nº cuenta"';
            ToolTip = 'Specifies the G/L account proposed for this concept.', Comment = 'ESP="Especifica la cuenta contable que se propone para este concepto."';
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
        key(PK; "JMC Concept Type")
        {
            Clustered = true;
        }
    }
}
