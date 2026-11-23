codeunit 53329 "JMC Item Class. Subscribers"
{
    EventSubscriberInstance = Manual;

    // Bound only by the item classification update so the standard per-item attribute confirmation is not shown.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Attribute Management", 'OnBeforeInheritAttributesFromItemCategory', '', false, false)]
    local procedure SkipAttributeInheritance(var Handle: Boolean)
    begin
        Handle := true;
    end;
}
