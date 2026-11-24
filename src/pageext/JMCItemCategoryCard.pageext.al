pageextension 53326 "JMC Item Category Card" extends "Item Category Card"
{
    layout
    {
        addafter(Description)
        {
            field("JMC Category Type"; Rec."JMC Category Type")
            {
                ApplicationArea = All;
                Caption = 'Category Type', Comment = 'ESP="Tipo categoría"';
                ToolTip = 'Specifies the category type. Items can only use categories with their same category type.', Comment = 'ESP="Especifica el tipo de categoría. Los productos solo pueden usar categorías de su mismo tipo."';
            }
        }
    }
}
