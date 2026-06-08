pageextension 53121 "JMC Pstd Sales Cr M Subform" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("JMC Return"; Rec."JMC Return")
            {
                ApplicationArea = All;
                Caption = 'Return', Comment = 'ESP="Devolución"';
                ToolTip = 'Specifies if this line is a return.', Comment = 'ESP="Especifica si esta línea es una devolución."';
            }
            field("JMC Comments"; Rec."JMC Comments")
            {
                ApplicationArea = All;
                Caption = 'Comments', Comment = 'ESP="Comentarios"';
                ToolTip = 'Specifies comments for this credit memo line.', Comment = 'ESP="Especifica comentarios para esta línea de abono."';
            }
        }
    }
}
