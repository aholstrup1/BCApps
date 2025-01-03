namespace Microsoft.Integration.Shopify;

using Microsoft.Utilities;

codeunit 30203 "Company Details Checklist Item"
{
    Access = Internal;

    trigger OnRun()
    begin
        Page.Run(Page::"Assisted Company Setup Wizard"); // Test
    end;
}
