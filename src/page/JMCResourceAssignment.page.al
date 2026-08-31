page 53131 "JMC Resource Assignment"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JMC Resource Assignment";
    SourceTableTemporary = true;
    Caption = 'Resource Assignment', Comment = 'ESP="Asignación de Recursos"';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;
    AutoSplitKey = false;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                Caption = 'Filters', Comment = 'ESP="Filtros"';
                field(BusinessLineFilter; BusinessLineFilter)
                {
                    Caption = 'Business Line', Comment = 'ESP="Línea de Negocio"';
                    ApplicationArea = All;
                    ToolTip = 'Filter by business line.', Comment = 'ESP="Filtrar por línea de negocio."';

                    trigger OnValidate()
                    begin
                        LoadData();
                    end;
                }
            }
            repeater(Group)
            {
                field("Source Table"; Rec."Source Table")
                {
                    Caption = 'Business Line', Comment = 'ESP="Línea de Negocio"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business line.', Comment = 'ESP="Especifica la línea de negocio."';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        // Set default business line based on source table
                        if Rec."Source Table" = Rec."Source Table"::Catering then
                            Rec."Business Line" := Rec."Business Line"::Catering
                        else
                            Rec."Business Line" := Rec."Business Line"::Industry;
                    end;
                }
                field("Event Code"; Rec."Event Code")
                {
                    Caption = 'Event Code', Comment = 'ESP="Código Evento"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event code.', Comment = 'ESP="Especifica el código del evento."';
                    Visible = Rec."Source Table" = Rec."Source Table"::Catering;
                }
                field("Event Description"; Rec."Event Description")
                {
                    Caption = 'Event Description', Comment = 'ESP="Descripción Evento"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event description.', Comment = 'ESP="Especifica la descripción del evento."';
                    Visible = Rec."Source Table" = Rec."Source Table"::Catering;
                    Editable = false;
                }
                field("Event Date Edit"; Rec."Event Date")
                {
                    Caption = 'Date', Comment = 'ESP="Fecha"';
                    ApplicationArea = All;
                    ToolTip = 'Event date.', Comment = 'ESP="Fecha del evento."';
                    Visible = true;
                    Editable = true;
                }
                field("Event Time Formatted"; Format(Rec."Event Time", 0, '<Hours24,2>:<Minutes,2>'))
                {
                    Caption = 'Hora';
                    ApplicationArea = All;
                    ToolTip = 'Hora del evento.';
                    Visible = true;
                    Editable = false;
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
                field(Tipo; Rec.Tipo)
                {
                    Caption = 'Tipo';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tipo.', Comment = 'ESP="Especifica el tipo."';
                    StyleExpr = TipoStyle;
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
                field("Business Line"; Rec."Business Line")
                {
                    Caption = 'Business Line', Comment = 'ESP="Línea de Negocio"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business line.', Comment = 'ESP="Especifica la línea de negocio."';
                    Visible = false;
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
        BusinessLineFilter: Enum "JMC Business Line Filter";
        EntryNoCounter: Integer;
        CanViewFinancialFields: Boolean;
        TipoStyle: Text;
        OriginalEventCode: Code[20];
        OriginalLineNo: Integer;
        OriginalResourceCode: Code[20];

    trigger OnOpenPage()
    begin
        // Always start with Both (Ambas) by default
        BusinessLineFilter := BusinessLineFilter::Both;

        CanViewFinancialFields := HasFinancialFieldsPermission();
        LoadData();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetTipoStyle();
    end;

    trigger OnAfterGetRecord()
    begin
        SetTipoStyle();

        // Store original values for Catering records to use in OnModifyRecord
        if Rec."Source Table" = Rec."Source Table"::Catering then begin
            OriginalEventCode := Rec."Event Code";
            OriginalLineNo := Rec."Event Resource Line No.";
            OriginalResourceCode := Rec."Resource Code";
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Assign a negative entry number for new records to avoid collision
        // EntryNoCounter is decremented for each Catering record, so we continue the sequence
        EntryNoCounter -= 1;
        Rec."Entry No." := EntryNoCounter;

        // Set initial business line based on current filter
        if BusinessLineFilter = BusinessLineFilter::Catering then begin
            Rec."Source Table" := Rec."Source Table"::Catering;
            Rec."Business Line" := Rec."Business Line"::Catering;
        end else begin
            // Default to Industry for new records (when filter is Industry or Both)
            Rec."Source Table" := Rec."Source Table"::Industry;
            Rec."Business Line" := Rec."Business Line"::Industry;
        end;

        Rec.Quantity := 1;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        LegacyAssignment: Record "Asignacion Recursos Eventos";
        NewAssignment: Record "JMC Resource Assignment";
    begin
        // Insert into physical tables
        if Rec."Source Table" = Rec."Source Table"::Catering then begin
            // Validate required fields for Catering
            if Rec."Event Code" = '' then
                Error('El código de evento es obligatorio para registros de Catering.');
            if Rec."Resource Code" = '' then
                Error('El código de recurso es obligatorio para registros de Catering.');

            // Insert into legacy table (50005)
            LegacyAssignment.Init();
            LegacyAssignment."Codigo Evento" := Rec."Event Code";
            LegacyAssignment."Linea Recurso Evento" := GetNextLineNo(Rec."Event Code");
            LegacyAssignment."Codigo Recurso" := Rec."Resource Code";
            LegacyAssignment.Descripcion := Rec.Description;
            LegacyAssignment.Cantidad := Rec.Quantity;
            LegacyAssignment."Unidad de Medida" := Rec."Unit of Measure";
            LegacyAssignment."Coste Unitario" := Rec."Unit Cost";
            LegacyAssignment."Tarea Realizada" := Rec."Task Performed";
            LegacyAssignment.Comentarios := Rec.Comments;
            LegacyAssignment."JMC Business Line" := Rec."Business Line";
            LegacyAssignment."JMC Fecha Evento" := Rec."Event Date";
            LegacyAssignment."JMC Hora Evento" := Rec."Event Time";
            LegacyAssignment."JMC Tipo" := Rec.Tipo;
            LegacyAssignment.Insert(true);
            Rec."Event Resource Line No." := LegacyAssignment."Linea Recurso Evento";
        end else begin
            // Insert into new table (53116)
            NewAssignment.Init();
            NewAssignment."Event Code" := Rec."Event Code";
            NewAssignment."Resource Code" := Rec."Resource Code";
            NewAssignment.Description := Rec.Description;
            NewAssignment.Quantity := Rec.Quantity;
            NewAssignment."Unit of Measure" := Rec."Unit of Measure";
            NewAssignment."Unit Cost" := Rec."Unit Cost";
            NewAssignment."Task Performed" := Rec."Task Performed";
            NewAssignment.Comments := Rec.Comments;
            NewAssignment."Business Line" := Rec."Business Line";
            NewAssignment."Event Date" := Rec."Event Date";
            NewAssignment."Event Time" := Rec."Event Time";
            NewAssignment.Tipo := Rec.Tipo;
            NewAssignment.Insert(true);
            Rec."Entry No." := NewAssignment."Entry No.";
        end;

        // Allow the record to be inserted into the temp table
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    var
        LegacyAssignment: Record "Asignacion Recursos Eventos";
        NewAssignment: Record "JMC Resource Assignment";
        ResourceChanged: Boolean;
    begin
        // Update physical tables based on source
        if Rec."Source Table" = Rec."Source Table"::Catering then begin
            // Check if Resource Code changed
            ResourceChanged := (OriginalResourceCode <> Rec."Resource Code");

            // Modify legacy table (50005) - Use ORIGINAL values for Get()
            if LegacyAssignment.Get(OriginalEventCode, OriginalLineNo, OriginalResourceCode) then begin
                if ResourceChanged then begin
                    // If resource code changed, delete old record and insert new one
                    // because Resource Code is part of the primary key
                    LegacyAssignment.Delete(true);

                    LegacyAssignment.Init();
                    LegacyAssignment."Codigo Evento" := Rec."Event Code";
                    LegacyAssignment."Linea Recurso Evento" := Rec."Event Resource Line No.";
                    LegacyAssignment."Codigo Recurso" := Rec."Resource Code";
                    LegacyAssignment.Descripcion := Rec.Description;
                    LegacyAssignment.Cantidad := Rec.Quantity;
                    LegacyAssignment."Unidad de Medida" := Rec."Unit of Measure";
                    LegacyAssignment."Coste Unitario" := Rec."Unit Cost";
                    LegacyAssignment."Tarea Realizada" := Rec."Task Performed";
                    LegacyAssignment.Comentarios := Rec.Comments;
                    LegacyAssignment."JMC Business Line" := Rec."Business Line";
                    LegacyAssignment."JMC Fecha Evento" := Rec."Event Date";
                    LegacyAssignment."JMC Hora Evento" := Rec."Event Time";
                    LegacyAssignment."JMC Tipo" := Rec.Tipo;
                    LegacyAssignment.Insert(true);

                    // Update the stored original values
                    OriginalEventCode := Rec."Event Code";
                    OriginalLineNo := Rec."Event Resource Line No.";
                    OriginalResourceCode := Rec."Resource Code";
                end else begin
                    // Resource didn't change, just modify the record
                    LegacyAssignment.Descripcion := Rec.Description;
                    LegacyAssignment.Cantidad := Rec.Quantity;
                    LegacyAssignment."Unidad de Medida" := Rec."Unit of Measure";
                    LegacyAssignment."Coste Unitario" := Rec."Unit Cost";
                    LegacyAssignment."Tarea Realizada" := Rec."Task Performed";
                    LegacyAssignment.Comentarios := Rec.Comments;
                    LegacyAssignment."JMC Business Line" := Rec."Business Line";
                    LegacyAssignment."JMC Fecha Evento" := Rec."Event Date";
                    LegacyAssignment."JMC Hora Evento" := Rec."Event Time";
                    LegacyAssignment."JMC Tipo" := Rec.Tipo;
                    LegacyAssignment.Modify(true);
                end;
            end;
        end else begin
            // Modify new table (53116)
            if NewAssignment.Get(Rec."Entry No.") then begin
                NewAssignment."Event Code" := Rec."Event Code";
                NewAssignment."Resource Code" := Rec."Resource Code";
                NewAssignment.Description := Rec.Description;
                NewAssignment.Quantity := Rec.Quantity;
                NewAssignment."Unit of Measure" := Rec."Unit of Measure";
                NewAssignment."Unit Cost" := Rec."Unit Cost";
                NewAssignment."Task Performed" := Rec."Task Performed";
                NewAssignment.Comments := Rec.Comments;
                NewAssignment."Business Line" := Rec."Business Line";
                NewAssignment."Event Date" := Rec."Event Date";
                NewAssignment."Event Time" := Rec."Event Time";
                NewAssignment.Tipo := Rec.Tipo;
                NewAssignment.Modify(true);
            end;
        end;

        // Allow the record to be modified in the temp table
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        LegacyAssignment: Record "Asignacion Recursos Eventos";
        NewAssignment: Record "JMC Resource Assignment";
    begin
        // Delete from physical tables based on source
        if Rec."Source Table" = Rec."Source Table"::Catering then begin
            // Delete from legacy table (50005) - Use ORIGINAL values for Get()
            if LegacyAssignment.Get(OriginalEventCode, OriginalLineNo, OriginalResourceCode) then
                LegacyAssignment.Delete(true);
        end else begin
            // Delete from new table (53116)
            if NewAssignment.Get(Rec."Entry No.") then
                NewAssignment.Delete(true);
        end;

        // Allow the record to be deleted from the temp table
        exit(true);
    end;

    local procedure LoadData()
    var
        LegacyAssignment: Record "Asignacion Recursos Eventos";
        NewAssignment: Record "JMC Resource Assignment";
        TempRec: Record "JMC Resource Assignment" temporary;
        EventoRec: Record Evento;
        Resource: Record Resource;
    begin
        Rec.Reset();
        Rec.DeleteAll();
        EntryNoCounter := 0;

        // Load data from legacy table (50005)
        LegacyAssignment.Reset();
        if LegacyAssignment.FindSet() then
            repeat
                LegacyAssignment.CalcFields("JMC Event Date", "JMC Event Time", "JMC Event Description");

                // Apply filters (calculate week no. inline for filtering)
                if ShouldIncludeRecord(
                    LegacyAssignment."JMC Business Line",
                    LegacyAssignment."JMC Event Date",
                    LegacyAssignment."Codigo Recurso",
                    LegacyAssignment."Tarea Realizada",
                    LegacyAssignment."JMC Tipo",
                    Date2DWY(LegacyAssignment."JMC Event Date", 2))
                then begin
                    EntryNoCounter -= 1;
                    Rec.Init();
                    Rec."Entry No." := EntryNoCounter;
                    Rec."Source Table" := Rec."Source Table"::Catering;
                    Rec."Event Code" := LegacyAssignment."Codigo Evento";
                    Rec."Event Resource Line No." := LegacyAssignment."Linea Recurso Evento";
                    Rec."Resource Code" := LegacyAssignment."Codigo Recurso";
                    // Get description from Resource Search Name (ALIAS)
                    if Resource.Get(LegacyAssignment."Codigo Recurso") then
                        Rec.Description := Resource."Search Name"
                    else
                        Rec.Description := '';
                    Rec.Quantity := LegacyAssignment.Cantidad;
                    Rec."Unit of Measure" := LegacyAssignment."Unidad de Medida";
                    Rec."Unit Cost" := LegacyAssignment."Coste Unitario";
                    Rec."Task Performed" := LegacyAssignment."Tarea Realizada";
                    Rec.Comments := LegacyAssignment.Comentarios;
                    Rec."Business Line" := LegacyAssignment."JMC Business Line";
                    // Load editable date and time fields
                    Rec."Event Date" := LegacyAssignment."JMC Fecha Evento";
                    Rec."Event Time" := LegacyAssignment."JMC Hora Evento";
                    // If empty, fall back to FlowField values
                    if Rec."Event Date" = 0D then
                        Rec."Event Date" := LegacyAssignment."JMC Event Date";
                    if Rec."Event Time" = 0T then
                        Rec."Event Time" := LegacyAssignment."JMC Event Time";
                    // Set event description from FlowField
                    Rec."Event Description" := LegacyAssignment."JMC Event Description";
                    Rec.Tipo := LegacyAssignment."JMC Tipo";

                    // Calculate date fields manually
                    if Rec."Event Date" <> 0D then begin
                        Rec."JMC Week No." := Date2DWY(Rec."Event Date", 2);
                        Rec."JMC Day of Week" := GetSpanishDayName(Rec."Event Date");
                        Rec."JMC Month" := Date2DMY(Rec."Event Date", 2);
                        Rec."JMC Year" := Date2DMY(Rec."Event Date", 3);
                    end;

                    Rec.Insert();
                end;
            until LegacyAssignment.Next() = 0;

        // Load data from new table (53116)
        NewAssignment.Reset();
        if NewAssignment.FindSet() then
            repeat
                NewAssignment.CalcFields("Event Description");

                // Apply filters
                if ShouldIncludeRecord(
                    NewAssignment."Business Line",
                    NewAssignment."Event Date",
                    NewAssignment."Resource Code",
                    NewAssignment."Task Performed",
                    NewAssignment.Tipo,
                    NewAssignment."JMC Week No.")
                then begin
                    Rec.Init();
                    Rec."Entry No." := NewAssignment."Entry No.";
                    Rec."Source Table" := Rec."Source Table"::Industry;
                    Rec."Event Code" := NewAssignment."Event Code";
                    Rec."Event Resource Line No." := NewAssignment."Event Resource Line No.";
                    Rec."Resource Code" := NewAssignment."Resource Code";
                    // Get description from Resource Search Name (ALIAS)
                    if Resource.Get(NewAssignment."Resource Code") then
                        Rec.Description := Resource."Search Name"
                    else
                        Rec.Description := '';
                    Rec.Quantity := NewAssignment.Quantity;
                    Rec."Unit of Measure" := NewAssignment."Unit of Measure";
                    Rec."Unit Cost" := NewAssignment."Unit Cost";
                    Rec."Task Performed" := NewAssignment."Task Performed";
                    Rec.Comments := NewAssignment.Comments;
                    Rec."Business Line" := NewAssignment."Business Line";
                    // Load editable date and time fields
                    Rec."Event Date" := NewAssignment."Event Date";
                    Rec."Event Time" := NewAssignment."Event Time";
                    Rec."Event Description" := NewAssignment."Event Description";
                    Rec.Tipo := NewAssignment.Tipo;

                    // Calculate date fields manually to ensure they are always populated
                    if Rec."Event Date" <> 0D then begin
                        Rec."JMC Week No." := Date2DWY(Rec."Event Date", 2);
                        Rec."JMC Day of Week" := GetSpanishDayName(Rec."Event Date");
                        Rec."JMC Month" := Date2DMY(Rec."Event Date", 2);
                        Rec."JMC Year" := Date2DMY(Rec."Event Date", 3);
                    end;

                    Rec.Insert();
                end;
            until NewAssignment.Next() = 0;

        // Sort by Event Date descending (most recent first)
        Rec.SetCurrentKey("Event Date");
        Rec.Ascending(false);

        if Rec.FindFirst() then;
    end;

    local procedure ShouldIncludeRecord(BizLine: Enum "JMC Business Line"; EventDate: Date; ResourceCode: Code[20]; TaskPerformed: Code[20]; Tipo: Code[100]; WeekNo: Integer): Boolean
    begin
        // Business Line filter - use explicit case logic
        case BusinessLineFilter of
            BusinessLineFilter::Industry:
                if BizLine <> BizLine::Industry then
                    exit(false);
            BusinessLineFilter::Catering:
                if BizLine <> BizLine::Catering then
                    exit(false);
            BusinessLineFilter::Both:
                ; // Include both, no filter
        end;

        exit(true);
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

    local procedure GetNextLineNo(EventCode: Code[20]): Integer
    var
        LegacyAssignment: Record "Asignacion Recursos Eventos";
        MaxLineNo: Integer;
    begin
        MaxLineNo := 0;
        LegacyAssignment.SetRange("Codigo Evento", EventCode);
        if LegacyAssignment.FindSet() then
            repeat
                if LegacyAssignment."Linea Recurso Evento" > MaxLineNo then
                    MaxLineNo := LegacyAssignment."Linea Recurso Evento";
            until LegacyAssignment.Next() = 0;
        exit(MaxLineNo + 10000);
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
