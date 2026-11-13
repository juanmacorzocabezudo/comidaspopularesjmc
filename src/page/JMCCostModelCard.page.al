page 53109 "JMC Cost Model Card"
{
    Caption = 'Cost Model', Comment = 'ESP="Modelo de costes"';
    PageType = Document;
    SourceTable = "JMC Cost Model";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("JMC Description"; Rec."JMC Description")
                {
                    ApplicationArea = All;
                }
            }
            group(Structure)
            {
                Caption = 'Structure Allocation', Comment = 'ESP="Reparto de estructura"';

                field("JMC Total Structure Cost"; Rec."JMC Total Structure Cost")
                {
                    ApplicationArea = All;
                }
                field("JMC Catering Structure Pct."; Rec."JMC Catering Structure Pct.")
                {
                    ApplicationArea = All;
                }
                field("JMC Industry Structure Pct."; Rec."JMC Industry Structure Pct.")
                {
                    ApplicationArea = All;
                }
                field("JMC Catering Allocation"; Rec."JMC Catering Allocation")
                {
                    ApplicationArea = All;
                }
                field("JMC Industry Allocation"; Rec."JMC Industry Allocation")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "JMC Cost Model Lines")
            {
                ApplicationArea = All;
                SubPageLink = "JMC Model Code" = field("JMC Code");
            }
        }
    }

    trigger OnOpenPage()
    var
        jmcModelCode: Code[20];
        jmcMultipleModelsErr: Label 'Multiple cost models exist. Resolve them before opening the cost model; no data has been changed.', Comment = 'ESP="Existen varios modelos de costes. Resuélvalos antes de abrir el modelo; no se ha modificado ningún dato."';
    begin
        Rec.Reset();
        Rec.LockTable();
        if Rec.FindFirst() then begin
            jmcModelCode := Rec."JMC Code";
            if Rec.Next() <> 0 then
                Error(jmcMultipleModelsErr);
            Rec.Get(jmcModelCode);
        end else begin
            Rec.Init();
            Rec."JMC Code" := 'GENERAL';
            Rec.Insert(true);
        end;
        Rec.SetRange("JMC Code", Rec."JMC Code");
    end;
}
