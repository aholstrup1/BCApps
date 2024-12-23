namespace Microsoft.Integration.Shopify;

/// <summary>
/// Codeunit Shpfy GQL Customer (ID 30127) implements Interface Shpfy IGraphQL.
/// </summary>
codeunit 30127 "Shpfy GQL Customer" implements "Shpfy IGraphQL"
{
    Access = Internal;

    /// <summary>
    /// GetGraphQL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetGraphQL(): Text
    begin
        exit('{"query":"{customer(id: \"gid://shopify/Customer/{{CustomerId}}\") {legacyResourceId firstName lastName email phone taxExempt taxExemptions verifiedEmail state note createdAt updatedAt tags emailMarketingConsent {consentUpdatedAt marketingState} addresses {id company firstName lastName address1 address2 zip city countryCodeV2 country provinceCode province phone} defaultAddress {id} metafields(first: 50) {edges {node {id namespace ownerType legacyResourceId key value type}}}}}"}');
    end;

    /// <summary>
    /// GetExpectedCost.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    internal procedure GetExpectedCost(): Integer
    begin
        exit(15);
    end;
}
