codeunit 53303 "JMC Supplier Incident Mgt"
{
    procedure CreateFromPurchaseOrder(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        SelectionPage: Page "JMC Supplier Incident Lines";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if not PurchaseLine.FindFirst() then
            Error(NoItemLinesErr);

        SelectionPage.SetTableView(PurchaseLine);
        SelectionPage.LookupMode(true);
        if SelectionPage.RunModal() = Action::LookupOK then begin
            SelectionPage.GetRecord(PurchaseLine);
            CreateFromPurchaseLine(PurchaseHeader, PurchaseLine);
        end;
    end;

    procedure CreateFromAssemblyOrder(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        SelectionPage: Page "JMC Assembly Incident Lines";
    begin
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if not AssemblyLine.FindFirst() then
            Error(NoItemLinesErr);

        SelectionPage.SetTableView(AssemblyLine);
        SelectionPage.LookupMode(true);
        if SelectionPage.RunModal() = Action::LookupOK then begin
            SelectionPage.GetRecord(AssemblyLine);
            CreateFromAssemblyLine(AssemblyHeader, AssemblyLine);
        end;
    end;

    local procedure CreateFromPurchaseLine(PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line")
    var
        Incident: Record "JMC Supplier Incident";
    begin
        Incident.Init();
        Incident."JMC No. Series" := GetIncidentNoSeries();
        Incident."JMC Vendor No." := PurchaseHeader."Buy-from Vendor No.";
        Incident."JMC Source Type" := Incident."JMC Source Type"::"Purchase Order";
        Incident."JMC Source Document No." := PurchaseHeader."No.";
        Incident."JMC Source Line No." := PurchaseLine."Line No.";
        Incident."JMC Item No." := PurchaseLine."No.";
        Incident."JMC Item Description" := PurchaseLine.Description;
        Incident.Insert(true);
        Page.Run(Page::"JMC Supplier Incident Card", Incident);
    end;

    local procedure CreateFromAssemblyLine(AssemblyHeader: Record "Assembly Header"; AssemblyLine: Record "Assembly Line")
    var
        Incident: Record "JMC Supplier Incident";
        Item: Record Item;
    begin
        Incident.Init();
        Incident."JMC No. Series" := GetIncidentNoSeries();
        Incident."JMC Source Type" := Incident."JMC Source Type"::"Assembly Order";
        Incident."JMC Source Document No." := AssemblyHeader."No.";
        Incident."JMC Source Line No." := AssemblyLine."Line No.";
        Incident."JMC Item No." := AssemblyLine."No.";
        Incident."JMC Item Description" := AssemblyLine.Description;
        if Item.Get(AssemblyLine."No.") then
            Incident."JMC Vendor No." := Item."Vendor No.";
        Incident.Insert(true);
        Page.Run(Page::"JMC Supplier Incident Card", Incident);
    end;

    local procedure GetIncidentNoSeries(): Code[20]
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();
        PurchasesPayablesSetup.TestField("JMC Supplier Incident Nos.");
        exit(PurchasesPayablesSetup."JMC Supplier Incident Nos.");
    end;

    var
        NoItemLinesErr: Label 'The document does not contain item lines.', Comment = 'ESP="El documento no contiene líneas de producto."';
}