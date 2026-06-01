page 53100 "JMC CP BOM Aditional Cost"
{
    Caption = 'BOM Additional Cost', Comment = 'ESP="Costes adicional de la BOM"';
    SourceTable = "BOM Aditional Cost";
    PageType = ListPart;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(Information)
            {
                Caption = 'Information', Comment = 'ESP="Información"';

                group(FixedCost)
                {
                    Caption = 'Fixed Cost', Comment = 'ESP="Coste Fijado"';

                    field(FixedBOMTotalCost; Item.Receta_CosteLMFijado)
                    {
                        Caption = 'BOM Total Cost (Fixed)', Comment = 'ESP="Coste Total LM (Fijado)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                    }
                    field(FixedGeneralCosts; FixedGeneralCostsValue)
                    {
                        Caption = 'General Costs (Fixed)', Comment = 'ESP="Costes Generales (Fijado)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                    }
                    field(FixedExworkStdCost; AsmInfoPaneMgt.CalcAditionalFixedTotalCoste(Rec."Item No", 0) + Item.Receta_CosteLMFijado)
                    {
                        Caption = 'EXWORK Standard (Fixed)', Comment = 'ESP="EXWORK Estándar (Fijado)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                    }
                    field(FixedProfit; FixedProfitValue)
                    {
                        Caption = 'Profit (Fixed)', Comment = 'ESP="Beneficio (Fijado)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                    }
                    field(FixedProfitPct; FixedProfitPctValue)
                    {
                        Caption = '% Profit (Fixed)', Comment = 'ESP="% Beneficio (Fijado)"';
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                group(ProductCost)
                {
                    Caption = 'Product Cost', Comment = 'ESP="Coste Producto"';

                    field(ProductBOMTotalCost; AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true))
                    {
                        Caption = 'BOM Total Cost (Product)', Comment = 'ESP="Coste Total LM (Producto)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                    }
                    field(ProductGeneralCosts; ProductGeneralCostsValue)
                    {
                        Caption = 'General Costs (Product)', Comment = 'ESP="Costes Generales (Producto)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                    }
                    field(ProductExworkStdCost; AsmInfoPaneMgt.CalcAditionalUnitTotalCosteReceta(Rec."Item No", 0, true) + AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true))
                    {
                        Caption = 'EXWORK Standard (Product)', Comment = 'ESP="EXWORK Estándar (Producto)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                    }
                    field(ProductProfit; ProductProfitValue)
                    {
                        Caption = 'Profit (Product)', Comment = 'ESP="Beneficio (Producto)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                        Style = Unfavorable;
                    }
                    field(ProductProfitPct; ProductProfitPctValue)
                    {
                        Caption = '% Profit (Product)', Comment = 'ESP="% Beneficio (Producto)"';
                        ApplicationArea = All;
                        DecimalPlaces = 3 : 3;
                        Editable = false;
                        Style = Unfavorable;
                    }
                }
            }
            repeater(Lines)
            {
                field(CostNo; Rec."No. Cost")
                {
                    Caption = 'Cost No.', Comment = 'ESP="Nº Coste"';
                    ApplicationArea = All;
                }
                field(CostDescription; Rec."Description Cost")
                {
                    Caption = 'Cost Description', Comment = 'ESP="Descripción Coste"';
                    ApplicationArea = All;
                }
                field(CostType; Rec."Type Coste")
                {
                    Caption = 'Cost Type', Comment = 'ESP="Tipo Coste"';
                    ApplicationArea = All;
                }
                field(CostValue; Rec.Value)
                {
                    Caption = 'Value', Comment = 'ESP="Valor"';
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                }
                field(ApplyOnAllCost; Rec."Apply on all cost")
                {
                    Caption = 'Apply on All Costs', Comment = 'ESP="Aplicar a Todos los Costes"';
                    ApplicationArea = All;
                }
                field(AdditionalFixedCost; Rec."Aditional fixed cost")
                {
                    Caption = 'General Costs (Fixed)', Comment = 'ESP="Costes Generales (Fijado)"';
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                }
                field(AdditionalProductCost; AsmInfoPaneMgt.CalcAditionalUnitCoste(Rec, true))
                {
                    Caption = 'Additional Std. Cost (Product)', Comment = 'ESP="Coste Estándar Adicional (Producto)"';
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                }
                field(LineProfit; AsmInfoPaneMgt.CalcBeneficioActualizado(Rec))
                {
                    Caption = 'Profit (Product)', Comment = 'ESP="Beneficio (Producto)"';
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    Style = Unfavorable;
                }
                field(LineProfitPct; AsmInfoPaneMgt.CalcPerBeneficioActualizado(Rec))
                {
                    Caption = '% Profit (Product)', Comment = 'ESP="% Beneficio (Producto)"';
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    Style = Unfavorable;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ActionGroup)
            {
                Caption = 'Actions', Comment = 'ESP="Acciones"';

                action(AddCostFromTemplate)
                {
                    Caption = 'Additional Cost', Comment = 'ESP="Coste Adicional"';
                    ApplicationArea = All;
                    Image = AddAction;

                    trigger OnAction()
                    begin
                        // Acción no implementada en la original
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateCalculatedFields();
    end;

    trigger OnOpenPage()
    begin
        if Item.Get(Rec."Item No") then;
        UpdateCalculatedFields();
    end;

    local procedure UpdateCalculatedFields()
    begin
        if Item.Get(Rec."Item No") then begin
            FixedGeneralCostsValue := AsmInfoPaneMgt.CalcAditionalFixedTotalCoste(Rec."Item No", 0);
            FixedProfitValue := Item."Unit Price" - (Item.Receta_CosteLMFijado + FixedGeneralCostsValue);
            if (Item.Receta_CosteLMFijado + FixedGeneralCostsValue) <> 0 then
                FixedProfitPctValue := (FixedProfitValue / (Item.Receta_CosteLMFijado + FixedGeneralCostsValue)) * 100
            else
                FixedProfitPctValue := 0;

            ProductGeneralCostsValue := AsmInfoPaneMgt.CalcAditionalUnitTotalCosteReceta(Rec."Item No", 0, true);
            ProductProfitValue := Item."Unit Price" - (AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true) + ProductGeneralCostsValue);
            if (AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true) + ProductGeneralCostsValue) <> 0 then
                ProductProfitPctValue := (ProductProfitValue / (AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true) + ProductGeneralCostsValue)) * 100
            else
                ProductProfitPctValue := 0;
        end;
    end;

    var
        Item: Record Item;
        AsmInfoPaneMgt: Codeunit AlxiaAssemblyInfoManagement;
        FixedProfitValue: Decimal;
        FixedProfitPctValue: Decimal;
        FixedGeneralCostsValue: Decimal;
        ProductProfitValue: Decimal;
        ProductProfitPctValue: Decimal;
        ProductGeneralCostsValue: Decimal;
        LineProfitStyleTxt: Text;
        ProductProfitStyleTxt: Text;
}
