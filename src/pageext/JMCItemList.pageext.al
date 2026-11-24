pageextension 53125 "JMC Item List" extends "Item List"
{
    layout
    {
        addbefore("Item Category Code")
        {
            field("JMC Category Type"; Rec."JMC Category Type")
            {
                ApplicationArea = All;
                Caption = 'Category Type', Comment = 'ESP="Tipo categoría"';
                ToolTip = 'Specifies the category type of the item. It filters the available item categories and subcategories.', Comment = 'ESP="Especifica el tipo de categoría del producto. Filtra las familias y sub familias disponibles."';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update(false);
            end;
        }
        addafter("Item Category Code")
        {
            field("JMC Item Category Name"; Rec."JMC Item Category Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the description of the item category.', Comment = 'ESP="Especifica la descripción de la familia del producto."';
            }
            field("JMC Sub Item Category Code"; Rec."JMC Sub Item Category Code")
            {
                ApplicationArea = All;
                Caption = 'Item Subcategory Code', Comment = 'ESP="Sub familia producto"';
                ToolTip = 'Specifies the item subcategory. Only categories with the same category type as the item are offered.', Comment = 'ESP="Especifica la sub familia del producto. Solo se ofrecen categorías del mismo tipo que el producto."';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
            field("JMC Item Subcategory Name"; Rec."JMC Item Subcategory Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the description of the item subcategory.', Comment = 'ESP="Especifica la descripción de la sub familia del producto."';
            }
        }
        modify("Last Direct Cost")
        {
            Visible = false;
        }
        addafter("Unit Cost")
        {
            field("JMC Last Direct Cost"; Rec."JMC Average Purchase Cost")
            {
                ApplicationArea = All;
                Caption = 'Last Direct Cost', Comment = 'ESP="Último coste directo"';
                ToolTip = 'Specifies the average purchase cost calculated from the last purchase invoice.', Comment = 'ESP="Especifica el coste medio de compra calculado de la última factura de compra."';

                trigger OnDrillDown()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    if Rec."JMC Last Purch. Invoice No." <> '' then begin
                        PurchInvHeader.Get(Rec."JMC Last Purch. Invoice No.");
                        Page.Run(Page::"Posted Purchase Invoice", PurchInvHeader);
                    end;
                end;
            }
        }
    }
}
