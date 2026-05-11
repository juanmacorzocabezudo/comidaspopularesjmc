report 53100 "JMC Delete Archived Events"
{
    Caption = 'Delete Archived Events', Comment = 'ESP="Eliminar eventos archivados"';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Evento; Evento)
        {
            DataItemTableView = SORTING("Codigo Evento") WHERE(Estado = CONST(Archivado));

            trigger OnAfterGetRecord()
            begin
                if ConfirmDeletion then begin
                    Delete(true);
                    DeletedCount += 1;
                end;
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
                        Caption = 'Confirm Deletion', Comment = 'ESP="Confirmar eliminación"';
                        ToolTip = 'Specifies if you want to delete the archived events. Check this box to proceed with deletion.', Comment = 'ESP="Especifica si desea eliminar los eventos archivados. Marque esta casilla para proceder con la eliminación."';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if not ConfirmDeletion then
            Error(ConfirmDeletionErr);

        DeletedCount := 0;
    end;

    trigger OnPostReport()
    begin
        Message(DeletedEventsMsg, DeletedCount);
    end;

    var
        ConfirmDeletion: Boolean;
        DeletedCount: Integer;
        ConfirmDeletionErr: Label 'You must confirm deletion to proceed.', Comment = 'ESP="Debe confirmar la eliminación para continuar."';
        DeletedEventsMsg: Label '%1 archived event(s) have been deleted.', Comment = 'ESP="%1 evento(s) archivado(s) han sido eliminados."';
}
