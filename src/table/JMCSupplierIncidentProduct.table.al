table 53321 "JMC Supplier Incident Product"
{
    Caption = 'Supplier Incident Product', Comment = 'ESP="Producto de incidencia de proveedor"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Incident No."; Code[20])
        {
            Caption = 'Incident No.', Comment = 'ESP="Nº incidencia"';
            TableRelation = "JMC Supplier Incident"."JMC No.";
            DataClassification = CustomerContent;
        }
        field(2; "JMC Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
            DataClassification = SystemMetadata;
        }
        field(3; "JMC Source Line No."; Integer)
        {
            Caption = 'Source Line No.', Comment = 'ESP="Nº línea origen"';
            DataClassification = CustomerContent;
        }
        field(4; "JMC Item No."; Code[20])
        {
            Caption = 'Item', Comment = 'ESP="Producto"';
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
        }
        field(5; "JMC Item Description"; Text[100])
        {
            Caption = 'Item Description', Comment = 'ESP="Descripción producto"';
            DataClassification = CustomerContent;
        }
        field(6; "JMC Quantity"; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
            DataClassification = CustomerContent;
        }
        field(7; "JMC Lot No."; Code[50])
        {
            Caption = 'Lot No.', Comment = 'ESP="Lote"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IncidentMgt: Codeunit "JMC Supplier Incident Mgt";
            begin
                IncidentMgt.ValidateTrackedLot(Rec);
            end;
        }
        field(8; "JMC Reservation Entry No."; Integer)
        {
            Caption = 'Tracking Entry No.', Comment = 'ESP="Nº mov. seguimiento"';
            TableRelation = "Reservation Entry"."Entry No.";
            DataClassification = SystemMetadata;
        }
        field(9; "JMC Tracked Lot No."; Code[50])
        {
            Caption = 'Lot No.', Comment = 'ESP="Lote"';
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by the editable JMC Lot No. field.';
            ObsoleteTag = '27.5.0.44';
            FieldClass = FlowField;
            CalcFormula = lookup("Reservation Entry"."Lot No." where("Entry No." = field("JMC Reservation Entry No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "JMC Incident No.", "JMC Line No.")
        {
            Clustered = true;
        }
        key(SourceLine; "JMC Incident No.", "JMC Source Line No.")
        {
        }
    }
}