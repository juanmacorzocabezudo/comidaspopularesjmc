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
                        }
                        field("JMC Catering Structure Pct."; Rec."JMC Catering Structure Pct.")
                        {
                            ApplicationArea = All;
                        }
                        field("JMC Industry Structure Pct."; Rec."JMC Industry Structure Pct.")
                        {
                            ApplicationArea = All;
                        }
                        field("JMC Catering Production Cost"; Rec."JMC Catering Production Cost")
                        {
                            ApplicationArea = All;
                        }
                        field("JMC Industry Production Cost"; Rec."JMC Industry Production Cost")
                        {
                            ApplicationArea = All;
                        }
                        field("JMC Production Dimension"; Rec."JMC Production Dimension")
                        {
                            ApplicationArea = All;
                        }
                    }
                    group(Allocation)
                    {
                        Caption = 'Allocation', Comment = 'ESP="Reparto"';

                        field("JMC Catering Allocation"; Rec."JMC Catering Allocation")
                        {
                            ApplicationArea = All;
                        }
                        field("JMC Industry Allocation"; Rec."JMC Industry Allocation")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group(LastCalculation)
            {
                Caption = 'Last Comparative Calculation', Comment = 'ESP="Último cálculo comparativo"';
                Editable = false;

                field("JMC Calculated At"; Rec."JMC Calculated At")
                {
                    ApplicationArea = All;
                }
                field("JMC Calculation Current"; Rec."JMC Calculation Current")
                {
                    ApplicationArea = All;
                }
                field("JMC Starting Date"; Rec."JMC Starting Date")
                {
                    ApplicationArea = All;
                }
                field("JMC Ending Date"; Rec."JMC Ending Date")
                {
                    ApplicationArea = All;
                }
                field("JMC Account Filter"; Rec."JMC Account Filter")
                {
                    ApplicationArea = All;
                }
                field("JMC Fixed Industrial Fund"; Rec."JMC Fixed Industrial Fund")
                {
                    ApplicationArea = All;
                }
                field("JMC Variable Industrial Fund"; Rec."JMC Variable Industrial Fund")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("JMC Fixed Management Fund"; Rec."JMC Fixed Management Fund")
                {
                    ApplicationArea = All;
                }
                field("JMC Variable Management Fund"; Rec."JMC Variable Management Fund")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("JMC Sales Pending Industrial"; Rec."JMC Sales Pending Industrial")
                {
                    ApplicationArea = All;
                }
                field("JMC Sales Pending Management"; Rec."JMC Sales Pending Management")
                {
                    ApplicationArea = All;
                }
                field("JMC Recipe Pending Industrial"; Rec."JMC Recipe Pending Industrial")
                {
                    ApplicationArea = All;
                }
                field("JMC Recipe Pending Management"; Rec."JMC Recipe Pending Management")
                {
                    ApplicationArea = All;
                }
            }
            part(SalesLines; "JMC Cost Model Lines")
            {
                Caption = 'Against Sales', Comment = 'ESP="Contra ventas"';
                ApplicationArea = All;
                UpdatePropagation = Both;
                SubPageLink = "JMC Model Code" = field("JMC Code"), "JMC Allocation Method" = const(Sales);
            }
            part(RecipeLines; "JMC Cost Model Lines")
            {
                Caption = 'Against Recipe', Comment = 'ESP="Contra receta"';
                ApplicationArea = All;
                UpdatePropagation = Both;
                SubPageLink = "JMC Model Code" = field("JMC Code"), "JMC Allocation Method" = const(Recipe);
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
                ToolTip = 'Calculates accounting funds and both product allocations for review, replacing model results only. It does not apply costs outside the model.', Comment = 'ESP="Calcula los fondos contables y ambos repartos por producto para revisión, sustituyendo solo los resultados del modelo. No aplica costes fuera del modelo."';
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
            action(PriorityFactors)
            {
                Caption = 'Priority Factors', Comment = 'ESP="Factores de prioridad"';
                ToolTip = 'Defines the approved decreasing factors for priorities 1 to 5. No factor values are assumed.', Comment = 'ESP="Define los factores decrecientes aprobados para las prioridades del 1 al 5. No se presupone ningún valor."';
                ApplicationArea = All;
                Image = Setup;
                RunObject = page "JMC Cost Priority Factors";
            }
            action(SimulateStructureCost)
            {
                Caption = 'Simulate Structure Cost', Comment = 'ESP="Simular coste de estructura"';
                ToolTip = 'Simulates a product quantity using both saved allocation methods, without recalculating or changing model costs.', Comment = 'ESP="Simula una cantidad de producto con ambos métodos de reparto guardados, sin recalcular ni cambiar los costes del modelo."';
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
            actionref(PriorityFactorsPromoted; PriorityFactors)
            {
            }
            actionref(SimulateStructureCostPromoted; SimulateStructureCost)
            {
            }
        }
    }

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
