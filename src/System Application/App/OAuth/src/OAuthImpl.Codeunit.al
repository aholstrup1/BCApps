// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.Authentication;

using System;

codeunit 1289 "OAuth Impl."
{
    Access = Internal;
    SingleInstance = false;
    InherentEntitlements = X;
    InherentPermissions = X;

    var
        TelemetrySecurityTok: Label 'AL Security', Locked = true;
        WeakHashFunctionTxt: Label 'Use of weak hash function', Locked = true;

    [TryFunction]
    procedure GetRequestToken(ConsumerKey: SecretText; ConsumerSecret: SecretText; RequestTokenUrl: Text; CallbackUrl: Text; var AccessTokenKey: SecretText; var AccessTokenSecret: SecretText)
    var
        OAuthAuthorization: DotNet OAuthAuthorization;
        Consumer: DotNet Consumer;
        Token: DotNet Token;
        RequestToken: DotNet Token;
        EmptySecretText: SecretText;
    begin
        Token := Token.Token(EmptySecretText, EmptySecretText);
        Consumer := Consumer.Consumer(ConsumerKey, ConsumerSecret);
        OAuthAuthorization := OAuthAuthorization.OAuthAuthorization(Consumer, Token);

        RequestToken := OAuthAuthorization.GetRequestToken(RequestTokenUrl, CallbackUrl);

        AccessTokenKey := RequestToken.TokenKey();
        AccessTokenSecret := RequestToken.TokenSecret();
    end;

    [TryFunction]
    procedure GetAccessToken(ConsumerKey: SecretText; ConsumerSecret: SecretText; RequestTokenUrl: Text; Verifier: Text; RequestTokenKey: SecretText; RequestTokenSecret: SecretText; var AccessTokenKey: SecretText; var AccessTokenSecret: SecretText)
    var
        OAuthAuthorization: DotNet OAuthAuthorization;
        Consumer: DotNet Consumer;
        RequestToken: DotNet Token;
        AccessToken: DotNet Token;
    begin
        RequestToken := RequestToken.Token(RequestTokenKey, RequestTokenSecret);
        Consumer := Consumer.Consumer(ConsumerKey, ConsumerSecret);
        OAuthAuthorization := OAuthAuthorization.OAuthAuthorization(Consumer, RequestToken);

        AccessToken := OAuthAuthorization.GetAccessToken(RequestTokenUrl, Verifier);

        AccessTokenKey := AccessToken.TokenKey();
        AccessTokenSecret := AccessToken.TokenSecret();
    end;

    [TryFunction]
    procedure GetAuthorizationHeader(ConsumerKey: SecretText; ConsumerSecret: SecretText; RequestTokenKey: SecretText; RequestTokenSecret: SecretText; RequestUrl: Text; RequestMethod: Enum "Http Request Type"; var AuthorizationHeader: SecretText)
    var
        OAuthAuthorization: DotNet OAuthAuthorization;
        Consumer: DotNet Consumer;
        RequestToken: DotNet Token;
    begin
        RequestToken := RequestToken.Token(RequestTokenKey, RequestTokenSecret);
        Consumer := Consumer.Consumer(ConsumerKey, ConsumerSecret);
        OAuthAuthorization := OAuthAuthorization.OAuthAuthorization(Consumer, RequestToken);

        case RequestMethod of
            RequestMethod::GET:
                AuthorizationHeader := OAuthAuthorization.GetAuthorizationHeader(RequestUrl, 'GET');
            RequestMethod::POST:
                AuthorizationHeader := OAuthAuthorization.GetAuthorizationHeader(RequestUrl, 'POST');
            RequestMethod::PATCH:
                AuthorizationHeader := OAuthAuthorization.GetAuthorizationHeader(RequestUrl, 'PATCH');
            RequestMethod::PUT:
                AuthorizationHeader := OAuthAuthorization.GetAuthorizationHeader(RequestUrl, 'PUT');
            RequestMethod::DELETE:
                AuthorizationHeader := OAuthAuthorization.GetAuthorizationHeader(RequestUrl, 'DELETE');
        end;
        Session.LogMessage('0000ED2', WeakHashFunctionTxt, Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', TelemetrySecurityTok);
    end;

}
