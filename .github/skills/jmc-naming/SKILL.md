---
name: jmc-naming
description: 'Apply JMC prefix to all AL objects and fields in Business Central. Use when creating tables, pages, reports, codeunits, or any AL object that requires the JMC naming convention.'
user-invocable: true
---

# JMC Naming Convention

This skill ensures all AL objects and fields follow the JMC naming convention by prefixing names with "JMC".

## When to Use

- Creating new AL tables, pages, reports, codeunits, or any object
- Defining new fields in tables or table extensions
- Extending existing Business Central objects
- Any scenario where JMC prefix is required for identification

## Naming Rules

### File Names

All AL files MUST follow the pattern: `[NameWithoutSpaces].[objecttype].al`

**Object Type Suffixes:**
- `.table.al` - Tables
- `.page.al` - Pages
- `.report.al` - Reports
- `.codeunit.al` - Codeunits
- `.query.al` - Queries
- `.xmlport.al` - XMLports
- `.enum.al` - Enums
- `.interface.al` - Interfaces
- `.controladdin.al` - Control Add-ins
- `.pageextension.al` - Page Extensions
- `.tableextension.al` - Table Extensions

**Examples:**
```
JMCCustomerData.table.al         // Table
JMCCustomerList.page.al          // Page
JMCDeleteArchivedEvents.report.al // Report
JMCManagement.codeunit.al        // Codeunit
JMCSalesOrderCard.page.al        // Page
JMCEventStatus.enum.al           // Enum
```

### Object Names

All object names MUST start with "JMC":

```al
// Tables
table 50100 "JMC Customer Data"
table 50101 "JMC Sales Configuration"

// Pages
page 50100 "JMC Customer List"
page 50101 "JMC Sales Order Card"

// Codeunits
codeunit 50100 "JMC Management"
codeunit 50101 "JMC Sales Functions"

// Reports
report 50100 "JMC Sales Report"
report 50101 "JMC Customer Statement"
```

### Captions - WITHOUT JMC Prefix

**IMPORTANT**: Captions NEVER include the JMC prefix, only object/field names do.

```al
report 53100 "JMC Delete Archived Events"  // ✅ Object name WITH JMC
{
    Caption = 'Delete Archived Events';  // ✅ Caption WITHOUT JMC
}

table 50100 "JMC Customer Master"  // ✅ Object name WITH JMC
{
    Caption = 'Customer Master';  // ✅ Caption WITHOUT JMC
    
    fields
    {
        field(1; "JMC Customer Code"; Code[20])  // ✅ Field name WITH JMC
        {
            Caption = 'Customer Code';  // ✅ Caption WITHOUT JMC
        }
    }
}
```

### Field Names

All field names MUST start with "JMC":

```al
field(1; "JMC Code"; Code[20])
{
    Caption = 'Code';  // Caption WITHOUT JMC
    DataClassification = CustomerContent;
}

field(2; "JMC Description"; Text[100])
{
    Caption = 'Description';  // Caption WITHOUT JMC
    DataClassification = CustomerContent;
}

field(3; "JMC Amount"; Decimal)
{
    Caption = 'Amount';  // Caption WITHOUT JMC
    DataClassification = CustomerContent;
}

field(4; "JMC Active"; Boolean)
{
    Caption = 'Active';  // Caption WITHOUT JMC
    DataClassification = CustomerContent;
}
```

### Variable Names

Local variables should use camelCase with jmc prefix:

```al
var
    jmcCustomer: Record Customer;
    jmcAmount: Decimal;
    jmcIsValid: Boolean;
    jmcTempBuffer: Record "JMC Temp Buffer" temporary;
```

Global variables should use PascalCase with JMC prefix:

```al
var
    JMCGlobalSetup: Record "JMC Setup";
    JMCManagement: Codeunit "JMC Management";
```

## Examples

### Complete Table Definition

```al
table 50100 "JMC Product Master"  // Object name WITH JMC
{
    Caption = 'Product Master';  // Caption WITHOUT JMC
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "JMC Product Code"; Code[20])  // Field name WITH JMC
        {
            Caption = 'Product Code';  // Caption WITHOUT JMC
            DataClassification = CustomerContent;
        }
        field(2; "JMC Product Name"; Text[100])  // Field name WITH JMC
        {
            Caption = 'Product Name';  // Caption WITHOUT JMC
            DataClassification = CustomerContent;
        }
        field(3; "JMC Unit Price"; Decimal)  // Field name WITH JMC
        {
            Caption = 'Unit Price';  // Caption WITHOUT JMC
            DataClassification = CustomerContent;
        }
        field(4; "JMC Active"; Boolean)  // Field name WITH JMC
        {
            Caption = 'Active';  // Caption WITHOUT JMC
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }
    
    keys
    {
        key(PK; "JMC Product Code")
        {
            Clustered = true;
        }
    }
}
```
    
    fields
    {
        field(1; "JMC Product Code"; Code[20])
        {
            Caption = 'JMC Product Code';
            DataClassificatio  // Object name WITH JMC
{
    PageType = List;
    SourceTable = "JMC Product Master";
    Caption = 'Product List';  // Caption WITHOUT JMC
    UsageCategory = Lists;
    ApplicationArea = All;
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("JMC Product Code"; Rec."JMC Product Code")
                {
                    ApplicationArea = All;
                    Caption = 'Product Code';  // Caption WITHOUT JMC
                }
                field("JMC Product Name"; Rec."JMC Product Name")
                {
                    ApplicationArea = All;
                    Caption = 'Product Name';  // Caption WITHOUT JMC
                }
                field("JMC Unit Price"; Rec."JMC Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price';  // Caption WITHOUT JMC
                }
                field("JMC Active"; Rec."JMC Active")
                {
                    ApplicationArea = All;
                    Caption = 'Active';  // Caption WITHOUT JMC

### Page Definition

File: `JMCProductList.page.al`

```al
page 50100 "JMC Product List"
{
    PageType = List;
    SourceTable = "JMC Product Master";
    Caption = 'JMC Product List';
    UsageCategory = Lists;
    ApplicationArea = All;
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("JMC Product Code"; Rec."JMC Product Code")
                {
                    ApplicationArea = All;
                }
                field("JMC Product Name"; Rec."JMC Product Name")
                {
                    ApplicationArea = All;
                }
                field("JMC Unit Price"; Rec."JMC Unit Price")
                {
                    ApplicationArea = All;
                }
                field("JMC Active"; Rec."JMC Active")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
```

## Validation Checklist

Before finalizing any AL code:

- [ ] File name follows pattern: `[NameWithoutSpaces].[objecttype].al`
- [ ] All object names start with "JMC"
- [ ] All field names start with "JMC"
- [ ] All captions do NOT include "JMC" prefix
- [ ] Variable naming follows jmc convention
- [ ] Object IDs are in the correct range (53100-53499)
- [ ] All code compiles without errors

## Benefits

1. **Easy Identification**: JMC objects are immediately recognizable
2. **Namespace Management**: Avoids conflicts with standard BC objects
3. **Team Consistency**: Everyone follows the same naming pattern
4. **Maintenance**: Easier to track and manage custom objects

## Procedure

When creating any AL object:

1. Create file with correct naming: `[NameWithoutSpaces].[objecttype].al`
2. Start with "JMC" prefix for the object name
3. Add "JMC" prefix to all field definitions
4. Set Caption WITHOUT "JMC" prefix (only object/field names have JMC)
5. Use jmc prefix for variables
6. Verify naming consistency throughout the code
7. Compile and validate

**Remember: 
- Object/Field names: WITH JMC prefix
- Captions: WITHOUT JMC prefix
- File names, object names, and field names MUST follow JMC conventions**
