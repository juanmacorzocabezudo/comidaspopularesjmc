page 53136 "JMC Res. Assignment Catering"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Asignacion Recursos Eventos";
    Caption = 'Resource Assignment - Catering', Comment = 'ESP="Asignación de Recursos - Catering"';
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
                field("Codigo Evento"; Rec."Codigo Evento")
                {
                    Caption = 'Event Code', Comment = 'ESP="Código Evento"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event code.', Comment = 'ESP="Especifica el código del evento."';
                    Editable = true;
                }
                field("JMC Event Description"; Rec."JMC Event Description")
                {
                    Caption = 'Event Description', Comment = 'ESP="Descripción Evento"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event description.', Comment = 'ESP="Especifica la descripción del evento."';
                    Editable = false;
                }
                field("JMC Fecha Evento"; Rec."JMC Fecha Evento")
                {
                    Caption = 'Date', Comment = 'ESP="Fecha"';
                    ApplicationArea = All;
                    ToolTip = 'Event date.', Comment = 'ESP="Fecha del evento."';
                    Visible = true;
                    Editable = false;
                }
                field("JMC Hora Evento"; Rec."JMC Hora Evento")
                {
                    Caption = 'Hora';
                    ApplicationArea = All;
                    ToolTip = 'Hora del evento.';
                    Visible = true;
                    Editable = false;
                }
                field("Codigo Recurso"; Rec."Codigo Recurso")
                {
                    Caption = 'Resource Code', Comment = 'ESP="Cód. Recurso"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource code.', Comment = 'ESP="Especifica el código del recurso."';

                    trigger OnValidate()
                    var
                        Resource: Record Resource;
                    begin
                        // Set description from Resource Search Name (ALIAS)
                        if Rec."Codigo Recurso" <> '' then begin
                            if Resource.Get(Rec."Codigo Recurso") then
                                Rec.Descripcion := Resource."Search Name";
                        end else
                            Rec.Descripcion := '';
                    end;
                }
                field(Descripcion; Rec.Descripcion)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción Recurso"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource description.', Comment = 'ESP="Especifica la descripción del recurso."';
                }
                field("Tarea Realizada"; Rec."Tarea Realizada")
                {
                    Caption = 'Task Performed', Comment = 'ESP="Tarea Realizada"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the task performed.', Comment = 'ESP="Especifica la tarea realizada."';
                }
                field(Comentarios; Rec.Comentarios)
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies comments.', Comment = 'ESP="Especifica comentarios."';
                }
                field("JMC Tipo"; Rec."JMC Tipo")
                {
                    Caption = 'Tipo';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tipo.', Comment = 'ESP="Especifica el tipo."';
                    StyleExpr = TipoStyle;
                }
                field(Cantidad; Rec.Cantidad)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.', Comment = 'ESP="Especifica la cantidad."';
                    Visible = CanViewFinancialFields;
                }
                field("Unidad de Medida"; Rec."Unidad de Medida")
                {
                    Caption = 'Unit of Measure', Comment = 'ESP="Unidad de Medida"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure.', Comment = 'ESP="Especifica la unidad de medida."';
                    Visible = CanViewFinancialFields;
                }
                field("Coste Unitario"; Rec."Coste Unitario")
                {
                    Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost.', Comment = 'ESP="Especifica el coste unitario."';
                    Visible = CanViewFinancialFields;
                }
                field("WeekNo"; Rec."JMC Week No.")
                {
                    Caption = 'Nº Semana';
                    ApplicationArea = All;
                    ToolTip = 'Especifica el número de semana.';
                    Editable = false;
                }
                field("DayOfWeek"; Rec."JMC Day of Week")
                {
                    Caption = 'Day of Week', Comment = 'ESP="Día de la Semana"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the day of week.', Comment = 'ESP="Especifica el día de la semana."';
                    Editable = false;
                }
                field("Month"; Rec."JMC Month")
                {
                    Caption = 'Month', Comment = 'ESP="Mes"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the month.', Comment = 'ESP="Especifica el mes."';
                    Editable = false;
                }
                field("Year"; Rec."JMC Year")
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
        Rec.SetCurrentKey("JMC Fecha Evento");
        Rec.Ascending(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetTipoStyle();
    end;

    trigger OnAfterGetRecord()
    var
        EventoRec: Record Evento;
        NeedsSave: Boolean;
    begin
        SetTipoStyle();
        NeedsSave := false;

        // If JMC Fecha Evento is empty but we have an Event Code, copy date from Event
        if (Rec."JMC Fecha Evento" = 0D) and (Rec."Codigo Evento" <> '') then begin
            if EventoRec.Get(Rec."Codigo Evento") then begin
                Rec."JMC Fecha Evento" := EventoRec."Fecha Evento";
                Rec."JMC Hora Evento" := EventoRec."Hora Evento";
                NeedsSave := true;
            end;
        end;

        // Calculate date fields if they are empty but we have a date
        if (Rec."JMC Fecha Evento" <> 0D) and (Rec."JMC Week No." = 0) then begin
            Rec."JMC Week No." := Date2DWY(Rec."JMC Fecha Evento", 2);
            Rec."JMC Day of Week" := GetSpanishDayName(Rec."JMC Fecha Evento");
            Rec."JMC Month" := Date2DMY(Rec."JMC Fecha Evento", 2);
            Rec."JMC Year" := Date2DMY(Rec."JMC Fecha Evento", 3);
            NeedsSave := true;
        end;

        // Save if any changes were made
        if NeedsSave then
            Rec.Modify(false);
    end;

    local procedure SetTipoStyle()
    begin
        // Set style based on Tipo value
        case UpperCase(Rec."JMC Tipo") of
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

    local procedure GetSpanishDayName(DateValue: Date): Text[10]
    var
        DayOfWeek: Integer;
    begin
        DayOfWeek := Date2DWY(DateValue, 1);
        case DayOfWeek of
            1:
                exit('Lunes');
            2:
                exit('Martes');
            3:
                exit('Miércoles');
            4:
                exit('Jueves');
            5:
                exit('Viernes');
            6:
                exit('Sábado');
            7:
                exit('Domingo');
        end;
    end;
}
