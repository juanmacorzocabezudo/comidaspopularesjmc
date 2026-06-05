page 53111 "JMC Oper. Rec. Journal"
{
    Caption = 'Operation Record Journal', Comment = 'ESP="Diario registro operativo"';
    PageType = Worksheet;
    SourceTable = "JMC Cronus Jnl. Line";
    SourceTableView = where("JMC Registered" = const(false));
    UsageCategory = Tasks;
    ApplicationArea = All;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(PostingDate; Rec."JMC Posting Date")
                {
                    Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
                    ToolTip = 'Specifies the posting date for the analysis movement.', Comment = 'ESP="Especifica la fecha de registro para el registro operativo."';
                    ApplicationArea = All;
                }
                field(CostType; Rec."JMC Cost Type")
                {
                    Caption = 'Type', Comment = 'ESP="Tipo"';
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
                    ToolTip = 'Specifies whether the line is an income or an expense.', Comment = 'ESP="Especifica si la linea es un ingreso o un gasto."';
                    ApplicationArea = All;
                }
                field(Amount; Rec."JMC Amount")
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                    ToolTip = 'Specifies the movement amount. The sign is normalized at registration time.', Comment = 'ESP="Especifica el importe del registro. El signo se normaliza al registrar."';
                    ApplicationArea = All;
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
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RegisterLines)
            {
                Caption = 'Register', Comment = 'ESP="Registrar"';
                ToolTip = 'Registers all unregistered journal lines into operation records.', Comment = 'ESP="Registra todas las lineas no registradas del diario en registros operativos."';
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    jmcAnalysisJournalLine: Record "JMC Cronus Jnl. Line";
                    jmcAnalysisJournalMgt: Codeunit "JMC Oper. Rec. Jnl. Mgt";
                begin
                    jmcAnalysisJournalLine.SetRange("JMC Registered", false);
                    jmcAnalysisJournalMgt.RegisterJournalLines(jmcAnalysisJournalLine);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        jmcAccessDeniedErr: Label 'You do not have permission to access this page. The JMC OPER. REC. MGT permission set is required.', Comment = 'ESP="No tiene permiso para acceder a esta página. Se requiere el conjunto de permisos JMC OPER. REC. MGT."';
    begin
        if not IsUserInPermissionSet('JMC OPER. REC. MGT') then
            Error(jmcAccessDeniedErr);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."JMC Posting Date" := WorkDate();
    end;

    local procedure IsUserInPermissionSet(PermissionSetCode: Code[20]): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("User Security ID", UserSecurityId());
        AccessControl.SetRange("Role ID", PermissionSetCode);
        exit(not AccessControl.IsEmpty());
    end;
}
