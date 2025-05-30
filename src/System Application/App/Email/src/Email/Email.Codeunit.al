// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Email;

/// <summary>
/// Provides functionality to create and send emails.
/// </summary>
codeunit 8901 Email
{
    Access = Public;

    #region SaveAsDraft

    /// <summary>
    /// Saves a draft email in the Outbox.
    /// </summary>
    /// <param name="EmailMessage">The email message to save.</param>
    procedure SaveAsDraft(EmailMessage: Codeunit "Email Message")
    begin
        EmailImpl.SaveAsDraft(EmailMessage);
    end;

    /// <summary>
    /// Saves a draft email in the Outbox.
    /// </summary>
    /// <param name="EmailMessage">The email message to save.</param>
    /// <param name="EmailOutbox">The created outbox entry.</param>
    procedure SaveAsDraft(EmailMessage: Codeunit "Email Message"; var EmailOutbox: Record "Email Outbox")
    begin
        EmailImpl.SaveAsDraft(EmailMessage, EmailOutbox);
    end;

    /// <summary>
    /// Saves a draft email in the Outbox.
    /// </summary>
    /// <param name="EmailMessage">The email message to save.</param>
    /// <param name="EmailAccountId">The email account ID for sending.</param>
    /// <param name="EmailConnector">The email connector for sending.</param>
    /// <param name="EmailOutbox">The created outbox entry.</param>
    procedure SaveAsDraft(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; var EmailOutbox: Record "Email Outbox")
    begin
        EmailImpl.SaveAsDraft(EmailMessage, EmailAccountId, EmailConnector, EmailOutbox);
    end;

    #endregion

    #region Enqueue

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <remarks>The default account will be used for sending the email.</remarks>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message")
    begin
        EmailImpl.Enqueue(EmailMessage, Enum::"Email Scenario"::Default, CurrentDateTime());
    end;

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <remarks>The default account will be used for sending the email.</remarks>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="NotBefore">The date and time for sending the email.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message"; NotBefore: DateTime)
    begin
        EmailImpl.Enqueue(EmailMessage, Enum::"Email Scenario"::Default, NotBefore);
    end;

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailScenario">The scenario to use in order to determine the email account to use for sending the email.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message"; EmailScenario: Enum "Email Scenario")
    begin
        EmailImpl.Enqueue(EmailMessage, EmailScenario, CurrentDateTime());
    end;

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailScenario">The scenario to use in order to determine the email account to use for sending the email.</param>
    /// <param name="NotBefore">The date and time for sending the email.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message"; EmailScenario: Enum "Email Scenario"; NotBefore: DateTime)
    begin
        EmailImpl.Enqueue(EmailMessage, EmailScenario, NotBefore);
    end;

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <remarks>Both "Account Id" and Connector fields need to be set on the <paramref name="EmailAccount"/> parameter.</remarks>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccount">The email account to use for sending the email.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message"; EmailAccount: Record "Email Account" temporary)
    begin
        EmailImpl.Enqueue(EmailMessage, EmailAccount."Account Id", EmailAccount.Connector, CurrentDateTime());
    end;

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccount">The email account to use for sending the email.</param>
    /// <param name="NotBefore">The earliest date and time for sending the email.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message"; EmailAccount: Record "Email Account" temporary; NotBefore: DateTime)
    begin
        EmailImpl.Enqueue(EmailMessage, EmailAccount."Account Id", EmailAccount.Connector, NotBefore);
    end;

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector")
    begin
        EmailImpl.Enqueue(EmailMessage, EmailAccountId, EmailConnector, CurrentDateTime());
    end;

    /// <summary>
    /// Enqueues an email to be sent in the background.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="NotBefore">The date and time for sending the email.</param>
    procedure Enqueue(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; NotBefore: DateTime)
    begin
        EmailImpl.Enqueue(EmailMessage, EmailAccountId, EmailConnector, NotBefore);
    end;

    #endregion

    #region Send

    /// <summary>
    /// Sends the email in the current session.
    /// </summary>
    /// <remarks>The default account will be used for sending the email.</remarks>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <returns>True if the email was successfully sent; otherwise - false.</returns>
    /// <error>The email message has already been queued.</error>
    /// <error>The email message has already been sent.</error>
    procedure Send(EmailMessage: Codeunit "Email Message"): Boolean
    begin
        exit(EmailImpl.Send(EmailMessage, Enum::"Email Scenario"::Default));
    end;

    /// <summary>
    /// Sends the email in the current session.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailScenario">The scenario to use in order to determine the email account to use for sending the email.</param>
    /// <returns>True if the email was successfully sent; otherwise - false.</returns>
    /// <error>The email message has already been queued.</error>
    /// <error>The email message has already been sent.</error>
    procedure Send(EmailMessage: Codeunit "Email Message"; EmailScenario: Enum "Email Scenario"): Boolean
    begin
        exit(EmailImpl.Send(EmailMessage, EmailScenario));
    end;

    /// <summary>
    /// Sends the email in the current session.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccount">The email account to use for sending the email.</param>
    /// <remarks>Both "Account Id" and Connector fields need to be set on the <paramref name="EmailAccount"/> parameter.</remarks>
    /// <returns>True if the email was successfully sent; otherwise - false</returns>
    /// <error>The email message has already been queued.</error>
    /// <error>The email message has already been sent.</error>
    procedure Send(EmailMessage: Codeunit "Email Message"; EmailAccount: Record "Email Account" temporary): Boolean
    begin
        exit(EmailImpl.Send(EmailMessage, EmailAccount."Account Id", EmailAccount.Connector));
    end;

    /// <summary>
    /// Sends the email in the current session.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <returns>True if the email was successfully sent; otherwise - false</returns>
    /// <error>The email message has already been queued.</error>
    /// <error>The email message has already been sent.</error>
    procedure Send(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"): Boolean
    begin
        exit(EmailImpl.Send(EmailMessage, EmailAccountId, EmailConnector));
    end;

    #endregion

    #region Reply
#if not CLEAN26
    /// <summary>
    /// Sends a reply to an external message id in the foreground.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="ExternalId">The external message id that is used to correlate and send the reply.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <returns>True if sent</returns>
    [Obsolete('Replaced by Reply without the ExternalId parameter. ExternalId is not used and is contained in the EmailMessage parameter.', '26.0')]
    procedure Reply(EmailMessage: Codeunit "Email Message"; ExternalId: Text; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"): Boolean
    begin
        exit(EmailImpl.Reply(EmailMessage, EmailAccountId, EmailConnector));
    end;

    /// <summary>
    /// Sends a reply to an external message id to all recipients on that email in the foreground.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="ExternalId">The external message id that is used to correlate and send the reply.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <returns>True if sent</returns>
    [Obsolete('Replaced by ReplyAll without the ExternalId parameter. ExternalId is not used and is contained in the EmailMessage parameter.', '26.0')]
    procedure ReplyAll(EmailMessage: Codeunit "Email Message"; ExternalId: Text; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"): Boolean
    begin
        exit(EmailImpl.ReplyAll(EmailMessage, EmailAccountId, EmailConnector));
    end;

    /// <summary>
    /// Sends a reply to an external message id in the background.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="ExternalId">The external message id that is used to correlate and send the reply.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="EmailOutbox">The email outbox which is set up for sending in the background.</param>
    [Obsolete('Replaced by EnqueueReply without the ExternalId parameter. ExternalId is not used and is contained in the EmailMessage parameter.', '26.0')]
    procedure EnqueueReply(EmailMessage: Codeunit "Email Message"; ExternalId: Text; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; var EmailOutbox: Record "Email Outbox")
    begin
        EmailImpl.Reply(EmailMessage, EmailAccountId, EmailConnector, EmailOutbox);
    end;

    /// <summary>
    /// Sends a reply to an external message id to all recipients on that email in the foreground.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="ExternalId">The external message id that is used to correlate and send the reply.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="EmailOutbox">The email outbox which is set up for sending in the background.</param>
    [Obsolete('Replaced by EnqueueReplyAll without the ExternalId parameter. ExternalId is not used and is contained in the EmailMessage parameter.', '26.0')]
    procedure EnqueueReplyAll(EmailMessage: Codeunit "Email Message"; ExternalId: Text; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; var EmailOutbox: Record "Email Outbox")
    begin
        EmailImpl.ReplyAll(EmailMessage, EmailAccountId, EmailConnector, EmailOutbox);
    end;
#endif

    /// <summary>
    /// Sends a reply to an external message id in the foreground.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <returns>True if sent</returns>
    procedure Reply(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"): Boolean
    begin
        exit(EmailImpl.Reply(EmailMessage, EmailAccountId, EmailConnector));
    end;

    /// <summary>
    /// Sends a reply to an external message id to all recipients on that email in the foreground.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <returns>True if sent</returns>
    procedure ReplyAll(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"): Boolean
    begin
        exit(EmailImpl.ReplyAll(EmailMessage, EmailAccountId, EmailConnector));
    end;

    /// <summary>
    /// Sends a reply to an external message id in the background.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="EmailOutbox">The email outbox which is set up for sending in the background.</param>
    procedure EnqueueReply(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; var EmailOutbox: Record "Email Outbox")
    begin
        EmailImpl.Reply(EmailMessage, EmailAccountId, EmailConnector, EmailOutbox);
    end;

    /// <summary>
    /// Sends a reply to an external message id to all recipients on that email in the foreground.
    /// </summary>
    /// <param name="EmailMessage">The email message with the details of the recipients and reply to be added.</param>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="EmailOutbox">The email outbox which is set up for sending in the background.</param>
    procedure EnqueueReplyAll(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; var EmailOutbox: Record "Email Outbox")
    begin
        EmailImpl.ReplyAll(EmailMessage, EmailAccountId, EmailConnector, EmailOutbox);
    end;

    #endregion

    #region RetrieveEmails
#if not CLEAN26
    /// <summary>
    /// Retrieves emails from the email account.
    /// </summary>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="EmailInbox">The return record of all new emails that were retrieved.</param>
    [Obsolete('Replaced by RetrieveEmails with an additional Filters parameter of type Record "Email Retrieval Filters".', '26.0')]
    procedure RetrieveEmails(EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; var EmailInbox: Record "Email Inbox")
    begin
        EmailImpl.RetrieveEmails(EmailAccountId, EmailConnector, EmailInbox);
    end;
#endif
    /// <summary>
    /// Retrieves emails from the email account.
    /// </summary>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="EmailInbox">The return record of all new emails that were retrieved.</param>
    /// <param name="Filters">Filters to be used when retrieving emails.</param>
    procedure RetrieveEmails(EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; var EmailInbox: Record "Email Inbox"; var Filters: Record "Email Retrieval Filters" temporary)
    begin
        EmailImpl.RetrieveEmails(EmailAccountId, EmailConnector, EmailInbox, Filters);
    end;

    #endregion

    #region MarkAsRead

    /// <summary>
    /// Marks the specified email as read.
    /// </summary>
    /// <param name="EmailAccountId">The ID of the email account to use for sending the email.</param>
    /// <param name="EmailConnector">The email connector to use for sending the email.</param>
    /// <param name="ExternalId">The external message id that is used to correlate and mark as read.</param>
    procedure MarkAsRead(EmailAccountId: Guid; EmailConnector: Enum "Email Connector"; ExternalId: Text)
    begin
        EmailImpl.MarkAsRead(EmailAccountId, EmailConnector, ExternalId);
    end;

    #endregion

    #region OpenInEditor

    /// <summary>
    /// Opens an email message in "Email Editor" page.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    procedure OpenInEditor(EmailMessage: Codeunit "Email Message")
    begin
        EmailImpl.OpenInEditor(EmailMessage, Enum::"Email Scenario"::Default, false);
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailScenario">The scenario to use in order to determine the email account to use  on the page.</param>
    procedure OpenInEditor(EmailMessage: Codeunit "Email Message"; EmailScenario: Enum "Email Scenario")
    begin
        EmailImpl.OpenInEditor(EmailMessage, EmailScenario, false);
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccount">The email account to fill in.</param>
    /// <remarks>Both "Account Id" and Connector fields need to be set on the <paramref name="EmailAccount"/> parameter.</remarks>
    procedure OpenInEditor(EmailMessage: Codeunit "Email Message"; EmailAccount: Record "Email Account" temporary)
    begin
        EmailImpl.OpenInEditor(EmailMessage, EmailAccount."Account Id", EmailAccount.Connector, false);
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccountId">The ID of the email account to use on the page.</param>
    /// <param name="EmailConnector">The email connector to use on the page.</param>
    procedure OpenInEditor(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector")
    begin
        EmailImpl.OpenInEditor(EmailMessage, EmailAccountId, EmailConnector, false);
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page modally.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <returns>The action that the user performed with the email message.</returns>
    procedure OpenInEditorModally(EmailMessage: Codeunit "Email Message"): Enum "Email Action"
    begin
        exit(EmailImpl.OpenInEditor(EmailMessage, Enum::"Email Scenario"::Default, true));
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page modally.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailScenario">The scenario to use in order to determine the email account to use  on the page.</param>
    /// <returns>The action that the user performed with the email message.</returns>
    procedure OpenInEditorModally(EmailMessage: Codeunit "Email Message"; EmailScenario: Enum "Email Scenario"): Enum "Email Action"
    begin
        exit(EmailImpl.OpenInEditor(EmailMessage, EmailScenario, true));
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page modally with scenario.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccount">The email account to fill in.</param>
    /// <param name="Scenario">The email scenario to fill in.</param>
    /// <remarks>Both "Account Id" and Connector fields need to be set on the <paramref name="EmailAccount"/> parameter.</remarks>
    /// <returns>The action that the user performed with the email message.</returns>
    procedure OpenInEditorModallyWithScenario(EmailMessage: Codeunit "Email Message"; EmailAccount: Record "Email Account" temporary; Scenario: Enum "Email Scenario"): Enum "Email Action"
    begin
        exit(EmailImpl.OpenInEditorWithScenario(EmailMessage, EmailAccount."Account Id", EmailAccount.Connector, true, Scenario));
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page modally.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccount">The email account to fill in.</param>
    /// <remarks>Both "Account Id" and Connector fields need to be set on the <paramref name="EmailAccount"/> parameter.</remarks>
    /// <returns>The action that the user performed with the email message.</returns>
    procedure OpenInEditorModally(EmailMessage: Codeunit "Email Message"; EmailAccount: Record "Email Account" temporary): Enum "Email Action"
    begin
        exit(EmailImpl.OpenInEditor(EmailMessage, EmailAccount."Account Id", EmailAccount.Connector, true));
    end;

    /// <summary>
    /// Opens an email message in "Email Editor" page modally.
    /// </summary>
    /// <param name="EmailMessage">The email message to use as payload.</param>
    /// <param name="EmailAccountId">The ID of the email account to use on the page.</param>
    /// <param name="EmailConnector">The email connector to use on the page.</param>
    /// <returns>The action that the user performed with the email message.</returns>
    procedure OpenInEditorModally(EmailMessage: Codeunit "Email Message"; EmailAccountId: Guid; EmailConnector: Enum "Email Connector"): Enum "Email Action"
    begin
        exit(EmailImpl.OpenInEditor(EmailMessage, EmailAccountId, EmailConnector, true));
    end;

    #endregion

    ///<summary>
    /// Gets the sent emails related to a record.
    ///</summary>
    ///<param name="TableId">The table ID of the record.</param>
    ///<param name="SystemId">The system ID of the record.</param>
    ///<returns>The sent email related to a record.</returns>
    procedure GetSentEmailsForRecord(TableId: Integer; SystemId: Guid; var ResultSentEmails: Record "Sent Email" temporary)
    begin
        EmailImpl.GetSentEmailsForRecord(TableId, SystemId, ResultSentEmails);
    end;

    ///<summary>
    /// Gets the sent emails related to a record.
    ///</summary>
    ///<param name="RecordVariant">Source Record.</param>
    ///<param name="ResultSentEmails">The sent email related to a record.</param>
    procedure GetSentEmailsForRecord(RecordVariant: Variant; var ResultSentEmails: Record "Sent Email" temporary);
    begin
        EmailImpl.GetSentEmailsForRecord(RecordVariant, ResultSentEmails);
    end;

    ///<summary>
    /// Gets the outbox emails related to a record.
    ///</summary>
    ///<param name="RecordVariant">Source record.</param>
    ///<param name="ResultEmailOutbox">The outbox emails related to a record.</param>
    procedure GetEmailOutboxForRecord(RecordVariant: Variant; var ResultEmailOutbox: Record "Email Outbox" temporary);
    begin
        EmailImpl.GetEmailOutboxForRecord(RecordVariant, ResultEmailOutbox);
    end;

    ///<summary>
    /// Open the sent emails page for a source record given by its table ID and system ID.
    ///</summary>
    ///<param name="TableId">The table ID of the record.</param>
    ///<param name="SystemId">The system ID of the record.</param>
    procedure OpenSentEmails(TableId: Integer; SystemId: Guid)
    begin
        EmailImpl.OpenSentEmails(TableId, SystemId);
    end;

    /// <summary>
    /// Open the sent emails page for a source record.
    /// </summary>
    /// <param name="RecordVariant">Source record. Can be either Record, RecordRef or RecordId.</param>
    procedure OpenSentEmails(RecordVariant: Variant)
    begin
        EmailImpl.OpenSentEmails(RecordVariant);
    end;

    ///<summary>
    /// Open the sent emails page for a source record given by its table ID and system ID.
    ///</summary>
    ///<param name="TableId">The table ID of the source record.</param>
    ///<param name="SystemId">The system ID of the source record.</param>
    ///<param name="NewerThanDate">The date to which the sent emails are filtered.</param>
    procedure OpenSentEmails(TableId: Integer; SystemId: Guid; NewerThanDate: DateTime)
    begin
        EmailImpl.OpenSentEmails(TableId, SystemId, NewerThanDate);
    end;

    ///<summary>
    /// Gets the outbox email status.
    ///</summary>
    ///<param name="MessageId">The MessageId of the record.</param>
    ///<returns>Email Status of the record.</returns>
    procedure GetOutboxEmailRecordStatus(MessageId: Guid) ResultStatus: Enum "Email Status";
    begin
        exit(EmailImpl.GetOutboxEmailRecordStatus(MessageId));
    end;

    ///<summary>
    /// Adds a relation between an email message and a record.
    ///</summary>
    ///<param name="EmailMessage">The email message for which to create the relation.</param>
    ///<param name="TableId">The table ID of the record.</param>
    ///<param name="SystemId">The system ID of the record.</param>
    ///<param name="RelationType">The relation type to set.</param>
    ///<param name="Origin">The origin of when the relation is added to the email.</param>
    procedure AddRelation(EmailMessage: Codeunit "Email Message"; TableId: Integer; SystemId: Guid; RelationType: Enum "Email Relation Type"; Origin: Enum "Email Relation Origin")
    begin
        EmailImpl.AddRelation(EmailMessage, TableId, SystemId, RelationType, Origin);
    end;

    ///<summary>
    /// Removes a related record from an email message.
    ///</summary>
    ///<param name="EmailMessage">The email message for which to remove the relation.</param>
    ///<param name="TableId">The table ID of the record.</param>
    ///<param name="SystemId">The system ID of the record.</param>
    procedure RemoveRelation(EmailMessage: Codeunit "Email Message"; TableId: Integer; SystemId: Guid): Boolean
    begin
        exit(EmailImpl.RemoveRelation(EmailMessage, TableId, SystemId));
    end;

    /// <summary>
    /// Check if email has any related records linked.
    /// </summary>
    /// <param name="EmailMessage">The email message for which to check.</param>
    /// <returns>True if it has a related records, otherwise false.</returns>
    procedure HasRelations(EmailMessage: Codeunit "Email Message"): Boolean
    begin
        exit(EmailImpl.HasSourceRecord(EmailMessage.GetId()));
    end;

    /// <summary>
    /// Adds the default attachments of a scenario to the email message.
    /// </summary>
    /// <param name="EmailMessage">The email message for which to add the attachments.</param>
    /// <param name="EmailScenario">Includes the default attachments from this scenario.</param>
    procedure AddDefaultAttachments(EmailMessage: Codeunit "Email Message"; EmailScenario: Enum "Email Scenario")
    begin
        EmailImpl.AddDefaultAttachments(EmailMessage, EmailScenario);
    end;

    #region Events

    /// <summary>
    /// Integration event to show an email source record.
    /// </summary>
    /// <param name="SourceTable">The ID of table that contains the source record.</param>
    /// <param name="SourceSystemId">The system ID of the source record.</param>
    /// <param name="IsHandled">Out parameter to set if the event was handled.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnShowSource(SourceTableId: Integer; SourceSystemId: Guid; var IsHandled: Boolean)
    begin
    end;

    /// <summary>
    /// Integration event to add additional relations based on added relation to emails.
    /// </summary>
    /// <param name="EmailMessageId">The ID of the email.</param>
    /// <param name="TableId">Record table id.</param>
    /// <param name="SystemId">Record system id.</param>
    /// <param name="RelatedSystemIds">Dictionary that contains a list of system ids for each table id, allowing to add related records to the email.</param>
    /// <remarks>A related record consists of a table id and a system id.</remarks>
    [IntegrationEvent(false, false)]
    internal procedure OnAfterAddRelation(EmailMessageId: Guid; TableId: Integer; SystemId: Guid; var RelatedSystemIds: Dictionary of [Integer, List of [Guid]])
    begin
    end;

    /// <summary>
    /// Integration event to execute code when relation is removed from email.
    /// </summary>
    /// <param name="EmailMessageId">The ID of the email.</param>
    /// <param name="TableId">Record table id.</param>
    /// <param name="SystemId">Record system id.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnAfterRemoveRelation(EmailMessageId: Guid; TableId: Integer; SystemId: Guid)
    begin
    end;

    /// <summary>
    /// Integration event to override the default email body for test messages.
    /// </summary>
    /// <param name="Connector">The connector used to send the email message.</param>
    /// <param name="AccountId">The account ID of the email account used to send the email message.</param>
    /// <param name="Body">Out param to set the email body to a new value.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnGetBodyForTestEmail(Connector: Enum "Email Connector"; AccountId: Guid; var Body: Text)
    begin
    end;

    /// <summary>
    /// Integration event to get the names and IDs of attachments related to a source record.
    /// </summary>
    /// <param name="SourceTableId">The table number of the source record.</param>
    /// <param name="SourceSystemID">The system ID of the source record.</param>
    /// <param name="EmailRelatedAttachments">Out parameter to return attachments related to the source record.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnFindRelatedAttachments(SourceTableId: Integer; SourceSystemID: Guid; var EmailRelatedAttachments: Record "Email Related Attachment")
    begin
    end;

    /// <summary>
    /// Integration event that requests an attachment to be added to an email.
    /// </summary>
    /// <param name="AttachmentTableID">The table number of the attachment.</param>
    /// <param name="AttachmentSystemID">The system ID of the attachment.</param>
    /// <param name="MessageID">The ID of the email to add an attachment to.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnGetAttachment(AttachmentTableID: Integer; AttachmentSystemID: Guid; MessageID: Guid)
    begin
    end;

    /// <summary>
    /// Integration event to implement additional validation after the email message has been enqueued in the email outbox.
    /// </summary>
    /// <param name="MessageId">The ID of the email that has been queued</param>
    [IntegrationEvent(false, false)]
    internal procedure OnEnqueuedInOutbox(MessageId: Guid)
    begin
    end;

    /// <summary>
    /// Integration event to implement additional validation after the email message has been enqueued in the email outbox.
    /// </summary>
    /// <param name="MessageId">The ID of the email that has been queued</param>
    [IntegrationEvent(false, false)]
    internal procedure OnEnqueuedReplyInOutbox(MessageId: Guid)
    begin
    end;

    /// <summary>
    /// Integration event that notifies senders when the email has been sent successfully. This event is isolated.
    /// </summary>
    /// <param name="SentEmail">The record of the sent email.</param>
    [IntegrationEvent(false, false, true)]
    internal procedure OnAfterEmailSent(SentEmail: Record "Sent Email")
    begin
    end;

    /// <summary>
    /// Integration event that notifies senders when the email has been sent unsuccessfully. This event is isolated.
    /// </summary>
    /// <param name="EmailOutbox">The record of the email outbox that failed to send.</param>
    [IntegrationEvent(false, false, true)]
    internal procedure OnAfterEmailSendFailed(EmailOutbox: Record "Email Outbox")
    begin
    end;

    /// <summary>
    /// Integration event that allows updating of the email message before the email editor opens.
    /// </summary>
    /// <param name="EmailMessage">Email message codeunit which is linked to the current email.</param>
    /// <param name="IsNewEmail">True if this is a newly created email.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnBeforeOpenEmailEditor(var EmailMessage: Codeunit "Email Message"; IsNewEmail: Boolean)
    begin
    end;

    /// <summary>
    /// Integration event that allows updating of the email message before the email is queued for sending.
    /// </summary>
    /// <param name="EmailMessage">Email message codeunit which is linked to the current email.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnBeforeSendEmail(var EmailMessage: Codeunit "Email Message")
    begin
    end;

    /// <summary>
    /// Integration event that allows updating of the email message before the email is queued for replying.
    /// </summary>
    /// <param name="EmailMessage">Email message codeunit which is linked to the current email.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnBeforeReplyEmail(var EmailMessage: Codeunit "Email Message")
    begin
    end;

    /// <summary>
    /// Integration event that allows adding filters to the Email Scenario Attachments before they are retrieved.
    /// </summary>
    /// <param name="EmailScenarioAttachments">The record to add filters to.</param>
    [IntegrationEvent(false, false)]
    internal procedure OnBeforeGetEmailAttachmentsByEmailScenarios(var EmailScenarioAttachments: Record "Email Scenario Attachments")
    begin
    end;

    #endregion

    var
        EmailImpl: Codeunit "Email Impl";
}