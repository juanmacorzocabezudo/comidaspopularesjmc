table 53106 "JMC C01 Cost History"
{
    Caption = 'Structure Cost History', Comment = 'ESP="Histórico costes de estructura"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
            AutoIncrement = true;
        }
        field(2; "JMC Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
            TableRelation = Item."No.";
        }
        field(3; "JMC Cost Value"; Decimal)
        {
            Caption = 'C01 Value', Comment = 'ESP="Valor C01"';
            DecimalPlaces = 0 : 18;
        }
        field(4; "JMC Cost Type"; Enum "JMC Cost Value Type")
        {
            Caption = 'Cost Type', Comment = 'ESP="Tipo coste"';
        }
        field(5; "JMC Applied At"; DateTime)
        {
            Caption = 'Applied At', Comment = 'ESP="Fecha y hora de aplicación"';
        }
        field(6; "JMC Applied By"; Code[50])
        {
            Caption = 'Applied By', Comment = 'ESP="Aplicado por"';
        }
        field(7; "JMC Model Code"; Code[20])
        {
            Caption = 'Model Code', Comment = 'ESP="Código modelo"';
        }
        field(8; "JMC Starting Date"; Date)
        {
            Caption = 'Starting Date', Comment = 'ESP="Fecha inicial"';
        }
        field(9; "JMC Ending Date"; Date)
        {
            Caption = 'Ending Date', Comment = 'ESP="Fecha final"';
        }
        field(10; "JMC Cost Fixed"; Boolean)
        {
            Caption = 'Cost Fixed', Comment = 'ESP="Coste fijado"';
            ToolTip = 'Select this entry to apply its C01 value to the recipe. Only one entry can be fixed per item.', Comment = 'ESP="Marque este movimiento para aplicar su valor C01 a la receta. Solo puede haber un movimiento fijado por producto."';

            trigger OnValidate()
            var
                jmcHistoryMgt: Codeunit "JMC Structure Recipe Costs";
                jmcChooseAnotherErr: Label 'Select another history entry to change the fixed cost.', Comment = 'ESP="Marque otro movimiento del histórico para cambiar el coste fijado."';
            begin
                if not "JMC Cost Fixed" then begin
                    if xRec."JMC Cost Fixed" then
                        Error(jmcChooseAnotherErr);
                    exit;
                end;
                if not xRec."JMC Cost Fixed" then
                    jmcHistoryMgt.FixHistoryEntry(Rec);
            end;
        }
        field(11; "JMC Fixed At"; DateTime)
        {
            Caption = 'Fixed At', Comment = 'ESP="Fecha y hora de fijación"';
        }
        field(12; "JMC Fixed By"; Code[50])
        {
            Caption = 'Fixed By', Comment = 'ESP="Fijado por"';
        }
        field(13; "JMC Base Unit"; Code[10])
        {
            Caption = 'Base Unit', Comment = 'ESP="Unidad base"';
        }
    }

    keys
    {
        key(PK; "JMC Entry No.")
        {
            Clustered = true;
        }
        key(ItemFixed; "JMC Item No.", "JMC Cost Fixed")
        {
        }
    }
}
