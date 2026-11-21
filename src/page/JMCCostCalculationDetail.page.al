page 53128 "JMC Cost Calculation Detail"
{
    Caption = 'Saved Calculation Breakdown', Comment = 'ESP="Desglose guardado del cálculo"';
    PageType = List;
    AnalysisModeEnabled = false;
    SourceTable = "JMC Cost Calculation Detail";
    SourceTableTemporary = true;
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(JMCSummaryExplanation)
            {
                Caption = 'Saved Summary Explanation', Comment = 'ESP="Explicación guardada del resumen"';
                field(JMCMetric; JMCMetricCaption)
                {
                    Caption = 'Explained Summary Value', Comment = 'ESP="Dato del resumen explicado"';
                    ToolTip = 'Identifies the model summary value explained on this page. The header shows how it was obtained and the lines below show its saved detail.', Comment = 'ESP="Indica qué dato del resumen del modelo se explica en esta página. La cabecera muestra cómo se obtuvo y las líneas de abajo permiten consultar su detalle guardado."';
                    ApplicationArea = All;
                }
                field(JMCCalculatedAt; JMCFormula."JMC Calculated At")
                {
                    Caption = 'Calculation Date and Time', Comment = 'ESP="Fecha y hora del cálculo"';
                    ToolTip = 'Shows when the calculation that produced these values was saved. Opening this page does not update them.', Comment = 'ESP="Muestra cuándo se guardó el cálculo que generó estos datos. Abrir esta página no los actualiza."';
                    ApplicationArea = All;
                }
                field(JMCStartingDate; JMCFormula."JMC Starting Date")
                {
                    Caption = 'Period Starting Date', Comment = 'ESP="Fecha inicial del periodo"';
                    ToolTip = 'Shows the first day of the period used to select accounting, production and sales movements. It is not the date when the calculation was run.', Comment = 'ESP="Es el primer día del periodo utilizado para seleccionar movimientos contables, de producción y de ventas. No es la fecha en la que se ejecutó el cálculo."';
                    ApplicationArea = All;
                }
                field(JMCEndingDate; JMCFormula."JMC Ending Date")
                {
                    Caption = 'Period Ending Date', Comment = 'ESP="Fecha final del periodo"';
                    ToolTip = 'Shows the last day of the selected period, including that day. Movements after this date were not used.', Comment = 'ESP="Es el último día del periodo seleccionado, incluido ese día. No se utilizaron movimientos posteriores a esta fecha."';
                    ApplicationArea = All;
                }
                field(JMCAccountFilter; JMCFormula."JMC Account Filter")
                {
                    Caption = 'Applied Account Filter', Comment = 'ESP="Filtro de cuentas aplicado"';
                    ToolTip = 'Shows the account numbers selected when calculating. If blank, no account-number restriction was applied, but only configured fixed industrial and management accounts were included.', Comment = 'ESP="Muestra los números de cuenta seleccionados al calcular. Si está vacío, no se limitó por número de cuenta, pero solo se incluyeron las cuentas fijas industriales y de gestión configuradas."';
                    ApplicationArea = All;
                }
                field(JMCFormulaText; JMCFormulaText)
                {
                    Caption = 'Calculation Formula', Comment = 'ESP="Fórmula de cálculo"';
                    ToolTip = 'Shows how the named values in this header are combined to obtain the result. It explains the saved calculation, not a new calculation using current data.', Comment = 'ESP="Muestra cómo se combinan los datos de esta cabecera para obtener el resultado. Explica el cálculo guardado, no un cálculo nuevo con datos actuales."';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(JMCOperandA; JMCFormula."JMC Operand A")
                {
                    Caption = 'Formula Operand A', Comment = 'ESP="Operando A"';
                    ToolTip = 'Shows the first value used in the formula above. Its name changes with the summary value being explained. This is the value saved when the model was calculated.', Comment = 'ESP="Es el primer dato que se utiliza en la fórmula de arriba. Su nombre cambia según el dato del resumen que esté consultando. Es el valor guardado al calcular el modelo."';
                    CaptionClass = '3,' + JMCOperandACaption;
                    ApplicationArea = All;
                }
                field(JMCOperandB; JMCFormula."JMC Operand B")
                {
                    Caption = 'Formula Operand B', Comment = 'ESP="Operando B"';
                    ToolTip = 'Shows the second value used in the formula above. Its name identifies what it represents. It is hidden when the formula does not need a second value.', Comment = 'ESP="Es el segundo dato que se utiliza en la fórmula de arriba. Su nombre indica qué representa. No se muestra cuando la fórmula no necesita un segundo dato."';
                    CaptionClass = '3,' + JMCOperandBCaption;
                    ApplicationArea = All;
                    Visible = JMCShowOperandB;
                }
                field(JMCRawResult; JMCFormula."JMC Raw Result")
                {
                    Caption = 'Unrounded Result', Comment = 'ESP="Resultado sin redondear"';
                    ToolTip = 'Shows the formula result before rounding or assigning the final remaining amount. Compare it with the saved result to see whether an adjustment was needed.', Comment = 'ESP="Es el resultado de la fórmula antes de redondear o asignar el importe que queda al final del reparto. Compárelo con el resultado guardado para ver si fue necesario un ajuste."';
                    ApplicationArea = All;
                    Visible = JMCNumeric;
                }
                field(JMCDifference; JMCFormula."JMC Rounding Difference")
                {
                    Caption = 'Rounding and Residual Adjustment', Comment = 'ESP="Ajuste de redondeo y residuo"';
                    ToolTip = 'Shows the saved result minus the unrounded result. It explains differences caused by rounding or distributing the final remaining amount; it is not an extra cost.', Comment = 'ESP="Es el resultado guardado menos el resultado sin redondear. Explica las diferencias por redondeo o por repartir el importe que queda al final; no es un coste adicional."';
                    ApplicationArea = All;
                    Visible = JMCNumeric;
                }
                field(JMCResult; JMCFormula."JMC Result")
                {
                    Caption = 'Saved Calculation Result', Comment = 'ESP="Resultado del cálculo guardado"';
                    ToolTip = 'Shows the exact result saved for this summary value. It does not include manual cost changes made after that calculation.', Comment = 'ESP="Muestra el resultado exacto guardado para este dato del resumen. No incluye los cambios manuales de costes realizados después de ese cálculo."';
                    ApplicationArea = All;
                    Visible = JMCNumeric;
                }
                field(JMCGuidance; JMCGuidance)
                {
                    Caption = 'Breakdown Guidance', Comment = 'ESP="Guía del desglose"';
                    ToolTip = 'Explains in everyday language how this result was obtained and what the lines below mean. Read it before adding amounts, because some lines explain different steps of the same calculation.', Comment = 'ESP="Explica con palabras sencillas cómo se obtuvo este resultado y qué significan las líneas de abajo. Léala antes de sumar importes, porque algunas líneas explican distintos pasos del mismo cálculo."';
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            repeater(JMCDetails)
            {
                field("JMC Detail Type"; Rec."JMC Detail Type") { ApplicationArea = All; }
                field("JMC Source Entry No."; Rec."JMC Source Entry No.") { ApplicationArea = All; }
                field("JMC Posting Date"; Rec."JMC Posting Date") { ApplicationArea = All; }
                field("JMC Document No."; Rec."JMC Document No.") { ApplicationArea = All; }
                field("JMC Account No."; Rec."JMC Account No.") { ApplicationArea = All; }
                field("JMC Item No."; Rec."JMC Item No.") { ApplicationArea = All; }
                field("JMC Description"; Rec."JMC Description") { ApplicationArea = All; }
                field("JMC Business"; Rec."JMC Business") { ApplicationArea = All; }
                field("JMC Classification"; Rec."JMC Classification") { ApplicationArea = All; }
                field("JMC Unit Code"; Rec."JMC Unit Code") { ApplicationArea = All; }
                field("JMC Quantity"; Rec."JMC Quantity") { ApplicationArea = All; }
                field("JMC Base Quantity"; Rec."JMC Base Quantity") { ApplicationArea = All; Visible = JMCAllocation; }
                field("JMC Base Recipe Cost"; Rec."JMC Base Recipe Cost") { ApplicationArea = All; Visible = false; }
                field("JMC Priority Level"; Rec."JMC Priority Level") { ApplicationArea = All; Visible = JMCAllocation; }
                field("JMC Priority Factor"; Rec."JMC Priority Factor") { ApplicationArea = All; Visible = JMCAllocation; }
                field("JMC Included"; Rec."JMC Included") { ApplicationArea = All; }
                field("JMC Source Amount"; Rec."JMC Source Amount") { ApplicationArea = All; }
                field("JMC Formula"; Rec."JMC Formula") { ApplicationArea = All; }
                field("JMC Operand A"; Rec."JMC Operand A") { ApplicationArea = All; }
                field("JMC Operand B"; Rec."JMC Operand B") { ApplicationArea = All; }
                field("JMC Operand C"; Rec."JMC Operand C") { ApplicationArea = All; }
                field("JMC Raw Result"; Rec."JMC Raw Result") { ApplicationArea = All; }
                field("JMC Result"; Rec."JMC Result") { ApplicationArea = All; }
                field("JMC Rounding Difference"; Rec."JMC Rounding Difference") { ApplicationArea = All; }
                field("JMC Issue"; Rec."JMC Issue") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(JMCAnalyzeLines)
            {
                Caption = 'Analyze Lines', Comment = 'ESP="Analizar líneas"';
                ToolTip = 'Opens the currently filtered saved lines in a separate list where you can enter analysis mode. No source data is reread and no costs are recalculated.', Comment = 'ESP="Abre las líneas guardadas con los filtros actuales en una lista independiente donde puede entrar en modo de análisis. No se vuelven a leer las fuentes ni se recalculan costes."';
                ApplicationArea = All;
                Image = AnalysisView;

                trigger OnAction()
                var
                    jmcAnalysis: Page "JMC Cost Detail Analysis";
                begin
                    jmcAnalysis.SetLines(Rec, JMCMetricCaption, JMCAllocation);
                    jmcAnalysis.Run();
                end;
            }
        }
        area(Navigation)
        {
            action(JMCOpenSource)
            {
                Caption = 'Open Current Source Movement', Comment = 'ESP="Abrir movimiento de origen actual"';
                ToolTip = 'Opens the current source movement, whose values may differ from this saved breakdown. Formula, group and model-line rows are explained by the saved operands instead.', Comment = 'ESP="Abre el movimiento de origen actual, cuyos valores pueden diferir de este desglose guardado. Las filas de fórmula, grupo y línea del modelo se explican con sus operandos guardados."';
                ApplicationArea = All;
                Image = LedgerEntries;
                Enabled = JMCSourceAvailable;

                trigger OnAction()
                var
                    jmcGLEntry: Record "G/L Entry";
                    jmcItemEntry: Record "Item Ledger Entry";
                begin
                    case Rec."JMC Detail Type" of
                        Rec."JMC Detail Type"::Accounting:
                            begin
                                jmcGLEntry.Get(Rec."JMC Source Entry No.");
                                jmcGLEntry.SetRecFilter();
                                Page.RunModal(Page::"General Ledger Entries", jmcGLEntry);
                            end;
                        Rec."JMC Detail Type"::Production:
                            begin
                                jmcItemEntry.Get(Rec."JMC Source Entry No.");
                                jmcItemEntry.SetRecFilter();
                                Page.RunModal(Page::"Item Ledger Entries", jmcItemEntry);
                            end;
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(JMCAnalyzeLinesPromoted; JMCAnalyzeLines)
            {
            }
            actionref(JMCOpenSourcePromoted; JMCOpenSource)
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        JMCFormula.TestField("JMC Model Code");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        JMCSourceAvailable := Rec."JMC Detail Type" in [Rec."JMC Detail Type"::Accounting, Rec."JMC Detail Type"::Production];
    end;

    procedure SetSummary(jmcModelCode: Code[20]; jmcFieldNo: Integer)
    var
        jmcDetail: Record "JMC Cost Calculation Detail";
        jmcCheck: Record "JMC Cost Calculation Detail";
        jmcModelRef: RecordRef;
        jmcFieldRef: FieldRef;
        jmcChangedErr: Label 'The saved calculation changed while opening its breakdown. Open the detail again.', Comment = 'ESP="El cálculo guardado cambió al abrir su desglose. Abra el detalle de nuevo."';
        jmcMissingErr: Label 'No saved breakdown exists for this result. Calculate the model again to generate its detail; existing results have not been changed.', Comment = 'ESP="Este resultado no tiene desglose guardado. Calcule de nuevo el modelo para generarlo; no se han modificado los resultados existentes."';
    begin
        jmcDetail.SetCurrentKey("JMC Model Code", "JMC Detail Type", "JMC Summary Field No.");
        jmcDetail.SetRange("JMC Model Code", jmcModelCode);
        jmcDetail.SetRange("JMC Detail Type", jmcDetail."JMC Detail Type"::Formula);
        jmcDetail.SetRange("JMC Summary Field No.", jmcFieldNo);
        if not jmcDetail.FindFirst() then
            Error(jmcMissingErr);
        JMCFormula := jmcDetail;
        jmcModelRef.Open(Database::"JMC Cost Model");
        jmcFieldRef := jmcModelRef.Field(jmcFieldNo);
        JMCMetricCaption := jmcFieldRef.Caption;
        jmcModelRef.Close();
        JMCNumeric := jmcFieldNo <> 35;
        JMCAllocation := jmcFieldNo in [13, 14, 29, 30];
        SetExplanation(jmcFieldNo);
        Rec.Reset();
        Rec.DeleteAll(false);
        jmcDetail.Reset();
        jmcDetail.SetRange("JMC Model Code", jmcModelCode);
        jmcDetail.SetRange("JMC Calculated At", JMCFormula."JMC Calculated At");
        if jmcDetail.FindSet() then
            repeat
                if ShowDetail(jmcDetail, jmcFieldNo) then begin
                    Rec := jmcDetail;
                    Rec.Insert(false);
                end;
            until jmcDetail.Next() = 0;
        jmcCheck.SetRange("JMC Model Code", jmcModelCode);
        jmcCheck.SetRange("JMC Detail Type", jmcCheck."JMC Detail Type"::Formula);
        jmcCheck.SetRange("JMC Summary Field No.", jmcFieldNo);
        if not jmcCheck.FindFirst() then
            Error(jmcChangedErr);
        if jmcCheck.SystemId <> JMCFormula.SystemId then
            Error(jmcChangedErr);
    end;

    local procedure SetExplanation(jmcFieldNo: Integer)
    var
        jmcModel: Record "JMC Cost Model";
        jmcUnknownErr: Label 'No explanation is available for summary field %1.', Comment = 'ESP="No hay una explicación disponible para el campo de resumen %1."';
        jmcIndustrialCateringLbl: Label 'Industrial Cost Pending in Catering', Comment = 'ESP="Coste industrial pendiente en Catering"';
        jmcIndustrialIndustryLbl: Label 'Industrial Cost Pending in Industry', Comment = 'ESP="Coste industrial pendiente en Alimentación"';
        jmcManagementCateringLbl: Label 'Management Cost Pending in Catering', Comment = 'ESP="Coste de gestión pendiente en Catering"';
        jmcManagementIndustryLbl: Label 'Management Cost Pending in Industry', Comment = 'ESP="Coste de gestión pendiente en Alimentación"';
        jmcTotalGuideLbl: Label 'Adds the fixed industrial and management funds. The rows below show the G/L entries that make up this total.', Comment = 'ESP="Suma los fondos fijos industrial y de gestión. Las filas de abajo muestran los movimientos contables que forman este total."';
        jmcIndustrialGuideLbl: Label 'Adds the amounts posted to the fixed industrial accounts selected for the period. Negative entries reduce the total. The rows below show those entries.', Comment = 'ESP="Suma los importes de las cuentas industriales fijas seleccionadas para el periodo. Los movimientos negativos restan. Debajo puede consultar esos movimientos."';
        jmcManagementGuideLbl: Label 'Adds the amounts posted to the fixed management accounts selected for the period. Negative entries reduce the total. The rows below show those entries.', Comment = 'ESP="Suma los importes de las cuentas de gestión fijas seleccionadas para el periodo. Los movimientos negativos restan. Debajo puede consultar esos movimientos."';
        jmcProductionGuideLbl: Label 'Adds the actual production cost for this business. The rows below show the production movements. Only rows marked as included contribute to the result.', Comment = 'ESP="Suma el coste real de producción de este negocio. Debajo aparecen los movimientos de producción. Solo suman las filas marcadas como incluidas."';
        jmcCateringPctGuideLbl: Label 'Shows the share of production cost that belongs to Catering: its cost divided by the combined cost of both businesses, multiplied by 100. Only included production rows are counted.', Comment = 'ESP="Indica qué parte del coste de producción corresponde a Catering: divide su coste entre el de ambos negocios y multiplica por 100. Solo cuentan los movimientos de producción incluidos."';
        jmcIndustryPctGuideLbl: Label 'Shows the percentage left for Industry after subtracting the Catering percentage from 100. The two percentages therefore add up to 100. The rows below show the production used to obtain them.', Comment = 'ESP="Muestra el porcentaje que queda para Alimentación al restar a 100 el porcentaje de Catering. Así, ambos porcentajes suman 100. Debajo se muestra la producción utilizada para obtenerlos."';
        jmcCateringFundGuideLbl: Label 'Multiplies the total structure cost by the Catering percentage to obtain the money available for this business.', Comment = 'ESP="Multiplica el gasto total de estructura por el porcentaje de Catering para obtener el dinero que corresponde a este negocio."';
        jmcIndustryFundGuideLbl: Label 'Subtracts the Catering allocation from the total structure cost. Industry receives the remaining amount.', Comment = 'ESP="Resta al gasto total de estructura el importe de Catering. Alimentación recibe el resto."';
        jmcSalesPendingGuideLbl: Label 'Adds the money still unallocated in Catering and Industry in the calculation against products. Below you can see the pending amounts and the reasons some products could not participate. Excluded product rows explain the reasons; do not add them to the pending amounts.', Comment = 'ESP="Suma el dinero que queda sin repartir en Catering y Alimentación en el cálculo contra productos. Debajo se muestran los importes pendientes y los motivos por los que algunos productos no participan. Las filas de productos excluidos explican el motivo; no se suman al pendiente."';
        jmcDimensionGuideLbl: Label 'LINEA identifies the business of each production movement: CATERING or ALIMENTACION. Only included rows count towards the percentages. Movements with no business are not counted; their exclusion reason appears below.', Comment = 'ESP="LINEA identifica el negocio de cada movimiento de producción: CATERING o ALIMENTACION. Solo cuentan para los porcentajes las filas incluidas. Los movimientos sin negocio no cuentan; debajo se indica por qué se han excluido."';
        jmcAllocationGuideLbl: Label 'Business Fund, Unit Group and Allocation rows are steps of the same calculation, not extra amounts. Do not add them together. Allocation rows show what each product receives.', Comment = 'ESP="Las filas Fondo del negocio, Grupo de unidad y Reparto son pasos del mismo cálculo, no importes adicionales. No las sume entre sí. Las filas Reparto muestran lo que recibe cada producto."';
        jmcSnapshotGuideLbl: Label 'These are the values saved at the last calculation. Later changes and manual adjustments are not included. Opening this page does not recalculate anything.', Comment = 'ESP="Son los datos guardados en el último cálculo. No incluyen cambios posteriores ni ajustes manuales. Abrir esta página no vuelve a calcular nada."';
    begin
        Clear(JMCOperandACaption);
        Clear(JMCOperandBCaption);
        case jmcFieldNo of
            jmcModel.FieldNo("JMC Total Structure Cost"):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Fixed Industrial Fund");
                    JMCOperandBCaption := jmcModel.FieldCaption("JMC Fixed Management Fund");
                    JMCGuidance := jmcTotalGuideLbl;
                end;
            jmcModel.FieldNo("JMC Fixed Industrial Fund"):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Fixed Industrial Fund");
                    JMCGuidance := jmcIndustrialGuideLbl;
                end;
            jmcModel.FieldNo("JMC Fixed Management Fund"):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Fixed Management Fund");
                    JMCGuidance := jmcManagementGuideLbl;
                end;
            jmcModel.FieldNo("JMC Catering Production Cost"), jmcModel.FieldNo("JMC Industry Production Cost"):
                begin
                    if jmcFieldNo = jmcModel.FieldNo("JMC Catering Production Cost") then
                        JMCOperandACaption := jmcModel.FieldCaption("JMC Catering Production Cost")
                    else
                        JMCOperandACaption := jmcModel.FieldCaption("JMC Industry Production Cost");
                    JMCGuidance := jmcProductionGuideLbl;
                end;
            jmcModel.FieldNo("JMC Catering Structure Pct."):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Catering Production Cost");
                    JMCOperandBCaption := jmcModel.FieldCaption("JMC Industry Production Cost");
                    JMCGuidance := jmcCateringPctGuideLbl;
                end;
            jmcModel.FieldNo("JMC Industry Structure Pct."):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Catering Structure Pct.");
                    JMCGuidance := jmcIndustryPctGuideLbl;
                end;
            jmcModel.FieldNo("JMC Catering Allocation"):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Total Structure Cost");
                    JMCOperandBCaption := jmcModel.FieldCaption("JMC Catering Structure Pct.");
                    JMCGuidance := jmcCateringFundGuideLbl;
                end;
            jmcModel.FieldNo("JMC Industry Allocation"):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Total Structure Cost");
                    JMCOperandBCaption := jmcModel.FieldCaption("JMC Catering Allocation");
                    JMCGuidance := jmcIndustryFundGuideLbl;
                end;
            jmcModel.FieldNo("JMC Production Dimension"):
                begin
                    JMCOperandACaption := jmcModel.FieldCaption("JMC Catering Production Cost");
                    JMCOperandBCaption := jmcModel.FieldCaption("JMC Industry Production Cost");
                    JMCGuidance := jmcDimensionGuideLbl;
                end;
            jmcModel.FieldNo("JMC Sales Pending Industrial"):
                begin
                    JMCOperandACaption := jmcIndustrialCateringLbl;
                    JMCOperandBCaption := jmcIndustrialIndustryLbl;
                    JMCGuidance := jmcSalesPendingGuideLbl;
                end;
            jmcModel.FieldNo("JMC Sales Pending Management"):
                begin
                    JMCOperandACaption := jmcManagementCateringLbl;
                    JMCOperandBCaption := jmcManagementIndustryLbl;
                    JMCGuidance := jmcSalesPendingGuideLbl;
                end;
            else
                Error(jmcUnknownErr, jmcFieldNo);
        end;
        JMCShowOperandB := JMCOperandBCaption <> '';
        SetFormulaText();
        if jmcFieldNo in [jmcModel.FieldNo("JMC Catering Allocation"), jmcModel.FieldNo("JMC Industry Allocation")] then
            JMCGuidance += ' ' + jmcAllocationGuideLbl;
        JMCGuidance += ' ' + jmcSnapshotGuideLbl;
    end;

    local procedure SetFormulaText()
    var
        jmcSumLbl: Label '%1 + %2', Locked = true;
        jmcDifferenceLbl: Label '%1 - %2', Locked = true;
        jmcShareLbl: Label '%1 / (%1 + %2) * 100', Locked = true;
        jmcRemainingPctLbl: Label '100 - %1', Locked = true;
        jmcPercentageLbl: Label '%1 * %2 / 100', Locked = true;
        jmcDimensionLbl: Label 'Production grouped by LINEA: CATERING or ALIMENTACION', Comment = 'ESP="Producción agrupada por LINEA: CATERING o ALIMENTACION"';
    begin
        case JMCFormula."JMC Formula" of
            'A':
                JMCFormulaText := JMCOperandACaption;
            'A + B':
                JMCFormulaText := StrSubstNo(jmcSumLbl, JMCOperandACaption, JMCOperandBCaption);
            'A - B':
                JMCFormulaText := StrSubstNo(jmcDifferenceLbl, JMCOperandACaption, JMCOperandBCaption);
            'A / (A + B) * 100':
                JMCFormulaText := StrSubstNo(jmcShareLbl, JMCOperandACaption, JMCOperandBCaption);
            '100 - A':
                JMCFormulaText := StrSubstNo(jmcRemainingPctLbl, JMCOperandACaption);
            'A * B / 100':
                JMCFormulaText := StrSubstNo(jmcPercentageLbl, JMCOperandACaption, JMCOperandBCaption);
            'LINEA: CATERING | ALIMENTACION':
                JMCFormulaText := jmcDimensionLbl;
            else
                JMCFormulaText := JMCFormula."JMC Formula";
        end;
    end;

    local procedure ShowDetail(jmcDetail: Record "JMC Cost Calculation Detail"; jmcFieldNo: Integer): Boolean
    var
        jmcCategory: Enum "JMC Cost Classification";
    begin
        // Rows saved by the retired recipe calculation are not part of the current explanation.
        if (jmcDetail."JMC Detail Type" in [jmcDetail."JMC Detail Type"::Allocation, jmcDetail."JMC Detail Type"::"Unit Group", jmcDetail."JMC Detail Type"::Pending]) and
           (jmcDetail."JMC Method" <> jmcDetail."JMC Method"::Sales)
        then
            exit(false);
        case jmcFieldNo of
            10:
                exit(jmcDetail."JMC Detail Type" = jmcDetail."JMC Detail Type"::Accounting);
            25, 27:
                begin
                    if jmcFieldNo = 25 then
                        jmcCategory := jmcCategory::"Industrial Manufacturing Cost"
                    else
                        jmcCategory := jmcCategory::"Full Management Cost";
                    exit((jmcDetail."JMC Detail Type" = jmcDetail."JMC Detail Type"::Accounting) and (jmcDetail."JMC Classification" = jmcCategory));
                end;
            11, 12, 35:
                exit(jmcDetail."JMC Detail Type" = jmcDetail."JMC Detail Type"::Production);
            33:
                exit((jmcDetail."JMC Detail Type" = jmcDetail."JMC Detail Type"::Production) and (jmcDetail."JMC Business" = 'CATERING'));
            34:
                exit((jmcDetail."JMC Detail Type" = jmcDetail."JMC Detail Type"::Production) and (jmcDetail."JMC Business" = 'ALIMENTACION'));
            13, 14:
                exit((jmcDetail."JMC Detail Type" in [jmcDetail."JMC Detail Type"::Allocation, jmcDetail."JMC Detail Type"::"Unit Group", jmcDetail."JMC Detail Type"::"Business Fund", jmcDetail."JMC Detail Type"::Pending]) and
                     (((jmcFieldNo = 13) and (jmcDetail."JMC Business" = 'CATERING')) or ((jmcFieldNo = 14) and (jmcDetail."JMC Business" = 'ALIMENTACION'))));
            29, 30:
                begin
                    if jmcFieldNo = 29 then
                        jmcCategory := jmcCategory::"Industrial Manufacturing Cost"
                    else
                        jmcCategory := jmcCategory::"Full Management Cost";
                    exit((jmcDetail."JMC Classification" = jmcCategory) and
                         ((jmcDetail."JMC Detail Type" = jmcDetail."JMC Detail Type"::Pending) or
                          ((jmcDetail."JMC Detail Type" = jmcDetail."JMC Detail Type"::Allocation) and not jmcDetail."JMC Included")));
                end;
        end;
        exit(false);
    end;

    var
        JMCFormula: Record "JMC Cost Calculation Detail";
        JMCMetricCaption: Text;
        JMCOperandACaption: Text;
        JMCOperandBCaption: Text;
        JMCFormulaText: Text;
        JMCGuidance: Text;
        JMCNumeric: Boolean;
        JMCShowOperandB: Boolean;
        JMCAllocation: Boolean;
        JMCSourceAvailable: Boolean;
}
