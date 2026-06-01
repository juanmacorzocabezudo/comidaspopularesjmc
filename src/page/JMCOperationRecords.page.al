page 53110 "JMC Cronus"
{
    Caption = 'Cronus', Comment = 'ESP="Cronus"';
    PageType = List;
    SourceTable = "JMC Cronus";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(EntryNo; Rec."JMC Entry No.")
                {
                    Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
                    ApplicationArea = All;
                }
                field(Cronus; Rec."JMC Cronus")
                {
                    Caption = 'Cronus', Comment = 'ESP="Cronus"';
                    ApplicationArea = All;
                }
                field(PostingDate; Rec."JMC Posting Date")
                {
                    Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
                    ApplicationArea = All;
                }
                field(CashBox; Rec."JMC Cash Box")
                {
                    Caption = 'Cash Box', Comment = 'ESP="Caja"';
                    ApplicationArea = All;
                }
                field(MovementType; Rec."JMC Movement Type")
                {
                    Caption = 'Movement Type', Comment = 'ESP="Tipo de movimiento"';
                    ApplicationArea = All;
                }
                field(Amount; Rec."JMC Amount")
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = jmcIsNegativeAmount;
                }
                field(GLAccountNo; Rec."JMC G/L Account No.")
                {
                    Caption = 'No.', Comment = 'ESP="Nº"';
                    ApplicationArea = All;
                }
                field(AccountDescription; Rec."JMC Account Description")
                {
                    Caption = 'Account', Comment = 'ESP="Cuenta"';
                    ApplicationArea = All;
                }
                field(Concept; Rec."JMC Concept")
                {
                    Caption = 'Concept', Comment = 'ESP="Concepto"';
                    ApplicationArea = All;
                }
                field(Detail; Rec."JMC Detail")
                {
                    Caption = 'Detail', Comment = 'ESP="Detalle"';
                    ApplicationArea = All;
                }
                field(BusinessLine; Rec."JMC Business Line")
                {
                    Caption = 'Business Line', Comment = 'ESP="Linea de negocio"';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        jmcBusinessLinesPage: Page "JMC Business Lines";
                    begin
                        jmcBusinessLinesPage.Run();
                    end;
                }
                field(Family; Rec."JMC Family")
                {
                    Caption = 'Family', Comment = 'ESP="Familia"';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        jmcFamiliesPage: Page "JMC Families";
                    begin
                        jmcFamiliesPage.Run();
                    end;
                }
                field(ExternalReference; Rec."JMC External Reference")
                {
                    Caption = 'External Reference', Comment = 'ESP="Referencia externa"';
                    ApplicationArea = All;
                }
                field(Comments; Rec."JMC Comments")
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                    ApplicationArea = All;
                }
                field(CreationDateTime; Rec."JMC Creation DateTime")
                {
                    Caption = 'Creation DateTime', Comment = 'ESP="Fecha/hora creacion"';
                    ApplicationArea = All;
                }
                field(CreationUser; Rec."JMC Creation User")
                {
                    Caption = 'Responsible User', Comment = 'ESP="Usuario responsable"';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(Statistics; "JMC Cronus Statistics")
            {
                Caption = 'Statistics', Comment = 'ESP="Estadísticas"';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ManageBusinessLines)
            {
                Caption = 'Business Lines', Comment = 'ESP="Lineas de negocio"';
                ToolTip = 'Manage business lines.', Comment = 'ESP="Administrar lineas de negocio."';
                ApplicationArea = All;
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    jmcBusinessLinesPage: Page "JMC Business Lines";
                begin
                    jmcBusinessLinesPage.Run();
                end;
            }
            action(ManageFamilies)
            {
                Caption = 'Families', Comment = 'ESP="Familias"';
                ToolTip = 'Manage families.', Comment = 'ESP="Administrar familias."';
                ApplicationArea = All;
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    jmcFamiliesPage: Page "JMC Families";
                begin
                    jmcFamiliesPage.Run();
                end;
            }
            action(DeleteRecord)
            {
                Caption = 'Delete', Comment = 'ESP="Eliminar"';
                ToolTip = 'Deletes the selected operation record.', Comment = 'ESP="Elimina el registro operativo seleccionado."';
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    jmcConfirmDeleteQst: Label 'Are you sure you want to delete this record?', Comment = 'ESP="¿Está seguro de que desea eliminar este registro?"';
                begin
                    if Confirm(jmcConfirmDeleteQst, false) then begin
                        Rec.Delete(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(OpenJournal)
            {
                Caption = 'Add Records', Comment = 'ESP="Añadir registros"';
                ToolTip = 'Opens the journal to add new operation records.', Comment = 'ESP="Abre el diario para añadir nuevos registros operativos."';
                ApplicationArea = All;
                Image = NewItem;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    jmcOperRecJournal: Page "JMC Oper. Rec. Journal";
                begin
                    jmcOperRecJournal.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        jmcAccessDeniedErr: Label 'You do not have permission to access this page. The JMC OPER. REC. READ or JMC OPER. REC. MGT permission set is required.', Comment = 'ESP="No tiene permiso para acceder a esta página. Se requiere el conjunto de permisos JMC OPER. REC. READ o JMC OPER. REC. MGT."';
    begin
        if not (IsUserInPermissionSet('JMC OPER. REC. READ') or IsUserInPermissionSet('JMC OPER. REC. MGT')) then
            Error(jmcAccessDeniedErr);
    end;

    trigger OnAfterGetRecord()
    begin
        jmcIsNegativeAmount := Rec."JMC Amount" < 0;
        CurrPage.Statistics.Page.UpdateTotals();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        jmcIsNegativeAmount := Rec."JMC Amount" < 0;
        CurrPage.Statistics.Page.UpdateTotals();
    end;

    var
        jmcIsNegativeAmount: Boolean;

    local procedure IsUserInPermissionSet(PermissionSetCode: Code[20]): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("User Security ID", UserSecurityId());
        AccessControl.SetRange("Role ID", PermissionSetCode);
        exit(not AccessControl.IsEmpty());
    end;
}
