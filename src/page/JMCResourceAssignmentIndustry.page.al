page 53135 "JMC Res. Assignment Industry"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JMC Resource Assignment";
    Caption = 'Resource Assignment - Industry', Comment = 'ESP="Asignación de Recursos - Industria"';
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    DelayedInsert = true;
    AutoSplitKey = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Event Code"; Rec."Event Code")
                {
                    Caption = 'Event Code', Comment = 'ESP="Código Evento"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event code.', Comment = 'ESP="Especifica el código del evento."';
                }
                field("Event Description"; Rec."Event Description")
                {
                    Caption = 'Event Description', Comment = 'ESP="Descripción Evento"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event description.', Comment = 'ESP="Especifica la descripción del evento."';
                    Editable = false;
                }
                field("Event Date"; Rec."Event Date")
                {
                    Caption = 'Date', Comment = 'ESP="Fecha"';
                    ApplicationArea = All;
                    ToolTip = 'Event date.', Comment = 'ESP="Fecha del evento."';
                    Visible = true;
                    Editable = true;
                }
                field("Event Time"; Rec."Event Time")
                {
                    Caption = 'Hora';
                    ApplicationArea = All;
                    ToolTip = 'Hora del evento.';
                    Visible = true;
                    Editable = true;
                }
                field("Resource Code"; Rec."Resource Code")
                {
                    Caption = 'Resource Code', Comment = 'ESP="Cód. Recurso"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource code.', Comment = 'ESP="Especifica el código del recurso."';

                    trigger OnValidate()
                    var
                        Resource: Record Resource;
                    begin
                        // Set description from Resource Search Name (ALIAS)
                        if Rec."Resource Code" <> '' then begin
                            if Resource.Get(Rec."Resource Code") then
                                Rec.Description := Resource."Search Name";
                        end else
                            Rec.Description := '';
                    end;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción Recurso"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource description.', Comment = 'ESP="Especifica la descripción del recurso."';
                }
                field("Task Performed"; Rec."Task Performed")
                {
                    Caption = 'Task Performed', Comment = 'ESP="Tarea Realizada"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the task performed.', Comment = 'ESP="Especifica la tarea realizada."';
                }
                field(Comments; Rec.Comments)
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies comments.', Comment = 'ESP="Especifica comentarios."';
                }
                field(Tipo; Rec.Tipo)
                {
                    Caption = 'Tipo';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tipo.', Comment = 'ESP="Especifica el tipo."';
                    StyleExpr = TipoStyle;
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.', Comment = 'ESP="Especifica la cantidad."';
                    Visible = CanViewFinancialFields;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure', Comment = 'ESP="Unidad de Medida"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure.', Comment = 'ESP="Especifica la unidad de medida."';
                    Visible = CanViewFinancialFields;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost.', Comment = 'ESP="Especifica el coste unitario."';
                    Visible = CanViewFinancialFields;
                }
                field("JMC Week No."; Rec."JMC Week No.")
                {
                    Caption = 'Nº Semana';
                    ApplicationArea = All;
                    ToolTip = 'Especifica el número de semana.';
                    Editable = false;
                }
                field("JMC Day of Week"; Rec."JMC Day of Week")
                {
                    Caption = 'Day of Week', Comment = 'ESP="Día de la Semana"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the day of week.', Comment = 'ESP="Especifica el día de la semana."';
                    Editable = false;
                }
                field("JMC Month"; Rec."JMC Month")
                {
                    Caption = 'Month', Comment = 'ESP="Mes"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the month.', Comment = 'ESP="Especifica el mes."';
                    Editable = false;
                }
                field("JMC Year"; Rec."JMC Year")
                {
                    Caption = 'Year', Comment = 'ESP="Año"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the year.', Comment = 'ESP="Especifica el año."';
                    Editable = false;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    var
        CanViewFinancialFields: Boolean;
        TipoStyle: Text;

    trigger OnOpenPage()
    begin
        CanViewFinancialFields := HasFinancialFieldsPermission();

        // Sort by Event Date descending (most recent first)
        Rec.SetCurrentKey("Event Date");
        Rec.Ascending(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetTipoStyle();
    end;

    trigger OnAfterGetRecord()
    begin
        SetTipoStyle();
    end;

    local procedure SetTipoStyle()
    begin
        // Set style based on Tipo value
        case UpperCase(Rec.Tipo) of
            'FABRICA':
                TipoStyle := 'StandardAccent';  // Blue
            'EVENTO':
                TipoStyle := 'Favorable';  // Green
            'COMP. DIARIO-EVENTO':
                TipoStyle := 'Ambiguous';  // Yellow
            'LIMPIEZA':
                TipoStyle := 'Unfavorable';  // Orange/Pink-ish light
            'ALMACEN':
                TipoStyle := 'Subordinate';  // Gray (closer to purple)
            'FORMULISTA':
                TipoStyle := 'Attention';  // Red
            'MANTENIMIENTO':
                TipoStyle := 'AttentionAccent';  // Orange dark
            'OFICINA':
                TipoStyle := 'Strong';  // Black bold
            else
                TipoStyle := 'Standard';  // Default black
        end;
    end;

    local procedure HasFinancialFieldsPermission(): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("User Security ID", UserSecurityId());
        AccessControl.SetRange("Role ID", 'JMC RES. ASSIG. FIN');
        exit(not AccessControl.IsEmpty());
    end;
}
