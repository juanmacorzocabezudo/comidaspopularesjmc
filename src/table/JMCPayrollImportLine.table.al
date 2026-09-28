table 53155 "JMC Payroll Import Line"
{
    Caption = 'Payroll Import Line', Comment = 'ESP="Línea importación nóminas"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Import No."; Integer)
        {
            Caption = 'Import No.', Comment = 'ESP="Nº importación"';
            ToolTip = 'Specifies the payroll import the line belongs to.', Comment = 'ESP="Especifica la importación de nóminas a la que pertenece la línea."';
            TableRelation = "JMC Payroll Import Header"."JMC No.";
            Editable = false;
        }
        field(2; "JMC Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
            ToolTip = 'Specifies the line number.', Comment = 'ESP="Especifica el número de línea."';
            Editable = false;
        }
        field(3; "JMC Excel Row No."; Integer)
        {
            Caption = 'Excel Row No.', Comment = 'ESP="Nº fila Excel"';
            ToolTip = 'Specifies the row of the Excel file the payroll was read from.', Comment = 'ESP="Especifica la fila del Excel de la que se leyó la nómina."';
            Editable = false;
        }
        field(4; "JMC Gestoría ID"; Code[20])
        {
            Caption = 'Gestoría ID', Comment = 'ESP="ID Gestoría"';
            ToolTip = 'Specifies the employee code of the payroll provider. It is used to find the resource by its Gestoría ID.', Comment = 'ESP="Especifica el código de trabajador de la asesoría. Se usa para buscar el recurso por su ID Gestoría."';

            trigger OnValidate()
            var
                jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                jmcResourceNo: Code[20];
            begin
                if jmcPayrollImportMgt.FindResource("JMC Gestoría ID", jmcResourceNo) = 1 then
                    Validate("JMC Resource No.", jmcResourceNo)
                else
                    Validate("JMC Resource No.", '');
            end;
        }
        field(5; "JMC Worker Name"; Text[100])
        {
            Caption = 'Worker Name (Excel)', Comment = 'ESP="Trabajador (Excel)"';
            ToolTip = 'Specifies the employee name as it appears in the Excel file.', Comment = 'ESP="Especifica el nombre del trabajador tal como aparece en el Excel."';
        }
        field(6; "JMC VAT Registration No."; Code[20])
        {
            Caption = 'NIF', Comment = 'ESP="NIF"';
            ToolTip = 'Specifies the tax ID of the employee.', Comment = 'ESP="Especifica el NIF del trabajador."';
        }
        field(7; "JMC Pay Type"; Code[20])
        {
            Caption = 'Pay Type', Comment = 'ESP="Tipo paga"';
            ToolTip = 'Specifies the pay type of the Excel file, such as MENSUAL, ATRASOS or FINIQUITO.', Comment = 'ESP="Especifica el tipo de paga del Excel, como MENSUAL, ATRASOS o FINIQUITO."';
        }
        field(8; "JMC Posting Date"; Date)
        {
            Caption = 'Payment Date', Comment = 'ESP="Fecha cobro"';
            ToolTip = 'Specifies the payment date. It is used as the posting date of the entry.', Comment = 'ESP="Especifica la fecha de cobro. Se usa como fecha de registro del asiento."';
        }
        field(9; "JMC Resource No."; Code[20])
        {
            Caption = 'Resource No.', Comment = 'ESP="Nº recurso"';
            ToolTip = 'Specifies the resource related to the payroll.', Comment = 'ESP="Especifica el recurso relacionado con la nómina."';
            TableRelation = Resource."No.";

            trigger OnValidate()
            var
                jmcResource: Record Resource;
                jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
            begin
                "JMC Resource Name" := '';
                if "JMC Resource No." <> '' then
                    if jmcResource.Get("JMC Resource No.") then
                        "JMC Resource Name" := jmcResource.Name;
                "JMC Description" := jmcPayrollImportMgt.GetPayrollDescription(Rec);
            end;
        }
        field(10; "JMC Resource Name"; Text[100])
        {
            Caption = 'Resource Name', Comment = 'ESP="Nombre recurso"';
            ToolTip = 'Specifies the name of the resource.', Comment = 'ESP="Especifica el nombre del recurso."';
            Editable = false;
        }
        field(11; "JMC Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            ToolTip = 'Specifies the description of the payroll entry.', Comment = 'ESP="Especifica la descripción del asiento de la nómina."';
        }
        field(20; "JMC Gross"; Decimal)
        {
            Caption = 'Gross (C.BRUTO)', Comment = 'ESP="Bruto (C.BRUTO)"';
            ToolTip = 'Specifies the C.BRUTO amount of the Excel file.', Comment = 'ESP="Especifica el importe C.BRUTO del Excel."';
            AutoFormatType = 1;
        }
        field(21; "JMC Company SS"; Decimal)
        {
            Caption = 'Company SS (SS.EMPRESA)', Comment = 'ESP="SS empresa (SS.EMPRESA)"';
            ToolTip = 'Specifies the SS.EMPRESA amount of the Excel file.', Comment = 'ESP="Especifica el importe SS.EMPRESA del Excel."';
            AutoFormatType = 1;
        }
        field(22; "JMC Total Cost"; Decimal)
        {
            Caption = 'Total Cost (C.TOTAL)', Comment = 'ESP="Coste total (C.TOTAL)"';
            ToolTip = 'Specifies the C.TOTAL amount of the Excel file.', Comment = 'ESP="Especifica el importe C.TOTAL del Excel."';
            AutoFormatType = 1;
        }
        field(23; "JMC TC1"; Decimal)
        {
            Caption = 'TC1', Comment = 'ESP="TC1"';
            ToolTip = 'Specifies the TC1 amount of the Excel file.', Comment = 'ESP="Especifica el importe TC1 del Excel."';
            AutoFormatType = 1;
        }
        field(24; "JMC Bonus"; Decimal)
        {
            Caption = 'Bonus (PRIMAS)', Comment = 'ESP="Primas (PRIMAS)"';
            ToolTip = 'Specifies the PRIMAS amount of the Excel file.', Comment = 'ESP="Especifica el importe PRIMAS del Excel."';
            AutoFormatType = 1;
        }
        field(25; "JMC Employee SS"; Decimal)
        {
            Caption = 'Employee SS (SS.TRAB.)', Comment = 'ESP="SS trabajador (SS.TRAB.)"';
            ToolTip = 'Specifies the SS.TRAB. amount of the Excel file.', Comment = 'ESP="Especifica el importe SS.TRAB. del Excel."';
            AutoFormatType = 1;
        }
        field(26; "JMC IRPF"; Decimal)
        {
            Caption = 'IRPF', Comment = 'ESP="IRPF"';
            ToolTip = 'Specifies the IRPF amount of the Excel file.', Comment = 'ESP="Especifica el importe IRPF del Excel."';
            AutoFormatType = 1;
        }
        field(27; "JMC Retention"; Decimal)
        {
            Caption = 'Retention (RETENCION)', Comment = 'ESP="Retención (RETENCION)"';
            ToolTip = 'Specifies the RETENCION amount of the Excel file.', Comment = 'ESP="Especifica el importe RETENCION del Excel."';
            AutoFormatType = 1;
        }
        field(28; "JMC Net Pay"; Decimal)
        {
            Caption = 'Net Pay (LIQUIDO)', Comment = 'ESP="Líquido (LIQUIDO)"';
            ToolTip = 'Specifies the LIQUIDO amount of the Excel file.', Comment = 'ESP="Especifica el importe LIQUIDO del Excel."';
            AutoFormatType = 1;
        }
        field(29; "JMC SS Base"; Decimal)
        {
            Caption = 'SS Base (BASE S.SOC)', Comment = 'ESP="Base SS (BASE S.SOC)"';
            ToolTip = 'Specifies the BASE S.SOC amount of the Excel file.', Comment = 'ESP="Especifica el importe BASE S.SOC del Excel."';
            AutoFormatType = 1;
        }
        field(30; "JMC IRPF Base"; Decimal)
        {
            Caption = 'IRPF Base (BASE IRPF)', Comment = 'ESP="Base IRPF (BASE IRPF)"';
            ToolTip = 'Specifies the BASE IRPF amount of the Excel file.', Comment = 'ESP="Especifica el importe BASE IRPF del Excel."';
            AutoFormatType = 1;
        }
        field(31; "JMC Discounts"; Decimal)
        {
            Caption = 'Discounts (DESCUENTOS)', Comment = 'ESP="Descuentos (DESCUENTOS)"';
            ToolTip = 'Specifies the DESCUENTOS amount of the Excel file.', Comment = 'ESP="Especifica el importe DESCUENTOS del Excel."';
            AutoFormatType = 1;
        }
        field(32; "JMC Payment in Kind"; Decimal)
        {
            Caption = 'Payment in Kind (RTOS ESPEC)', Comment = 'ESP="Retrib. especie (RTOS ESPEC)"';
            ToolTip = 'Specifies the RTOS ESPEC amount of the Excel file.', Comment = 'ESP="Especifica el importe RTOS ESPEC del Excel."';
            AutoFormatType = 1;
        }
        field(33; "JMC Advances"; Decimal)
        {
            Caption = 'Advances (ANTICIPOS)', Comment = 'ESP="Anticipos (ANTICIPOS)"';
            ToolTip = 'Specifies the ANTICIPOS amount of the Excel file.', Comment = 'ESP="Especifica el importe ANTICIPOS del Excel."';
            AutoFormatType = 1;
        }
        field(34; "JMC Medical Insurance"; Decimal)
        {
            Caption = 'Medical Insurance (seguro med)', Comment = 'ESP="Seguro médico (seguro med)"';
            ToolTip = 'Specifies the seguro med amount of the Excel file.', Comment = 'ESP="Especifica el importe seguro med del Excel."';
            AutoFormatType = 1;
        }
        field(35; "JMC Medical Insurance IRPF"; Decimal)
        {
            Caption = 'Medical Insurance IRPF (s.med irpf)', Comment = 'ESP="Seguro médico IRPF (s.med irpf)"';
            ToolTip = 'Specifies the s.med irpf amount of the Excel file.', Comment = 'ESP="Especifica el importe s.med irpf del Excel."';
            AutoFormatType = 1;
        }
        field(36; "JMC Payment in Kind Deduction"; Decimal)
        {
            Caption = 'Payment in Kind Deduction (deduc rtos)', Comment = 'ESP="Deducción retrib. especie (deduc rtos)"';
            ToolTip = 'Specifies the deduc rtos amount of the Excel file.', Comment = 'ESP="Especifica el importe deduc rtos del Excel."';
            AutoFormatType = 1;
        }
        field(37; "JMC Extra Pay"; Decimal)
        {
            Caption = 'Extra Pay (PP EXTRA)', Comment = 'ESP="Paga extra (PP EXTRA)"';
            ToolTip = 'Specifies the PP EXTRA amount of the Excel file.', Comment = 'ESP="Especifica el importe PP EXTRA del Excel."';
            AutoFormatType = 1;
        }
        field(38; "JMC Self-Employed SS"; Decimal)
        {
            Caption = 'Self-Employed SS (SS AUTONOM)', Comment = 'ESP="SS autónomos (SS AUTONOM)"';
            ToolTip = 'Specifies the SS AUTONOM amount of the Excel file.', Comment = 'ESP="Especifica el importe SS AUTONOM del Excel."';
            AutoFormatType = 1;
        }
        field(50; "JMC Validation Status"; Enum "JMC Payroll Validation Status")
        {
            Caption = 'Validation Status', Comment = 'ESP="Estado validación"';
            ToolTip = 'Specifies the result of the last validation. Any change sets the line back to Pending.', Comment = 'ESP="Especifica el resultado de la última validación. Cualquier cambio vuelve a dejar la línea en Pendiente."';
            Editable = false;
        }
        field(51; "JMC Validation Message"; Text[250])
        {
            Caption = 'Validation Message', Comment = 'ESP="Mensaje validación"';
            ToolTip = 'Specifies the errors and warnings found in the last validation.', Comment = 'ESP="Especifica los errores y avisos encontrados en la última validación."';
            Editable = false;
        }
        field(52; "JMC Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
            ToolTip = 'Specifies the document number created in the general journal.', Comment = 'ESP="Especifica el nº de documento creado en el diario general."';
            Editable = false;
        }
        field(53; "JMC Total Debit"; Decimal)
        {
            Caption = 'Total Debit', Comment = 'ESP="Total debe"';
            ToolTip = 'Specifies the debit total of the proposed entry.', Comment = 'ESP="Especifica el total debe de la propuesta de asiento."';
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = sum("JMC Payroll Import Entry"."JMC Debit Amount" where("JMC Import No." = field("JMC Import No."), "JMC Import Line No." = field("JMC Line No.")));
            Editable = false;
        }
        field(54; "JMC Total Credit"; Decimal)
        {
            Caption = 'Total Credit', Comment = 'ESP="Total haber"';
            ToolTip = 'Specifies the credit total of the proposed entry.', Comment = 'ESP="Especifica el total haber de la propuesta de asiento."';
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = sum("JMC Payroll Import Entry"."JMC Credit Amount" where("JMC Import No." = field("JMC Import No."), "JMC Import Line No." = field("JMC Line No.")));
            Editable = false;
        }
        field(55; "JMC Entry Balance"; Decimal)
        {
            Caption = 'Difference', Comment = 'ESP="Descuadre"';
            ToolTip = 'Specifies the difference between debit and credit of the proposed entry.', Comment = 'ESP="Especifica la diferencia entre el debe y el haber de la propuesta de asiento."';
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = sum("JMC Payroll Import Entry"."JMC Amount" where("JMC Import No." = field("JMC Import No."), "JMC Import Line No." = field("JMC Line No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "JMC Import No.", "JMC Line No.")
        {
            Clustered = true;
        }
        key(Duplicate; "JMC VAT Registration No.", "JMC Posting Date")
        {
        }
    }

    trigger OnInsert()
    begin
        TestHeaderEditable();
    end;

    trigger OnModify()
    begin
        TestHeaderEditable();
        SetPendingValidation();
    end;

    trigger OnDelete()
    var
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
    begin
        TestHeaderEditable();
        jmcPayrollEntry.SetRange("JMC Import No.", "JMC Import No.");
        jmcPayrollEntry.SetRange("JMC Import Line No.", "JMC Line No.");
        jmcPayrollEntry.DeleteAll(false);
        SetHeaderPendingValidation();
    end;

    procedure GetColumnAmount(jmcExcelColumn: Enum "JMC Payroll Excel Column"): Decimal
    begin
        case jmcExcelColumn of
            jmcExcelColumn::Gross:
                exit("JMC Gross");
            jmcExcelColumn::"Company SS":
                exit("JMC Company SS");
            jmcExcelColumn::"Total Cost":
                exit("JMC Total Cost");
            jmcExcelColumn::TC1:
                exit("JMC TC1");
            jmcExcelColumn::Bonus:
                exit("JMC Bonus");
            jmcExcelColumn::"Employee SS":
                exit("JMC Employee SS");
            jmcExcelColumn::IRPF:
                exit("JMC IRPF");
            jmcExcelColumn::Retention:
                exit("JMC Retention");
            jmcExcelColumn::"Net Pay":
                exit("JMC Net Pay");
            jmcExcelColumn::"SS Base":
                exit("JMC SS Base");
            jmcExcelColumn::"IRPF Base":
                exit("JMC IRPF Base");
            jmcExcelColumn::Discounts:
                exit("JMC Discounts");
            jmcExcelColumn::"Payment in Kind":
                exit("JMC Payment in Kind");
            jmcExcelColumn::Advances:
                exit("JMC Advances");
            jmcExcelColumn::"Medical Insurance":
                exit("JMC Medical Insurance");
            jmcExcelColumn::"Medical Insurance IRPF":
                exit("JMC Medical Insurance IRPF");
            jmcExcelColumn::"Payment in Kind Deduction":
                exit("JMC Payment in Kind Deduction");
            jmcExcelColumn::"Extra Pay":
                exit("JMC Extra Pay");
            jmcExcelColumn::"Self-Employed SS":
                exit("JMC Self-Employed SS");
        end;
        exit(0);
    end;

    procedure SetColumnAmount(jmcExcelColumn: Enum "JMC Payroll Excel Column"; jmcAmount: Decimal)
    begin
        case jmcExcelColumn of
            jmcExcelColumn::Gross:
                "JMC Gross" := jmcAmount;
            jmcExcelColumn::"Company SS":
                "JMC Company SS" := jmcAmount;
            jmcExcelColumn::"Total Cost":
                "JMC Total Cost" := jmcAmount;
            jmcExcelColumn::TC1:
                "JMC TC1" := jmcAmount;
            jmcExcelColumn::Bonus:
                "JMC Bonus" := jmcAmount;
            jmcExcelColumn::"Employee SS":
                "JMC Employee SS" := jmcAmount;
            jmcExcelColumn::IRPF:
                "JMC IRPF" := jmcAmount;
            jmcExcelColumn::Retention:
                "JMC Retention" := jmcAmount;
            jmcExcelColumn::"Net Pay":
                "JMC Net Pay" := jmcAmount;
            jmcExcelColumn::"SS Base":
                "JMC SS Base" := jmcAmount;
            jmcExcelColumn::"IRPF Base":
                "JMC IRPF Base" := jmcAmount;
            jmcExcelColumn::Discounts:
                "JMC Discounts" := jmcAmount;
            jmcExcelColumn::"Payment in Kind":
                "JMC Payment in Kind" := jmcAmount;
            jmcExcelColumn::Advances:
                "JMC Advances" := jmcAmount;
            jmcExcelColumn::"Medical Insurance":
                "JMC Medical Insurance" := jmcAmount;
            jmcExcelColumn::"Medical Insurance IRPF":
                "JMC Medical Insurance IRPF" := jmcAmount;
            jmcExcelColumn::"Payment in Kind Deduction":
                "JMC Payment in Kind Deduction" := jmcAmount;
            jmcExcelColumn::"Extra Pay":
                "JMC Extra Pay" := jmcAmount;
            jmcExcelColumn::"Self-Employed SS":
                "JMC Self-Employed SS" := jmcAmount;
        end;
    end;

    procedure TestHeaderEditable()
    var
        jmcPayrollHeader: Record "JMC Payroll Import Header";
    begin
        if jmcPayrollHeader.Get("JMC Import No.") then
            jmcPayrollHeader.TestEditable();
    end;

    procedure SetPendingValidation()
    begin
        "JMC Validation Status" := "JMC Validation Status"::Pending;
        SetHeaderPendingValidation();
    end;

    local procedure SetHeaderPendingValidation()
    var
        jmcPayrollHeader: Record "JMC Payroll Import Header";
    begin
        if jmcPayrollHeader.Get("JMC Import No.") then
            jmcPayrollHeader.SetPendingValidation();
    end;
}
