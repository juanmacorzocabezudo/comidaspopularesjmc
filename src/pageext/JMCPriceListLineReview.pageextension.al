pageextension 53106 "JMC Price List Line Review" extends "Price List Line Review"
{
    layout
    {
        addafter(Description)
        {
            field(JMCFormat; Rec."JMC Format")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
    }
}