codeunit 53303 "JMC Supplier Incident Mgt"
{
    procedure CreateFromPurchaseOrder(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        Incident: Record "JMC Supplier Incident";
    begin
        if not SelectPurchaseLines(PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseLine) then
            exit;

        Incident.Init();
        Incident."JMC No. Series" := GetIncidentNoSeries();
        Incident."JMC Vendor No." := PurchaseHeader."Buy-from Vendor No.";
        Incident."JMC Source Type" := Incident."JMC Source Type"::"Purchase Order";
        Incident."JMC Source Document No." := PurchaseHeader."No.";
        Incident."JMC Source Line No." := PurchaseLine."Line No.";
        Incident."JMC Item No." := PurchaseLine."No.";
        Incident."JMC Item Description" := PurchaseLine.Description;
        Incident.Insert(true);

        repeat
            InsertPurchaseIncidentProduct(Incident, PurchaseLine);
        until PurchaseLine.Next() = 0;

        Page.Run(Page::"JMC Supplier Incident Card", Incident);
    end;

    procedure CreateFromAssemblyOrder(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        Incident: Record "JMC Supplier Incident";
        Item: Record Item;
    begin
        if not SelectAssemblyLines(AssemblyHeader."Document Type", AssemblyHeader."No.", AssemblyLine) then
            exit;

        Incident.Init();
        Incident."JMC No. Series" := GetIncidentNoSeries();
        Incident."JMC Source Type" := Incident."JMC Source Type"::"Assembly Order";
        Incident."JMC Source Document No." := AssemblyHeader."No.";
        Incident."JMC Source Line No." := AssemblyLine."Line No.";
        Incident."JMC Item No." := AssemblyLine."No.";
        Incident."JMC Item Description" := AssemblyLine.Description;
        if Item.Get(AssemblyLine."No.") then
            Incident."JMC Vendor No." := Item."Vendor No.";
        ValidateAssemblyLineVendors(AssemblyLine, Incident."JMC Vendor No.");
        Incident.Insert(true);

        AssemblyLine.FindSet();
        repeat
            InsertAssemblyIncidentProduct(Incident, AssemblyLine);
        until AssemblyLine.Next() = 0;

        Page.Run(Page::"JMC Supplier Incident Card", Incident);
    end;

    procedure AddProductsToIncident(Incident: Record "JMC Supplier Incident")
    var
        PurchaseLine: Record "Purchase Line";
        AssemblyLine: Record "Assembly Line";
    begin
        case Incident."JMC Source Type" of
            Incident."JMC Source Type"::"Purchase Order":
                begin
                    if not SelectPurchaseLines(PurchaseLine."Document Type"::Order, Incident."JMC Source Document No.", PurchaseLine) then
                        exit;
                    repeat
                        InsertPurchaseIncidentProduct(Incident, PurchaseLine);
                    until PurchaseLine.Next() = 0;
                end;
            Incident."JMC Source Type"::"Assembly Order":
                begin
                    if not SelectAssemblyLines(AssemblyLine."Document Type"::Order, Incident."JMC Source Document No.", AssemblyLine) then
                        exit;
                    ValidateAssemblyLineVendors(AssemblyLine, Incident."JMC Vendor No.");
                    AssemblyLine.FindSet();
                    repeat
                        InsertAssemblyIncidentProduct(Incident, AssemblyLine);
                    until AssemblyLine.Next() = 0;
                end;
            else
                Error(NoSourceDocumentErr);
        end;
    end;

    procedure SelectTrackedLot(var IncidentProduct: Record "JMC Supplier Incident Product"): Boolean
    var
        Incident: Record "JMC Supplier Incident";
        PurchaseLine: Record "Purchase Line";
        AssemblyLine: Record "Assembly Line";
        ReservationEntry: Record "Reservation Entry";
        TrackedLotsPage: Page "JMC Incident Tracking Lots";
    begin
        if not Incident.Get(IncidentProduct."JMC Incident No.") then
            exit(false);

        case Incident."JMC Source Type" of
            Incident."JMC Source Type"::"Purchase Order":
                begin
                    PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                    ReservationEntry.SetSourceFilter(
                        Database::"Purchase Line",
                        PurchaseLine."Document Type".AsInteger(),
                        Incident."JMC Source Document No.",
                        IncidentProduct."JMC Source Line No.",
                        true);
                end;
            Incident."JMC Source Type"::"Assembly Order":
                begin
                    AssemblyLine."Document Type" := AssemblyLine."Document Type"::Order;
                    ReservationEntry.SetSourceFilter(
                        Database::"Assembly Line",
                        AssemblyLine."Document Type".AsInteger(),
                        Incident."JMC Source Document No.",
                        IncidentProduct."JMC Source Line No.",
                        true);
                end;
            else
                Error(NoSourceDocumentErr);
        end;

        ReservationEntry.SetRange("Item No.", IncidentProduct."JMC Item No.");
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservationEntry.IsEmpty() then
            Error(NoTrackedLotsErr);

        TrackedLotsPage.SetTableView(ReservationEntry);
        TrackedLotsPage.LookupMode(true);
        if TrackedLotsPage.RunModal() <> Action::LookupOK then
            exit(false);

        TrackedLotsPage.GetRecord(ReservationEntry);
        IncidentProduct.Validate("JMC Lot No.", ReservationEntry."Lot No.");
        IncidentProduct."JMC Reservation Entry No." := ReservationEntry."Entry No.";
        IncidentProduct.Modify(true);
        exit(true);
    end;

    procedure ValidateTrackedLot(var IncidentProduct: Record "JMC Supplier Incident Product")
    var
        Incident: Record "JMC Supplier Incident";
        PurchaseLine: Record "Purchase Line";
        AssemblyLine: Record "Assembly Line";
        ReservationEntry: Record "Reservation Entry";
    begin
        if IncidentProduct."JMC Lot No." = '' then begin
            IncidentProduct."JMC Reservation Entry No." := 0;
            exit;
        end;
        if not Incident.Get(IncidentProduct."JMC Incident No.") then
            Error(NoSourceDocumentErr);

        case Incident."JMC Source Type" of
            Incident."JMC Source Type"::"Purchase Order":
                begin
                    PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                    ReservationEntry.SetSourceFilter(
                        Database::"Purchase Line",
                        PurchaseLine."Document Type".AsInteger(),
                        Incident."JMC Source Document No.",
                        IncidentProduct."JMC Source Line No.",
                        true);
                end;
            Incident."JMC Source Type"::"Assembly Order":
                begin
                    AssemblyLine."Document Type" := AssemblyLine."Document Type"::Order;
                    ReservationEntry.SetSourceFilter(
                        Database::"Assembly Line",
                        AssemblyLine."Document Type".AsInteger(),
                        Incident."JMC Source Document No.",
                        IncidentProduct."JMC Source Line No.",
                        true);
                end;
            else
                Error(NoSourceDocumentErr);
        end;

        ReservationEntry.SetRange("Item No.", IncidentProduct."JMC Item No.");
        ReservationEntry.SetRange("Lot No.", IncidentProduct."JMC Lot No.");
        if not ReservationEntry.FindFirst() then
            Error(InvalidTrackedLotErr, IncidentProduct."JMC Lot No.");

        IncidentProduct."JMC Reservation Entry No." := ReservationEntry."Entry No.";
    end;

    local procedure SelectPurchaseLines(DocumentType: Enum "Purchase Document Type"; DocumentNo: Code[20]; var PurchaseLine: Record "Purchase Line"): Boolean
    var
        SelectionPage: Page "JMC Supplier Incident Lines";
    begin
        PurchaseLine.SetRange("Document Type", DocumentType);
        PurchaseLine.SetRange("Document No.", DocumentNo);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if not PurchaseLine.FindFirst() then
            Error(NoItemLinesErr);

        SelectionPage.SetTableView(PurchaseLine);
        SelectionPage.LookupMode(true);
        if SelectionPage.RunModal() <> Action::LookupOK then
            exit(false);

        SelectionPage.SetSelectionFilter(PurchaseLine);
        exit(PurchaseLine.FindSet());
    end;

    local procedure SelectAssemblyLines(DocumentType: Enum "Assembly Document Type"; DocumentNo: Code[20]; var AssemblyLine: Record "Assembly Line"): Boolean
    var
        SelectionPage: Page "JMC Assembly Incident Lines";
    begin
        AssemblyLine.SetRange("Document Type", DocumentType);
        AssemblyLine.SetRange("Document No.", DocumentNo);
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if not AssemblyLine.FindFirst() then
            Error(NoItemLinesErr);

        SelectionPage.SetTableView(AssemblyLine);
        SelectionPage.LookupMode(true);
        if SelectionPage.RunModal() <> Action::LookupOK then
            exit(false);

        SelectionPage.SetSelectionFilter(AssemblyLine);
        exit(AssemblyLine.FindSet());
    end;

    local procedure InsertPurchaseIncidentProduct(Incident: Record "JMC Supplier Incident"; PurchaseLine: Record "Purchase Line")
    var
        IncidentProduct: Record "JMC Supplier Incident Product";
    begin
        IncidentProduct.SetRange("JMC Incident No.", Incident."JMC No.");
        IncidentProduct.SetRange("JMC Source Line No.", PurchaseLine."Line No.");
        if not IncidentProduct.IsEmpty() then
            exit;

        IncidentProduct.Init();
        IncidentProduct."JMC Incident No." := Incident."JMC No.";
        IncidentProduct."JMC Line No." := GetNextProductLineNo(Incident."JMC No.");
        IncidentProduct."JMC Source Line No." := PurchaseLine."Line No.";
        IncidentProduct."JMC Item No." := PurchaseLine."No.";
        IncidentProduct."JMC Item Description" := PurchaseLine.Description;
        IncidentProduct."JMC Quantity" := PurchaseLine.Quantity;
        IncidentProduct.Insert(true);
    end;

    local procedure InsertAssemblyIncidentProduct(Incident: Record "JMC Supplier Incident"; AssemblyLine: Record "Assembly Line")
    var
        IncidentProduct: Record "JMC Supplier Incident Product";
    begin
        IncidentProduct.SetRange("JMC Incident No.", Incident."JMC No.");
        IncidentProduct.SetRange("JMC Source Line No.", AssemblyLine."Line No.");
        if not IncidentProduct.IsEmpty() then
            exit;

        IncidentProduct.Init();
        IncidentProduct."JMC Incident No." := Incident."JMC No.";
        IncidentProduct."JMC Line No." := GetNextProductLineNo(Incident."JMC No.");
        IncidentProduct."JMC Source Line No." := AssemblyLine."Line No.";
        IncidentProduct."JMC Item No." := AssemblyLine."No.";
        IncidentProduct."JMC Item Description" := AssemblyLine.Description;
        IncidentProduct."JMC Quantity" := AssemblyLine.Quantity;
        IncidentProduct.Insert(true);
    end;

    local procedure ValidateAssemblyLineVendors(var AssemblyLine: Record "Assembly Line"; VendorNo: Code[20])
    var
        Item: Record Item;
    begin
        if not AssemblyLine.FindSet() then
            exit;

        repeat
            if Item.Get(AssemblyLine."No.") and (Item."Vendor No." <> VendorNo) then
                Error(MultipleVendorsErr);
        until AssemblyLine.Next() = 0;
    end;

    local procedure GetNextProductLineNo(IncidentNo: Code[20]): Integer
    var
        IncidentProduct: Record "JMC Supplier Incident Product";
    begin
        IncidentProduct.SetRange("JMC Incident No.", IncidentNo);
        if IncidentProduct.FindLast() then
            exit(IncidentProduct."JMC Line No." + 10000);
        exit(10000);
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
        MultipleVendorsErr: Label 'Select products from the same vendor to create a supplier incident.', Comment = 'ESP="Seleccione productos del mismo proveedor para crear una incidencia."';
        NoSourceDocumentErr: Label 'This incident is not linked to a purchase order or an assembly order.', Comment = 'ESP="Esta incidencia no está vinculada a un pedido de compra ni a un pedido de ensamblado."';
        NoTrackedLotsErr: Label 'No lot tracking lines are assigned to this product line.', Comment = 'ESP="La línea de producto no tiene lotes asignados en el seguimiento."';
        InvalidTrackedLotErr: Label 'Lot %1 is not assigned to this product line in the source document tracking.', Comment = 'ESP="El lote %1 no está asignado a esta línea de producto en el seguimiento del documento de origen."';
}