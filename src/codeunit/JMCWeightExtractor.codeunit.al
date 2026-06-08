codeunit 53103 "JMC Weight Extractor"
{
    procedure ExtractWeightInGrams(Description: Text): Decimal
    var
        Weight: Decimal;
        CleanDesc: Text;
    begin
        CleanDesc := UpperCase(Description);
        Weight := 0;

        // Try to extract weight in different formats
        if TryExtractKilos(CleanDesc, Weight) then
            exit(Weight);

        if TryExtractGrams(CleanDesc, Weight) then
            exit(Weight);

        if TryExtractMilliliters(CleanDesc, Weight) then
            exit(Weight);

        exit(0);
    end;

    local procedure TryExtractKilos(Description: Text; var Weight: Decimal): Boolean
    var
        NumberText: Text;
        CommaPos: Integer;
    begin
        // Look for patterns like "1,5 kilos", "1 kilo", "2,5kg", "1KG"
        if (StrPos(Description, 'KILO') > 0) or (StrPos(Description, 'KG') > 0) then begin
            NumberText := ExtractNumberBeforeKeyword(Description, 'KILO');
            if NumberText = '' then
                NumberText := ExtractNumberBeforeKeyword(Description, 'KG');

            if NumberText <> '' then begin
                // Replace comma with dot for decimal conversion
                CommaPos := StrPos(NumberText, ',');
                if CommaPos > 0 then
                    NumberText := CopyStr(NumberText, 1, CommaPos - 1) + '.' + CopyStr(NumberText, CommaPos + 1);

                if Evaluate(Weight, NumberText) then begin
                    Weight := Weight * 1000; // Convert to grams
                    exit(true);
                end;
            end;
        end;
        exit(false);
    end;

    local procedure TryExtractGrams(Description: Text; var Weight: Decimal): Boolean
    var
        NumberText: Text;
    begin
        // Look for patterns like "250 gramos", "750 gr", "500GR", "350 + 100 gr"
        if (StrPos(Description, 'GRAMO') > 0) or (StrPos(Description, ' GR') > 0) or (StrPos(Description, 'GR ') > 0) then begin
            // Check if there's a sum (e.g., "350 + 100 gr")
            if TryExtractSum(Description, 'GR', Weight) then
                exit(true);

            NumberText := ExtractNumberBeforeKeyword(Description, 'GRAMO');
            if NumberText = '' then
                NumberText := ExtractNumberBeforeKeyword(Description, 'GR');

            if NumberText <> '' then begin
                if Evaluate(Weight, NumberText) then
                    exit(true);
            end;
        end;
        exit(false);
    end;

    local procedure TryExtractMilliliters(Description: Text; var Weight: Decimal): Boolean
    var
        NumberText: Text;
    begin
        // Look for patterns like "1030 ML", "300 mililitros", "1 litro"
        if (StrPos(Description, 'LITRO') > 0) or (StrPos(Description, 'ML') > 0) then begin
            // First try liters
            if StrPos(Description, 'LITRO') > 0 then begin
                NumberText := ExtractNumberBeforeKeyword(Description, 'LITRO');
                if NumberText <> '' then begin
                    if Evaluate(Weight, NumberText) then begin
                        Weight := Weight * 1000; // Convert liters to ml
                        exit(true);
                    end;
                end;
            end;

            // Try milliliters
            NumberText := ExtractNumberBeforeKeyword(Description, 'ML');
            if NumberText = '' then
                NumberText := ExtractNumberBeforeKeyword(Description, 'MILILITRO');

            if NumberText <> '' then begin
                if Evaluate(Weight, NumberText) then
                    exit(true);
            end;
        end;
        exit(false);
    end;

    local procedure ExtractNumberBeforeKeyword(Description: Text; Keyword: Text): Text
    var
        KeywordPos: Integer;
        StartPos: Integer;
        i: Integer;
        Char: Text[1];
        NumberText: Text;
        FoundNumber: Boolean;
    begin
        KeywordPos := StrPos(Description, Keyword);
        if KeywordPos = 0 then
            exit('');

        // Search backwards from keyword position to find the number
        FoundNumber := false;
        NumberText := '';
        for i := KeywordPos - 1 downto 1 do begin
            Char := CopyStr(Description, i, 1);
            // Check if character is digit, comma, or dot
            if (Char >= '0') and (Char <= '9') then begin
                NumberText := Char + NumberText;
                FoundNumber := true;
            end else if ((Char = ',') or (Char = '.')) and FoundNumber then begin
                NumberText := Char + NumberText;
            end else if FoundNumber then begin
                // Stop when we hit a non-numeric character after finding numbers
                exit(NumberText);
            end;
        end;

        exit(NumberText);
    end;

    local procedure TryExtractSum(Description: Text; Keyword: Text; var Weight: Decimal): Boolean
    var
        PlusPos: Integer;
        KeywordPos: Integer;
        FirstNumber: Decimal;
        SecondNumber: Decimal;
        FirstText: Text;
        SecondText: Text;
        i: Integer;
        Char: Text[1];
        FoundNumber: Boolean;
    begin
        KeywordPos := StrPos(Description, Keyword);
        if KeywordPos = 0 then
            exit(false);

        // Look for + sign before the keyword
        PlusPos := 0;
        for i := KeywordPos - 1 downto 1 do begin
            Char := CopyStr(Description, i, 1);
            if Char = '+' then begin
                PlusPos := i;
                break;
            end;
        end;

        if PlusPos = 0 then
            exit(false);

        // Extract second number (after +, before keyword)
        SecondText := '';
        FoundNumber := false;
        for i := KeywordPos - 1 downto PlusPos + 1 do begin
            Char := CopyStr(Description, i, 1);
            if (Char >= '0') and (Char <= '9') then begin
                SecondText := Char + SecondText;
                FoundNumber := true;
            end else if FoundNumber then
                    break;
        end;

        if not Evaluate(SecondNumber, SecondText) then
            exit(false);

        // Extract first number (before +)
        FirstText := '';
        FoundNumber := false;
        for i := PlusPos - 1 downto 1 do begin
            Char := CopyStr(Description, i, 1);
            if (Char >= '0') and (Char <= '9') then begin
                FirstText := Char + FirstText;
                FoundNumber := true;
            end else if FoundNumber then
                    break;
        end;

        if not Evaluate(FirstNumber, FirstText) then
            exit(false);

        Weight := FirstNumber + SecondNumber;
        exit(true);
    end;
}
