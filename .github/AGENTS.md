# Custom Agents for Business Central Development

This workspace includes specialized agents and skills for Business Central AL development.

## Agents

### BC Architect

**File**: `.github/agents/bc-architect.agent.md`

Expert AL architect for Microsoft Dynamics 365 Business Central. Specializes in:
- Designing and implementing AL code structure
- Optimizing object definitions (Tables, Pages, Reports, Codeunits)
- Ensuring best practices and performance optimization
- Creating maintainable and extensible solutions

**Usage**: Invoke with `@BC Architect` or it will be automatically selected for AL architecture tasks.

**Tools**: read, edit, search, execute

---

## Skills

### JMC Naming Convention

**File**: `.github/skills/jmc-naming/SKILL.md`

Ensures all AL objects and fields follow the JMC naming convention by prefixing names with "JMC".

**Usage**: Type `/jmc-naming` or mention "JMC naming" in your request.

**Applies to**:
- Creating tables, pages, reports, codeunits
- Defining fields in tables or extensions
- Any AL object creation

**Example Output**:
```al
// File: JMCCustomerData.table.al
table 50100 "JMC Customer Data"  // Object name WITH JMC
{
    Caption = 'Customer Data';  // Caption WITHOUT JMC
    
    field(1; "JMC Customer No."; Code[20])  // Field name WITH JMC
    {
        Caption = 'Customer No.';  // Caption WITHOUT JMC
    }
}
```

**Important**: Object and field names include JMC prefix, but Captions do NOT.

---

### English Fields with Spanish Translation

**File**: `.github/skills/english-fields-spanish-translation/SKILL.md`

Creates AL fields in English with Spanish translations using the Comment attribute format `ESP=""`.

**Usage**: Type `/english-fields-spanish-translation` or mention "English fields with Spanish translation".

**Applies to**:
- Defining table fields with bilingual support
- Creating pages, reports, and UI elements
- Any AL development requiring English/Spanish support

**Translation Rules**:
- Caption: `Caption = 'English', Comment = 'ESP="Spanish"';` (same line)
- ToolTip: `ToolTip = 'English', Comment = 'ESP="Spanish"';` (same line)
- Labels: `Label 'English', Comment = 'ESP="Spanish"'`

**Example Output**:
```al
field(1; "Customer Name"; Text[100])
{
    Caption = 'Customer Name', Comment = 'ESP="Nombre del Cliente"';
    ToolTip = 'Specifies the customer name.', Comment = 'ESP="Especifica el nombre del cliente."';
    DataClassification = CustomerContent;
}

var
    SuccessMsg: Label 'Operation completed.', Comment = 'ESP="Operación completada."';
```

---

## Workflow

For optimal Business Central development in this workspace:

1. **Use @BC Architect** for designing and implementing AL objects
2. **Apply /jmc-naming** to ensure all objects use JMC prefix
3. **Apply /english-fields-spanish-translation** for bilingual field support

### Example Combined Usage

```
@BC Architect create a new table for customer orders using JMC naming 
with English fields and Spanish translations
```

This will:
- Design an optimized AL table structure
- Prefix all objects and fields with "JMC"
- Define fields in English with Spanish in Comment attributes

---

## Development Standards

All code created with these agents follows:
- Business Central best practices
- Performance optimization patterns
- JMC naming conventions (all objects/fields prefixed)
- File naming convention: `[NameWithoutSpaces].[objecttype].al`
- English field names with Spanish translations
- Proper data classifications
- Object ID range: 53100-53499

### File Naming Examples

```
JMCCustomerData.table.al
JMCCustomerList.page.al
JMCDeleteArchivedEvents.report.al
JMCManagement.codeunit.al
JMCEventStatus.enum.al
```
