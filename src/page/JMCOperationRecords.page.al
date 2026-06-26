page 53110 "JMC Cronus"
{
    Caption = 'Cronus', Comment = 'ESP="Cronus"';
    PageType = List;
    SourceTable = "JMC Cronus";
    SourceTableView = sorting("JMC Entry No.") order(descending);
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
                field(CostType; Rec."JMC Cost Type")
                {
                    Caption = 'Type', Comment = 'ESP="Tipo"';
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

                    trigger OnValidate()
                    begin
                        CurrPage.Statistics.Page.UpdateTotals();
                    end;
                }
                field(MovementType; Rec."JMC Movement Type")
                {
                    Caption = 'Movement Type', Comment = 'ESP="Tipo de movimiento"';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Statistics.Page.UpdateTotals();
                    end;
                }
                field(Amount; Rec."JMC Amount")
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = jmcIsNegativeAmount;

                    trigger OnValidate()
                    begin
                        jmcIsNegativeAmount := Rec."JMC Amount" < 0;
                        CurrPage.Statistics.Page.UpdateTotals();
                        CurrPage.Update(false);
                    end;
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
                }
                field(Family; Rec."JMC Family")
                {
                    Caption = 'Family', Comment = 'ESP="Familia"';
                    ApplicationArea = All;
                }
                field(FamilyName; Rec."JMC Family Name")
                {
                    Caption = 'Family Name', Comment = 'ESP="Nombre familia"';
                    ApplicationArea = All;
                }
                field(CustomerType; Rec."JMC Customer Type")
                {
                    Caption = 'Customer Type', Comment = 'ESP="Tipo cliente"';
                    ApplicationArea = All;
                }
                field(ResourceNo; Rec."JMC Resource No.")
                {
                    Caption = 'Resource No.', Comment = 'ESP="Nº recurso"';
                    ApplicationArea = All;
                }
                field(ResourceName; Rec."JMC Resource Name")
                {
                    Caption = 'Resource Name', Comment = 'ESP="Nombre recurso"';
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
                    CurrPage.Statistics.Page.UpdateTotals();
                end;
            }
            action(BusinessLineValues)
            {
                Caption = 'Business Line', Comment = 'ESP="Linea negocio"';
                ToolTip = 'Opens the dimension values for Business Line.', Comment = 'ESP="Abre los valores de dimensión para línea de negocio."';
                ApplicationArea = All;
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    jmcDimensionValue: Record "Dimension Value";
                begin
                    jmcDimensionValue.FilterGroup(2);
                    jmcDimensionValue.SetRange("Dimension Code", 'LINEA');
                    jmcDimensionValue.FilterGroup(0);
                    Page.Run(Page::"Dimension Values", jmcDimensionValue);
                end;
            }
            action(FamilyValues)
            {
                Caption = 'Family', Comment = 'ESP="Familia"';
                ToolTip = 'Opens the dimension values for Family.', Comment = 'ESP="Abre los valores de dimensión para familia."';
                ApplicationArea = All;
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    jmcDimensionValue: Record "Dimension Value";
                begin
                    jmcDimensionValue.FilterGroup(2);
                    jmcDimensionValue.SetRange("Dimension Code", 'FAMILIA');
                    jmcDimensionValue.FilterGroup(0);
                    Page.Run(Page::"Dimension Values", jmcDimensionValue);
                end;
            }
            action(CustomerTypeValues)
            {
                Caption = 'Customer Type', Comment = 'ESP="Tipo cliente"';
                ToolTip = 'Opens the dimension values for Customer Type.', Comment = 'ESP="Abre los valores de dimensión para tipo cliente."';
                ApplicationArea = All;
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    jmcDimensionValue: Record "Dimension Value";
                begin
                    jmcDimensionValue.FilterGroup(2);
                    jmcDimensionValue.SetRange("Dimension Code", 'TIPO CLIENTE');
                    jmcDimensionValue.FilterGroup(0);
                    Page.Run(Page::"Dimension Values", jmcDimensionValue);
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

        jmcLastRecordCount := GetRecordCount();
        CurrPage.Statistics.Page.UpdateTotals();
    end;

    trigger OnAfterGetRecord()
    begin
        jmcIsNegativeAmount := Rec."JMC Amount" < 0;

        // Actualizar estadísticas después de cualquier cambio
        if jmcRecordModified then begin
            CurrPage.Statistics.Page.UpdateTotals();
            jmcRecordModified := false;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        jmcCurrentRecordCount: Integer;
    begin
        jmcIsNegativeAmount := Rec."JMC Amount" < 0;

        // Solo actualizar estadísticas si el número de registros ha cambiado
        // Esto detecta inserciones/eliminaciones desde el diario
        jmcCurrentRecordCount := GetRecordCount();
        if jmcCurrentRecordCount <> jmcLastRecordCount then begin
            CurrPage.Statistics.Page.UpdateTotals();
            jmcLastRecordCount := jmcCurrentRecordCount;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        jmcIsNegativeAmount := Rec."JMC Amount" < 0;
        jmcRecordModified := true;  // Marcar que hubo modificación
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        jmcIsNegativeAmount := Rec."JMC Amount" < 0;
        jmcLastRecordCount := GetRecordCount() + 1;
        jmcRecordModified := true;  // Marcar que hubo inserción
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        jmcLastRecordCount := GetRecordCount() - 1;
        CurrPage.Statistics.Page.UpdateTotals();  // Actualizar inmediatamente al eliminar
    end;

    var
        jmcIsNegativeAmount: Boolean;
        jmcLastRecordCount: Integer;
        jmcRecordModified: Boolean;

    local procedure IsUserInPermissionSet(PermissionSetCode: Code[20]): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("User Security ID", UserSecurityId());
        AccessControl.SetRange("Role ID", PermissionSetCode);
        exit(not AccessControl.IsEmpty());
    end;

    local procedure GetRecordCount(): Integer
    var
        jmcOperationRecord: Record "JMC Cronus";
    begin
        jmcOperationRecord.Copy(Rec);
        jmcOperationRecord.SetRange("JMC Entry No.");
        exit(jmcOperationRecord.Count());
    end;
}
