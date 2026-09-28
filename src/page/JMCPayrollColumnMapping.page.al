page 53152 "JMC Payroll Column Mapping"
{
    Caption = 'Payroll Column Mapping', Comment = 'ESP="Mapeo columnas nómina"';
    PageType = List;
    SourceTable = "JMC Payroll Column Mapping";
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(ExcelColumn; Rec."JMC Excel Column") { }
                field(Informative; Rec."JMC Informative") { }
                field(ConceptType; Rec."JMC Concept Type") { }
                field(PostingSign; Rec."JMC Posting Sign") { }
                field(BalancingConceptType; Rec."JMC Balancing Concept Type") { }
            }
        }
    }
}
