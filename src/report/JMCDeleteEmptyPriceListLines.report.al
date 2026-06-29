report 53103 "JMC Delete Empty Price Lines"
{
    Caption = 'Delete Empty Price List Lines', Comment = 'ESP="Eliminar líneas de precio vacías"';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PriceListLine; "Price List Line")
        {
            DataItemTableView = WHERE("Asset No." = CONST(''));
            RequestFilterFields = "Price List Code", "Price Type", "Asset Type";

            trigger OnAfterGetRecord()
            begin
                PriceListLine.Delete(true);
                DeletedCount += 1;
            end;

            trigger OnPreDataItem()
            begin
                DeletedCount := 0;
            end;

            trigger OnPostDataItem()
            begin
                Message(CompletedMsg, DeletedCount);
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

                    field(ConfirmDeletion; ConfirmDeletion)
                    {
                        ApplicationArea = All;
                        Caption = 'Confirm Deletion', Comment = 'ESP="Confirmar eliminación"';
                        ToolTip = 'Confirm that you want to delete all price list lines with empty product.', Comment = 'ESP="Confirme que desea eliminar todas las líneas de lista de precios con producto vacío."';
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
            ConfirmDeletion := false;
        end;
    }

    trigger OnPreReport()
    begin
        if not ConfirmDeletion then
            Error(ConfirmationRequiredErr);
    end;

    var
        DeletedCount: Integer;
        ConfirmDeletion: Boolean;
        CompletedMsg: Label '%1 empty price list lines have been deleted successfully.', Comment = 'ESP="%1 líneas de lista de precios vacías se han eliminado correctamente."';
        ConfirmationRequiredErr: Label 'You must confirm the deletion by checking the "Confirm Deletion" field.', Comment = 'ESP="Debe confirmar la eliminación marcando el campo Confirmar eliminación."';
        InfoTxt: Label 'This process will permanently delete all Price List Lines where the Product (Asset No.) is empty. Use the filters to preview the records before deletion. Make sure to check "Confirm Deletion" to proceed.', Comment = 'ESP="Este proceso eliminará permanentemente todas las líneas de lista de precios donde el Producto (Asset No.) esté vacío. Use los filtros para previsualizar los registros antes de la eliminación. Asegúrese de marcar Confirmar eliminación para continuar."';
}
