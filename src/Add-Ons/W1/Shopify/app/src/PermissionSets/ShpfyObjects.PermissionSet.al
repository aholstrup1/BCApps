namespace Microsoft.Integration.Shopify;

/// <summary>
/// Shpfy - Objects Permissions (ID 30104).
/// </summary>
permissionset 30104 "Shpfy - Objects"
{
    Access = Internal;
    Assignable = false;
    Caption = 'Shopify - Objects', MaxLength = 30;

    Permissions =
        table "Shpfy Bulk Operation" = X,
        table "Shpfy Catalog" = X,
        table "Shpfy Catalog Price" = X,
        table "Shpfy Company" = X,
        table "Shpfy Company Location" = X,
        table "Shpfy Credit Card Company" = X,
        table "Shpfy Cue" = X,
        table "Shpfy Customer" = X,
        table "Shpfy Customer Address" = X,
        table "Shpfy Customer Template" = X,
        table "Shpfy Data Capture" = X,
        table "Shpfy Dispute" = X,
        table "Shpfy Doc. Link To Doc." = X,
        table "Shpfy Fulfillment Line" = X,
        table "Shpfy FulFillment Order Header" = X,
        table "Shpfy FulFillment Order Line" = X,
        table "Shpfy Gift Card" = X,
        table "Shpfy Initial Import Line" = X,
        table "Shpfy Inventory Item" = X,
        table "Shpfy Invoice Header" = X,
        table "Shpfy Log Entry" = X,
        table "Shpfy Metafield" = X,
        table "Shpfy Order Attribute" = X,
        table "Shpfy Order Disc.Appl." = X,
        table "Shpfy Order Fulfillment" = X,
        table "Shpfy Order Header" = X,
        table "Shpfy Order Line" = X,
        table "Shpfy Order Line Attribute" = X,
        table "Shpfy Order Payment Gateway" = X,
        table "Shpfy Order Risk" = X,
        table "Shpfy Order Shipping Charges" = X,
        table "Shpfy Order Tax Line" = X,
        table "Shpfy Order Transaction" = X,
        table "Shpfy Orders to Import" = X,
        table "Shpfy Payment Method Mapping" = X,
        table "Shpfy Payment Terms" = X,
        table "Shpfy Payment Transaction" = X,
        table "Shpfy Payout" = X,
        table "Shpfy Product" = X,
        table "Shpfy Refund Header" = X,
        table "Shpfy Refund Line" = X,
        table "Shpfy Refund Shipping Line" = X,
        table "Shpfy Registered Store New" = X,
        table "Shpfy Return Header" = X,
        table "Shpfy Return Line" = X,
        table "Shpfy Shipment Method Mapping" = X,
        table "Shpfy Shop" = X,
        table "Shpfy Shop Collection Map" = X,
        table "Shpfy Shop Inventory" = X,
        table "Shpfy Shop Location" = X,
        table "Shpfy Skipped Record" = X,
        table "Shpfy Suggest Payment" = X,
        table "Shpfy Synchronization Info" = X,
        table "Shpfy Tag" = X,
        table "Shpfy Tax Area" = X,
        table "Shpfy Translation" = X,
        table "Shpfy Transaction Gateway" = X,
        table "Shpfy Variant" = X,
        report "Shpfy Add Company to Shopify" = X,
        report "Shpfy Add Customer to Shopify" = X,
        report "Shpfy Add Item to Shopify" = X,
        report "Shpfy Create Location Filter" = X,
        report "Shpfy Create Sales Orders" = X,
        report "Shpfy Suggest Payments" = X,
        report "Shpfy Sync Catalog Prices" = X,
        report "Shpfy Sync Catalogs" = X,
        report "Shpfy Sync Companies" = X,
        report "Shpfy Sync Countries" = X,
        report "Shpfy Sync Customers" = X,
        report "Shpfy Sync Disputes" = X,
        report "Shpfy Sync Images" = X,
        report "Shpfy Sync Invoices to Shpfy" = X,
        report "Shpfy Sync Orders from Shopify" = X,
        report "Shpfy Sync Payments" = X,
        report "Shpfy Sync Products" = X,
        report "Shpfy Sync Shipm. to Shopify" = X,
        report "Shpfy Sync Stock to Shopify" = X,
        report "Shpfy Translator" = X,
        codeunit "Company Details Checklist Item" = X,
        codeunit "Shpfy Authentication Mgt." = X,
        codeunit "Shpfy Background Syncs" = X,
        codeunit "Shpfy Balance Today" = X,
        codeunit "Shpfy Base64" = X,
        codeunit "Shpfy BC Document Type Convert" = X,
        codeunit "Shpfy Bulk Operation API" = X,
        codeunit "Shpfy Bulk Operation Mgt." = X,
        codeunit "Shpfy Bulk UpdateProductImage" = X,
        codeunit "Shpfy Bulk UpdateProductPrice" = X,
        codeunit "Shpfy Can Have Stock" = X,
        codeunit "Shpfy Can Not Have Stock" = X,
        codeunit "Shpfy Catalog API" = X,
        codeunit "Shpfy Checklist Item List" = X,
        codeunit "Shpfy Communication Events" = X,
        codeunit "Shpfy Communication Mgt." = X,
        codeunit "Shpfy Comp. By Default Comp." = X,
        codeunit "Shpfy Comp. By Email/Phone" = X,
        codeunit "Shpfy Company API" = X,
        codeunit "Shpfy Company Export" = X,
        codeunit "Shpfy Company Import" = X,
        codeunit "Shpfy Company Mapping" = X,
        codeunit "Shpfy County Code" = X,
        codeunit "Shpfy County From Json Code" = X,
        codeunit "Shpfy County From Json Name" = X,
        codeunit "Shpfy County Name" = X,
        codeunit "Shpfy Create Customer" = X,
        codeunit "Shpfy Create Item" = X,
        codeunit "Shpfy Create Product" = X,
        codeunit "Shpfy Create Sales Doc. Refund" = X,
        codeunit "Shpfy CreateProdStatusActive" = X,
        codeunit "Shpfy CreateProdStatusDraft" = X,
        codeunit "Shpfy Create Transl. Product" = X,
        codeunit "Shpfy Cust. By Bill-to" = X,
        codeunit "Shpfy Cust. By Default Cust." = X,
        codeunit "Shpfy Cust. By Email/Phone" = X,
        codeunit "Shpfy Customer API" = X,
        codeunit "Shpfy Customer Events" = X,
        codeunit "Shpfy Customer Export" = X,
        codeunit "Shpfy Customer Import" = X,
        codeunit "Shpfy Customer Mapping" = X,
        codeunit "Shpfy Disabled Value" = X,
        codeunit "Shpfy Document Link Mgt." = X,
        codeunit "Shpfy Draft Orders API" = X,
        codeunit "Shpfy Export Shipments" = X,
        codeunit "Shpfy Filter Mgt." = X,
        codeunit "Shpfy Free Inventory" = X,
        codeunit "Shpfy Fulfillment API" = X,
        codeunit "Shpfy Fulfillment Orders API" = X,
        codeunit "Shpfy Gift Cards" = X,
        codeunit "Shpfy GQL AddProductImage" = X,
        codeunit "Shpfy GQL AllCustomerIds" = X,
        codeunit "Shpfy GQL ApiKey" = X,
        codeunit "Shpfy GQL BulkOperation" = X,
        codeunit "Shpfy GQL BulkOperations" = X,
        codeunit "Shpfy GQL BulkOpMutation" = X,
        codeunit "Shpfy GQL CatalogPrices" = X,
        codeunit "Shpfy GQL CatalogProducts" = X,
        codeunit "Shpfy GQL Catalogs" = X,
        codeunit "Shpfy GQL CloseOrder" = X,
        codeunit "Shpfy GQL Company" = X,
        codeunit "Shpfy GQL CompanyAssignConRole" = X,
        codeunit "Shpfy GQL CompanyAssignContact" = X,
        codeunit "Shpfy GQL CompanyAssignMainCon" = X,
        codeunit "Shpfy GQL CompanyIds" = X,
        codeunit "Shpfy GQL CompanyMetafieldIds" = X,
        codeunit "Shpfy GQL CreateCatalog" = X,
        codeunit "Shpfy GQL CreateFulfillmentSvc" = X,
        codeunit "Shpfy GQL CreatePriceList" = X,
        codeunit "Shpfy GQL CreatePublication" = X,
        codeunit "Shpfy GQL CreateUploadUrl" = X,
        codeunit "Shpfy GQL CreateWebhookSub" = X,
        codeunit "Shpfy GQL Customer" = X,
        codeunit "Shpfy GQL CustomerIds" = X,
        codeunit "Shpfy GQL CustomerMetafieldIds" = X,
        codeunit "Shpfy GQL DeleteWebhookSub" = X,
        codeunit "Shpfy GQL DeliveryMethods" = X,
        codeunit "Shpfy GQL DeliveryProfiles" = X,
        codeunit "Shpfy GQL DisputeById" = X,
        codeunit "Shpfy GQL Disputes" = X,
        codeunit "Shpfy GQL DraftOrderComplete" = X,
        codeunit "Shpfy GQL FFOrdersFromOrder" = X,
        codeunit "Shpfy GQL FindCustByEMail" = X,
        codeunit "Shpfy GQL FindCustByPhone" = X,
        codeunit "Shpfy GQL FindVariantByBarcode" = X,
        codeunit "Shpfy GQL FindVariantBySKU" = X,
        codeunit "Shpfy GQL Fulfill Order" = X,
        codeunit "Shpfy GQL Get Fulfillments" = X,
        codeunit "Shpfy GQL Get Next S. Channels" = X,
        codeunit "Shpfy GQL Get SalesChannels" = X,
        codeunit "Shpfy GQL GetProductImage" = X,
        codeunit "Shpfy GQL GetWebhookSubs" = X,
        codeunit "Shpfy GQL InventoryActivate" = X,
        codeunit "Shpfy GQL InventoryEntries" = X,
        codeunit "Shpfy GQL LocationGroups" = X,
        codeunit "Shpfy GQL LocationOrderLines" = X,
        codeunit "Shpfy GQL Locations" = X,
        codeunit "Shpfy GQL MarkOrderAsPaid" = X,
        codeunit "Shpfy GQL MetafieldDefinitions" = X,
        codeunit "Shpfy GQL MetafieldsSet" = X,
        codeunit "Shpfy GQL Modify Inventory" = X,
        codeunit "Shpfy GQL Next Locations" = X,
        codeunit "Shpfy GQL NextAllCustomerIds" = X,
        codeunit "Shpfy GQL NextCatalogPrices" = X,
        codeunit "Shpfy GQL NextCatalogProducts" = X,
        codeunit "Shpfy GQL NextCatalogs" = X,
        codeunit "Shpfy GQL NextCompanyIds" = X,
        codeunit "Shpfy GQL NextCustomerIds" = X,
        codeunit "Shpfy GQL NextDisputes" = X,
        codeunit "Shpfy GQL NextDeliveryMethods" = X,
        codeunit "Shpfy GQL NextDeliveryProfiles" = X,
        codeunit "Shpfy GQL NextFFOrdersFromOrd" = X,
        codeunit "Shpfy GQL NextFulfillmentLines" = X,
        codeunit "Shpfy GQL NextInvEntries" = X,
        codeunit "Shpfy GQL NextOpenFFOrderLines" = X,
        codeunit "Shpfy GQL NextOpenFFOrders" = X,
        codeunit "Shpfy GQL NextOpenOrdToImport" = X,
        codeunit "Shpfy GQL NextOrderLines" = X,
        codeunit "Shpfy GQL NextOrderReturns" = X,
        codeunit "Shpfy GQL NextOrdersToImport" = X,
        codeunit "Shpfy GQL NextPaymTransactions" = X,
        codeunit "Shpfy GQL NextPayouts" = X,
        codeunit "Shpfy GQL NextProductImages" = X,
        codeunit "Shpfy GQL NextRefundLines" = X,
        codeunit "Shpfy GQL NextReturnLines" = X,
        codeunit "Shpfy GQL NextRefundShipLines" = X,
        codeunit "Shpfy GQL NextShipmentLines" = X,
        codeunit "Shpfy GQL NextVariantIds" = X,
        codeunit "Shpfy GQL NextVariantImages" = X,
        codeunit "Shpfy GQL OpenFulfillmOrders" = X,
        codeunit "Shpfy GQL OpenFulfillmOrdLines" = X,
        codeunit "Shpfy GQL OpenOrdersToImport" = X,
        codeunit "Shpfy GQL OrderCancel" = X,
        codeunit "Shpfy GQL OrderFulfillment" = X,
        codeunit "Shpfy GQL OrderHeader" = X,
        codeunit "Shpfy GQL OrderLines" = X,
        codeunit "Shpfy GQL OrderRisks" = X,
        codeunit "Shpfy GQL OrderTransactions" = X,
        codeunit "Shpfy GQL OrdersToImport" = X,
        codeunit "Shpfy GQL Payment Terms" = X,
        codeunit "Shpfy GQL PaymentTransactions" = X,
        codeunit "Shpfy GQL Payouts" = X,
        codeunit "Shpfy GQL ProductById" = X,
        codeunit "Shpfy GQL ProductIds" = X,
        codeunit "Shpfy GQL ProductImages" = X,
        codeunit "Shpfy GQL ProductMetafieldIds" = X,
        codeunit "Shpfy GQL RefundHeader" = X,
        codeunit "Shpfy GQL RefundLines" = X,
        codeunit "Shpfy GQL RefundShippingLines" = X,
        codeunit "Shpfy GQL ReturnHeader" = X,
        codeunit "Shpfy GQL ReturnLines" = X,
        codeunit "Shpfy GQL ShipmentLines" = X,
        codeunit "Shpfy GQL ShipToCountries" = X,
        codeunit "Shpfy GQL ShopLocales" = X,
        codeunit "Shpfy GQL TranslationsRegister" = X,
        codeunit "Shpfy GQL TranslResource" = X,
        codeunit "Shpfy GQL UpdateCatalogPrices" = X,
        codeunit "Shpfy GQL UpdateOrderAttr" = X,
        codeunit "Shpfy GQL UpdateProductImage" = X,
        codeunit "Shpfy GQL VariantById" = X,
        codeunit "Shpfy GQL VariantIds" = X,
        codeunit "Shpfy GQL VariantImages" = X,
        codeunit "Shpfy GQL VariantMetafieldIds" = X,
        codeunit "Shpfy GraphQL Queries" = X,
        codeunit "Shpfy GraphQL Rate Limit" = X,
        codeunit "Shpfy Guided Experience" = X,
        codeunit "Shpfy Hash" = X,
        codeunit "Shpfy IDocSource Default" = X,
        codeunit "Shpfy IDocSource Refund" = X,
        codeunit "Shpfy Import Order" = X,
        codeunit "Shpfy Initial Import" = X,
#if not CLEAN24
        codeunit "Shpfy Install Mgt." = X,
#endif
        codeunit "Shpfy Installer" = X,
        codeunit "Shpfy Inventory API" = X,
        codeunit "Shpfy Inventory Events" = X,
        codeunit "Shpfy Item Reference Mgt." = X,
        codeunit "Shpfy Json Helper" = X,
        codeunit "Shpfy Log Entries Delete" = X,
        codeunit "Shpfy Math" = X,
        codeunit "Shpfy Metafield API" = X,
        codeunit "Shpfy Metafield Owner Company" = X,
        codeunit "Shpfy Metafield Owner Customer" = X,
        codeunit "Shpfy Metafield Owner Product" = X,
        codeunit "Shpfy Metafield Owner Variant" = X,
        codeunit "Shpfy Mtfld Type Boolean" = X,
        codeunit "Shpfy Mtfld Type Collect. Ref" = X,
        codeunit "Shpfy Mtfld Type Color" = X,
        codeunit "Shpfy Mtfld Type Company Ref" = X,
        codeunit "Shpfy Mtfld Type Customer Ref" = X,
        codeunit "Shpfy Mtfld Type Date" = X,
        codeunit "Shpfy Mtfld Type DateTime" = X,
        codeunit "Shpfy Mtfld Type Dimension" = X,
        codeunit "Shpfy Mtfld Type File Ref" = X,
        codeunit "Shpfy Mtfld Type Integer" = X,
        codeunit "Shpfy Mtfld Type Json" = X,
        codeunit "Shpfy Mtfld Type Metaobj. Ref" = X,
        codeunit "Shpfy Mtfld Type Mixed Ref" = X,
        codeunit "Shpfy Mtfld Type Money" = X,
        codeunit "Shpfy Mtfld Type Multi Text" = X,
        codeunit "Shpfy Mtfld Type Num Decimal" = X,
        codeunit "Shpfy Mtfld Type Num Integer" = X,
        codeunit "Shpfy Mtfld Type Page Ref" = X,
        codeunit "Shpfy Mtfld Type Product Ref" = X,
        codeunit "Shpfy Mtfld Type Single Text" = X,
        codeunit "Shpfy Mtfld Type String" = X,
        codeunit "Shpfy Mtfld Type Url" = X,
        codeunit "Shpfy Mtfld Type Variant Ref" = X,
        codeunit "Shpfy Mtfld Type Volume" = X,
        codeunit "Shpfy Mtfld Type Weight" = X,
        codeunit "Shpfy Name is CompanyName" = X,
        codeunit "Shpfy Name is Empty" = X,
        codeunit "Shpfy Name is First. LastName" = X,
        codeunit "Shpfy Name is Last. FirstName" = X,
        codeunit "Shpfy Open Order" = X,
        codeunit "Shpfy Open PostedReturnReceipt" = X,
        codeunit "Shpfy Open PostedSalesCrMemo" = X,
        codeunit "Shpfy Open PostedSalesInvoice" = X,
        codeunit "Shpfy Open Refund" = X,
        codeunit "Shpfy Open Return" = X,
        codeunit "Shpfy Open SalesCrMemo" = X,
        codeunit "Shpfy Open SalesInvoice" = X,
        codeunit "Shpfy Open SalesOrder" = X,
        codeunit "Shpfy Open SalesReturnOrder" = X,
        codeunit "Shpfy Open SalesShipment" = X,
        codeunit "Shpfy OpenBCDoc NotSupported" = X,
        codeunit "Shpfy OpenDoc NotSupported" = X,
        codeunit "Shpfy Order Events" = X,
        codeunit "Shpfy Order Fulfillments" = X,
        codeunit "Shpfy Order Mapping" = X,
        codeunit "Shpfy Order Mgt." = X,
        codeunit "Shpfy Order Risks" = X,
        codeunit "Shpfy Orders API" = X,
        codeunit "Shpfy Payment Terms API" = X,
        codeunit "Shpfy Payments" = X,
        codeunit "Shpfy Payments API" = X,
        codeunit "Shpfy Posted Invoice Export" = X,
        codeunit "Shpfy Process Order" = X,
        codeunit "Shpfy Process Orders" = X,
        codeunit "Shpfy Product API" = X,
        codeunit "Shpfy Product Events" = X,
        codeunit "Shpfy Product Export" = X,
        codeunit "Shpfy Product Image Export" = X,
        codeunit "Shpfy Product Import" = X,
        codeunit "Shpfy Product Mapping" = X,
        codeunit "Shpfy Product Price Calc." = X,
        codeunit "Shpfy Refund Enum Convertor" = X,
        codeunit "Shpfy Refund Process Events" = X,
        codeunit "Shpfy Refunds API" = X,
        codeunit "Shpfy RemoveProductDoNothing" = X,
        codeunit "Shpfy RetRefProc Cr.Memo" = X,
        codeunit "Shpfy RetRefProc Default" = X,
        codeunit "Shpfy RetRefProc ImportOnly" = X,
        codeunit "Shpfy Return Enum Convertor" = X,
        codeunit "Shpfy Returns API" = X,
        codeunit "Shpfy Sales Channel API" = X,
        codeunit "Shpfy Shipping Charges" = X,
        codeunit "Shpfy Shipping Events" = X,
        codeunit "Shpfy Shipping Methods" = X,
        codeunit "Shpfy Shop Mgt." = X,
        codeunit "Shpfy Skipped Record" = X,
        codeunit "Shpfy Suggest Payments" = X,
        codeunit "Shpfy Suppress Asm Warning" = X,
        codeunit "Shpfy Sync Catalog Prices" = X,
        codeunit "Shpfy Sync Companies" = X,
        codeunit "Shpfy Sync Countries" = X,
        codeunit "Shpfy Sync Customers" = X,
        codeunit "Shpfy Sync Inventory" = X,
        codeunit "Shpfy Sync Product Image" = X,
        codeunit "Shpfy Sync Products" = X,
        codeunit "Shpfy Sync Shop Locations" = X,
        codeunit "Shpfy ToArchivedProduct" = X,
        codeunit "Shpfy ToDraftProduct" = X,
        codeunit "Shpfy Translation API" = X,
        codeunit "Shpfy Translation Mgt." = X,
        codeunit "Shpfy Transactions" = X,
        codeunit "Shpfy Update Customer" = X,
        codeunit "Shpfy Update Item" = X,
        codeunit "Shpfy Update Price Source" = X,
        codeunit "Shpfy Update Sales Invoice" = X,
        codeunit "Shpfy Update Sales Shipment" = X,
        codeunit "Shpfy Upgrade Mgt." = X,
        codeunit "Shpfy Variant API" = X,
        codeunit "Shpfy Webhooks API" = X,
        codeunit "Shpfy Webhooks Mgt." = X,
        page "Shpfy Activities" = X,
        page "Shpfy Add Item Confirm" = X,
        page "Shpfy Authentication" = X,
        page "Shpfy Bulk Operations" = X,
        page "Shpfy Cancel Order" = X,
        page "Shpfy Catalogs" = X,
        page "Shpfy Companies" = X,
        page "Shpfy Company Card" = X,
        page "Shpfy Connector Guide" = X,
        page "Shpfy Credit Card Companies" = X,
        page "Shpfy Customer Adresses" = X,
        page "Shpfy Customer Card" = X,
        page "Shpfy Customer Templates" = X,
        page "Shpfy Customers" = X,
        page "Shpfy Data Capture List" = X,
        page "Shpfy Disputes" = X,
        page "Shpfy Fulfillment Order Card" = X,
        page "Shpfy Fulfillment Order Lines" = X,
        page "Shpfy Fulfillment Orders" = X,
        page "Shpfy Gift Card Transactions" = X,
        page "Shpfy Gift Cards" = X,
        page "Shpfy Initial Import" = X,
        page "Shpfy Inventory FactBox" = X,
        page "Shpfy Linked To Documents" = X,
        page "Shpfy Log Entries" = X,
        page "Shpfy Log Entry Card" = X,
        page "Shpfy Main Contact Factbox" = X,
        page "Shpfy Metafield Assist Edit" = X,
        page "Shpfy Metafields" = X,
        page "Shpfy Order" = X,
        page "Shpfy Order Attributes" = X,
        page "Shpfy Order Fulfillment" = X,
        page "Shpfy Order Fulfillment Lines" = X,
        page "Shpfy Order Fulfillments" = X,
        page "Shpfy Order Lines Attributes" = X,
        page "Shpfy Order Risks" = X,
        page "Shpfy Order Shipping Charges" = X,
        page "Shpfy Order Subform" = X,
        page "Shpfy Order Transactions" = X,
        page "Shpfy Orders" = X,
        page "Shpfy Orders to Import" = X,
        page "Shpfy Payment Methods Mapping" = X,
        page "Shpfy Payment Terms Mapping" = X,
        page "Shpfy Payment Transactions" = X,
        page "Shpfy Payouts" = X,
        page "Shpfy Products" = X,
        page "Shpfy Products Overview" = X,
        page "Shpfy Refund" = X,
        page "Shpfy Refund Lines" = X,
        page "Shpfy Refund Shipping Lines" = X,
        page "Shpfy Refunds" = X,
        page "Shpfy Return" = X,
        page "Shpfy Return Lines" = X,
        page "Shpfy Returns" = X,
        page "Shpfy Sales Channels" = X,
        page "Shpfy Shipment Methods Mapping" = X,
        page "Shpfy Shop Card" = X,
        page "Shpfy Shop Locations Mapping" = X,
        page "Shpfy Shop Selection" = X,
        page "Shpfy Shops" = X,
        page "Shpfy Skipped Records" = X,
        page "Shpfy Tag Factbox" = X,
        page "Shpfy Tags" = X,
        page "Shpfy Tax Areas" = X,
        page "Shpfy Languages" = X,
        page "Shpfy Transaction Gateways" = X,
        page "Shpfy Transactions" = X,
        page "Shpfy Variants" = X,
        query "Shpfy Shipment Location" = X;
}
