report 53327 "JMC Update Item Categories"
{
    Caption = 'Update Item Categories 2027', Comment = 'ESP="Actualizar categorías de producto 2027"';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                LoadCategories();
                CountChanges();
                if PreviewOnly then begin
                    Message(PreviewMsg, CreatedCount, UpdatedCount, UnchangedCount);
                    exit;
                end;

                if not Confirm(ConfirmUpdateQst, false, CreatedCount, UpdatedCount, UnchangedCount) then
                    exit;

                ApplyCategories(true);
                ApplyCategories(false);
                Message(CompletedMsg, CreatedCount, UpdatedCount, UnchangedCount);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(PreviewOnly; PreviewOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Preview Only', Comment = 'ESP="Solo simulación"';
                        ToolTip = 'Shows the number of categories to create or update without changing data.', Comment = 'ESP="Muestra el número de categorías que se crearían o actualizarían sin modificar datos."';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        PreviewOnly := true;
    end;

    local procedure CountChanges()
    var
        ItemCategory: Record "Item Category";
    begin
        CreatedCount := 0;
        UpdatedCount := 0;
        UnchangedCount := 0;
        if TempItemCategory.FindSet() then
            repeat
                if not ItemCategory.Get(TempItemCategory.Code) then
                    CreatedCount += 1
                else
                    if CategoryDiffers(ItemCategory, TempItemCategory) then
                        UpdatedCount += 1
                    else
                        UnchangedCount += 1;
            until TempItemCategory.Next() = 0;
    end;

    local procedure CategoryDiffers(ItemCategory: Record "Item Category"; DesiredCategory: Record "Item Category" temporary): Boolean
    begin
        exit((ItemCategory.Description <> DesiredCategory.Description) or
             (ItemCategory."Parent Category" <> DesiredCategory."Parent Category") or
             (ItemCategory."JMC Category Type" <> DesiredCategory."JMC Category Type"));
    end;

    local procedure ApplyCategories(RootCategories: Boolean)
    var
        ItemCategory: Record "Item Category";
    begin
        if TempItemCategory.FindSet() then
            repeat
                if (TempItemCategory."Parent Category" = '') = RootCategories then
                    if ItemCategory.Get(TempItemCategory.Code) then begin
                        if CategoryDiffers(ItemCategory, TempItemCategory) then begin
                            ItemCategory.Validate(Description, TempItemCategory.Description);
                            ItemCategory.Validate("JMC Category Type", TempItemCategory."JMC Category Type");
                            if ItemCategory."Parent Category" <> TempItemCategory."Parent Category" then
                                ItemCategory.Validate("Parent Category", TempItemCategory."Parent Category");
                            ItemCategory.Modify(true);
                        end;
                    end else begin
                        ItemCategory.Init();
                        ItemCategory.Validate(Code, TempItemCategory.Code);
                        ItemCategory.Validate(Description, TempItemCategory.Description);
                        ItemCategory.Validate("JMC Category Type", TempItemCategory."JMC Category Type");
                        ItemCategory.Validate("Parent Category", TempItemCategory."Parent Category");
                        ItemCategory.Insert(true);
                    end;
            until TempItemCategory.Next() = 0;
    end;

    local procedure AddCategory(CategoryCode: Code[20]; CategoryDescription: Text[100]; ParentCode: Code[20]; CategoryType: Enum "JMC Category Type")
    begin
        TempItemCategory.Init();
        TempItemCategory.Code := CategoryCode;
        TempItemCategory.Description := CategoryDescription;
        TempItemCategory."Parent Category" := ParentCode;
        TempItemCategory."JMC Category Type" := CategoryType;
        TempItemCategory.Insert();
    end;

    local procedure LoadCategories()
    begin
        TempItemCategory.DeleteAll();
        AddCategory('1010', 'Entrantes y aperitivos', '', Enum::"JMC Category Type"::CA);
        AddCategory('1011', 'Bandejas y platos cocktail', '1010', Enum::"JMC Category Type"::CA);
        AddCategory('1012', 'Snacks y picoteo', '1010', Enum::"JMC Category Type"::CA);
        AddCategory('1013', 'Entrantes fríos y embutidos', '1010', Enum::"JMC Category Type"::CA);
        AddCategory('1020', 'Primeros', '', Enum::"JMC Category Type"::CA);
        AddCategory('1021', 'Ensaladas', '1020', Enum::"JMC Category Type"::CA);
        AddCategory('1022', 'Cremas, sopas y caldos', '1020', Enum::"JMC Category Type"::CA);
        AddCategory('1023', 'Verduras', '1020', Enum::"JMC Category Type"::CA);
        AddCategory('1024', 'Guarniciones', '1020', Enum::"JMC Category Type"::CA);
        AddCategory('1025', 'Pan', '1020', Enum::"JMC Category Type"::CA);
        AddCategory('1030', 'Huevos con… y tortillas', '', Enum::"JMC Category Type"::CA);
        AddCategory('1031', 'Huevos fritos y revueltos', '1030', Enum::"JMC Category Type"::CA);
        AddCategory('1032', 'Tortillas', '1030', Enum::"JMC Category Type"::CA);
        AddCategory('1040', 'Arroces, pastas y migas', '', Enum::"JMC Category Type"::CA);
        AddCategory('1041', 'Paellas y arroces', '1040', Enum::"JMC Category Type"::CA);
        AddCategory('1042', 'Fideuás', '1040', Enum::"JMC Category Type"::CA);
        AddCategory('1043', 'Pastas', '1040', Enum::"JMC Category Type"::CA);
        AddCategory('1044', 'Migas y gachas', '1040', Enum::"JMC Category Type"::CA);
        AddCategory('1050', 'Estofados y guisos', '', Enum::"JMC Category Type"::CA);
        AddCategory('1051', 'Legumbres y cocidos', '1050', Enum::"JMC Category Type"::CA);
        AddCategory('1052', 'Guisos y calderetas', '1050', Enum::"JMC Category Type"::CA);
        AddCategory('1053', 'Carnes en salsa', '1050', Enum::"JMC Category Type"::CA);
        AddCategory('1060', 'Carnes y parrilladas', '', Enum::"JMC Category Type"::CA);
        AddCategory('1061', 'Asados', '1060', Enum::"JMC Category Type"::CA);
        AddCategory('1062', 'Parrilladas, plancha y brasa', '1060', Enum::"JMC Category Type"::CA);
        AddCategory('1063', 'Pollo y aves', '1060', Enum::"JMC Category Type"::CA);
        AddCategory('1064', 'Otras carnes', '1060', Enum::"JMC Category Type"::CA);
        AddCategory('1070', 'Pescados y mariscos', '', Enum::"JMC Category Type"::CA);
        AddCategory('1071', 'Pescados', '1070', Enum::"JMC Category Type"::CA);
        AddCategory('1072', 'Mariscos y moluscos', '1070', Enum::"JMC Category Type"::CA);
        AddCategory('1080', 'Cocina internacional', '', Enum::"JMC Category Type"::CA);
        AddCategory('1081', 'Cocina asiática', '1080', Enum::"JMC Category Type"::CA);
        AddCategory('1082', 'Cocina europea y americana', '1080', Enum::"JMC Category Type"::CA);
        AddCategory('1090', 'Postres', '', Enum::"JMC Category Type"::CA);
        AddCategory('1091', 'Postres propios', '1090', Enum::"JMC Category Type"::CA);
        AddCategory('1092', 'Postres comprados y fruta', '1090', Enum::"JMC Category Type"::CA);
        AddCategory('1100', 'Bebidas', '', Enum::"JMC Category Type"::CA);
        AddCategory('1101', 'Bebida por persona', '1100', Enum::"JMC Category Type"::CA);
        AddCategory('1102', 'Agua y refrescos', '1100', Enum::"JMC Category Type"::CA);
        AddCategory('1103', 'Vinos, cervezas y sangría', '1100', Enum::"JMC Category Type"::CA);
        AddCategory('1104', 'Barra libre y copas', '1100', Enum::"JMC Category Type"::CA);
        AddCategory('1105', 'Café e infusiones', '1100', Enum::"JMC Category Type"::CA);
        AddCategory('1110', 'Desayunos y coffee break', '', Enum::"JMC Category Type"::CA);
        AddCategory('1111', 'Coffee break', '1110', Enum::"JMC Category Type"::CA);
        AddCategory('1112', 'Chocolate y churros', '1110', Enum::"JMC Category Type"::CA);
        AddCategory('1113', 'Bollería y repostería', '1110', Enum::"JMC Category Type"::CA);
        AddCategory('1120', 'Bocadillos y montados', '', Enum::"JMC Category Type"::CA);
        AddCategory('1121', 'Bocadillos y sándwiches', '1120', Enum::"JMC Category Type"::CA);
        AddCategory('1122', 'Montados y tostas', '1120', Enum::"JMC Category Type"::CA);
        AddCategory('1130', 'Menús cerrados', '', Enum::"JMC Category Type"::CA);
        AddCategory('1131', 'Menús y precios cerrados de evento', '1130', Enum::"JMC Category Type"::CA);
        AddCategory('1132', 'Menús guarderías y colectividades', '1130', Enum::"JMC Category Type"::CA);
        AddCategory('1133', 'Menús especiales', '1130', Enum::"JMC Category Type"::CA);
        AddCategory('1140', 'Menaje', '', Enum::"JMC Category Type"::CA);
        AddCategory('1141', 'Kits de menaje', '1140', Enum::"JMC Category Type"::CA);
        AddCategory('1142', 'Mantelería y material de servicio', '1140', Enum::"JMC Category Type"::CA);
        AddCategory('1150', 'Cocktails cerrados', '', Enum::"JMC Category Type"::CA);
        AddCategory('1151', 'Cocktails cerrados', '1150', Enum::"JMC Category Type"::CA);
        AddCategory('1152', 'Buffets y show cooking', '1150', Enum::"JMC Category Type"::CA);
        AddCategory('1160', 'Servicios y otros', '', Enum::"JMC Category Type"::CA);
        AddCategory('1161', 'Servicios de evento', '1160', Enum::"JMC Category Type"::CA);
        AddCategory('1162', 'Suplementos y descuentos', '1160', Enum::"JMC Category Type"::CA);
        AddCategory('1163', 'Anticipos', '1160', Enum::"JMC Category Type"::CA);
        AddCategory('1164', 'Venta de materia prima', '1160', Enum::"JMC Category Type"::CA);
        AddCategory('1165', 'Otros conceptos', '1160', Enum::"JMC Category Type"::CA);
        AddCategory('2100', 'Salsas y aliños', '', Enum::"JMC Category Type"::PT);
        AddCategory('2110', 'Salsas frías', '2100', Enum::"JMC Category Type"::PT);
        AddCategory('2120', 'Salsas cocinadas', '2100', Enum::"JMC Category Type"::PT);
        AddCategory('2130', 'Salsas picantes', '2100', Enum::"JMC Category Type"::PT);
        AddCategory('2140', 'Aliños y vinagretas', '2100', Enum::"JMC Category Type"::PT);
        AddCategory('2150', 'Cremosos y untables', '2100', Enum::"JMC Category Type"::PT);
        AddCategory('2200', 'Caldos y bases', '', Enum::"JMC Category Type"::PT);
        AddCategory('2210', 'Caldos concentrados', '2200', Enum::"JMC Category Type"::PT);
        AddCategory('2220', 'Bases y sofritos', '2200', Enum::"JMC Category Type"::PT);
        AddCategory('2230', 'Preparados para arroz', '2200', Enum::"JMC Category Type"::PT);
        AddCategory('2300', 'Arroces, pastas y migas', '', Enum::"JMC Category Type"::PT);
        AddCategory('2310', 'Arroces', '2300', Enum::"JMC Category Type"::PT);
        AddCategory('2320', 'Pastas y lasañas', '2300', Enum::"JMC Category Type"::PT);
        AddCategory('2330', 'Migas', '2300', Enum::"JMC Category Type"::PT);
        AddCategory('2400', 'Carnes cocinadas', '', Enum::"JMC Category Type"::PT);
        AddCategory('2410', 'Cerdo', '2400', Enum::"JMC Category Type"::PT);
        AddCategory('2420', 'Vacuno', '2400', Enum::"JMC Category Type"::PT);
        AddCategory('2430', 'Pollo', '2400', Enum::"JMC Category Type"::PT);
        AddCategory('2440', 'Asados y otras carnes', '2400', Enum::"JMC Category Type"::PT);
        AddCategory('2500', 'Croquetas y rebozados', '', Enum::"JMC Category Type"::PT);
        AddCategory('2510', 'Croquetas', '2500', Enum::"JMC Category Type"::PT);
        AddCategory('2520', 'Fingers y rebozados', '2500', Enum::"JMC Category Type"::PT);
        AddCategory('2530', 'Albóndigas, hamburguesas y salchichas', '2500', Enum::"JMC Category Type"::PT);
        AddCategory('2600', 'Verduras y legumbres', '', Enum::"JMC Category Type"::PT);
        AddCategory('2610', 'Verduras cocinadas', '2600', Enum::"JMC Category Type"::PT);
        AddCategory('2620', 'Legumbres', '2600', Enum::"JMC Category Type"::PT);
        AddCategory('2630', 'Cremas y gazpachos', '2600', Enum::"JMC Category Type"::PT);
        AddCategory('2640', 'Encurtidos y cebolla caramelizada', '2600', Enum::"JMC Category Type"::PT);
        AddCategory('2700', 'Platos preparados', '', Enum::"JMC Category Type"::PT);
        AddCategory('2710', 'Cocina tradicional', '2700', Enum::"JMC Category Type"::PT);
        AddCategory('2720', 'Recetas internacionales', '2700', Enum::"JMC Category Type"::PT);
        AddCategory('2730', 'Ensaladas y bowls', '2700', Enum::"JMC Category Type"::PT);
        AddCategory('2800', 'Postres', '', Enum::"JMC Category Type"::PT);
        AddCategory('2810', 'Postres', '2800', Enum::"JMC Category Type"::PT);
        AddCategory('2900', 'Otros productos', '', Enum::"JMC Category Type"::PT);
        AddCategory('2910', 'Sazonadores', '2900', Enum::"JMC Category Type"::PT);
        AddCategory('2920', 'Conservas en aceite', '2900', Enum::"JMC Category Type"::PT);
        AddCategory('3100', 'Salsas y aliños', '', Enum::"JMC Category Type"::PI);
        AddCategory('3110', 'Salsas', '3100', Enum::"JMC Category Type"::PI);
        AddCategory('3120', 'Aliños y vinagretas', '3100', Enum::"JMC Category Type"::PI);
        AddCategory('3200', 'Caldos y concentrados', '', Enum::"JMC Category Type"::PI);
        AddCategory('3210', 'Caldos', '3200', Enum::"JMC Category Type"::PI);
        AddCategory('3220', 'Concentrados y potenciadores', '3200', Enum::"JMC Category Type"::PI);
        AddCategory('3300', 'Adobos y rebozados', '', Enum::"JMC Category Type"::PI);
        AddCategory('3310', 'Adobos y marinadas', '3300', Enum::"JMC Category Type"::PI);
        AddCategory('3320', 'Sazonadores y mezclas', '3300', Enum::"JMC Category Type"::PI);
        AddCategory('3330', 'Tempuras y empanados', '3300', Enum::"JMC Category Type"::PI);
        AddCategory('3340', 'Salmueras y encurtidos', '3300', Enum::"JMC Category Type"::PI);
        AddCategory('3400', 'Carnes', '', Enum::"JMC Category Type"::PI);
        AddCategory('3410', 'Carnes marinadas', '3400', Enum::"JMC Category Type"::PI);
        AddCategory('3420', 'Carnes cocinadas', '3400', Enum::"JMC Category Type"::PI);
        AddCategory('3430', 'Masas cárnicas', '3400', Enum::"JMC Category Type"::PI);
        AddCategory('3440', 'Asados', '3400', Enum::"JMC Category Type"::PI);
        AddCategory('3500', 'Verduras y legumbres', '', Enum::"JMC Category Type"::PI);
        AddCategory('3510', 'Verduras cortadas', '3500', Enum::"JMC Category Type"::PI);
        AddCategory('3520', 'Verduras cocinadas', '3500', Enum::"JMC Category Type"::PI);
        AddCategory('3530', 'Patata', '3500', Enum::"JMC Category Type"::PI);
        AddCategory('3540', 'Legumbres cocidas', '3500', Enum::"JMC Category Type"::PI);
        AddCategory('3600', 'Arroces, pastas y masas', '', Enum::"JMC Category Type"::PI);
        AddCategory('3610', 'Arroces y bases de paella', '3600', Enum::"JMC Category Type"::PI);
        AddCategory('3620', 'Pastas', '3600', Enum::"JMC Category Type"::PI);
        AddCategory('3630', 'Masas de croquetas y migas', '3600', Enum::"JMC Category Type"::PI);
        AddCategory('3700', 'Rellenos', '', Enum::"JMC Category Type"::PI);
        AddCategory('3710', 'Rellenos salados', '3700', Enum::"JMC Category Type"::PI);
        AddCategory('3720', 'Rellenos dulces', '3700', Enum::"JMC Category Type"::PI);
        AddCategory('3900', 'Otros intermedios', '', Enum::"JMC Category Type"::PI);
        AddCategory('3910', 'Otros', '3900', Enum::"JMC Category Type"::PI);
        AddCategory('4100', 'Carnes', '', Enum::"JMC Category Type"::MP);
        AddCategory('4110', 'Cerdo', '4100', Enum::"JMC Category Type"::MP);
        AddCategory('4120', 'Vacuno', '4100', Enum::"JMC Category Type"::MP);
        AddCategory('4130', 'Pollo y aves', '4100', Enum::"JMC Category Type"::MP);
        AddCategory('4140', 'Cordero y cabrito', '4100', Enum::"JMC Category Type"::MP);
        AddCategory('4150', 'Casquería', '4100', Enum::"JMC Category Type"::MP);
        AddCategory('4160', 'Embutidos y curados', '4100', Enum::"JMC Category Type"::MP);
        AddCategory('4190', 'Otras carnes', '4100', Enum::"JMC Category Type"::MP);
        AddCategory('4200', 'Pescados y mariscos', '', Enum::"JMC Category Type"::MP);
        AddCategory('4210', 'Pescados', '4200', Enum::"JMC Category Type"::MP);
        AddCategory('4220', 'Mariscos', '4200', Enum::"JMC Category Type"::MP);
        AddCategory('4230', 'Pulpo, calamar y sepia', '4200', Enum::"JMC Category Type"::MP);
        AddCategory('4300', 'Frutas y verduras', '', Enum::"JMC Category Type"::MP);
        AddCategory('4310', 'Verduras frescas', '4300', Enum::"JMC Category Type"::MP);
        AddCategory('4320', 'Verduras congeladas', '4300', Enum::"JMC Category Type"::MP);
        AddCategory('4330', 'Frutas', '4300', Enum::"JMC Category Type"::MP);
        AddCategory('4340', 'Patatas', '4300', Enum::"JMC Category Type"::MP);
        AddCategory('4350', 'Hierbas y brotes', '4300', Enum::"JMC Category Type"::MP);
        AddCategory('4400', 'Lácteos y huevos', '', Enum::"JMC Category Type"::MP);
        AddCategory('4410', 'Leche y nata', '4400', Enum::"JMC Category Type"::MP);
        AddCategory('4420', 'Quesos', '4400', Enum::"JMC Category Type"::MP);
        AddCategory('4430', 'Huevos', '4400', Enum::"JMC Category Type"::MP);
        AddCategory('4440', 'Otros lácteos', '4400', Enum::"JMC Category Type"::MP);
        AddCategory('4500', 'Despensa', '', Enum::"JMC Category Type"::MP);
        AddCategory('4510', 'Arroces', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4520', 'Pastas', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4530', 'Legumbres', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4540', 'Harinas y féculas', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4550', 'Frutos secos y semillas', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4560', 'Azúcar y edulcorantes', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4570', 'Aceites y grasas', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4580', 'Conservas y encurtidos', '4500', Enum::"JMC Category Type"::MP);
        AddCategory('4600', 'Condimentos y aditivos', '', Enum::"JMC Category Type"::MP);
        AddCategory('4610', 'Especias', '4600', Enum::"JMC Category Type"::MP);
        AddCategory('4620', 'Sal y vinagres', '4600', Enum::"JMC Category Type"::MP);
        AddCategory('4630', 'Salsas comerciales', '4600', Enum::"JMC Category Type"::MP);
        AddCategory('4640', 'Caldos comerciales', '4600', Enum::"JMC Category Type"::MP);
        AddCategory('4650', 'Aditivos', '4600', Enum::"JMC Category Type"::MP);
        AddCategory('4660', 'Aromas y colorantes', '4600', Enum::"JMC Category Type"::MP);
        AddCategory('4700', 'Panadería y postres', '', Enum::"JMC Category Type"::MP);
        AddCategory('4710', 'Pan', '4700', Enum::"JMC Category Type"::MP);
        AddCategory('4720', 'Bollería y pastelería', '4700', Enum::"JMC Category Type"::MP);
        AddCategory('4730', 'Postres y helados', '4700', Enum::"JMC Category Type"::MP);
        AddCategory('4740', 'Galletas y dulces', '4700', Enum::"JMC Category Type"::MP);
        AddCategory('4800', 'Bebidas', '', Enum::"JMC Category Type"::MP);
        AddCategory('4810', 'Agua', '4800', Enum::"JMC Category Type"::MP);
        AddCategory('4820', 'Refrescos y zumos', '4800', Enum::"JMC Category Type"::MP);
        AddCategory('4830', 'Cervezas', '4800', Enum::"JMC Category Type"::MP);
        AddCategory('4840', 'Vinos y cavas', '4800', Enum::"JMC Category Type"::MP);
        AddCategory('4850', 'Licores', '4800', Enum::"JMC Category Type"::MP);
        AddCategory('4860', 'Bebidas para cocina', '4800', Enum::"JMC Category Type"::MP);
        AddCategory('4870', 'Café e infusiones', '4800', Enum::"JMC Category Type"::MP);
        AddCategory('4900', 'Precocinados y snacks', '', Enum::"JMC Category Type"::MP);
        AddCategory('4910', 'Precocinados', '4900', Enum::"JMC Category Type"::MP);
        AddCategory('4920', 'Snacks', '4900', Enum::"JMC Category Type"::MP);
        AddCategory('5100', 'Envases', '', Enum::"JMC Category Type"::MA);
        AddCategory('5110', 'Bandejas y barquetas', '5100', Enum::"JMC Category Type"::MA);
        AddCategory('5120', 'Tarrinas y botes', '5100', Enum::"JMC Category Type"::MA);
        AddCategory('5130', 'Frascos, botellas y latas', '5100', Enum::"JMC Category Type"::MA);
        AddCategory('5140', 'Tapas y tapones', '5100', Enum::"JMC Category Type"::MA);
        AddCategory('5150', 'Bolsas de vacío y cocción', '5100', Enum::"JMC Category Type"::MA);
        AddCategory('5160', 'Films', '5100', Enum::"JMC Category Type"::MA);
        AddCategory('5200', 'Embalaje y etiquetado', '', Enum::"JMC Category Type"::MA);
        AddCategory('5210', 'Cajas y estuches', '5200', Enum::"JMC Category Type"::MA);
        AddCategory('5220', 'Sleeves', '5200', Enum::"JMC Category Type"::MA);
        AddCategory('5230', 'Palets y film de paletizar', '5200', Enum::"JMC Category Type"::MA);
        AddCategory('5240', 'Etiquetas', '5200', Enum::"JMC Category Type"::MA);
        AddCategory('5250', 'Consumibles de impresión', '5200', Enum::"JMC Category Type"::MA);
        AddCategory('5300', 'Menaje desechable', '', Enum::"JMC Category Type"::MA);
        AddCategory('5310', 'Platos', '5300', Enum::"JMC Category Type"::MA);
        AddCategory('5320', 'Cubiertos', '5300', Enum::"JMC Category Type"::MA);
        AddCategory('5330', 'Servilletas', '5300', Enum::"JMC Category Type"::MA);
        AddCategory('5340', 'Vasos', '5300', Enum::"JMC Category Type"::MA);
        AddCategory('5350', 'Mantelería y blondas', '5300', Enum::"JMC Category Type"::MA);
        AddCategory('5360', 'Menaje cocktail', '5300', Enum::"JMC Category Type"::MA);
        AddCategory('5400', 'Limpieza e higiene', '', Enum::"JMC Category Type"::MA);
        AddCategory('5410', 'Productos químicos', '5400', Enum::"JMC Category Type"::MA);
        AddCategory('5420', 'Útiles de limpieza', '5400', Enum::"JMC Category Type"::MA);
        AddCategory('5430', 'Papel e higiene', '5400', Enum::"JMC Category Type"::MA);
        AddCategory('5440', 'Plagas y control de calidad', '5400', Enum::"JMC Category Type"::MA);
        AddCategory('5500', 'Vestuario y EPIs', '', Enum::"JMC Category Type"::MA);
        AddCategory('5510', 'Ropa de trabajo', '5500', Enum::"JMC Category Type"::MA);
        AddCategory('5520', 'EPIs y desechables', '5500', Enum::"JMC Category Type"::MA);
        AddCategory('5600', 'Utensilios', '', Enum::"JMC Category Type"::MA);
        AddCategory('5610', 'Utensilios de cocina', '5600', Enum::"JMC Category Type"::MA);
        AddCategory('5620', 'Recipientes y contenedores', '5600', Enum::"JMC Category Type"::MA);
        AddCategory('5700', 'Energía y gases', '', Enum::"JMC Category Type"::MA);
        AddCategory('5710', 'Gas butano', '5700', Enum::"JMC Category Type"::MA);
        AddCategory('5720', 'Gas para envasado', '5700', Enum::"JMC Category Type"::MA);
        AddCategory('5900', 'Otros auxiliares', '', Enum::"JMC Category Type"::MA);
        AddCategory('5910', 'Material de oficina', '5900', Enum::"JMC Category Type"::MA);
        AddCategory('5990', 'Otros', '5900', Enum::"JMC Category Type"::MA);
        AddCategory('6100', 'Servicios', '', Enum::"JMC Category Type"::SER);
        AddCategory('6110', 'Desarrollo', '6100', Enum::"JMC Category Type"::SER);
        AddCategory('6120', 'Transporte y logística', '6100', Enum::"JMC Category Type"::SER);
        AddCategory('6130', 'Rappels y penalizaciones', '6100', Enum::"JMC Category Type"::SER);
        AddCategory('6140', 'Suministros y servicios externos', '6100', Enum::"JMC Category Type"::SER);
        AddCategory('6190', 'Otros servicios', '6100', Enum::"JMC Category Type"::SER);
        AddCategory('7100', 'Consumo interno', '', Enum::"JMC Category Type"::CI);
        AddCategory('7110', 'Recortes y aprovechamientos', '7100', Enum::"JMC Category Type"::CI);
        AddCategory('7120', 'Comida de personal', '7100', Enum::"JMC Category Type"::CI);
        AddCategory('7130', 'Muestras y degustaciones', '7100', Enum::"JMC Category Type"::CI);
        AddCategory('8100', 'Pruebas', '', Enum::"JMC Category Type"::PR);
        AddCategory('8110', 'Productos en prueba', '8100', Enum::"JMC Category Type"::PR);
        AddCategory('9100', 'Distribución (histórico)', '', Enum::"JMC Category Type"::DI);
        AddCategory('9110', 'Alimentación', '9100', Enum::"JMC Category Type"::DI);
        AddCategory('9120', 'No alimentación', '9100', Enum::"JMC Category Type"::DI);
    end;

    var
        TempItemCategory: Record "Item Category" temporary;
        PreviewOnly: Boolean;
        CreatedCount: Integer;
        UpdatedCount: Integer;
        UnchangedCount: Integer;
        PreviewMsg: Label 'Simulation only. No data was changed.\Categories to create: %1\Categories to update: %2\Unchanged categories: %3', Comment = 'ESP="Solo simulación. No se han modificado datos.\Categorías que se crearían: %1\Categorías que se actualizarían: %2\Categorías sin cambios: %3"';
        ConfirmUpdateQst: Label 'Create %1 categories and update %2 categories? %3 categories are unchanged. Changing category parents can affect inherited item attributes.', Comment = 'ESP="¿Crear %1 categorías y actualizar %2 categorías? %3 categorías no tienen cambios. Cambiar categorías padre puede afectar a los atributos heredados de los productos."';
        CompletedMsg: Label 'Categories updated.\Created: %1\Updated: %2\Unchanged: %3', Comment = 'ESP="Categorías actualizadas.\Creadas: %1\Actualizadas: %2\Sin cambios: %3"';
}
