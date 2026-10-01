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

            trigger OnLookup()
            begin
                LookupLotNo();
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
        field(10; "JMC Tracking Source Type"; Integer)
        {
            Caption = 'Tracking Source Type', Comment = 'ESP="Tipo origen seguimiento"';
            DataClassification = SystemMetadata;
        }
        field(11; "JMC Tracking Source ID"; Code[20])
        {
            Caption = 'Tracking Source ID', Comment = 'ESP="Nº origen seguimiento"';
            DataClassification = SystemMetadata;
        }
        field(12; "JMC Tracking Source Subtype"; Integer)
        {
            Caption = 'Tracking Source Subtype', Comment = 'ESP="Subtipo origen seguimiento"';
            DataClassification = SystemMetadata;
        }
        field(13; "JMC Observations"; Text[2048])
        {
            Caption = 'Observations', Comment = 'ESP="Observaciones"';
            DataClassification = CustomerContent;
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

    local procedure LookupLotNo()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempLotNoInfo: Record "Lot No. Information" temporary;
        LotLookup: Page "JMC Incident Lot Lookup";
    begin
        ItemLedgerEntry.SetLoadFields("Item No.", "Lot No.");
        ItemLedgerEntry.SetRange("Item No.", "JMC Item No.");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
        if ItemLedgerEntry.FindSet() then
            repeat
                if not TempLotNoInfo.Get("JMC Item No.", '', ItemLedgerEntry."Lot No.") then begin
                    TempLotNoInfo.Init();
                    TempLotNoInfo."Item No." := "JMC Item No.";
                    TempLotNoInfo."Lot No." := ItemLedgerEntry."Lot No.";
                    TempLotNoInfo.Insert();
                end;
            until ItemLedgerEntry.Next() = 0;

        if TempLotNoInfo.Get("JMC Item No.", '', "JMC Lot No.") then;
        LotLookup.SetLots(TempLotNoInfo);
        LotLookup.SetRecord(TempLotNoInfo);
        LotLookup.LookupMode(true);
        if LotLookup.RunModal() = Action::LookupOK then begin
            LotLookup.GetRecord(TempLotNoInfo);
            Validate("JMC Lot No.", TempLotNoInfo."Lot No.");
        end;
    end;
}