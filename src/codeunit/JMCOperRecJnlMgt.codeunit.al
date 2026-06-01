codeunit 53110 "JMC Oper. Rec. Jnl. Mgt"
{
    procedure RegisterJournalLines(var jmcAnalysisJournalLine: Record "JMC Cronus Jnl. Line")
    var
        jmcAnalysisEntry: Record "JMC Cronus";
        jmcLinesRegistered: Integer;
        jmcNoLinesToRegisterErr: Label 'There are no journal lines to register.', Comment = 'ESP="No hay lineas de diario para registrar."';
        jmcLinesRegisteredMsg: Label '%1 line(s) have been registered in analysis entries.', Comment = 'ESP="Se han registrado %1 linea(s) en registros operativos."';
    begin
        if jmcAnalysisJournalLine.IsEmpty() then
            Error(jmcNoLinesToRegisterErr);

        if jmcAnalysisJournalLine.FindSet(true) then
            repeat
                if not jmcAnalysisJournalLine."JMC Registered" then begin
                    jmcAnalysisEntry.AddFromJournalLine(jmcAnalysisJournalLine);
                    MarkLineAsRegistered(jmcAnalysisJournalLine);
                    jmcLinesRegistered += 1;
                end;
            until jmcAnalysisJournalLine.Next() = 0;

        if jmcLinesRegistered = 0 then
            Error(jmcNoLinesToRegisterErr);

        Message(jmcLinesRegisteredMsg, jmcLinesRegistered);
    end;

    local procedure MarkLineAsRegistered(var jmcAnalysisJournalLine: Record "JMC Cronus Jnl. Line")
    begin
        jmcAnalysisJournalLine."JMC Registered" := true;
        jmcAnalysisJournalLine."JMC Registered DateTime" := CurrentDateTime();
        jmcAnalysisJournalLine."JMC Registered By" := CopyStr(UserId(), 1, MaxStrLen(jmcAnalysisJournalLine."JMC Registered By"));
        jmcAnalysisJournalLine.Modify(true);
    end;
}
