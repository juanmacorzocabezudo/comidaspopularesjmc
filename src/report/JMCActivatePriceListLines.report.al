report 53102 "JMC Activate Price List Lines"
{
    Caption = 'Activate Price List Lines', Comment = 'ESP="Activar líneas de lista de precios"';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PriceListLine; "Price List Line")
        {
            RequestFilterFields = "Price List Code", "Price Type", "Asset Type", "Asset No.";

            trigger OnAfterGetRecord()
            begin
                if PriceListLine.Status <> PriceListLine.Status::Active then begin
                    PriceListLine.Status := PriceListLine.Status::Active;
                    PriceListLine.Modify(true);
                    ProcessedCount += 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                ProcessedCount := 0;
                PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Purchase);
            end;

            trigger OnPostDataItem()
            begin
                Message(CompletedMsg, ProcessedCount);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';

                    field(ConfirmActivation; ConfirmActivation)
                    {
                        ApplicationArea = All;
                        Caption = 'Confirm Activation', Comment = 'ESP="Confirmar activación"';
                        ToolTip = 'Confirm that you want to activate all filtered price list lines.', Comment = 'ESP="Confirme que desea activar todas las líneas de lista de precios filtradas."';
                    }
                }
                group(Information)
                {
                    Caption = 'Information', Comment = 'ESP="Información"';

                    field(InfoText; InfoTxt)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        Style = StrongAccent;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            ConfirmActivation := false;
        end;
    }

    trigger OnPreReport()
    begin
        if not ConfirmActivation then
            Error(ConfirmationRequiredErr);
    end;

    var
        ProcessedCount: Integer;
        ConfirmActivation: Boolean;
        CompletedMsg: Label '%1 price list lines have been activated successfully.', Comment = 'ESP="%1 líneas de lista de precios se han activado correctamente."';
        ConfirmationRequiredErr: Label 'You must confirm the activation by checking the "Confirm Activation" field.', Comment = 'ESP="Debe confirmar la activación marcando el campo Confirmar activación."';
        InfoTxt: Label 'This process will change the status of all filtered Price List Lines to Active. Use the filters to limit the lines to process. Make sure to check "Confirm Activation" to proceed.', Comment = 'ESP="Este proceso cambiará el estado de todas las líneas de lista de precios filtradas a Activo. Use los filtros para limitar las líneas a procesar. Asegúrese de marcar Confirmar activación para continuar."';
}
