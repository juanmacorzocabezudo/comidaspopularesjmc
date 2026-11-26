report 53113 "JMC Set Direct Res. Variable"
{
    Caption = 'Set Direct Resources to Variable', Comment = 'ESP="Marcar recursos directos como Variable"';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(JMCResource; Resource)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", Name;

            trigger OnAfterGetRecord()
            begin
                if not JMCUsedResources.ContainsKey(JMCResource."No.") then begin
                    JMCUnusedCount += 1;
                    exit;
                end;
                if JMCResource."JMC Cost Type" = JMCResource."JMC Cost Type"::Variable then begin
                    JMCUnchangedCount += 1;
                    exit;
                end;
                JMCResource.Validate("JMC Cost Type", JMCResource."JMC Cost Type"::Variable);
                JMCResource.Modify(true);
                JMCUpdatedCount += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Information)
                {
                    Caption = 'Information', Comment = 'ESP="Información"';

                    field(JMCInformation; JMCInformationLbl)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        Clear(JMCUsedResources);
        JMCUpdatedCount := 0;
        JMCUnchangedCount := 0;
        JMCUnusedCount := 0;
        CollectUsedResources();
    end;

    trigger OnPostReport()
    var
        jmcModel: Record "JMC Cost Model";
    begin
        if JMCUpdatedCount > 0 then begin
            jmcModel.ModifyAll("JMC Personnel Sources Ready", false, false);
            jmcModel.ModifyAll("JMC Calculation Current", false, false);
        end;
        Message(JMCCompletedMsg, JMCUpdatedCount, JMCUnchangedCount, JMCUnusedCount);
    end;

    local procedure CollectUsedResources()
    var
        jmcAssemblyLine: Record "Assembly Line";
        jmcPostedAssemblyLine: Record "Posted Assembly Line";
        jmcAssignment: Record "Asignacion Recursos Eventos";
    begin
        jmcAssemblyLine.SetRange("Document Type", jmcAssemblyLine."Document Type"::Order);
        jmcAssemblyLine.SetRange(Type, jmcAssemblyLine.Type::Resource);
        jmcAssemblyLine.SetFilter("No.", '<>%1', '');
        jmcAssemblyLine.SetLoadFields("No.");
        if jmcAssemblyLine.FindSet() then
            repeat
                IncludeResource(jmcAssemblyLine."No.");
            until jmcAssemblyLine.Next() = 0;

        jmcPostedAssemblyLine.SetRange(Type, jmcPostedAssemblyLine.Type::Resource);
        jmcPostedAssemblyLine.SetFilter("No.", '<>%1', '');
        jmcPostedAssemblyLine.SetLoadFields("No.");
        if jmcPostedAssemblyLine.FindSet() then
            repeat
                IncludeResource(jmcPostedAssemblyLine."No.");
            until jmcPostedAssemblyLine.Next() = 0;

        jmcAssignment.SetFilter("Codigo Recurso", '<>%1', '');
        jmcAssignment.SetLoadFields("Codigo Recurso");
        if jmcAssignment.FindSet() then
            repeat
                IncludeResource(jmcAssignment."Codigo Recurso");
            until jmcAssignment.Next() = 0;
    end;

    local procedure IncludeResource(jmcResourceNo: Code[20])
    begin
        if not JMCUsedResources.ContainsKey(jmcResourceNo) then
            JMCUsedResources.Add(jmcResourceNo, true);
    end;

    var
        JMCUsedResources: Dictionary of [Code[20], Boolean];
        JMCUpdatedCount: Integer;
        JMCUnchangedCount: Integer;
        JMCUnusedCount: Integer;
        JMCInformationLbl: Label 'Sets the cost type to Variable for filtered resources used in assembly orders, posted assemblies or event assignments, including resources currently classified as Fixed. No date or status filters apply. Other resources and source documents are not changed. Accept to apply or cancel to leave data unchanged. Afterwards, run Calculate All Costs.', Comment = 'ESP="Cambia el tipo de coste a Variable de los recursos filtrados usados en pedidos de ensamblado, ensamblados registrados o asignaciones a eventos, incluidos los clasificados como Fijo. No se filtra por fechas ni estados. No modifica los demás recursos ni los documentos de origen. Acepte para aplicar o cancele para no modificar datos. Después, ejecute Calcular todos los costes."';
        JMCCompletedMsg: Label 'Resource classification completed. Changed to Variable: %1. Already Variable: %2. Not used in assemblies or events and preserved: %3. Run Calculate All Costs to reread personnel costs.', Comment = 'ESP="Clasificación de recursos completada. Cambiados a Variable: %1. Ya eran Variable: %2. Sin uso en ensamblados o eventos y conservados: %3. Ejecute Calcular todos los costes para volver a leer los costes de personal."';
}
