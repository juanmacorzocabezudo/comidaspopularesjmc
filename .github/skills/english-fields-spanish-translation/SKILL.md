---
name: english-fields-spanish-translation
description: 'Create AL fields and UI elements in English with Spanish translations. Use for tables, pages, reports with English code and Spanish translations via Comment ESP="".'
user-invocable: true
---

# English Fields with Spanish Translation

This skill ensures all AL code is written in English with Spanish translations provided through the `Comment` attribute using the format `ESP=""`.

## When to Use

- Defining new fields in tables
- Creating pages, reports, and UI elements
- Working in projects that need English code with Spanish user interface
- Any AL development requiring bilingual support (English/Spanish)

## Key Translation Rules

1. **Field Name**: Always in English
2. **Caption**: In English, followed by `, Comment = 'ESP="Spanish Translation"'` **on the same line**
3. **Caption NEVER includes JMC prefix** - Only object names have JMC, Captions do NOT
4. **ToolTip**: In English, followed by `, Comment = 'ESP="Spanish Translation"'` **on the same line**
5. **Labels**: Text in English, with `, Comment = 'ESP="Spanish Translation"'`
6. **Consistency**: Translation must be accurate and contextual

## IMPORTANT: JMC Prefix Rule

- ✅ **Object names**: Include JMC prefix (e.g., `report 53100 "JMC Delete Archived Events"`)
- ❌ **Captions**: NEVER include JMC prefix (e.g., `Caption = 'Delete Archived Events'`)
- ✅ **Spanish translation**: Can include JMC if contextual (e.g., `Comment = 'ESP="Eliminar eventos archivados"'`)

**Example:**
```al
report 53100 "JMC Delete Archived Events"  // ✅ Object name WITH JMC
{
    Caption = 'Delete Archived Events', Comment = 'ESP="Eliminar eventos archivados"';  // ✅ Caption WITHOUT JMC
}
```

## Translation Pattern

### Fields with Caption and ToolTip

```al
field(1; "Customer Name"; Text[100])
{
    Caption = 'Customer Name', Comment = 'ESP="Nombre del Cliente"';
    ToolTip = 'Specifies the name of the customer.', Comment = 'ESP="Especifica el nombre del cliente."';
    DataClassification = CustomerContent;
}
```

### Page Fields

```al
field("Customer Name"; Rec."Customer Name")
{
    ApplicationArea = All;
    Caption = 'Customer Name', Comment = 'ESP="Nombre del Cliente"';
    ToolTip = 'Specifies the customer name.', Comment = 'ESP="Especifica el nombre del cliente."';
}
```

### Page Groups and Actions

```al
group(General)
{
    Caption = 'General', Comment = 'ESP="General"';
    
    // fields...
}

action(Calculate)
{
    Caption = 'Calculate Total', Comment = 'ESP="Calcular Total"';
    ToolTip = 'Calculates the total amount.', Comment = 'ESP="Calcula el importe total."';
    ApplicationArea = All;
}
```

### Label Variables  // Object name WITH JMC
{
    Caption = 'Sales Configuration', Comment = 'ESP="Configuración Ventas"';  // Caption WITHOUT JMC
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "JMC Primary Key"; Code[10])  // Field name WITH JMC
        {
            Caption = 'Primary Key', Comment = 'ESP="Clave Principal"';  // Caption WITHOUT JMC
            ToolTip = 'Specifies the primary key.', Comment = 'ESP="Especifica la clave principal."';
            DataClassification = CustomerContent;
        }
        
        field(2; "JMC Enable Discount"; Boolean)  // Field name WITH JMC
        {
            Caption = 'Enable Discount', Comment = 'ESP="Habilitar Descuento"';  // Caption WITHOUT JMC
            ToolTip = 'Specifies if discounts are enabled.', Comment = 'ESP="Especifica si los descuentos están habilitados."';
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "JMC on = 'Primary Key', Comment = 'ESP="Clave Principal"';
            ToolTip = 'Specifies the primary key.', Comment = 'ESP="Especifica la clave principal."';
            DataClassification = CustomerContent;
        }
        
        field(2; "Enable Discount"; Boolean)
        {
            Caption = 'Enable Discount', Comment = 'ESP="Habilitar Descuento"';
            ToolTip = 'Specifies if discounts are enabled.', Comment = 'ESP="Especifica si los descuentos están habilitados."';
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Primary Key")
        {  // Object name WITH JMC
{
    Caption = 'Delete Archived Events', Comment = 'ESP="Eliminar eventos archivados"';  // Caption WITHOUT JMC
    }
    
    var
        MaxDiscountErr: Label 'Discount cannot exceed maximum.', Comment = 'ESP="El descuento no puede exceder el máximo."';
}
```

### Report Example

File: `JMCDeleteArchivedEvents.report.al`

```al
report 53100 "JMC Delete Archived Events"
{
    Caption = 'JMC Delete Archived Events', Comment = 'ESP="JMC Eliminar Eventos Archivados"';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;
    
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    
                    field(ShowDetails; ShowDetails)
                    {
                        Caption = 'Show Details', Comment = 'ESP="Mostrar Detalles"';
                        ToolTip = 'Specifies if details should be shown.', Comment = 'ESP="Especifica si se deben mostrar los detalles."';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    
    var
        ShowDetails: Boolean;
        NoDataMsg: Label 'No data found.', Comment = 'ESP="No se encontraron datos."';
}
```

## Common Terms Dictionary

| English | Spanish |
|---------|---------|
| Customer | Cliente |
| Product | Producto |
| Order | Pedido |
| Invoice | Factura |
| Price | Precio |
| Quantity | Cantidad |
| Date | Fecha |
| Amount | Importe |
| Discount | Descuento |
| Active | Activo |
| Blocked | Bloqueado |
| Description | Descripción |
| Code | Código |
| Number (No.) | Número (Nº) |
| Options | Opciones |
| Delete | Eliminar |
| Confirm | Confirmar |
| Enable | Habilitar |
| Disable | Deshabilitar |
| Maximum | Máximo |
| Minimum | Mínimo |
| Specifies | Especifica |
| Processing | Procesando |
| Completed | Completado |

## Validation Checklist

Before finalizing AL code:

- [ ] Field/Object names are in English
- [ ] Object names include JMC prefix
- [ ] Caption is in English WITHOUT JMC prefix
- [ ] Caption has Comment on same line with Spanish translation
- [ ] ToolTip (if present) is in English with Comment on same line
- [ ] Label variables have `, Comment = 'ESP=""'` syntax
- [ ] Spanish translations are accurate and contextual
- [ ] DataClassification is specified (for fields)
- [ ] All code compiles without errors

## Procedure

When Object Names**: Include JMC prefix (e.g., `"JMC Customer Master"`)
2. **Field Names**: Include JMC prefix (e.g., `"JMC Customer Code"`)
3. **Caption**: WITHOUT JMC prefix, `Caption = 'English', Comment = 'ESP="Spanish"';` (same line, comma separated)
4. **ToolTip**: `ToolTip = 'English', Comment = 'ESP="Spanish"';` (same line, comma separated)
5. **Labels**: `Label 'English', Comment = 'ESP="Spanish"'` 
6. **Translate**: Convert to Spanish considering context
7. **Verify**: Check spelling and consistency, ensure no JMC in Captions
8. **Compile and test**

**Remember: 
- Object/Field names: WITH JMC
- Captions: WITHOUT JMC
-e and test**

**Remember: Comment must be on the same line as Caption/ToolTip, separated by comma!**
