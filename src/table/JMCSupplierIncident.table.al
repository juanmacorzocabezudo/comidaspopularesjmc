table 53302 "JMC Supplier Incident"
{
    Caption = 'Supplier Incident', Comment = 'ESP="Incidencia de proveedor"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            DataClassification = SystemMetadata;
        }
        field(2; "JMC Date"; Date)
        {
            Caption = 'Date', Comment = 'ESP="Fecha"';
            DataClassification = CustomerContent;
        }
        field(3; "JMC Vendor No."; Code[20])
        {
            Caption = 'Vendor', Comment = 'ESP="Proveedor"';
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(4; "JMC Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name', Comment = 'ESP="Nombre proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("JMC Vendor No.")));
            Editable = false;
        }
        field(5; "JMC Source Type"; Enum "JMC Incident Source Type")
        {
            Caption = 'Source Document Type', Comment = 'ESP="Tipo documento origen"';
            DataClassification = CustomerContent;
        }
        field(6; "JMC Source Document No."; Code[20])
        {
            Caption = 'Source Document No.', Comment = 'ESP="Nº documento origen"';
            DataClassification = CustomerContent;
        }
        field(7; "JMC Source Line No."; Integer)
        {
            Caption = 'Source Line No.', Comment = 'ESP="Nº línea origen"';
            DataClassification = CustomerContent;
        }
        field(8; "JMC Item No."; Code[20])
        {
            Caption = 'Item', Comment = 'ESP="Producto"';
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
        }
        field(9; "JMC Item Description"; Text[100])
        {
            Caption = 'Item Description', Comment = 'ESP="Descripción producto"';
            DataClassification = CustomerContent;
        }
        field(10; "JMC Lot No."; Code[50])
        {
            Caption = 'Lot No.', Comment = 'ESP="Lote"';
            DataClassification = CustomerContent;
        }
        field(11; "JMC Detected By"; Enum "JMC Incident Detected By")
        {
            Caption = 'Detected By', Comment = 'ESP="Detectado por"';
            DataClassification = CustomerContent;
        }
        field(12; "JMC Recurring Incident"; Boolean)
        {
            Caption = 'Recurring Incident', Comment = 'ESP="Incidencia recurrente"';
            DataClassification = CustomerContent;
        }
        field(13; "JMC NC No."; Code[20])
        {
            Caption = 'NC No.', Comment = 'ESP="NC asociada"';
            DataClassification = CustomerContent;
        }
        field(14; "JMC Incident Description"; Text[2048])
        {
            Caption = 'Incident Description', Comment = 'ESP="Descripción incidencia"';
            DataClassification = CustomerContent;
        }
        field(15; "JMC Supplier Communication"; Text[2048])
        {
            Caption = 'Supplier Communication', Comment = 'ESP="Comunicación con proveedor"';
            DataClassification = CustomerContent;
        }
        field(16; "JMC Communication Date"; Date)
        {
            Caption = 'Communication Date', Comment = 'ESP="Fecha comunicación"';
            DataClassification = CustomerContent;
        }
        field(17; "JMC Supplier Response"; Text[2048])
        {
            Caption = 'Supplier Response', Comment = 'ESP="Respuesta proveedor"';
            DataClassification = CustomerContent;
        }
        field(18; "JMC Corrective Measures"; Text[2048])
        {
            Caption = 'Corrective Measures', Comment = 'ESP="Medidas correctivas"';
            DataClassification = CustomerContent;
        }
        field(19; "JMC Credit Memo Registered"; Boolean)
        {
            Caption = 'Credit Memo Registered', Comment = 'ESP="Abono registrado"';
            DataClassification = CustomerContent;
        }
        field(20; "JMC Created By"; Code[50])
        {
            Caption = 'Created By', Comment = 'ESP="Usuario creador"';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(21; "JMC Creation DateTime"; DateTime)
        {
            Caption = 'Creation DateTime', Comment = 'ESP="Fecha creación"';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(22; "JMC No. Series"; Code[20])
        {
            Caption = 'No. Series', Comment = 'ESP="Nº serie"';
            TableRelation = "No. Series".Code;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "JMC No.")
        {
            Clustered = true;
        }
        key(VendorDate; "JMC Vendor No.", "JMC Date")
        {
        }
        key(SourceDocument; "JMC Source Type", "JMC Source Document No.")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "JMC Date" = 0D then
            "JMC Date" := WorkDate();
        if "JMC Created By" = '' then
            "JMC Created By" := CopyStr(UserId(), 1, MaxStrLen("JMC Created By"));
        if "JMC Creation DateTime" = 0DT then
            "JMC Creation DateTime" := CurrentDateTime();
        if "JMC No." = '' then begin
            TestField("JMC No. Series");
            "JMC No." := NoSeries.GetNextNo("JMC No. Series", "JMC Date", true);
        end;
    end;
}