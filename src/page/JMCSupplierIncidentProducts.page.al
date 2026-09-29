page 53322 "JMC Supplier Incident Products"
{
    PageType = ListPart;
    SourceTable = "JMC Supplier Incident Product";
    Caption = 'Incident Products', Comment = 'ESP="Productos de incidencia"';
    ApplicationArea = All;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Products)
            {
                field("Source Line No."; Rec."JMC Source Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Item; Rec."JMC Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec."JMC Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec."JMC Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."JMC Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select a lot assigned to this source document line.', Comment = 'ESP="Selecciona un lote asignado a esta línea del documento de origen."';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        IncidentMgt: Codeunit "JMC Supplier Incident Mgt";
                    begin
                        if IncidentMgt.SelectTrackedLot(Rec) then begin
                            Text := Rec."JMC Lot No.";
                            CurrPage.Update(false);
                        end;
                        exit(true);
                    end;
                }
            }
        }
    }
}