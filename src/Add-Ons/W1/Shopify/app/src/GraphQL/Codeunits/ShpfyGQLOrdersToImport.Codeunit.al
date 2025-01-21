namespace Microsoft.Integration.Shopify;

/// <summary>
/// Codeunit Shpfy GQL OrdersToImport (ID 30145) implements Interface Shpfy IGraphQL.
/// </summary>
codeunit 30145 "Shpfy GQL OrdersToImport" implements "Shpfy IGraphQL"
{
    Access = Internal;

    /// <summary>
    /// GetGraphQL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetGraphQL(): Text
    begin
        exit('{"query": "{orders(first:25, query: \"updated_at:>''{{Time}}''\"){pageInfo{hasNextPage} edges{cursor node{legacyResourceId name createdAt updatedAt channel { name } test fullyPaid unpaid closed displayFinancialStatus displayFulfillmentStatus subtotalLineItemsQuantity totalPriceSet{shopMoney{amount currencyCode}} customAttributes{key value} tags risk { assessments { riskLevel }} displayAddress { countryCode } shippingAddress { countryCode } billingAddress { countryCode } totalTaxSet { presentmentMoney { amount } shopMoney { amount } } purchasingEntity { ... on PurchasingCompany { company { id }}}}}}}"}');
    end;

    /// <summary>
    /// GetExpectedCost.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    internal procedure GetExpectedCost(): Integer
    begin
        exit(153);
    end;
}
