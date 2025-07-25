// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.User;

using System.Environment;
using System.Security.AccessControl;

/// <summary>
/// Lookup page for users.
/// </summary>
page 9843 "User Lookup"
{
    Extensible = true;
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = User;
    SourceTableView = sorting("User Name");
    Permissions = tabledata User = r;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    Caption = 'User Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the user. If the user must enter credentials when they sign in, this is the name they must enter.';
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Caption = 'Full Name';
                    Editable = false;
                    ToolTip = 'Specifies the full name of the user.';
                }
                field("Windows Security ID"; Rec."Windows Security ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Windows Security ID of the user. This is only relevant for Windows authentication.';
                    Visible = not IsSaaS;
                }
                field("Authentication Email"; Rec."Authentication Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the Microsoft account that this user uses to sign in to Office 365 or SharePoint Online.';
                    Visible = IsSaaS;
                }
            }
        }
    }


    trigger OnOpenPage()
    var
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        if HideOnlyExternalUsers then
            UserSelectionImpl.HideOnlyExternalUsers(Rec)
        else
            UserSelectionImpl.HideExternalAndSystemUsers(Rec);
        IsSaaS := EnvironmentInformation.IsSaaS();
    end;

    var
        UserSelectionImpl: Codeunit "User Selection Impl.";
        IsSaaS: Boolean;
        HideOnlyExternalUsers: Boolean;

    /// <summary>
    /// Gets the currently selected users.
    /// </summary>
    /// <param name="SelectedUser">A record that contains the currently selected users</param>
    [Scope('OnPrem')]
    procedure GetSelectedUsers(var SelectedUser: Record User)
    var
        User: Record User;
    begin
        if SelectedUser.IsTemporary() then begin
            SelectedUser.Reset();
            SelectedUser.DeleteAll();
            CurrPage.SetSelectionFilter(User);
            if User.FindSet() then
                repeat
                    SelectedUser.Copy(User);
                    SelectedUser.Insert();
                until User.Next() = 0;
        end else begin
            CurrPage.SetSelectionFilter(SelectedUser);
            SelectedUser.FindSet();
        end;
    end;

    internal procedure SetHideOnlyExternalUsers(HideOnlyExternal: Boolean)
    begin
        HideOnlyExternalUsers := HideOnlyExternal;
    end;
}


