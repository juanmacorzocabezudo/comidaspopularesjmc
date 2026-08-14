page 53131 "JMC Resource Assignment"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JMC Resource Assignment";
    SourceTableTemporary = true;
    Caption = 'Resource Assignment', Comment = 'ESP="Asignación de Recursos"';
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    DelayedInsert = true;

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
                field(EventDateFilter; EventDateFilter)
                {
                    Caption = 'Event Date', Comment = 'ESP="Fecha"';
                    ApplicationArea = All;
                    ToolTip = 'Filter by event date.', Comment = 'ESP="Filtrar por fecha del evento."';

                    trigger OnValidate()
                    begin
                        LoadData();
                    end;
                }
                field(ResourceCodeFilter; ResourceCodeFilter)
                {
                    Caption = 'Resource Code', Comment = 'ESP="Código Recurso"';
                    ApplicationArea = All;
                    ToolTip = 'Filter by resource code.', Comment = 'ESP="Filtrar por código de recurso."';
                    TableRelation = Resource;

                    trigger OnValidate()
                    begin
                        LoadData();
                    end;
                }
                field(TaskPerformedFilter; TaskPerformedFilter)
                {
                    Caption = 'Task Performed', Comment = 'ESP="Tarea Realizada"';
                    ApplicationArea = All;
                    ToolTip = 'Filter by task performed.', Comment = 'ESP="Filtrar por tarea realizada."';
                    TableRelation = "Work Type";

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

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        EventoRec: Record Evento;
                    begin
                        EventoRec.SetView('SORTING("Fecha Evento") ORDER(Descending)');
                        if Page.RunModal(0, EventoRec) = Action::LookupOK then begin
                            Rec."Event Code" := EventoRec."Codigo Evento";
                            Rec.Validate("Event Code");
                        end;
                    end;

                    trigger OnValidate()
                    var
                        EventoRec: Record Evento;
                    begin
                        // Copy date and time from event when event code is selected
                        if Rec."Event Code" <> '' then begin
                            if EventoRec.Get(Rec."Event Code") then begin
                                Rec."Event Date" := EventoRec."Fecha Evento";
                                Rec."Event Time" := EventoRec."Hora Evento";
                            end;
                            Rec.CalcFields("Event Description");
                        end else begin
                            Clear(Rec."Event Date");
                            Clear(Rec."Event Time");
                        end;
                    end;
                }
                field("Event Description"; Rec."Event Description")
                {
                    Caption = 'Event Description', Comment = 'ESP="Descripción Evento"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event description.', Comment = 'ESP="Especifica la descripción del evento."';
                    Visible = Rec."Source Table" = Rec."Source Table"::Catering;
                    Editable = false;
                }
                field("Event Date"; GetFormattedEventDate())
                {
                    Caption = 'Event Date', Comment = 'ESP="Fecha"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event date.', Comment = 'ESP="Especifica la fecha del evento."';
                    Visible = Rec."Source Table" = Rec."Source Table"::Catering;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Event Date Edit"; Rec."Event Date")
                {
                    Caption = 'Edit Date', Comment = 'ESP="Editar Fecha"';
                    ApplicationArea = All;
                    ToolTip = 'Edit the event date.', Comment = 'ESP="Editar la fecha del evento."';
                    Visible = Rec."Source Table" = Rec."Source Table"::Catering;
                    Editable = true;
                    ShowCaption = false;
                    Width = 10;
                }
                field("Event Time"; Rec."Event Time")
                {
                    Caption = 'Event Time', Comment = 'ESP="Hora"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event time.', Comment = 'ESP="Especifica la hora del evento."';
                    Visible = Rec."Source Table" = Rec."Source Table"::Catering;
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

    var
        BusinessLineFilter: Enum "JMC Business Line Filter";
        EventDateFilter: Date;
        ResourceCodeFilter: Code[20];
        TaskPerformedFilter: Code[10];
        EntryNoCounter: Integer;
        CanViewFinancialFields: Boolean;

    trigger OnOpenPage()
    begin
        BusinessLineFilter := BusinessLineFilter::Industry;
        // Check if user has the specific permission set assigned
        CanViewFinancialFields := HasFinancialFieldsPermission();
        LoadData();
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
    begin
        // Update physical tables based on source
        if Rec."Source Table" = Rec."Source Table"::Catering then begin
            // Modify legacy table (50005)
            if LegacyAssignment.Get(Rec."Event Code", Rec."Event Resource Line No.", Rec."Resource Code") then begin
                LegacyAssignment.Descripcion := Rec.Description;
                LegacyAssignment.Cantidad := Rec.Quantity;
                LegacyAssignment."Unidad de Medida" := Rec."Unit of Measure";
                LegacyAssignment."Coste Unitario" := Rec."Unit Cost";
                LegacyAssignment."Tarea Realizada" := Rec."Task Performed";
                LegacyAssignment.Comentarios := Rec.Comments;
                LegacyAssignment."JMC Business Line" := Rec."Business Line";
                LegacyAssignment."JMC Fecha Evento" := Rec."Event Date";
                LegacyAssignment."JMC Hora Evento" := Rec."Event Time";
                LegacyAssignment.Modify(true);
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
            // Delete from legacy table (50005)
            if LegacyAssignment.Get(Rec."Event Code", Rec."Event Resource Line No.", Rec."Resource Code") then
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

                // Apply filters
                if ShouldIncludeRecord(
                    LegacyAssignment."JMC Business Line",
                    LegacyAssignment."JMC Event Date",
                    LegacyAssignment."Codigo Recurso",
                    LegacyAssignment."Tarea Realizada")
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
                    NewAssignment."Task Performed")
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
                    Rec.Insert();
                end;
            until NewAssignment.Next() = 0;

        if Rec.FindFirst() then;
    end;

    local procedure ShouldIncludeRecord(BizLine: Enum "JMC Business Line"; EventDate: Date; ResourceCode: Code[20]; TaskPerformed: Code[20]): Boolean
    begin
        // Business Line filter
        if BusinessLineFilter <> BusinessLineFilter::Both then begin
            if (BusinessLineFilter = BusinessLineFilter::Catering) and (BizLine <> BizLine::Catering) then
                exit(false);
            if (BusinessLineFilter = BusinessLineFilter::Industry) and (BizLine <> BizLine::Industry) then
                exit(false);
        end;

        // Event Date filter
        if EventDateFilter <> 0D then
            if EventDate <> EventDateFilter then
                exit(false);

        // Resource Code filter
        if ResourceCodeFilter <> '' then
            if ResourceCode <> ResourceCodeFilter then
                exit(false);

        // Task Performed filter
        if TaskPerformedFilter <> '' then
            if TaskPerformed <> TaskPerformedFilter then
                exit(false);

        exit(true);
    end;

    local procedure GetFormattedEventDate(): Text
    var
        WeekdayName: Text;
        MonthName: Text;
    begin
        if Rec."Event Date" = 0D then
            exit('');

        // Format: sábado, 15 de agosto de 2026
        WeekdayName := Format(Rec."Event Date", 0, '<Weekday Text>');
        MonthName := Format(Rec."Event Date", 0, '<Month Text>');

        exit(StrSubstNo('%1, %2 de %3 de %4',
            WeekdayName,
            Format(Rec."Event Date", 0, '<Day>'),
            MonthName,
            Format(Rec."Event Date", 0, '<Year4>')));
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
}
