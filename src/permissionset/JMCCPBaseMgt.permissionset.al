permissionset 53100 "JMC CP BASE MGT"
{
    Caption = 'JMC CP Base Management', Comment = 'ESP="JMC CP Base - Gestión"';
    Assignable = true;

    Permissions =
        // Tablas base de compras
        tabledata "Purchase Header" = RIMD,
        tabledata "Purchase Line" = RIMD,
        tabledata "Purch. Rcpt. Header" = RIMD,
        tabledata "Purch. Rcpt. Line" = RIMD,
        tabledata "Purch. Inv. Header" = RIMD,
        tabledata "Purch. Inv. Line" = RIMD,
        tabledata "Purch. Cr. Memo Hdr." = RIMD,
        tabledata "Purch. Cr. Memo Line" = RIMD,

        // Tablas relacionadas necesarias para compras y eventos
        tabledata "G/L Account" = RIMD,
        tabledata "Resource" = RIMD,
        tabledata "Item" = RIMD,
        tabledata "Vendor" = RIMD,
        tabledata "Item Ledger Entry" = RIMD,
        tabledata "Value Entry" = R,
        tabledata "Evento" = RIMD,
        tabledata "Price List Line" = RIMD,

        // Tablas JMC personalizadas
        tabledata "JMC Purchase Order Method" = RIMD,
        tabledata "JMC Purchase Order Reason" = RIMD,
        tabledata "JMC Cronus" = RIMD,
        tabledata "JMC Cronus Jnl. Line" = RIMD,

        // Páginas de compras base
        page "Purchase Order" = X,
        page "Purchase Orders" = X,
        page "Purchase Order Subform" = X,
        page "Purchase Invoice" = X,
        page "Purchase Invoices" = X,
        page "Purchase Credit Memo" = X,
        page "Purchase Credit Memos" = X,
        page "Posted Purchase Receipt" = X,
        page "Posted Purchase Receipts" = X,
        page "Posted Purchase Rcpt. Subform" = X,
        page "Posted Purchase Invoice" = X,
        page "Posted Purchase Invoices" = X,
        page "Posted Purch. Invoice Subform" = X,
        page "Posted Purchase Credit Memo" = X,
        page "Posted Purchase Credit Memos" = X,
        page "Posted Purch. Cr. Memo Subform" = X,
        page "G/L Account Card" = X,
        page "Chart of Accounts" = X,
        page "Resource Card" = X,
        page "Item Ledger Entries" = X,

        // Páginas JMC personalizadas
        page "JMC Purchase Order Methods" = X,
        page "JMC Purchase Order Reasons" = X,
        page "JMC Cronus" = X,
        page "JMC Oper. Rec. Journal" = X,
        page "JMC Cronus Statistics" = X,
        page "JMC CP BOM Aditional Cost" = X,
        page "JMC Internal Notes Editor" = X,

        // Reports JMC
        report "JMC Delete Archived Events" = X,
        report "JMC Update Item Weights" = X,
        report "JMC Activate Price List Lines" = X,

        // Codeunits necesarios
        codeunit "JMC Events" = X,
        codeunit "JMC Oper. Rec. Jnl. Mgt" = X,

        // Codeunits de Business Central para registro de compras
        codeunit "Purch.-Post" = X,
        codeunit "Purch.-Post (Yes/No)" = X,
        codeunit "Purch.-Post + Print" = X;
}
