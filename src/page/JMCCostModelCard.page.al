page 53109 "JMC Cost Model Card"
{
    Caption = 'Cost Model', Comment = 'ESP="Modelo de costes"';
    PageType = Document;
    SourceTable = "JMC Cost Model";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("JMC Description"; Rec."JMC Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter a name that helps you identify this cost model. Changing the name does not calculate or apply costs.', Comment = 'ESP="Escriba un nombre que le ayude a identificar este modelo de costes. Cambiar el nombre no calcula ni aplica costes."';
                }
            }
            group(Structure)
            {
                Caption = 'Structure Allocation', Comment = 'ESP="Reparto de estructura"';
                Editable = false;

                grid(StructureSummary)
                {
                    group(StructureBasis)
                    {
                        ShowCaption = false;

                        field("JMC Total Structure Cost"; Rec."JMC Total Structure Cost")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Shows the fixed industrial and management expenses included in the last calculation. Variable expenses and recipe cost are excluded. Select the amount to see its saved breakdown.', Comment = 'ESP="Muestra la suma de los gastos fijos industriales y de gestión incluidos en el último cálculo. No incluye gastos variables ni el coste de receta. Pulse el importe para ver su desglose guardado."';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowSummaryDetail(Rec.FieldNo("JMC Total Structure Cost"));
                            end;
                        }
                        field("JMC Catering Structure Pct."; Rec."JMC Catering Structure Pct.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Shows the share of total production cost that belongs to Catering. This percentage determines its share of structure expenses. Select the value to see how it was calculated.', Comment = 'ESP="Muestra qué parte del coste total de producción corresponde a Catering. Este porcentaje determina qué parte de los gastos de estructura le corresponde. Pulse el valor para ver cómo se calculó."';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowSummaryDetail(Rec.FieldNo("JMC Catering Structure Pct."));
                            end;
                        }
                        field("JMC Industry Structure Pct."; Rec."JMC Industry Structure Pct.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Shows the share of production cost that belongs to Alimentacion. It is the percentage remaining after Catering and determines its share of structure expenses. Select the value to see the breakdown.', Comment = 'ESP="Muestra qué parte del coste de producción corresponde a Alimentación. Es el porcentaje que queda hasta el cien por cien después de Catering y determina su parte de los gastos de estructura. Pulse el valor para ver el desglose."';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowSummaryDetail(Rec.FieldNo("JMC Industry Structure Pct."));
                            end;
                        }
                        field("JMC Catering Production Cost"; Rec."JMC Catering Production Cost")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Shows the actual production cost of final products posted in the period under LINEA = CATERING. It includes cost adjustments available when calculated. It is used to split expenses and is not another expense to add.', Comment = 'ESP="Muestra el coste real de producción de los productos finales registrados en el periodo con LINEA = CATERING. Incluye los ajustes disponibles al calcular. Sirve para repartir los gastos y no es otro gasto que deba sumar."';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowSummaryDetail(Rec.FieldNo("JMC Catering Production Cost"));
                            end;
                        }
                        field("JMC Industry Production Cost"; Rec."JMC Industry Production Cost")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Shows the actual production cost of final products posted in the period under LINEA = ALIMENTACION. It includes cost adjustments available when calculated. It is used to split expenses and is not another expense to add.', Comment = 'ESP="Muestra el coste real de producción de los productos finales registrados en el periodo con LINEA = ALIMENTACION. Incluye los ajustes disponibles al calcular. Sirve para repartir los gastos y no es otro gasto que deba sumar."';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowSummaryDetail(Rec.FieldNo("JMC Industry Production Cost"));
                            end;
                        }
                    }
                    group(Allocation)
                    {
                        Caption = 'Allocation', Comment = 'ESP="Reparto"';

                        field("JMC Catering Allocation"; Rec."JMC Catering Allocation")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Shows the structure expenses assigned to Catering using its production percentage. The calculation distributes this amount among eligible CA, MP and MA products.', Comment = 'ESP="Muestra los gastos de estructura asignados a Catering según su porcentaje de producción. El cálculo reparte este importe entre los productos CA, MP y MA aptos."';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowSummaryDetail(Rec.FieldNo("JMC Catering Allocation"));
                            end;
                        }
                        field("JMC Industry Allocation"; Rec."JMC Industry Allocation")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Shows the structure expenses assigned to Alimentacion after the Catering share. The calculation distributes this amount among eligible PT, PI, PR and SER products.', Comment = 'ESP="Muestra los gastos de estructura asignados a Alimentación tras descontar la parte de Catering. El cálculo reparte este importe entre los productos PT, PI, PR y SER aptos."';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowSummaryDetail(Rec.FieldNo("JMC Industry Allocation"));
                            end;
                        }
                    }
                }
            }
            group(PersonnelCost)
            {
                Caption = 'Fixed Personnel Costs', Comment = 'ESP="Costes de personal fijo"';
                Editable = false;

                field("JMC Fixed Resource Cost"; Rec."JMC Fixed Resource Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows net accounting expenses associated with fixed resources, excluding closing entries and balance sheet accounts. Select the amount to review its sources.', Comment = 'ESP="Muestra los gastos contables netos asociados a recursos fijos, sin movimientos de cierre ni cuentas de balance. Pulse el importe para consultar sus orígenes."';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Fixed Resource Cost"));
                    end;
                }
                field("JMC Industry Resource Pct."; Rec."JMC Industry Resource Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Industry structure percentage used for fixed personnel cost.', Comment = 'ESP="Muestra el porcentaje de estructura de Alimentación utilizado para el coste fijo de personal."';
                }
                field("JMC Catering Resource Pct."; Rec."JMC Catering Resource Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Catering structure percentage used for fixed personnel cost.', Comment = 'ESP="Muestra el porcentaje de estructura de Catering utilizado para el coste fijo de personal."';
                }
                field("JMC Industry Direct Personnel"; Rec."JMC Industry Direct Personnel")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows non-fixed resource costs from all assembly orders. Posted quantities and outstanding order quantities are counted once.', Comment = 'ESP="Muestra los costes de recursos no fijos de todos los pedidos de ensamblado. Las cantidades registradas y las pendientes de los pedidos se cuentan una sola vez."';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Industry Direct Personnel"));
                    end;
                }
                field("JMC Catering Direct Personnel"; Rec."JMC Catering Direct Personnel")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows non-fixed resource costs from eligible event assignments. Event cost is saved quantity times unit cost.', Comment = 'ESP="Muestra los costes de recursos no fijos de asignaciones a eventos válidos. El coste del evento es la cantidad por el coste unitario guardados."';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Catering Direct Personnel"));
                    end;
                }
                field("JMC Industry Resource Allocation"; Rec."JMC Industry Resource Allocation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Industry direct personnel cost plus its share of fixed accounting personnel cost, before allocation to products.', Comment = 'ESP="Muestra el coste directo de personal de Alimentación más su parte del coste fijo contable de personal, antes de repartirlo entre productos."';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Industry Resource Allocation"));
                    end;
                }
                field("JMC Catering Resource Allocation"; Rec."JMC Catering Resource Allocation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Catering direct personnel cost plus its share of fixed accounting personnel cost, before allocation to products.', Comment = 'ESP="Muestra el coste directo de personal de Catering más su parte del coste fijo contable de personal, antes de repartirlo entre productos."';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Catering Resource Allocation"));
                    end;
                }
            }
            group(LastCalculation)
            {
                Caption = 'Last Comparative Calculation', Comment = 'ESP="Último cálculo comparativo"';
                Editable = false;

                field("JMC Calculated At"; Rec."JMC Calculated At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows when Calculate All Costs last completed successfully. Opening the model does not update this date or its results.', Comment = 'ESP="Muestra cuándo terminó correctamente la última ejecución de Calcular todos los costes. Abrir el modelo no actualiza esta fecha ni sus resultados."';
                }
                field("JMC Calculation Current"; Rec."JMC Calculation Current")
                {
                    ApplicationArea = All;
                    ToolTip = 'A check mark means that model inputs have not changed since calculation. It does not detect later changes to entries or recipes. Run Calculate All Costs to refresh the source data.', Comment = 'ESP="La marca indica que no se han cambiado los datos del modelo desde el cálculo. No detecta cambios posteriores en movimientos o recetas. Ejecute Calcular todos los costes para actualizar las fuentes."';
                }
                field("JMC Starting Date"; Rec."JMC Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the first posting date included in the saved calculation. Accounting expenses and sales and production entries are read from this date through the ending date.', Comment = 'ESP="Muestra la primera fecha de registro incluida en el cálculo guardado. Se consultan los gastos contables y los movimientos de venta y producción desde esta fecha hasta la fecha final."';
                }
                field("JMC Ending Date"; Rec."JMC Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the last posting date included in the saved calculation. Change the period in Calculate All Costs to calculate different dates.', Comment = 'ESP="Muestra la última fecha de registro incluida en el cálculo guardado. Para calcular otras fechas debe cambiar el periodo en Calcular todos los costes."';
                }
                field("JMC Account Filter"; Rec."JMC Account Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows which account numbers were considered for expenses. Blank means no account number restriction. Only accounts configured as fixed industrial or management expenses are included. This filter does not restrict sales or production.', Comment = 'ESP="Muestra qué números de cuenta se tuvieron en cuenta para los gastos. Si está vacío no se limita el número de cuenta. Solo se incluyen las cuentas configuradas como gastos fijos industriales o de gestión. Este filtro no limita las ventas ni la producción."';
                }
                field("JMC Fixed Industrial Fund"; Rec."JMC Fixed Industrial Fund")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the net amount of fixed industrial expenses selected from accounting for the period. Credit entries reduce this amount. It is part of total structure cost. Select the amount to see the included entries.', Comment = 'ESP="Muestra el importe neto de los gastos industriales fijos seleccionados de contabilidad para el periodo. Los abonos reducen este importe. Forma parte del gasto de estructura total. Pulse el importe para ver los movimientos incluidos."';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Fixed Industrial Fund"));
                    end;
                }
                field("JMC Variable Industrial Fund"; Rec."JMC Variable Industrial Fund")
                {
                    ApplicationArea = All;
                    ToolTip = 'This hidden field is retained for compatibility with earlier results. New calculations leave it at zero because variable industrial expenses are not allocated.', Comment = 'ESP="Este campo oculto se conserva por compatibilidad con resultados anteriores. Los nuevos cálculos lo dejan a cero porque no se reparten gastos industriales variables."';
                    Visible = false;
                }
                field("JMC Fixed Management Fund"; Rec."JMC Fixed Management Fund")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the net amount of fixed management expenses selected from accounting for the period. Credit entries reduce this amount. It is part of total structure cost. Select the amount to see the included entries.', Comment = 'ESP="Muestra el importe neto de los gastos de gestión fijos seleccionados de contabilidad para el periodo. Los abonos reducen este importe. Forma parte del gasto de estructura total. Pulse el importe para ver los movimientos incluidos."';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Fixed Management Fund"));
                    end;
                }
                field("JMC Variable Management Fund"; Rec."JMC Variable Management Fund")
                {
                    ApplicationArea = All;
                    ToolTip = 'This hidden field is retained for compatibility with earlier results. New calculations leave it at zero because variable management expenses are not allocated.', Comment = 'ESP="Este campo oculto se conserva por compatibilidad con resultados anteriores. Los nuevos cálculos lo dejan a cero porque no se reparten gastos de gestión variables."';
                    Visible = false;
                }
                field("JMC Sales Pending Industrial"; Rec."JMC Sales Pending Industrial")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the industrial expenses that could not be distributed in the calculation against products. This amount is not included in product allocations. Select it to see which business has pending expenses and the lines that could not receive an allocation.', Comment = 'ESP="Muestra los gastos industriales que no se han podido repartir en el cálculo contra productos. Este importe no está incluido en lo asignado a los productos. Púlselo para ver qué negocio tiene gastos pendientes y las líneas que no han podido recibir reparto."';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Sales Pending Industrial"));
                    end;
                }
                field("JMC Sales Pending Management"; Rec."JMC Sales Pending Management")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the management expenses that could not be distributed in the calculation against products. This amount is not included in product allocations. Select it to see which business has pending expenses and the lines that could not receive an allocation.', Comment = 'ESP="Muestra los gastos de gestión que no se han podido repartir en el cálculo contra productos. Este importe no está incluido en lo asignado a los productos. Púlselo para ver qué negocio tiene gastos pendientes y las líneas que no han podido recibir reparto."';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowSummaryDetail(Rec.FieldNo("JMC Sales Pending Management"));
                    end;
                }
            }
            part(SalesLines; "JMC Cost Model Lines")
            {
                Caption = 'Calculation Against Products', Comment = 'ESP="Cálculo contra productos"';
                ApplicationArea = All;
                UpdatePropagation = Both;
                SubPageLink = "JMC Model Code" = field("JMC Code"), "JMC Allocation Method" = const(Sales);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateAllCosts)
            {
                Caption = 'Calculate All Costs', Comment = 'ESP="Calcular todos los costes"';
                ToolTip = 'Calculates accounting costs and the allocation against products for review, replacing model results only. It does not apply costs outside the model.', Comment = 'ESP="Calcula los costes contables y el reparto contra productos para revisión, sustituyendo solo los resultados del modelo. No aplica costes fuera del modelo."';
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                var
                    jmcCalculation: Report "JMC Calculate Model Costs";
                begin
                    CurrPage.SaveRecord();
                    // Finish page edits before opening a modal request page.
                    Commit();
                    jmcCalculation.SetModel(Rec);
                    jmcCalculation.RunModal();
                    Rec.Get(Rec."JMC Code");
                    CurrPage.Update(false);
                end;
            }
            action(ResourceCostDistribution)
            {
                Caption = 'Resource Cost Distribution', Comment = 'ESP="Distribución del coste de personal"';
                ToolTip = 'Shows the structure percentages used automatically to split fixed accounting personnel cost between Industry and Catering.', Comment = 'ESP="Muestra los porcentajes de estructura utilizados automáticamente para repartir el coste fijo contable de personal entre Alimentación y Catering."';
                ApplicationArea = All;
                Image = Setup;

                trigger OnAction()
                var
                    jmcDistributionPage: Page "JMC Resource Cost Distribution";
                begin
                    CurrPage.SaveRecord();
                    Rec.TestField("JMC Personnel Sources Ready");
                    jmcDistributionPage.SetPercentages(Rec."JMC Industry Structure Pct.", Rec."JMC Catering Structure Pct.");
                    jmcDistributionPage.RunModal();
                end;
            }
            action(SimulateStructureCost)
            {
                Caption = 'Simulate Structure Cost', Comment = 'ESP="Simular coste de estructura"';
                ToolTip = 'Simulates a product quantity using the saved calculation against products, without recalculating or changing model costs.', Comment = 'ESP="Simula una cantidad de producto con el cálculo contra productos guardado, sin recalcular ni cambiar los costes del modelo."';
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                var
                    jmcSimulator: Page "JMC Cost Model Simulator";
                begin
                    CurrPage.SaveRecord();
                    Commit();
                    jmcSimulator.SetModel(Rec."JMC Code");
                    jmcSimulator.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            actionref(CalculateAllCostsPromoted; CalculateAllCosts)
            {
            }
            actionref(ResourceCostDistributionPromoted; ResourceCostDistribution)
            {
            }
            actionref(SimulateStructureCostPromoted; SimulateStructureCost)
            {
            }
        }
    }

    local procedure ShowSummaryDetail(jmcFieldNo: Integer)
    var
        jmcDetail: Page "JMC Cost Calculation Detail";
    begin
        CurrPage.SaveRecord();
        Commit();
        jmcDetail.SetSummary(Rec."JMC Code", jmcFieldNo);
        jmcDetail.RunModal();
    end;

    trigger OnOpenPage()
    var
        jmcModelCode: Code[20];
        jmcMultipleModelsErr: Label 'Multiple cost models exist. Resolve them before opening the cost model; no data has been changed.', Comment = 'ESP="Existen varios modelos de costes. Resuélvalos antes de abrir el modelo; no se ha modificado ningún dato."';
    begin
        Rec.Reset();
        Rec.LockTable();
        if Rec.FindFirst() then begin
            jmcModelCode := Rec."JMC Code";
            if Rec.Next() <> 0 then
                Error(jmcMultipleModelsErr);
            Rec.Get(jmcModelCode);
        end else begin
            Rec.Init();
            Rec."JMC Code" := 'GENERAL';
            Rec.Insert(true);
        end;
        Rec.SetRange("JMC Code", Rec."JMC Code");
    end;
}
