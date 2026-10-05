pageextension 53137 "JMC Resource List" extends "Resource List"
{
    layout
    {
        addafter(Name)
        {
            field("JMC Gestoría ID"; Rec."JMC Gestoría ID")
            {
                ApplicationArea = All;
            }
        }
    }
}