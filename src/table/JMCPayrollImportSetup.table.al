table 53150 "JMC Payroll Import Setup"
{
    Caption = 'Payroll Import Setup', Comment = 'ESP="Configuración importación nóminas"';
    DataClassification = CustomerContent;
    DrillDownPageId = "JMC Payroll Import Setup";
    LookupPageId = "JMC Payroll Import Setup";

    fields
    {
        field(1; "JMC Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'ESP="Clave primaria"';
        }
        field(2; "JMC Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name', Comment = 'ESP="Nombre libro diario"';
            ToolTip = 'Specifies the general journal template where the payroll lines are created.', Comment = 'ESP="Especifica el libro del diario general donde se crean las líneas de nómina."';
            TableRelation = "Gen. Journal Template".Name where(Type = const(General), Recurring = const(false));

            trigger OnValidate()
            begin
                if "JMC Journal Template Name" <> xRec."JMC Journal Template Name" then
                    "JMC Journal Batch Name" := '';
            end;
        }
        field(3; "JMC Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';
            ToolTip = 'Specifies the general journal batch where the payroll lines are created. The batch must be empty when the journal is created.', Comment = 'ESP="Especifica la sección del diario general donde se crean las líneas de nómina. La sección debe estar vacía al crear el diario."';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("JMC Journal Template Name"));
        }
        field(4; "JMC Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series', Comment = 'ESP="Nº serie documento"';
            ToolTip = 'Specifies the number series used for the document number of each payroll entry when the journal batch has no number series.', Comment = 'ESP="Especifica la serie usada para el nº de documento de cada asiento de nómina cuando la sección del diario no tiene serie."';
            TableRelation = "No. Series";
        }
        field(5; "JMC Balance Tolerance"; Decimal)
        {
            Caption = 'Balance Tolerance', Comment = 'ESP="Tolerancia de cuadre"';
            ToolTip = 'Specifies the maximum difference allowed in the payroll checks.', Comment = 'ESP="Especifica la diferencia máxima admitida en las comprobaciones de la nómina."';
            DecimalPlaces = 2 : 5;
            MinValue = 0;
            InitValue = 0.01;
        }
    }

    keys
    {
        key(PK; "JMC Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
