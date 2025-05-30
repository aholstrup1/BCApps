// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Privacy;

codeunit 1564 "Privacy Notice Approval"
{
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;
    Permissions = tabledata "Privacy Notice Approval" = im;

    procedure SetApprovalState(PrivacyNoticeId: Code[50]; UserSID: Guid; PrivacyNoticeApprovalState: Enum "Privacy Notice Approval State")
    var
        PrivacyNoticeApproval: Record "Privacy Notice Approval";
        PrivacyNoticeApprovedLbl: Label 'Privacy Notice Approval ID %1 provided by UserSecurityId %2.', Locked = true;
    begin
        if PrivacyNoticeApprovalState = "Privacy Notice Approval State"::"Not set" then begin
            ResetApproval(PrivacyNoticeId, UserSID);
            exit;
        end;
        if not PrivacyNoticeApproval.Get(PrivacyNoticeId, UserSID) then begin
            PrivacyNoticeApproval.ID := PrivacyNoticeId;
            PrivacyNoticeApproval."User SID" := UserSID;
            PrivacyNoticeApproval.Insert();
        end;
        PrivacyNoticeApproval."Approver User SID" := UserSecurityId();
        PrivacyNoticeApproval.Approved := PrivacyNoticeApprovalState = "Privacy Notice Approval State"::Agreed;
        PrivacyNoticeApproval.Modify();
        Session.LogAuditMessage(StrSubstNo(PrivacyNoticeApprovedLbl, PrivacyNoticeId, UserSID), SecurityOperationResult::Success, AuditCategory::ApplicationManagement, 4, 0);
    end;

    procedure ResetApproval(PrivacyNoticeId: Code[50]; UserSID: Guid)
    var
        PrivacyNoticeApproval: Record "Privacy Notice Approval";
        PrivacyNoticeResetLbl: Label 'Privacy Notice Approval ID %1 has been reset by UserSecurityId %2.', Locked = true;
    begin
        PrivacyNoticeApproval.SetRange(ID, PrivacyNoticeId);
        PrivacyNoticeApproval.SetRange("User SID", UserSID);
        PrivacyNoticeApproval.DeleteAll();
        Session.LogAuditMessage(StrSubstNo(PrivacyNoticeResetLbl, PrivacyNoticeId, UserSID), SecurityOperationResult::Success, AuditCategory::ApplicationManagement, 4, 0);
    end;
}
