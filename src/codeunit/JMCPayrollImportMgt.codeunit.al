codeunit 53150 "JMC Payroll Import Mgt."
{
    var
        JMCWorkerHeaderTok: Label 'TRABAJADOR', Locked = true;
        JMCNIFHeaderTok: Label 'N.I.F.', Locked = true;
        JMCPayTypeHeaderTok: Label 'TIPO PAGA', Locked = true;
        JMCDateHeaderTok: Label 'FECHA COBRO', Locked = true;
        JMCTotalRowTok: Label 'TOTAL EMPRESA', Locked = true;
        JMCSelectFileTxt: Label 'Select the payroll Excel file', Comment = 'ESP="Seleccione el Excel de nóminas"';
        JMCExcelFilterTxt: Label 'Excel files (*.xlsx)|*.xlsx', Comment = 'ESP="Ficheros Excel (*.xlsx)|*.xlsx"';
        JMCReplaceLinesQst: Label 'Payroll import %1 already has lines. Do you want to delete them and import the Excel file again?', Comment = 'ESP="La importación de nóminas %1 ya tiene líneas. ¿Desea borrarlas y volver a importar el Excel?"';
        JMCHeaderNotFoundErr: Label 'The header row with the columns TRABAJADOR and FECHA COBRO was not found in the Excel file.', Comment = 'ESP="No se ha encontrado en el Excel la fila de cabecera con las columnas TRABAJADOR y FECHA COBRO."';
        JMCMissingColumnErr: Label 'The column %1 was not found in the Excel file.', Comment = 'ESP="No se ha encontrado la columna %1 en el Excel."';
        JMCNoCodeColumnErr: Label 'The employee code column must be the column before TRABAJADOR.', Comment = 'ESP="La columna del código de trabajador debe ser la anterior a TRABAJADOR."';
        JMCInvalidAmountErr: Label 'The value %1 in row %2, column %3 is not a valid amount.', Comment = 'ESP="El valor %1 de la fila %2, columna %3 no es un importe válido."';
        JMCLinesImportedMsg: Label '%1 payroll lines have been imported.', Comment = 'ESP="Se han importado %1 nóminas."';
        JMCPayrollDescriptionTxt: Label 'Payroll %1 %2 - %3', Comment = 'ESP="Nómina %1 %2 - %3"';
        JMCNoLinesErr: Label 'There are no payroll lines to validate.', Comment = 'ESP="No hay nóminas para validar."';
        JMCValidationResultMsg: Label 'Validation completed.\\Payrolls: %1\Errors: %2\Warnings: %3', Comment = 'ESP="Validación finalizada.\\Nóminas: %1\Errores: %2\Avisos: %3"';
        JMCTotalsMismatchMsg: Label 'The totals of the payrolls do not match the TOTAL EMPRESA row of the Excel file.', Comment = 'ESP="Los totales de las nóminas no coinciden con la fila TOTAL EMPRESA del Excel."';
        JMCResourceNotFoundErr: Label 'No resource has Gestoría ID %1.', Comment = 'ESP="Ningún recurso tiene el ID Gestoría %1."';
        JMCResourceMultipleErr: Label 'Several resources have Gestoría ID %1.', Comment = 'ESP="Varios recursos tienen el ID Gestoría %1."';
        JMCResourceNotExistErr: Label 'Resource %1 does not exist.', Comment = 'ESP="El recurso %1 no existe."';
        JMCNoDateErr: Label 'The payment date is empty.', Comment = 'ESP="La fecha de cobro está vacía."';
        JMCDateNotAllowedErr: Label 'The date %1 is not within the allowed posting period.', Comment = 'ESP="La fecha %1 no está dentro del periodo de registro permitido."';
        JMCColumnNotMappedErr: Label 'Column %1 has an amount but is not mapped to a concept.', Comment = 'ESP="La columna %1 tiene importe pero no tiene concepto asignado en el mapeo."';
        JMCColumnSplitWarn: Label 'The entry lines of column %1 do not add up to the Excel amount.', Comment = 'ESP="Las líneas de asiento de la columna %1 no suman el importe del Excel."';
        JMCNoEntriesErr: Label 'The payroll has no entry lines.', Comment = 'ESP="La nómina no tiene líneas de asiento."';
        JMCEntryWithoutAccountErr: Label 'There are entry lines without a G/L account.', Comment = 'ESP="Hay líneas de asiento sin cuenta contable."';
        JMCGarnishmentWithoutAuthorityErr: Label 'There are garnishment lines without an authority.', Comment = 'ESP="Hay líneas de embargo sin organismo."';
        JMCInvalidAccountErr: Label 'G/L account %1 does not exist, is blocked, is not a posting account or does not allow direct posting.', Comment = 'ESP="La cuenta %1 no existe, está bloqueada, no es auxiliar o no permite registro directo."';
        JMCUnbalancedErr: Label 'The entry is not balanced. Difference: %1.', Comment = 'ESP="El asiento no cuadra. Descuadre: %1."';
        JMCDuplicateErr: Label 'The payroll is duplicated in this import or in an import already sent to the journal.', Comment = 'ESP="La nómina está duplicada en esta importación o en otra ya pasada al diario."';
        JMCTotalCostWarn: Label 'C.TOTAL does not match C.BRUTO + SS.EMPRESA.', Comment = 'ESP="C.TOTAL no coincide con C.BRUTO + SS.EMPRESA."';
        JMCTC1Warn: Label 'TC1 does not match SS.EMPRESA + SS.TRAB.', Comment = 'ESP="TC1 no coincide con SS.EMPRESA + SS.TRAB."';
        JMCValidateFirstErr: Label 'Validate the payroll import before creating the journal.', Comment = 'ESP="Valide la importación de nóminas antes de crear el diario."';
        JMCHasErrorsErr: Label 'The journal cannot be created because there are %1 payrolls with errors.', Comment = 'ESP="No se puede crear el diario porque hay %1 nóminas con errores."';
        JMCWarningsQst: Label 'There are %1 payrolls with warnings. Do you want to create the journal anyway?', Comment = 'ESP="Hay %1 nóminas con avisos. ¿Desea crear el diario igualmente?"';
        JMCTotalsMismatchQst: Label 'The totals of the payrolls do not match the TOTAL EMPRESA row of the Excel file. Do you want to create the journal anyway?', Comment = 'ESP="Los totales de las nóminas no coinciden con la fila TOTAL EMPRESA del Excel. ¿Desea crear el diario igualmente?"';
        JMCCreateJournalQst: Label 'Do you want to create %1 payroll entries in journal %2, batch %3?', Comment = 'ESP="¿Desea crear %1 asientos de nómina en el libro %2, sección %3?"';
        JMCBatchNotEmptyErr: Label 'Journal batch %2 of template %1 must be empty before creating the payroll entries.', Comment = 'ESP="La sección %2 del libro %1 debe estar vacía antes de crear los asientos de nómina."';
        JMCJournalCreatedMsg: Label '%1 payroll entries have been created in journal %2, batch %3.', Comment = 'ESP="Se han creado %1 asientos de nómina en el libro %2, sección %3."';
        JMCNoJournalErr: Label 'The journal has not been created yet for this payroll import.', Comment = 'ESP="Todavía no se ha creado el diario para esta importación de nóminas."';
        JMCMarkProcessedQst: Label 'Do you want to mark payroll import %1 as processed?', Comment = 'ESP="¿Desea marcar como procesada la importación de nóminas %1?"';
        JMCRegenerateQst: Label 'The proposed entry of the payroll will be created again from the Excel amounts and the manual changes will be lost. Do you want to continue?', Comment = 'ESP="La propuesta de asiento de la nómina se volverá a crear desde los importes del Excel y se perderán los cambios manuales. ¿Desea continuar?"';
        JMCNoSpaceErr: Label 'There is no room to insert a new line after this line. Move the line or renumber the entry lines.', Comment = 'ESP="No hay hueco para insertar una línea después de esta. Mueva la línea o renumere las líneas del asiento."';
        JMCIssueSeparatorTok: Label '; ', Locked = true;

    procedure CreateAndImport(var jmcPayrollHeader: Record "JMC Payroll Import Header"): Boolean
    begin
        jmcPayrollHeader.Init();
        jmcPayrollHeader.Insert(true);
        Commit();
        ImportExcel(jmcPayrollHeader);
        jmcPayrollHeader.Get(jmcPayrollHeader."JMC No.");
        if HasLines(jmcPayrollHeader) then
            exit(true);
        jmcPayrollHeader.Delete(true);
        exit(false);
    end;

    procedure ImportExcel(var jmcPayrollHeader: Record "JMC Payroll Import Header")
    var
        jmcTempExcelBuffer: Record "Excel Buffer" temporary;
        jmcInStream: InStream;
        jmcFileName: Text;
        jmcSheetName: Text;
        jmcLinesRead: Integer;
    begin
        jmcPayrollHeader.Get(jmcPayrollHeader."JMC No.");
        jmcPayrollHeader.TestEditable();
        if HasLines(jmcPayrollHeader) then
            if not Confirm(JMCReplaceLinesQst, false, jmcPayrollHeader."JMC No.") then
                exit;
        if not UploadIntoStream(JMCSelectFileTxt, '', JMCExcelFilterTxt, jmcFileName, jmcInStream) then
            exit;
        jmcSheetName := jmcTempExcelBuffer.SelectSheetsNameStream(jmcInStream);
        if jmcSheetName = '' then
            exit;
        jmcTempExcelBuffer.OpenBookStream(jmcInStream, jmcSheetName);
        jmcTempExcelBuffer.ReadSheet();

        DeleteLines(jmcPayrollHeader);
        jmcPayrollHeader."JMC Excel Total Gross" := 0;
        jmcPayrollHeader."JMC Excel Total Company SS" := 0;
        jmcPayrollHeader."JMC Excel Total Net Pay" := 0;
        jmcLinesRead := ReadPayrollLines(jmcPayrollHeader, jmcTempExcelBuffer);

        jmcPayrollHeader."JMC File Name" := CopyStr(jmcFileName, 1, MaxStrLen(jmcPayrollHeader."JMC File Name"));
        if jmcPayrollHeader."JMC Description" = '' then
            jmcPayrollHeader."JMC Description" := CopyStr(jmcFileName, 1, MaxStrLen(jmcPayrollHeader."JMC Description"));
        jmcPayrollHeader."JMC Import DateTime" := CurrentDateTime();
        jmcPayrollHeader."JMC Imported By" := CopyStr(UserId(), 1, MaxStrLen(jmcPayrollHeader."JMC Imported By"));
        jmcPayrollHeader."JMC Status" := jmcPayrollHeader."JMC Status"::Pending;
        jmcPayrollHeader."JMC Totals Mismatch" := false;
        UpdateDateRange(jmcPayrollHeader);
        jmcPayrollHeader.Modify(true);
        Message(JMCLinesImportedMsg, jmcLinesRead);
    end;

    procedure ValidateImport(var jmcPayrollHeader: Record "JMC Payroll Import Header")
    var
        jmcSetup: Record "JMC Payroll Import Setup";
        jmcPayrollLine: Record "JMC Payroll Import Line";
        jmcErrors: Integer;
        jmcWarnings: Integer;
    begin
        jmcPayrollHeader.Get(jmcPayrollHeader."JMC No.");
        jmcPayrollHeader.TestEditable();
        jmcSetup.GetSetup();
        jmcSetup.TestField("JMC Journal Template Name");
        jmcSetup.TestField("JMC Journal Batch Name");
        InitializeDefaults();

        jmcPayrollLine.SetRange("JMC Import No.", jmcPayrollHeader."JMC No.");
        if not jmcPayrollLine.FindSet(true) then
            Error(JMCNoLinesErr);
        repeat
            if not EntriesExist(jmcPayrollLine) then
                GenerateEntries(jmcPayrollLine);
            ValidateLine(jmcPayrollLine, jmcSetup);
            jmcPayrollLine.Modify(false);
            case jmcPayrollLine."JMC Validation Status" of
                jmcPayrollLine."JMC Validation Status"::Error:
                    jmcErrors += 1;
                jmcPayrollLine."JMC Validation Status"::Warning:
                    jmcWarnings += 1;
            end;
        until jmcPayrollLine.Next() = 0;

        jmcPayrollHeader.Get(jmcPayrollHeader."JMC No.");
        UpdateDateRange(jmcPayrollHeader);
        CheckTotals(jmcPayrollHeader, jmcSetup."JMC Balance Tolerance");
        if jmcErrors = 0 then
            jmcPayrollHeader."JMC Status" := jmcPayrollHeader."JMC Status"::Validated
        else
            jmcPayrollHeader."JMC Status" := jmcPayrollHeader."JMC Status"::Pending;
        jmcPayrollHeader.Modify(true);

        jmcPayrollHeader.CalcFields("JMC No. of Lines");
        Message(JMCValidationResultMsg, jmcPayrollHeader."JMC No. of Lines", jmcErrors, jmcWarnings);
        if jmcPayrollHeader."JMC Totals Mismatch" then
            Message(JMCTotalsMismatchMsg);
    end;

    procedure CreateJournal(var jmcPayrollHeader: Record "JMC Payroll Import Header")
    var
        jmcSetup: Record "JMC Payroll Import Setup";
        jmcGenJnlTemplate: Record "Gen. Journal Template";
        jmcGenJnlBatch: Record "Gen. Journal Batch";
        jmcGenJnlLine: Record "Gen. Journal Line";
        jmcPayrollLine: Record "JMC Payroll Import Line";
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
        jmcNoSeriesBatch: Codeunit "No. Series - Batch";
        jmcNoSeries: Codeunit "No. Series";
        jmcDocumentNo: Code[20];
        jmcJnlLineNo: Integer;
        jmcDocuments: Integer;
    begin
        jmcPayrollHeader.Get(jmcPayrollHeader."JMC No.");
        jmcPayrollHeader.TestEditable();
        jmcPayrollHeader.CalcFields("JMC No. of Lines", "JMC No. of Errors", "JMC No. of Warnings", "JMC No. of Pending");
        if (jmcPayrollHeader."JMC Status" <> jmcPayrollHeader."JMC Status"::Validated) or (jmcPayrollHeader."JMC No. of Pending" <> 0) then
            Error(JMCValidateFirstErr);
        if jmcPayrollHeader."JMC No. of Errors" <> 0 then
            Error(JMCHasErrorsErr, jmcPayrollHeader."JMC No. of Errors");

        jmcSetup.GetSetup();
        jmcSetup.TestField("JMC Journal Template Name");
        jmcSetup.TestField("JMC Journal Batch Name");
        jmcGenJnlTemplate.Get(jmcSetup."JMC Journal Template Name");
        jmcGenJnlBatch.Get(jmcSetup."JMC Journal Template Name", jmcSetup."JMC Journal Batch Name");
        if jmcGenJnlBatch."No. Series" = '' then
            jmcSetup.TestField("JMC Document No. Series");
        jmcGenJnlLine.SetRange("Journal Template Name", jmcGenJnlBatch."Journal Template Name");
        jmcGenJnlLine.SetRange("Journal Batch Name", jmcGenJnlBatch.Name);
        if not jmcGenJnlLine.IsEmpty() then
            Error(JMCBatchNotEmptyErr, jmcGenJnlBatch."Journal Template Name", jmcGenJnlBatch.Name);

        if jmcPayrollHeader."JMC No. of Warnings" <> 0 then
            if not Confirm(JMCWarningsQst, false, jmcPayrollHeader."JMC No. of Warnings") then
                exit;
        if jmcPayrollHeader."JMC Totals Mismatch" then
            if not Confirm(JMCTotalsMismatchQst, false) then
                exit;
        if not Confirm(JMCCreateJournalQst, true, jmcPayrollHeader."JMC No. of Lines", jmcGenJnlBatch."Journal Template Name", jmcGenJnlBatch.Name) then
            exit;

        jmcPayrollLine.SetRange("JMC Import No.", jmcPayrollHeader."JMC No.");
        if jmcPayrollLine.FindSet(true) then
            repeat
                // The batch series is only peeked here; the posting routine consumes it.
                if jmcGenJnlBatch."No. Series" <> '' then
                    jmcDocumentNo := jmcNoSeriesBatch.GetNextNo(jmcGenJnlBatch."No. Series", jmcPayrollLine."JMC Posting Date")
                else
                    jmcDocumentNo := jmcNoSeries.GetNextNo(jmcSetup."JMC Document No. Series", jmcPayrollLine."JMC Posting Date");

                jmcPayrollEntry.SetRange("JMC Import No.", jmcPayrollLine."JMC Import No.");
                jmcPayrollEntry.SetRange("JMC Import Line No.", jmcPayrollLine."JMC Line No.");
                if jmcPayrollEntry.FindSet() then
                    repeat
                        jmcJnlLineNo += 10000;
                        InsertJournalLine(jmcGenJnlTemplate, jmcGenJnlBatch, jmcPayrollEntry, jmcPayrollLine."JMC Posting Date", jmcDocumentNo, jmcJnlLineNo);
                    until jmcPayrollEntry.Next() = 0;

                jmcPayrollLine."JMC Document No." := jmcDocumentNo;
                jmcPayrollLine.Modify(false);
                if jmcDocuments = 0 then
                    jmcPayrollHeader."JMC First Document No." := jmcDocumentNo;
                jmcPayrollHeader."JMC Last Document No." := jmcDocumentNo;
                jmcDocuments += 1;
            until jmcPayrollLine.Next() = 0;

        jmcPayrollHeader."JMC Journal Template Name" := jmcGenJnlBatch."Journal Template Name";
        jmcPayrollHeader."JMC Journal Batch Name" := jmcGenJnlBatch.Name;
        jmcPayrollHeader."JMC Status" := jmcPayrollHeader."JMC Status"::"Journal Created";
        jmcPayrollHeader.Modify(true);
        Message(JMCJournalCreatedMsg, jmcDocuments, jmcGenJnlBatch."Journal Template Name", jmcGenJnlBatch.Name);
    end;

    procedure OpenJournal(jmcPayrollHeader: Record "JMC Payroll Import Header")
    var
        jmcGenJnlBatch: Record "Gen. Journal Batch";
        jmcGenJnlManagement: Codeunit GenJnlManagement;
    begin
        if (jmcPayrollHeader."JMC Journal Template Name" = '') or (jmcPayrollHeader."JMC Journal Batch Name" = '') then
            Error(JMCNoJournalErr);
        jmcGenJnlBatch.Get(jmcPayrollHeader."JMC Journal Template Name", jmcPayrollHeader."JMC Journal Batch Name");
        jmcGenJnlManagement.TemplateSelectionFromBatch(jmcGenJnlBatch);
    end;

    procedure MarkProcessed(var jmcPayrollHeader: Record "JMC Payroll Import Header")
    begin
        jmcPayrollHeader.Get(jmcPayrollHeader."JMC No.");
        jmcPayrollHeader.TestField("JMC Status", jmcPayrollHeader."JMC Status"::"Journal Created");
        if not Confirm(JMCMarkProcessedQst, false, jmcPayrollHeader."JMC No.") then
            exit;
        jmcPayrollHeader."JMC Status" := jmcPayrollHeader."JMC Status"::Processed;
        jmcPayrollHeader.Modify(true);
    end;

    procedure RegenerateEntries(var jmcPayrollLine: Record "JMC Payroll Import Line")
    begin
        jmcPayrollLine.Get(jmcPayrollLine."JMC Import No.", jmcPayrollLine."JMC Line No.");
        jmcPayrollLine.TestHeaderEditable();
        if not Confirm(JMCRegenerateQst, false) then
            exit;
        InitializeDefaults();
        GenerateEntries(jmcPayrollLine);
        jmcPayrollLine.SetPendingValidation();
        jmcPayrollLine.Modify(false);
    end;

    procedure SplitEntry(var jmcPayrollEntry: Record "JMC Payroll Import Entry")
    var
        jmcNextEntry: Record "JMC Payroll Import Entry";
        jmcNewEntry: Record "JMC Payroll Import Entry";
        jmcNewLineNo: Integer;
        jmcHalfAmount: Decimal;
    begin
        jmcNextEntry.SetRange("JMC Import No.", jmcPayrollEntry."JMC Import No.");
        jmcNextEntry.SetRange("JMC Import Line No.", jmcPayrollEntry."JMC Import Line No.");
        jmcNextEntry.SetFilter("JMC Line No.", '>%1', jmcPayrollEntry."JMC Line No.");
        if jmcNextEntry.FindFirst() then
            jmcNewLineNo := jmcPayrollEntry."JMC Line No." + (jmcNextEntry."JMC Line No." - jmcPayrollEntry."JMC Line No.") div 2
        else
            jmcNewLineNo := jmcPayrollEntry."JMC Line No." + 10000;
        if jmcNewLineNo = jmcPayrollEntry."JMC Line No." then
            Error(JMCNoSpaceErr);

        jmcHalfAmount := Round(jmcPayrollEntry."JMC Amount" / 2);
        jmcNewEntry := jmcPayrollEntry;
        jmcNewEntry."JMC Line No." := jmcNewLineNo;
        jmcNewEntry."JMC Balancing" := false;
        jmcNewEntry.Validate("JMC Amount", jmcHalfAmount);
        jmcNewEntry.Insert(true);

        jmcPayrollEntry.Validate("JMC Amount", jmcPayrollEntry."JMC Amount" - jmcHalfAmount);
        jmcPayrollEntry.Modify(true);
    end;

    procedure FindResource(jmcGestoriaID: Code[20]; var jmcResourceNo: Code[20]): Integer
    var
        jmcResource: Record Resource;
        jmcCount: Integer;
    begin
        jmcResourceNo := '';
        if jmcGestoriaID = '' then
            exit(0);
        jmcResource.SetLoadFields("No.");
        jmcResource.SetRange("JMC Gestoría ID", jmcGestoriaID);
        jmcCount := jmcResource.Count();
        if jmcCount = 1 then begin
            jmcResource.FindFirst();
            jmcResourceNo := jmcResource."No.";
        end;
        exit(jmcCount);
    end;

    procedure GetPayrollDescription(jmcPayrollLine: Record "JMC Payroll Import Line"): Text[100]
    var
        jmcName: Text;
    begin
        jmcName := jmcPayrollLine."JMC Resource Name";
        if jmcName = '' then
            jmcName := jmcPayrollLine."JMC Worker Name";
        exit(CopyStr(StrSubstNo(JMCPayrollDescriptionTxt, jmcPayrollLine."JMC Pay Type", Format(jmcPayrollLine."JMC Posting Date", 0, '<Month,2>/<Year4>'), jmcName), 1, 100));
    end;

    procedure InitializeDefaults()
    var
        jmcConceptSetup: Record "JMC Payroll Concept Setup";
        jmcGarnishmentAccount: Record "JMC Garnishment Account Setup";
        jmcColumnMapping: Record "JMC Payroll Column Mapping";
        jmcOrdinal: Integer;
    begin
        foreach jmcOrdinal in Enum::"JMC Payroll Concept Type".Ordinals() do
            if jmcOrdinal <> 0 then
                if not jmcConceptSetup.Get(Enum::"JMC Payroll Concept Type".FromInteger(jmcOrdinal)) then begin
                    jmcConceptSetup.Init();
                    jmcConceptSetup."JMC Concept Type" := Enum::"JMC Payroll Concept Type".FromInteger(jmcOrdinal);
                    jmcConceptSetup.Insert();
                end;

        foreach jmcOrdinal in Enum::"JMC Garnishment Authority".Ordinals() do
            if jmcOrdinal <> 0 then
                if not jmcGarnishmentAccount.Get(Enum::"JMC Garnishment Authority".FromInteger(jmcOrdinal)) then begin
                    jmcGarnishmentAccount.Init();
                    jmcGarnishmentAccount."JMC Authority" := Enum::"JMC Garnishment Authority".FromInteger(jmcOrdinal);
                    jmcGarnishmentAccount.Insert();
                end;

        foreach jmcOrdinal in Enum::"JMC Payroll Excel Column".Ordinals() do
            if jmcOrdinal <> 0 then
                if not jmcColumnMapping.Get(Enum::"JMC Payroll Excel Column".FromInteger(jmcOrdinal)) then begin
                    jmcColumnMapping.Init();
                    jmcColumnMapping."JMC Excel Column" := Enum::"JMC Payroll Excel Column".FromInteger(jmcOrdinal);
                    SetDefaultMapping(jmcColumnMapping);
                    jmcColumnMapping.Insert();
                end;
    end;

    local procedure SetDefaultMapping(var jmcColumnMapping: Record "JMC Payroll Column Mapping")
    begin
        case jmcColumnMapping."JMC Excel Column" of
            jmcColumnMapping."JMC Excel Column"::Gross:
                jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::Salary;
            jmcColumnMapping."JMC Excel Column"::"Company SS":
                jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::"Company SS";
            jmcColumnMapping."JMC Excel Column"::TC1:
                begin
                    jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::"SS Payable";
                    jmcColumnMapping."JMC Posting Sign" := jmcColumnMapping."JMC Posting Sign"::Reverse;
                end;
            jmcColumnMapping."JMC Excel Column"::IRPF:
                jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::"IRPF Payable";
            jmcColumnMapping."JMC Excel Column"::Retention,
            jmcColumnMapping."JMC Excel Column"::Discounts:
                jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::"Other Deduction";
            jmcColumnMapping."JMC Excel Column"::"Net Pay":
                begin
                    jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::"Net Pay";
                    jmcColumnMapping."JMC Posting Sign" := jmcColumnMapping."JMC Posting Sign"::Reverse;
                end;
            jmcColumnMapping."JMC Excel Column"::Advances:
                jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::Advance;
            jmcColumnMapping."JMC Excel Column"::"Extra Pay":
                begin
                    jmcColumnMapping."JMC Concept Type" := jmcColumnMapping."JMC Concept Type"::"Extra Pay Accrual";
                    jmcColumnMapping."JMC Balancing Concept Type" := jmcColumnMapping."JMC Balancing Concept Type"::"Extra Pay Provision";
                end;
            // Already included in other columns (C.TOTAL, TC1) or bases only.
            jmcColumnMapping."JMC Excel Column"::"Total Cost",
            jmcColumnMapping."JMC Excel Column"::"Employee SS",
            jmcColumnMapping."JMC Excel Column"::"SS Base",
            jmcColumnMapping."JMC Excel Column"::"IRPF Base":
                jmcColumnMapping."JMC Informative" := true;
        end;
    end;

    local procedure ReadPayrollLines(var jmcPayrollHeader: Record "JMC Payroll Import Header"; var jmcTempExcelBuffer: Record "Excel Buffer" temporary): Integer
    var
        jmcPayrollLine: Record "JMC Payroll Import Line";
        jmcColumns: Dictionary of [Text, Integer];
        jmcExcelColumn: Enum "JMC Payroll Excel Column";
        jmcOrdinal: Integer;
        jmcHeaderRow: Integer;
        jmcLastRow: Integer;
        jmcRow: Integer;
        jmcColumnNo: Integer;
        jmcCodeColumn: Integer;
        jmcWorkerColumn: Integer;
        jmcNIFColumn: Integer;
        jmcPayTypeColumn: Integer;
        jmcDateColumn: Integer;
        jmcLineNo: Integer;
        jmcCount: Integer;
        jmcPostingDate: Date;
        jmcGestoriaID: Text;
        jmcWorkerName: Text;
        jmcResourceNo: Code[20];
    begin
        jmcHeaderRow := FindHeaderRow(jmcTempExcelBuffer);
        if jmcHeaderRow = 0 then
            Error(JMCHeaderNotFoundErr);
        ReadHeaderColumns(jmcTempExcelBuffer, jmcHeaderRow, jmcColumns);
        jmcWorkerColumn := GetRequiredColumn(jmcColumns, JMCWorkerHeaderTok);
        jmcNIFColumn := GetRequiredColumn(jmcColumns, JMCNIFHeaderTok);
        jmcPayTypeColumn := GetRequiredColumn(jmcColumns, JMCPayTypeHeaderTok);
        jmcDateColumn := GetRequiredColumn(jmcColumns, JMCDateHeaderTok);
        jmcCodeColumn := jmcWorkerColumn - 1;
        if jmcCodeColumn < 1 then
            Error(JMCNoCodeColumnErr);

        jmcTempExcelBuffer.Reset();
        if not jmcTempExcelBuffer.FindLast() then
            exit(0);
        jmcLastRow := jmcTempExcelBuffer."Row No.";

        for jmcRow := jmcHeaderRow + 1 to jmcLastRow do
            if UpperCase(GetCellText(jmcTempExcelBuffer, jmcRow, 1)) = JMCTotalRowTok then
                ReadTotals(jmcPayrollHeader, jmcTempExcelBuffer, jmcRow, jmcColumns)
            else begin
                jmcGestoriaID := GetCellText(jmcTempExcelBuffer, jmcRow, jmcCodeColumn);
                jmcWorkerName := GetCellText(jmcTempExcelBuffer, jmcRow, jmcWorkerColumn);
                if (jmcGestoriaID <> '') and (jmcWorkerName <> '') and TryParseDate(GetCellText(jmcTempExcelBuffer, jmcRow, jmcDateColumn), jmcPostingDate) then begin
                    jmcLineNo += 10000;
                    jmcPayrollLine.Init();
                    jmcPayrollLine."JMC Import No." := jmcPayrollHeader."JMC No.";
                    jmcPayrollLine."JMC Line No." := jmcLineNo;
                    jmcPayrollLine."JMC Excel Row No." := jmcRow;
                    jmcPayrollLine."JMC Gestoría ID" := CopyStr(jmcGestoriaID, 1, MaxStrLen(jmcPayrollLine."JMC Gestoría ID"));
                    jmcPayrollLine."JMC Worker Name" := CopyStr(jmcWorkerName, 1, MaxStrLen(jmcPayrollLine."JMC Worker Name"));
                    jmcPayrollLine."JMC VAT Registration No." := CopyStr(GetCellText(jmcTempExcelBuffer, jmcRow, jmcNIFColumn), 1, MaxStrLen(jmcPayrollLine."JMC VAT Registration No."));
                    jmcPayrollLine."JMC Pay Type" := CopyStr(UpperCase(GetCellText(jmcTempExcelBuffer, jmcRow, jmcPayTypeColumn)), 1, MaxStrLen(jmcPayrollLine."JMC Pay Type"));
                    jmcPayrollLine."JMC Posting Date" := jmcPostingDate;
                    foreach jmcOrdinal in Enum::"JMC Payroll Excel Column".Ordinals() do begin
                        jmcExcelColumn := Enum::"JMC Payroll Excel Column".FromInteger(jmcOrdinal);
                        if jmcColumns.Get(UpperCase(GetExcelHeader(jmcExcelColumn)), jmcColumnNo) then
                            jmcPayrollLine.SetColumnAmount(jmcExcelColumn, ParseAmount(GetCellText(jmcTempExcelBuffer, jmcRow, jmcColumnNo), jmcRow, GetExcelHeader(jmcExcelColumn)));
                    end;
                    if FindResource(jmcPayrollLine."JMC Gestoría ID", jmcResourceNo) = 1 then
                        jmcPayrollLine.Validate("JMC Resource No.", jmcResourceNo)
                    else
                        jmcPayrollLine."JMC Description" := GetPayrollDescription(jmcPayrollLine);
                    jmcPayrollLine.Insert(true);
                    jmcCount += 1;
                end;
            end;
        exit(jmcCount);
    end;

    local procedure FindHeaderRow(var jmcTempExcelBuffer: Record "Excel Buffer" temporary): Integer
    var
        jmcCandidateRows: List of [Integer];
        jmcRow: Integer;
        jmcColumnNo: Integer;
    begin
        jmcTempExcelBuffer.Reset();
        if jmcTempExcelBuffer.FindSet() then
            repeat
                if UpperCase(DelChr(jmcTempExcelBuffer."Cell Value as Text", '<>', ' ')) = JMCWorkerHeaderTok then
                    jmcCandidateRows.Add(jmcTempExcelBuffer."Row No.");
            until jmcTempExcelBuffer.Next() = 0;

        foreach jmcRow in jmcCandidateRows do begin
            jmcTempExcelBuffer.Reset();
            jmcTempExcelBuffer.SetRange("Row No.", jmcRow);
            if jmcTempExcelBuffer.FindSet() then
                repeat
                    if UpperCase(DelChr(jmcTempExcelBuffer."Cell Value as Text", '<>', ' ')) = JMCDateHeaderTok then
                        jmcColumnNo := jmcTempExcelBuffer."Column No.";
                until (jmcTempExcelBuffer.Next() = 0) or (jmcColumnNo <> 0);
            if jmcColumnNo <> 0 then begin
                jmcTempExcelBuffer.Reset();
                exit(jmcRow);
            end;
        end;
        jmcTempExcelBuffer.Reset();
        exit(0);
    end;

    local procedure ReadHeaderColumns(var jmcTempExcelBuffer: Record "Excel Buffer" temporary; jmcHeaderRow: Integer; var jmcColumns: Dictionary of [Text, Integer])
    var
        jmcHeaderText: Text;
    begin
        jmcTempExcelBuffer.Reset();
        jmcTempExcelBuffer.SetRange("Row No.", jmcHeaderRow);
        if jmcTempExcelBuffer.FindSet() then
            repeat
                jmcHeaderText := UpperCase(DelChr(jmcTempExcelBuffer."Cell Value as Text", '<>', ' '));
                if (jmcHeaderText <> '') and not jmcColumns.ContainsKey(jmcHeaderText) then
                    jmcColumns.Add(jmcHeaderText, jmcTempExcelBuffer."Column No.");
            until jmcTempExcelBuffer.Next() = 0;
        jmcTempExcelBuffer.Reset();
    end;

    local procedure GetRequiredColumn(var jmcColumns: Dictionary of [Text, Integer]; jmcHeaderText: Text): Integer
    var
        jmcColumnNo: Integer;
    begin
        if not jmcColumns.Get(UpperCase(jmcHeaderText), jmcColumnNo) then
            Error(JMCMissingColumnErr, jmcHeaderText);
        exit(jmcColumnNo);
    end;

    local procedure ReadTotals(var jmcPayrollHeader: Record "JMC Payroll Import Header"; var jmcTempExcelBuffer: Record "Excel Buffer" temporary; jmcRow: Integer; var jmcColumns: Dictionary of [Text, Integer])
    begin
        jmcPayrollHeader."JMC Excel Total Gross" := GetTotal(jmcTempExcelBuffer, jmcRow, jmcColumns, Enum::"JMC Payroll Excel Column"::Gross);
        jmcPayrollHeader."JMC Excel Total Company SS" := GetTotal(jmcTempExcelBuffer, jmcRow, jmcColumns, Enum::"JMC Payroll Excel Column"::"Company SS");
        jmcPayrollHeader."JMC Excel Total Net Pay" := GetTotal(jmcTempExcelBuffer, jmcRow, jmcColumns, Enum::"JMC Payroll Excel Column"::"Net Pay");
    end;

    local procedure GetTotal(var jmcTempExcelBuffer: Record "Excel Buffer" temporary; jmcRow: Integer; var jmcColumns: Dictionary of [Text, Integer]; jmcExcelColumn: Enum "JMC Payroll Excel Column"): Decimal
    var
        jmcColumnNo: Integer;
    begin
        if not jmcColumns.Get(UpperCase(GetExcelHeader(jmcExcelColumn)), jmcColumnNo) then
            exit(0);
        exit(ParseAmount(GetCellText(jmcTempExcelBuffer, jmcRow, jmcColumnNo), jmcRow, GetExcelHeader(jmcExcelColumn)));
    end;

    local procedure GetCellText(var jmcTempExcelBuffer: Record "Excel Buffer" temporary; jmcRow: Integer; jmcColumn: Integer): Text
    begin
        if jmcTempExcelBuffer.Get(jmcRow, jmcColumn) then
            exit(DelChr(jmcTempExcelBuffer."Cell Value as Text", '<>', ' '));
        exit('');
    end;

    local procedure ParseAmount(jmcText: Text; jmcRow: Integer; jmcHeaderText: Text): Decimal
    var
        jmcAmount: Decimal;
    begin
        if jmcText = '' then
            exit(0);
        if Evaluate(jmcAmount, jmcText) then
            exit(Round(jmcAmount));
        if Evaluate(jmcAmount, jmcText, 9) then
            exit(Round(jmcAmount));
        Error(JMCInvalidAmountErr, jmcText, jmcRow, jmcHeaderText);
    end;

    local procedure TryParseDate(jmcText: Text; var jmcDate: Date): Boolean
    var
        jmcSerial: Decimal;
    begin
        jmcDate := 0D;
        if jmcText = '' then
            exit(false);
        if StrPos(jmcText, '/') > 0 then begin
            if TryParseDayMonthYear(jmcText, jmcDate) then
                exit(jmcDate <> 0D);
            if Evaluate(jmcDate, jmcText) then
                exit(jmcDate <> 0D);
            exit(false);
        end;
        // Excel serial date (days since 30/12/1899).
        if Evaluate(jmcSerial, jmcText) then
            if (jmcSerial >= 1) and (jmcSerial < 2958466) then begin
                jmcDate := DMY2Date(30, 12, 1899) + Round(jmcSerial, 1, '<');
                exit(true);
            end;
        if Evaluate(jmcDate, jmcText) then
            exit(jmcDate <> 0D);
        exit(false);
    end;

    [TryFunction]
    local procedure TryParseDayMonthYear(jmcText: Text; var jmcDate: Date)
    var
        jmcParts: List of [Text];
        jmcDay: Integer;
        jmcMonth: Integer;
        jmcYear: Integer;
    begin
        jmcParts := jmcText.Split('/');
        if jmcParts.Count() <> 3 then
            Error('');
        Evaluate(jmcDay, jmcParts.Get(1));
        Evaluate(jmcMonth, jmcParts.Get(2));
        Evaluate(jmcYear, jmcParts.Get(3).Split(' ').Get(1));
        if jmcYear < 100 then
            jmcYear += 2000;
        jmcDate := DMY2Date(jmcDay, jmcMonth, jmcYear);
    end;

    local procedure GetExcelHeader(jmcExcelColumn: Enum "JMC Payroll Excel Column"): Text
    begin
        case jmcExcelColumn of
            jmcExcelColumn::Gross:
                exit('C.BRUTO');
            jmcExcelColumn::"Company SS":
                exit('SS.EMPRESA');
            jmcExcelColumn::"Total Cost":
                exit('C.TOTAL');
            jmcExcelColumn::TC1:
                exit('TC1');
            jmcExcelColumn::Bonus:
                exit('PRIMAS');
            jmcExcelColumn::"Employee SS":
                exit('SS.TRAB.');
            jmcExcelColumn::IRPF:
                exit('IRPF');
            jmcExcelColumn::Retention:
                exit('RETENCION');
            jmcExcelColumn::"Net Pay":
                exit('LIQUIDO');
            jmcExcelColumn::"SS Base":
                exit('BASE S.SOC');
            jmcExcelColumn::"IRPF Base":
                exit('BASE IRPF');
            jmcExcelColumn::Discounts:
                exit('DESCUENTOS');
            jmcExcelColumn::"Payment in Kind":
                exit('RTOS ESPEC');
            jmcExcelColumn::Advances:
                exit('ANTICIPOS');
            jmcExcelColumn::"Medical Insurance":
                exit('seguro med');
            jmcExcelColumn::"Medical Insurance IRPF":
                exit('s.med irpf');
            jmcExcelColumn::"Payment in Kind Deduction":
                exit('deduc rtos');
            jmcExcelColumn::"Extra Pay":
                exit('PP EXTRA');
            jmcExcelColumn::"Self-Employed SS":
                exit('SS AUTONOM');
        end;
        exit('');
    end;

    local procedure GenerateEntries(var jmcPayrollLine: Record "JMC Payroll Import Line")
    var
        jmcColumnMapping: Record "JMC Payroll Column Mapping";
        jmcAmount: Decimal;
        jmcEntryLineNo: Integer;
    begin
        DeleteEntries(jmcPayrollLine);
        if jmcColumnMapping.FindSet() then
            repeat
                if not jmcColumnMapping."JMC Informative" and (jmcColumnMapping."JMC Concept Type" <> jmcColumnMapping."JMC Concept Type"::" ") then begin
                    jmcAmount := jmcPayrollLine.GetColumnAmount(jmcColumnMapping."JMC Excel Column");
                    if jmcAmount <> 0 then begin
                        if jmcColumnMapping."JMC Posting Sign" = jmcColumnMapping."JMC Posting Sign"::Reverse then
                            jmcAmount := -jmcAmount;
                        InsertEntry(jmcPayrollLine, jmcEntryLineNo, jmcColumnMapping."JMC Concept Type", jmcColumnMapping."JMC Excel Column", false, jmcAmount);
                        if jmcColumnMapping."JMC Balancing Concept Type" <> jmcColumnMapping."JMC Balancing Concept Type"::" " then
                            InsertEntry(jmcPayrollLine, jmcEntryLineNo, jmcColumnMapping."JMC Balancing Concept Type", jmcColumnMapping."JMC Excel Column", true, -jmcAmount);
                    end;
                end;
            until jmcColumnMapping.Next() = 0;
    end;

    local procedure InsertEntry(var jmcPayrollLine: Record "JMC Payroll Import Line"; var jmcEntryLineNo: Integer; jmcConceptType: Enum "JMC Payroll Concept Type"; jmcExcelColumn: Enum "JMC Payroll Excel Column"; jmcBalancing: Boolean; jmcAmount: Decimal)
    var
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
    begin
        jmcEntryLineNo += 10000;
        jmcPayrollEntry.Init();
        jmcPayrollEntry."JMC Import No." := jmcPayrollLine."JMC Import No.";
        jmcPayrollEntry."JMC Import Line No." := jmcPayrollLine."JMC Line No.";
        jmcPayrollEntry."JMC Line No." := jmcEntryLineNo;
        jmcPayrollEntry."JMC Source Column" := jmcExcelColumn;
        jmcPayrollEntry."JMC Balancing" := jmcBalancing;
        jmcPayrollEntry."JMC Concept Type" := jmcConceptType;
        jmcPayrollEntry.ProposeAccountAndDescription();
        jmcPayrollEntry.Validate("JMC Amount", jmcAmount);
        jmcPayrollEntry.Insert(false);
    end;

    local procedure ValidateLine(var jmcPayrollLine: Record "JMC Payroll Import Line"; var jmcSetup: Record "JMC Payroll Import Setup")
    var
        jmcResource: Record Resource;
        jmcColumnMapping: Record "JMC Payroll Column Mapping";
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
        jmcGenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        jmcExcelColumn: Enum "JMC Payroll Excel Column";
        jmcMessage: Text;
        jmcHasError: Boolean;
        jmcHasWarning: Boolean;
        jmcResourceNo: Code[20];
        jmcOrdinal: Integer;
        jmcAmount: Decimal;
        jmcExpectedAmount: Decimal;
        jmcTolerance: Decimal;
    begin
        jmcTolerance := jmcSetup."JMC Balance Tolerance";

        if jmcPayrollLine."JMC Resource No." = '' then
            case FindResource(jmcPayrollLine."JMC Gestoría ID", jmcResourceNo) of
                0:
                    AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCResourceNotFoundErr, jmcPayrollLine."JMC Gestoría ID"));
                1:
                    jmcPayrollLine.Validate("JMC Resource No.", jmcResourceNo);
                else
                    AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCResourceMultipleErr, jmcPayrollLine."JMC Gestoría ID"));
            end
        else
            if not jmcResource.Get(jmcPayrollLine."JMC Resource No.") then
                AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCResourceNotExistErr, jmcPayrollLine."JMC Resource No."));

        if jmcPayrollLine."JMC Posting Date" = 0D then
            AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, JMCNoDateErr)
        else
            if jmcGenJnlCheckLine.DateNotAllowed(jmcPayrollLine."JMC Posting Date", jmcSetup."JMC Journal Template Name") then
                AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCDateNotAllowedErr, jmcPayrollLine."JMC Posting Date"));

        foreach jmcOrdinal in Enum::"JMC Payroll Excel Column".Ordinals() do begin
            jmcExcelColumn := Enum::"JMC Payroll Excel Column".FromInteger(jmcOrdinal);
            jmcAmount := jmcPayrollLine.GetColumnAmount(jmcExcelColumn);
            if jmcAmount <> 0 then
                if not jmcColumnMapping.Get(jmcExcelColumn) then
                    AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCColumnNotMappedErr, GetExcelHeader(jmcExcelColumn)))
                else
                    if not jmcColumnMapping."JMC Informative" then
                        if jmcColumnMapping."JMC Concept Type" = jmcColumnMapping."JMC Concept Type"::" " then
                            AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCColumnNotMappedErr, GetExcelHeader(jmcExcelColumn)))
                        else begin
                            jmcExpectedAmount := jmcAmount;
                            if jmcColumnMapping."JMC Posting Sign" = jmcColumnMapping."JMC Posting Sign"::Reverse then
                                jmcExpectedAmount := -jmcAmount;
                            if Abs(SumColumnEntries(jmcPayrollLine, jmcExcelColumn) - jmcExpectedAmount) > jmcTolerance then
                                AddIssue(jmcMessage, jmcHasError, jmcHasWarning, false, StrSubstNo(JMCColumnSplitWarn, GetExcelHeader(jmcExcelColumn)));
                        end;
        end;

        jmcPayrollEntry.SetRange("JMC Import No.", jmcPayrollLine."JMC Import No.");
        jmcPayrollEntry.SetRange("JMC Import Line No.", jmcPayrollLine."JMC Line No.");
        if jmcPayrollEntry.IsEmpty() then
            AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, JMCNoEntriesErr)
        else begin
            jmcPayrollEntry.SetRange("JMC G/L Account No.", '');
            if not jmcPayrollEntry.IsEmpty() then
                AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, JMCEntryWithoutAccountErr);
            jmcPayrollEntry.SetRange("JMC G/L Account No.");
            jmcPayrollEntry.SetRange("JMC Concept Type", jmcPayrollEntry."JMC Concept Type"::Garnishment);
            jmcPayrollEntry.SetRange("JMC Garnishment Authority", jmcPayrollEntry."JMC Garnishment Authority"::" ");
            if not jmcPayrollEntry.IsEmpty() then
                AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, JMCGarnishmentWithoutAuthorityErr);
            jmcPayrollEntry.SetRange("JMC Concept Type");
            jmcPayrollEntry.SetRange("JMC Garnishment Authority");
            jmcPayrollEntry.SetFilter("JMC G/L Account No.", '<>%1', '');
            if jmcPayrollEntry.FindSet() then
                repeat
                    if not IsValidAccount(jmcPayrollEntry."JMC G/L Account No.") then
                        AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCInvalidAccountErr, jmcPayrollEntry."JMC G/L Account No."));
                until jmcPayrollEntry.Next() = 0;

            // The journal must balance exactly per document; the tolerance only applies to the Excel checks.
            jmcPayrollLine.CalcFields("JMC Entry Balance");
            if jmcPayrollLine."JMC Entry Balance" <> 0 then
                AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, StrSubstNo(JMCUnbalancedErr, jmcPayrollLine."JMC Entry Balance"));
        end;

        if IsDuplicate(jmcPayrollLine) then
            AddIssue(jmcMessage, jmcHasError, jmcHasWarning, true, JMCDuplicateErr);

        if Abs(jmcPayrollLine."JMC Total Cost" - (jmcPayrollLine."JMC Gross" + jmcPayrollLine."JMC Company SS")) > jmcTolerance then
            AddIssue(jmcMessage, jmcHasError, jmcHasWarning, false, JMCTotalCostWarn);
        if Abs(jmcPayrollLine."JMC TC1" - (jmcPayrollLine."JMC Company SS" + Abs(jmcPayrollLine."JMC Employee SS"))) > jmcTolerance then
            AddIssue(jmcMessage, jmcHasError, jmcHasWarning, false, JMCTC1Warn);

        if jmcHasError then
            jmcPayrollLine."JMC Validation Status" := jmcPayrollLine."JMC Validation Status"::Error
        else
            if jmcHasWarning then
                jmcPayrollLine."JMC Validation Status" := jmcPayrollLine."JMC Validation Status"::Warning
            else
                jmcPayrollLine."JMC Validation Status" := jmcPayrollLine."JMC Validation Status"::Correct;
        jmcPayrollLine."JMC Validation Message" := CopyStr(jmcMessage, 1, MaxStrLen(jmcPayrollLine."JMC Validation Message"));
    end;

    local procedure AddIssue(var jmcMessage: Text; var jmcHasError: Boolean; var jmcHasWarning: Boolean; jmcIsError: Boolean; jmcIssue: Text)
    begin
        if jmcIsError then
            jmcHasError := true
        else
            jmcHasWarning := true;
        if jmcMessage <> '' then
            jmcMessage += JMCIssueSeparatorTok;
        jmcMessage += jmcIssue;
    end;

    local procedure IsValidAccount(jmcAccountNo: Code[20]): Boolean
    var
        jmcGLAccount: Record "G/L Account";
    begin
        if not jmcGLAccount.Get(jmcAccountNo) then
            exit(false);
        exit((jmcGLAccount."Account Type" = jmcGLAccount."Account Type"::Posting) and not jmcGLAccount.Blocked and jmcGLAccount."Direct Posting");
    end;

    local procedure SumColumnEntries(var jmcPayrollLine: Record "JMC Payroll Import Line"; jmcExcelColumn: Enum "JMC Payroll Excel Column"): Decimal
    var
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
    begin
        jmcPayrollEntry.SetCurrentKey("JMC Import No.", "JMC Import Line No.", "JMC Source Column", "JMC Balancing");
        jmcPayrollEntry.SetRange("JMC Import No.", jmcPayrollLine."JMC Import No.");
        jmcPayrollEntry.SetRange("JMC Import Line No.", jmcPayrollLine."JMC Line No.");
        jmcPayrollEntry.SetRange("JMC Source Column", jmcExcelColumn);
        jmcPayrollEntry.SetRange("JMC Balancing", false);
        jmcPayrollEntry.CalcSums("JMC Amount");
        exit(jmcPayrollEntry."JMC Amount");
    end;

    local procedure IsDuplicate(var jmcPayrollLine: Record "JMC Payroll Import Line"): Boolean
    var
        jmcOtherLine: Record "JMC Payroll Import Line";
        jmcOtherHeader: Record "JMC Payroll Import Header";
    begin
        jmcOtherLine.SetCurrentKey("JMC VAT Registration No.", "JMC Posting Date");
        jmcOtherLine.SetRange("JMC VAT Registration No.", jmcPayrollLine."JMC VAT Registration No.");
        jmcOtherLine.SetRange("JMC Posting Date", jmcPayrollLine."JMC Posting Date");
        if jmcPayrollLine."JMC VAT Registration No." = '' then
            jmcOtherLine.SetRange("JMC Gestoría ID", jmcPayrollLine."JMC Gestoría ID");
        jmcOtherLine.SetRange("JMC Pay Type", jmcPayrollLine."JMC Pay Type");
        jmcOtherLine.SetRange("JMC Gross", jmcPayrollLine."JMC Gross");
        jmcOtherLine.SetRange("JMC Net Pay", jmcPayrollLine."JMC Net Pay");
        if jmcOtherLine.FindSet() then
            repeat
                if jmcOtherLine."JMC Import No." = jmcPayrollLine."JMC Import No." then begin
                    if jmcOtherLine."JMC Line No." <> jmcPayrollLine."JMC Line No." then
                        exit(true);
                end else
                    if jmcOtherHeader.Get(jmcOtherLine."JMC Import No.") then
                        if jmcOtherHeader."JMC Status" in [jmcOtherHeader."JMC Status"::"Journal Created", jmcOtherHeader."JMC Status"::Processed] then
                            exit(true);
            until jmcOtherLine.Next() = 0;
        exit(false);
    end;

    local procedure CheckTotals(var jmcPayrollHeader: Record "JMC Payroll Import Header"; jmcTolerance: Decimal)
    begin
        jmcPayrollHeader."JMC Totals Mismatch" := false;
        if (jmcPayrollHeader."JMC Excel Total Gross" = 0) and (jmcPayrollHeader."JMC Excel Total Company SS" = 0) and (jmcPayrollHeader."JMC Excel Total Net Pay" = 0) then
            exit;
        jmcPayrollHeader.CalcFields("JMC Total Gross", "JMC Total Company SS", "JMC Total Net Pay");
        jmcPayrollHeader."JMC Totals Mismatch" :=
            (Abs(jmcPayrollHeader."JMC Excel Total Gross" - jmcPayrollHeader."JMC Total Gross") > jmcTolerance) or
            (Abs(jmcPayrollHeader."JMC Excel Total Company SS" - jmcPayrollHeader."JMC Total Company SS") > jmcTolerance) or
            (Abs(jmcPayrollHeader."JMC Excel Total Net Pay" - jmcPayrollHeader."JMC Total Net Pay") > jmcTolerance);
    end;

    local procedure InsertJournalLine(var jmcGenJnlTemplate: Record "Gen. Journal Template"; var jmcGenJnlBatch: Record "Gen. Journal Batch"; var jmcPayrollEntry: Record "JMC Payroll Import Entry"; jmcPostingDate: Date; jmcDocumentNo: Code[20]; jmcLineNo: Integer)
    var
        jmcGenJnlLine: Record "Gen. Journal Line";
    begin
        jmcGenJnlLine.Init();
        jmcGenJnlLine."Journal Template Name" := jmcGenJnlBatch."Journal Template Name";
        jmcGenJnlLine."Journal Batch Name" := jmcGenJnlBatch.Name;
        jmcGenJnlLine."Line No." := jmcLineNo;
        jmcGenJnlLine.Validate("Posting Date", jmcPostingDate);
        jmcGenJnlLine."Document Type" := jmcGenJnlLine."Document Type"::" ";
        jmcGenJnlLine."Document No." := jmcDocumentNo;
        jmcGenJnlLine."Source Code" := jmcGenJnlTemplate."Source Code";
        jmcGenJnlLine."Reason Code" := jmcGenJnlBatch."Reason Code";
        jmcGenJnlLine."Posting No. Series" := jmcGenJnlBatch."Posting No. Series";
        jmcGenJnlLine.Validate("Account Type", jmcGenJnlLine."Account Type"::"G/L Account");
        // Validating the account applies its default dimensions.
        jmcGenJnlLine.Validate("Account No.", jmcPayrollEntry."JMC G/L Account No.");
        jmcGenJnlLine.Description := jmcPayrollEntry."JMC Description";
        jmcGenJnlLine.Validate(Amount, jmcPayrollEntry."JMC Amount");
        jmcGenJnlLine.Insert(true);
    end;

    local procedure UpdateDateRange(var jmcPayrollHeader: Record "JMC Payroll Import Header")
    var
        jmcPayrollLine: Record "JMC Payroll Import Line";
    begin
        jmcPayrollHeader."JMC Date From" := 0D;
        jmcPayrollHeader."JMC Date To" := 0D;
        jmcPayrollLine.SetLoadFields("JMC Posting Date");
        jmcPayrollLine.SetRange("JMC Import No.", jmcPayrollHeader."JMC No.");
        jmcPayrollLine.SetFilter("JMC Posting Date", '<>%1', 0D);
        if jmcPayrollLine.FindSet() then
            repeat
                if (jmcPayrollHeader."JMC Date From" = 0D) or (jmcPayrollLine."JMC Posting Date" < jmcPayrollHeader."JMC Date From") then
                    jmcPayrollHeader."JMC Date From" := jmcPayrollLine."JMC Posting Date";
                if jmcPayrollLine."JMC Posting Date" > jmcPayrollHeader."JMC Date To" then
                    jmcPayrollHeader."JMC Date To" := jmcPayrollLine."JMC Posting Date";
            until jmcPayrollLine.Next() = 0;
    end;

    local procedure HasLines(jmcPayrollHeader: Record "JMC Payroll Import Header"): Boolean
    var
        jmcPayrollLine: Record "JMC Payroll Import Line";
    begin
        jmcPayrollLine.SetRange("JMC Import No.", jmcPayrollHeader."JMC No.");
        exit(not jmcPayrollLine.IsEmpty());
    end;

    local procedure EntriesExist(var jmcPayrollLine: Record "JMC Payroll Import Line"): Boolean
    var
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
    begin
        jmcPayrollEntry.SetRange("JMC Import No.", jmcPayrollLine."JMC Import No.");
        jmcPayrollEntry.SetRange("JMC Import Line No.", jmcPayrollLine."JMC Line No.");
        exit(not jmcPayrollEntry.IsEmpty());
    end;

    local procedure DeleteEntries(var jmcPayrollLine: Record "JMC Payroll Import Line")
    var
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
    begin
        jmcPayrollEntry.SetRange("JMC Import No.", jmcPayrollLine."JMC Import No.");
        jmcPayrollEntry.SetRange("JMC Import Line No.", jmcPayrollLine."JMC Line No.");
        jmcPayrollEntry.DeleteAll(false);
    end;

    local procedure DeleteLines(var jmcPayrollHeader: Record "JMC Payroll Import Header")
    var
        jmcPayrollLine: Record "JMC Payroll Import Line";
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
    begin
        jmcPayrollEntry.SetRange("JMC Import No.", jmcPayrollHeader."JMC No.");
        jmcPayrollEntry.DeleteAll(false);
        jmcPayrollLine.SetRange("JMC Import No.", jmcPayrollHeader."JMC No.");
        jmcPayrollLine.DeleteAll(false);
    end;
}
