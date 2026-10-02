report 53109 "JMC Incident Vendor PDF"
{
    Caption = 'Supplier Incident Details', Comment = 'ESP="Datos de la incidencia de proveedor"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/JMCIncidentVendorPdf.rdlc';
    UsageCategory = None;
    ApplicationArea = All;
    UseRequestPage = false;

    dataset
    {
        dataitem(Incident; "JMC Supplier Incident")
        {
            column(IncidentNo; "JMC No.") { }
            column(IncidentDate; "JMC Date") { }
            column(VendorName; "JMC Vendor Name") { }
            column(SourceDocument; SourceDocumentText) { }
            column(LotNo; "JMC Lot No.") { }
            column(IncidentDescription; "JMC Incident Description") { }
            column(DetectedBy; DetectedByText) { }
            column(ProductList; ProductList) { }
            column(TitleCaption; TitleLbl) { }
            column(Section1Caption; Section1Lbl) { }
            column(Section2Caption; Section2Lbl) { }
            column(Section3Caption; Section3Lbl) { }
            column(IncidentCodeCaption; IncidentCodeLbl) { }
            column(DateCaption; DateLbl) { }
            column(VendorCaption; VendorLbl) { }
            column(SourceDocumentCaption; SourceDocumentLbl) { }
            column(LotCaption; LotLbl) { }
            column(ProductsCaption; ProductsLbl) { }
            column(DescriptionCaption; DescriptionLbl) { }
            column(DetectedByCaption; DetectedByLbl) { }
            column(Section3Intro; Section3IntroLbl) { }
            column(RootCauseText; RootCauseLbl) { }
            column(CorrectiveActionText; CorrectiveActionLbl) { }
            column(PreventiveActionText; PreventiveActionLbl) { }
            column(ResponsibleText; ResponsibleLbl) { }

            trigger OnAfterGetRecord()
            begin
                CalcFields("JMC Vendor Name");
                SourceDocumentText := StrSubstNo('%1 %2', "JMC Source Type", "JMC Source Document No.");
                DetectedByText := Format("JMC Detected By");
                BuildProductList();
            end;
        }
    }

    local procedure BuildProductList()
    var
        IncidentProduct: Record "JMC Supplier Incident Product";
        ProductListBuilder: TextBuilder;
    begin
        ProductListBuilder.AppendLine(StrSubstNo(ProductHeaderLbl, ItemLbl, ProductDescriptionLbl, QuantityLbl, LotLbl));
        IncidentProduct.SetRange("JMC Incident No.", Incident."JMC No.");
        if IncidentProduct.FindSet() then
            repeat
                ProductListBuilder.AppendLine(StrSubstNo(ProductRowLbl, IncidentProduct."JMC Item No.", IncidentProduct."JMC Item Description", Format(IncidentProduct."JMC Quantity"), IncidentProduct."JMC Lot No."));
            until IncidentProduct.Next() = 0;
        ProductList := ProductListBuilder.ToText();
    end;

    var
        SourceDocumentText: Text[100];
        DetectedByText: Text[100];
        ProductList: Text;
        TitleLbl: Label 'Supplier Incident', Comment = 'ESP="Incidencia de proveedor"';
        Section1Lbl: Label '1. General incident information', Comment = 'ESP="1. Datos generales de la incidencia"';
        Section2Lbl: Label '2. Description of the problem detected', Comment = 'ESP="2. Descripción del problema detectado"';
        Section3Lbl: Label '3. Root cause analysis and action plan', Comment = 'ESP="3. Análisis de causa raíz y plan de acción"';
        IncidentCodeLbl: Label 'Incident code', Comment = 'ESP="Código de incidencia"';
        DateLbl: Label 'Issue date', Comment = 'ESP="Fecha de emisión"';
        VendorLbl: Label 'Vendor name', Comment = 'ESP="Nombre del proveedor"';
        SourceDocumentLbl: Label 'Order / Receipt No.', Comment = 'ESP="Nº pedido / albarán"';
        LotLbl: Label 'Lot', Comment = 'ESP="Lote"';
        ProductsLbl: Label 'Products', Comment = 'ESP="Productos"';
        ItemLbl: Label 'Item', Comment = 'ESP="Producto"';
        ProductDescriptionLbl: Label 'Description', Comment = 'ESP="Descripción"';
        QuantityLbl: Label 'Quantity', Comment = 'ESP="Cantidad"';
        DescriptionLbl: Label 'Detailed description of the failure', Comment = 'ESP="Descripción detallada del fallo"';
        DetectedByLbl: Label 'Detected by', Comment = 'ESP="Detectado por"';
        Section3IntroLbl: Label 'Please provide the following information:', Comment = 'ESP="Les rogamos que indiquen la siguiente información:"';
        RootCauseLbl: Label 'Root cause: technical, human or process reason that caused the incident.', Comment = 'ESP="Causa raíz: motivo técnico, humano o de proceso que originó la incidencia."';
        CorrectiveActionLbl: Label 'Corrective action: measures applied to correct the affected lot or service.', Comment = 'ESP="Acción correctiva: medidas aplicadas para corregir el lote o servicio afectado."';
        PreventiveActionLbl: Label 'Preventive action: measures implemented to ensure it does not happen again.', Comment = 'ESP="Acción preventiva: medidas implantadas para asegurar que no vuelva a ocurrir."';
        ResponsibleLbl: Label 'Person responsible and deadline for each action.', Comment = 'ESP="Persona responsable y fecha límite de cada acción."';
        ProductHeaderLbl: Label '%1 | %2 | %3 | %4', Comment = 'ESP="%1 | %2 | %3 | %4"';
        ProductRowLbl: Label '%1 | %2 | %3 | %4', Comment = 'ESP="%1 | %2 | %3 | %4"';
}
