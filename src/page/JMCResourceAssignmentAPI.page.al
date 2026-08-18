page 53133 "JMC Resource Assignment API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'recursos';

    EntityCaption = 'Asignación de Recursos';
    EntitySetCaption = 'Asignaciones de Recursos';
    EntityName = 'asignacionRecursos';
    EntitySetName = 'asignacionesRecursos';

    PageType = API;
    SourceTable = "JMC Resource Assignment";
    SourceTableTemporary = true;
    DelayedInsert = true;
    ODataKeyFields = "Entry No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(nMovimiento; Rec."Entry No.")
                {
                    Caption = 'Nº Mov.';
                }
                field(tablaOrigen; Rec."Source Table")
                {
                    Caption = 'Tabla Origen';
                }
                field(codigoEvento; Rec."Event Code")
                {
                    Caption = 'Código Evento';
                }
                field(fechaEvento; Rec."Event Date")
                {
                    Caption = 'Fecha Evento';
                }
                field(horaEvento; Rec."Event Time")
                {
                    Caption = 'Hora Evento';
                }
                field(descripcionEvento; Rec."Event Description")
                {
                    Caption = 'Descripción Evento';
                }
                field(codigoRecurso; Rec."Resource Code")
                {
                    Caption = 'Código Recurso';
                }
                field(descripcion; Rec.Description)
                {
                    Caption = 'Descripción';
                }
                field(tipo; Rec.Tipo)
                {
                    Caption = 'Tipo';
                }
                field(cantidad; Rec.Quantity)
                {
                    Caption = 'Cantidad';
                }
                field(unidadMedida; Rec."Unit of Measure")
                {
                    Caption = 'Unidad de Medida';
                }
                field(costeUnitario; Rec."Unit Cost")
                {
                    Caption = 'Coste Unitario';
                }
                field(tareaRealizada; Rec."Task Performed")
                {
                    Caption = 'Tarea Realizada';
                }
                field(comentarios; Rec.Comments)
                {
                    Caption = 'Comentarios';
                }
                field(lineaNegocio; Rec."Business Line")
                {
                    Caption = 'Línea de Negocio';
                }
                field(numeroSemana; Rec."JMC Week No.")
                {
                    Caption = 'Nº Semana';
                }
                field(diaSemana; Rec."JMC Day of Week")
                {
                    Caption = 'Día de la Semana';
                }
                field(mes; Rec."JMC Month")
                {
                    Caption = 'Mes';
                }
                field(anio; Rec."JMC Year")
                {
                    Caption = 'Año';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadAllData();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        DateFilter: Text;
        ResourceFilter: Text;
        TypeFilter: Text;
    begin
        // Capturar filtros cuando se hace una búsqueda
        DateFilter := Rec.GetFilter("Event Date");
        ResourceFilter := Rec.GetFilter("Resource Code");
        TypeFilter := Rec.GetFilter(Tipo);

        // Recargar datos con filtros si hay algún filtro aplicado
        if (DateFilter <> '') or (ResourceFilter <> '') or (TypeFilter <> '') then
            LoadFilteredData(DateFilter, ResourceFilter, TypeFilter);

        exit(Rec.FindSet());
    end;

    local procedure LoadAllData()
    var
        LegacyAssignment: Record "Asignacion Recursos Eventos";
        NewAssignment: Record "JMC Resource Assignment";
        Resource: Record Resource;
        EntryNoCounter: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();
        EntryNoCounter := 0;

        // Load data from legacy table (Catering - 50005)
        LegacyAssignment.Reset();

        if LegacyAssignment.FindSet() then
            repeat
                LegacyAssignment.CalcFields("JMC Event Date", "JMC Event Time", "JMC Event Description");

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
                Rec.Tipo := LegacyAssignment."JMC Tipo";

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

                // Calculate date fields manually
                if Rec."Event Date" <> 0D then begin
                    Rec."JMC Week No." := Date2DWY(Rec."Event Date", 2);
                    Rec."JMC Day of Week" := Format(Rec."Event Date", 0, '<Weekday Text>');
                    Rec."JMC Month" := Date2DMY(Rec."Event Date", 2);
                    Rec."JMC Year" := Date2DMY(Rec."Event Date", 3);
                end;

                Rec.Insert();
            until LegacyAssignment.Next() = 0;

        // Load data from new table (Industry - 53116)
        NewAssignment.Reset();

        if NewAssignment.FindSet() then
            repeat
                NewAssignment.CalcFields("Event Description");

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
                Rec.Tipo := NewAssignment.Tipo;

                // Load editable date and time fields
                Rec."Event Date" := NewAssignment."Event Date";
                Rec."Event Time" := NewAssignment."Event Time";
                Rec."Event Description" := NewAssignment."Event Description";

                // Calculate date fields manually to ensure they are always populated
                if Rec."Event Date" <> 0D then begin
                    Rec."JMC Week No." := Date2DWY(Rec."Event Date", 2);
                    Rec."JMC Day of Week" := Format(Rec."Event Date", 0, '<Weekday Text>');
                    Rec."JMC Month" := Date2DMY(Rec."Event Date", 2);
                    Rec."JMC Year" := Date2DMY(Rec."Event Date", 3);
                end;

                Rec.Insert();
            until NewAssignment.Next() = 0;

        if Rec.FindFirst() then;
    end;

    local procedure LoadFilteredData(DateFilter: Text; ResourceFilter: Text; TypeFilter: Text)
    var
        LegacyAssignment: Record "Asignacion Recursos Eventos";
        NewAssignment: Record "JMC Resource Assignment";
        Resource: Record Resource;
        EntryNoCounter: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();
        EntryNoCounter := 0;

        // Load data from legacy table (Catering - 50005) con filtros
        LegacyAssignment.Reset();

        // Aplicar filtros si existen
        if DateFilter <> '' then
            LegacyAssignment.SetFilter("JMC Fecha Evento", DateFilter);
        if ResourceFilter <> '' then
            LegacyAssignment.SetFilter("Codigo Recurso", ResourceFilter);
        if TypeFilter <> '' then
            LegacyAssignment.SetFilter("JMC Tipo", TypeFilter);

        if LegacyAssignment.FindSet() then
            repeat
                LegacyAssignment.CalcFields("JMC Event Date", "JMC Event Time", "JMC Event Description");

                EntryNoCounter -= 1;
                Rec.Init();
                Rec."Entry No." := EntryNoCounter;
                Rec."Source Table" := Rec."Source Table"::Catering;
                Rec."Event Code" := LegacyAssignment."Codigo Evento";
                Rec."Event Resource Line No." := LegacyAssignment."Linea Recurso Evento";
                Rec."Resource Code" := LegacyAssignment."Codigo Recurso";

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
                Rec.Tipo := LegacyAssignment."JMC Tipo";

                Rec."Event Date" := LegacyAssignment."JMC Fecha Evento";
                Rec."Event Time" := LegacyAssignment."JMC Hora Evento";

                if Rec."Event Date" = 0D then
                    Rec."Event Date" := LegacyAssignment."JMC Event Date";
                if Rec."Event Time" = 0T then
                    Rec."Event Time" := LegacyAssignment."JMC Event Time";

                Rec."Event Description" := LegacyAssignment."JMC Event Description";

                // Calculate date fields manually
                if Rec."Event Date" <> 0D then begin
                    Rec."JMC Week No." := Date2DWY(Rec."Event Date", 2);
                    Rec."JMC Day of Week" := Format(Rec."Event Date", 0, '<Weekday Text>');
                    Rec."JMC Month" := Date2DMY(Rec."Event Date", 2);
                    Rec."JMC Year" := Date2DMY(Rec."Event Date", 3);
                end;

                Rec.Insert();
            until LegacyAssignment.Next() = 0;

        // Load data from new table (Industry - 53116) con filtros
        NewAssignment.Reset();

        // Aplicar filtros si existen
        if DateFilter <> '' then
            NewAssignment.SetFilter("Event Date", DateFilter);
        if ResourceFilter <> '' then
            NewAssignment.SetFilter("Resource Code", ResourceFilter);
        if TypeFilter <> '' then
            NewAssignment.SetFilter(Tipo, TypeFilter);

        if NewAssignment.FindSet() then
            repeat
                NewAssignment.CalcFields("Event Description");

                Rec.Init();
                Rec."Entry No." := NewAssignment."Entry No.";
                Rec."Source Table" := Rec."Source Table"::Industry;
                Rec."Event Code" := NewAssignment."Event Code";
                Rec."Event Resource Line No." := NewAssignment."Event Resource Line No.";
                Rec."Resource Code" := NewAssignment."Resource Code";

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
                Rec.Tipo := NewAssignment.Tipo;

                Rec."Event Date" := NewAssignment."Event Date";
                Rec."Event Time" := NewAssignment."Event Time";
                Rec."Event Description" := NewAssignment."Event Description";

                Rec."JMC Week No." := NewAssignment."JMC Week No.";
                Rec."JMC Day of Week" := NewAssignment."JMC Day of Week";
                Rec."JMC Month" := NewAssignment."JMC Month";
                Rec."JMC Year" := NewAssignment."JMC Year";

                Rec.Insert();
            until NewAssignment.Next() = 0;

        if Rec.FindFirst() then;
    end;
}
