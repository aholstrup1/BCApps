// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.DataAdministration;

using System.Telemetry;
using System.Reflection;
using System.Security.User;
using System.Security.AccessControl;

codeunit 3904 "Apply Retention Policy Impl."
{
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;
    TableNo = "Retention Policy Setup";
    Permissions = tabledata AllObjWithCaption = r;

    var
        TotalNumberOfRecordsDeleted: Integer;
        EndCurrentRun: Boolean;
        ApplyAllRetentionPolicies: Boolean;
        IsUserInvokedRun: Boolean;
        IsConfirmed: Boolean;
        ContinueWithRerun: Boolean;
        WaitDialogMsg: Label 'We''re deleting records based on your retention policy. This might take a few moments.';
        StartedByUserLbl: Label 'Started by user.';
        StartApplyRetentionPoliciesInfoLbl: Label 'Started applying all retention policies.';
        EndApplyRetentionPoliciesInfoLbl: Label 'Finished applying all retention policies.';
        StartApplyRetentionPolicyInfoLbl: Label 'Started applying the retention policy defined for table %1, %2. ', Comment = '%1 = a id of a table (integer), %2 = the caption of the table.';
        RetentionPolicyAppliedLbl: Label 'The retention policy defined for table %1, %2 applied by the UserSecurityId %3. ', Locked = true;
        EndApplyRetentionPolicyInfoLbl: Label 'Finished applying the retention policy defined for table: %1, %2.', Comment = '%1 = a id of a table (integer), %2 = the caption of the table.';
        DisabledRetentionPolicyOnMissingTableLbl: Label 'Table %1 was not found. The retention policy has been disabled.', Comment = '%1 = a id of a table (integer)';
        StartRetentionPolicyRecordCountLbl: Label 'Started counting the number of expired records in table %1, %2. ', Comment = '%1 = a id of a table (integer), %2 = table caption';
        NumberOfExpiredRecordsLbl: Label '%1 of %2 records are expired in table %3, %4, and can be deleted.', Comment = '%1, %2 = integers, %3 = a id of a table (integer),%4 = table name';
        EndRetentionPolicyRecordCountLbl: Label 'Finished counting the number of expired records in table %1, %2.', Comment = '%1 = a id of a table (integer), %2 = table caption';
        TableNotAllowedErrorLbl: Label 'Table %1, %2, is not in the list of allowed tables.', Comment = '%1 = table number, %2 = table name';
        ErrorOccuredDuringApplyErrLbl: Label 'An error occured while applying the retention policy for table %1 %2.\\%3', Comment = '%1 = table number, %2 = table caption, %3 = error message';
        ConfirmApplyRetentionPoliciesLbl: Label 'Do you want to delete expired data, as defined in your retention policies?';
        ConfirmApplyRetentionPolicyLbl: Label 'Do you want to delete expired data, as defined in the selected retention policy?';
        RetentionPolicySetupRecordNotTempErr: Label 'The retention policy setup record instance must be temporary. Contact your Microsoft Partner for assistance.';
        UserDidNotConfirmErr: Label 'The operation was cancelled.';
        NoFiltersReturnedErr: Label 'No filters were found in the record to apply for table %1, %2. No records will be deleted.', Comment = '%1 = table number, %2 = table caption';
        IndirectPermissionsRequiredErr: Label 'A subscriber with indirect permissions is required to delete expired records from table %1, %2. Contact your Microsoft Partner for assistance.', Comment = '%1 = table number, %2 = table caption';
        EndCurrentRunLbl: Label 'Deleted the maximum number of records allowed. We have stopped deleting records in this table.';
        ConfirmRerunMsg: Label 'Reached the maximum number of records that can be deleted at the same time. The maximum number allowed is %1.\\Do you want to delete more records?', Comment = '%1 = integer';
        DeletedRecordsFromTableLbl: Label 'Deleted %1 of %2 records from table %3, %4.', Comment = '%1, %2 = integers, %3 = a id of a table (integer), %4 = the caption of the table.';
        RetenPolFiltering: Interface "Reten. Pol. Filtering";
        WhereNewerFilterExclTxt: Label 'WHERE(Field%1=1(>%2&%3..))', Locked = true;
        WhereNewerFilterExclWithNullTxt: Label 'WHERE(Field%1=1(>=%2&%3..))', Locked = true;
        WhereOlderFilterExclTxt: Label 'WHERE(Field%1=1(>%2&..%3))', Locked = true;
        WhereOlderFilterExclWithNullTxt: Label 'WHERE(Field%1=1(>=%2&..%3))', Locked = true;
        SingleDateFilterExclWithNullTxt: Label 'WHERE(Field%1=1(%2|%3))', Locked = true;
        SingleDateFilterExclTxt: Label 'WHERE(Field%1=1(%2))', Locked = true;
        DateFieldNoMustHaveAValueErr: Label 'The field Date Field No. must have a value in the retention policy for table %1, %2', Comment = '%1 = table number, %2 = table caption';
        SystemUserSIDTxt: Label '{00000000-0000-0000-0000-000000000001}', Locked = true;

    trigger OnRun()
    var
        RetentionPolicySetup: Record "Retention Policy Setup";
    begin
        if IsNullGuid(Rec.SystemId) then
            ApplyRetentionPolicy(false) // run all
        else begin
            // run one
            if not Rec.IsTemporary() then
                Error(RetentionPolicySetupRecordNotTempErr);
            RetentionPolicySetup.GetBySystemId(Rec.SystemId); // let the error bubble up
            TotalNumberOfRecordsDeleted := Rec."Number Of Records Deleted";
            ApplyRetentionPolicy(RetentionPolicySetup, false, false);
            Rec."Number Of Records Deleted" := TotalNumberOfRecordsDeleted;
        end;
    end;

    procedure ApplyRetentionPolicy(UserInvokedRun: Boolean)
    var
        RetentionPolicySetup: Record "Retention Policy Setup";
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        Dialog: Dialog;
    begin
        RetentionPolicyLog.LogInfo(LogCategory(), AppendStartedByUserMessage(StartApplyRetentionPoliciesInfoLbl, UserInvokedRun));

        ApplyAllRetentionPolicies := true;

        RetentionPolicySetup.SetRange(Enabled, true);
        RetentionPolicySetup.SetRange(Manual, false);
        if RetentionPolicySetup.FindSet(false) then begin
            if GuiAllowed() then begin
                Dialog.HideSubsequentDialogs(true);
                Dialog.Open(WaitDialogMsg);
            end;

            repeat
                if UserInvokedRun then
                    // allow errors to bubble up
                    ApplyRetentionPolicy(RetentionPolicySetup, false, UserInvokedRun)
                else
                    // suppress errors
                    SafeApplyRetentionPolicy(RetentionPolicySetup)
            until (RetentionPolicySetup.Next() = 0) or EndCurrentRun;

            if GuiAllowed() then
                Dialog.Close();
        end;
        RetentionPolicyLog.LogInfo(LogCategory(), AppendStartedByUserMessage(EndApplyRetentionPoliciesInfoLbl, UserInvokedRun));

        if ContinueWithRerun then
            Codeunit.Run(Codeunit::"Apply Retention Policy Impl.");
    end;

    procedure ApplyRetentionPolicy(RetentionPolicySetup: Record "Retention Policy Setup"; Manual: Boolean; UserInvokedRun: Boolean)
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        RetenPolicyTelemetryImpl: Codeunit "Reten. Policy Telemetry Impl.";
        FeatureTelemetry: Codeunit "Feature Telemetry";
        RecordRef: RecordRef;
        Dialog: Dialog;
        ExpiredRecordExpirationDate: Date;
    begin
        IsUserInvokedRun := UserInvokedRun;

        if not IsSystemEnabledPolicy(RetentionPolicySetup) then
            FeatureTelemetry.LogUptake('0000FVU', 'Retention policies', Enum::"Feature Uptake Status"::Used);
        if not CanApplyRetentionPolicy(RetentionPolicySetup, Manual) then
            exit;

        if GuiAllowed() then begin
            Dialog.HideSubsequentDialogs(true);
            Dialog.Open(WaitDialogMsg);
        end;

        RetentionPolicySetup.CalcFields("Table Name", "Table Caption");
        RetentionPolicyLog.LogInfo(LogCategory(), AppendStartedByUserMessage(StrSubstNo(StartApplyRetentionPolicyInfoLbl, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption"), UserInvokedRun));
        Session.LogAuditMessage(StrSubstNo(RetentionPolicyAppliedLbl, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption", UserSecurityId()), SecurityOperationResult::Success, AuditCategory::ApplicationManagement, 3, 0);

        if GetExpiredRecords(RetentionPolicySetup, RecordRef, ExpiredRecordExpirationDate) then
            DeleteExpiredRecords(RecordRef)
        else
            RetenPolicyTelemetryImpl.SendTelemetryOnRecordsDeleted(RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Name", 0, IsUserInvokedRun);

        RetentionPolicyLog.LogInfo(LogCategory(), AppendStartedByUserMessage(StrSubstNo(EndApplyRetentionPolicyInfoLbl, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption"), UserInvokedRun));

        if GuiAllowed() then
            Dialog.Close();

        CheckAndContinueWithRerun(RetentionPolicySetup);

        if not IsSystemEnabledPolicy(RetentionPolicySetup) then
            FeatureTelemetry.LogUsage('0000FVV', 'Retention policies', 'Retention policy applied');
    end;

    procedure GetExpiredRecordCount(RetentionPolicySetup: Record "Retention Policy Setup"; var ExpiredRecordExpirationDate: Date): Integer;
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        RecordRef: RecordRef;
        ExpiredRecordCount: Integer;
        TotalRecordCount: Integer;
    begin
        RetentionPolicySetup.CalcFields("Table Caption");
        RetentionPolicyLog.LogInfo(LogCategory(), StrSubstNo(StartRetentionPolicyRecordCountLbl, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption"));

        if GetExpiredRecords(RetentionPolicySetup, RecordRef, ExpiredRecordExpirationDate) then begin
            ExpiredRecordCount := this.Count(RecordRef);
            RecordRef.Reset();
            TotalRecordCount := this.Count(RecordRef);
        end;
        RetentionPolicyLog.LogInfo(LogCategory(), StrSubstNo(EndRetentionPolicyRecordCountLbl, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption"));
        RetentionPolicyLog.LogInfo(LogCategory(), StrSubstNo(NumberOfExpiredRecordsLbl, ExpiredRecordCount, TotalRecordCount, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption"));
        exit(ExpiredRecordCount);
    end;

    local procedure SafeApplyRetentionPolicy(RetentionPolicySetup: Record "Retention Policy Setup")
    var
        TempRetentionPolicySetup: Record "Retention Policy Setup" temporary;
        RetentionPolicyLog: Codeunit "Retention Policy Log";
    begin
        Commit();
        TempRetentionPolicySetup.SystemId := RetentionPolicySetup.SystemId;
        TempRetentionPolicySetup."Number Of Records Deleted" := TotalNumberOfRecordsDeleted;
        if not Codeunit.Run(Codeunit::"Apply Retention Policy Impl.", TempRetentionPolicySetup) then begin
            RetentionPolicyLog.LogError(LogCategory(), StrSubstNo(ErrorOccuredDuringApplyErrLbl, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption", GetLastErrorText()), false);
            exit
        end;
        TotalNumberOfRecordsDeleted := TempRetentionPolicySetup."Number Of Records Deleted";
    end;

    local procedure CanApplyRetentionPolicy(var RetentionPolicySetup: Record "Retention Policy Setup"; Manual: Boolean): Boolean
    var
        RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
        RetentionPolicyLog: Codeunit "Retention Policy Log";
    begin
        if not ConfirmApplyRetentionPolicies() then
            exit(false);

        if not RetentionPolicySetup.Enabled then
            exit(false);

        if not TableExists(RetentionPolicySetup."Table Id") then begin
            DisableRetentionPolicySetup(RetentionPolicySetup);
            exit(false);
        end;

        if Manual <> RetentionPolicySetup.Manual then
            exit(false);

        RetentionPolicySetup.CalcFields("Table Caption");
        if not RetenPolAllowedTables.IsAllowedTable(RetentionPolicySetup."Table Id") then
            RetentionPolicyLog.LogError(LogCategory(), StrSubstNo(TableNotAllowedErrorLbl, RetentionPolicySetup."Table Id", RetentionPolicySetup."Table Caption"));

        exit(true)
    end;

    local procedure DeleteExpiredRecords(var RecordRef: RecordRef)
    var
        TempRetenPolDeletingParam: Record "Reten. Pol. Deleting Param" temporary;
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
        RetenPolicyTelemetryImpl: Codeunit "Reten. Policy Telemetry Impl.";
        ApplyRetentionPolicyFacade: Codeunit "Apply Retention Policy";
        RecordRefDuplicate: RecordRef;
        RetenPolDeleting: Interface "Reten. Pol. Deleting";
        Handled: Boolean;
        NumberOfRecordsDeleted: Integer;
        RecordCountBefore: Integer;
        RecordCountAfter: Integer;
    begin
        RecordRefDuplicate := RecordRef.Duplicate();

        FillTempRetenPolDeletingParamTable(TempRetenPolDeletingParam, RecordRef);
        RecordCountBefore := TempRetenPolDeletingParam."Record Count Before Delete";

        RetenPolDeleting := RetenPolAllowedTables.GetRetenPolDeleting(RecordRef.Number);
        RetenPolDeleting.DeleteRecords(RecordRef, TempRetenPolDeletingParam);

        if not TempRetenPolDeletingParam."Skip Event Indirect Perm. Req." then begin
            ApplyRetentionPolicyFacade.OnApplyRetentionPolicyIndirectPermissionRequired(RecordRefDuplicate, Handled);
            if not Handled then
                RetentionPolicyLog.LogError(LogCategory(), StrSubstNo(IndirectPermissionsRequiredErr, RecordRefDuplicate.Number, RecordRefDuplicate.Caption));
            Handled := false;
        end;

        RecordCountAfter := Count(RecordRefDuplicate);
        NumberOfRecordsDeleted := RecordCountBefore - RecordCountAfter;
        TotalNumberOfRecordsDeleted += NumberOfRecordsDeleted;

        RetentionPolicyLog.LogInfo(LogCategory(), StrSubstNo(DeletedRecordsFromTableLbl, NumberOfRecordsDeleted, RecordCountBefore, RecordRefDuplicate.Number, RecordRefDuplicate.Caption));
        RetenPolicyTelemetryImpl.SendTelemetryOnRecordsDeleted(RecordRefDuplicate.Number, RecordRefDuplicate.Name, NumberOfRecordsDeleted, IsUserInvokedRun);

        if not TempRetenPolDeletingParam."Skip Event Rec. Limit Exceeded" then
            RaiseRecordLimitExceededEvent(RecordRefDuplicate, RecordCountAfter);
    end;

    local procedure CheckAndContinueWithRerun(var RetentionPolicySetup: Record "Retention Policy Setup")
    begin
        if not ApplyAllRetentionPolicies then
            if ContinueWithRerun then begin
                Commit();
                ClearAll();
                IsConfirmed := true;
                ApplyRetentionPolicy(RetentionPolicySetup, RetentionPolicySetup.Manual, true);
            end;
    end;

    local procedure FillTempRetenPolDeletingParamTable(var TempRetenPolDeletingParam: Record "Reten. Pol. Deleting Param" temporary; var RecordRef: RecordRef)
    begin
        TempRetenPolDeletingParam."Record Count Before Delete" := this.Count(RecordRef);
        TempRetenPolDeletingParam."Indirect Permission Required" := VerifyIndirectDeletePermission(RecordRef.Number);
        TempRetenPolDeletingParam."Skip Event Indirect Perm. Req." := not TempRetenPolDeletingParam."Indirect Permission Required";
        TempRetenPolDeletingParam."Max. Number of Rec. to Delete" := MaxNumberOfRecordsToDelete() - TotalNumberOfRecordsDeleted;
        TempRetenPolDeletingParam."Skip Event Rec. Limit Exceeded" := TempRetenPolDeletingParam."Max. Number of Rec. to Delete" > TempRetenPolDeletingParam."Record Count Before Delete";
        TempRetenPolDeletingParam."Total Max. Nr. of Rec. to Del." := MaxNumberOfRecordsToDelete();
        TempRetenPolDeletingParam."User Invoked Run" := IsUserInvokedRun;
    end;

    local procedure RaiseRecordLimitExceededEvent(var RecordRefDuplicate: RecordRef; RecordCountAfter: Integer)
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        ApplyRetentionPolicyFacade: Codeunit "Apply Retention Policy";
        Handled: Boolean;
    begin
        EndCurrentRun := true;
        RetentionPolicyLog.LogWarning(LogCategory(), EndCurrentRunLbl);
        ApplyRetentionPolicyFacade.OnApplyRetentionPolicyRecordLimitExceeded(RecordRefDuplicate.Number, RecordCountAfter, ApplyAllRetentionPolicies, IsUserInvokedRun, Handled);
        if IsUserInvokedRun and (not Handled) and GuiAllowed() then begin
            Commit();
            if Confirm(ConfirmRerunMsg, true, MaxNumberOfRecordsToDelete()) then
                ContinueWithRerun := true;
        end;
    end;

    local procedure TableExists(TableId: Integer): Boolean
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        exit(AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, TableId))
    end;

    local procedure DisableRetentionPolicySetup(var RetentionPolicySetup: Record "Retention Policy Setup")
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
    begin
        RetentionPolicySetup.Validate(Enabled, false);
        RetentionPolicySetup.Modify(true);
        RetentionPolicyLog.LogInfo(LogCategory(), StrSubstNo(DisabledRetentionPolicyOnMissingTableLbl, RetentionPolicySetup."Table Id"));
    end;

    local procedure ConfirmApplyRetentionPolicies(): Boolean
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
    begin
        if not GuiAllowed then
            exit(true);
        if not IsUserInvokedRun then
            exit(true);

        if not IsConfirmed then
            if ApplyAllRetentionPolicies then
                IsConfirmed := Confirm(ConfirmApplyRetentionPoliciesLbl, false)
            else
                IsConfirmed := Confirm(ConfirmApplyRetentionPolicyLbl, false);
        if not IsConfirmed then
            RetentionPolicyLog.LogError(LogCategory(), UserDidNotConfirmErr);

        exit(true);
    end;

    local procedure GetExpiredRecords(RetentionPolicySetup: Record "Retention Policy Setup"; var RecordRef: RecordRef; var ExpiredRecordExpirationDate: Date): Boolean
    var
        TempRetenPolFilteringParam: Record "Reten. Pol. Filtering Param" temporary;
        RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        RecordReference: Codeunit "Record Reference";
        RecordReferenceIndirectPermission: Interface "Record Reference";
        RecordsToDelete: Boolean;
    begin
        TempRetenPolFilteringParam."Null Date Replacement value" := DT2Date(RetentionPolicySetup.SystemCreatedAt);
        RetenPolFiltering := RetenPolAllowedTables.GetRetenPolFiltering(RetentionPolicySetup."Table Id");
        if RetentionPolicySetup."Apply to all records" then begin
            RecordsToDelete := RetenPolFiltering.ApplyRetentionPolicyAllRecordFilters(RetentionPolicySetup, RecordRef, TempRetenPolFilteringParam);
            if RecordsToDelete then
                if RecordRef.GetFilters() = '' then begin
                    RetentionPolicyLog.LogWarning(LogCategory(), StrSubstNo(NoFiltersReturnedErr, RecordRef.Number, RecordRef.Caption));
                    exit(false);
                end;
            exit(RecordsToDelete);
        end;

        RecordsToDelete := RetenPolFiltering.ApplyRetentionPolicySubSetFilters(RetentionPolicySetup, RecordRef, TempRetenPolFilteringParam);
        RecordRef.MarkedOnly(true);
        RecordReference.Initialize(RecordRef, RecordReferenceIndirectPermission);
        if RecordsToDelete and RecordReferenceIndirectPermission.IsEmpty(RecordRef) then begin
            RetentionPolicyLog.LogWarning(LogCategory(), StrSubstNo(NoFiltersReturnedErr, RecordRef.Number, RecordRef.Caption));
            exit(false)
        end;
        ExpiredRecordExpirationDate := TempRetenPolFilteringParam."Expired Record Expiration Date";
        exit(RecordsToDelete);
    end;

    local procedure VerifyIndirectDeletePermission(TableId: Integer): Boolean
    var
        TempDummyExpandedPermission: Record "Expanded Permission" temporary;
        UserPermissions: Codeunit "User Permissions";
    begin
        TempDummyExpandedPermission := UserPermissions.GetEffectivePermission(TempDummyExpandedPermission."Object Type"::"Table Data", TableId);
        exit(TempDummyExpandedPermission."Delete Permission" = TempDummyExpandedPermission."Delete Permission"::Indirect)
    end;

    procedure SetWhereOlderExpirationDateFilter(DateFieldNo: Integer; ExpirationDate: Date; var RecordRef: RecordRef; FilterGroup: Integer; NullDateReplacementValue: Date)
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        FilterView: Text;
    begin
        if DateFieldNo = 0 then
            RetentionPolicyLog.LogError(LogCategory(), StrSubstNo(DateFieldNoMustHaveAValueErr, RecordRef.Number, RecordRef.Caption));

        RecordRef.FilterGroup := FilterGroup;

        if (ExpirationDate >= NullDateReplacementValue) and (DateFieldNo in [RecordRef.SystemCreatedAtNo, RecordRef.SystemModifiedAtNo]) then
            FilterView := StrSubstNo(WhereOlderFilterExclWithNullTxt, DateFieldNo, '''''', CalcDate('<-1D>', ExpirationDate))
        else
            FilterView := StrSubstNo(WhereOlderFilterExclTxt, DateFieldNo, '''''', CalcDate('<-1D>', ExpirationDate));

        RecordRef.SetView(FilterView);
    end;

    procedure SetWhereNewerExpirationDateFilter(DateFieldNo: Integer; ExpirationDate: Date; var RecordRef: RecordRef; FilterGroup: Integer; NullDateReplacementValue: Date)
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        FilterView: Text;
    begin
        if DateFieldNo = 0 then
            RetentionPolicyLog.LogError(LogCategory(), StrSubstNo(DateFieldNoMustHaveAValueErr, RecordRef.Number, RecordRef.Caption));

        RecordRef.FilterGroup := FilterGroup;

        if (ExpirationDate <= NullDateReplacementValue) and (DateFieldNo in [RecordRef.SystemCreatedAtNo, RecordRef.SystemModifiedAtNo]) then
            FilterView := StrSubstNo(WhereNewerFilterExclWithNullTxt, DateFieldNo, '''''', ExpirationDate)
        else
            FilterView := StrSubstNo(WhereNewerFilterExclTxt, DateFieldNo, '''''', ExpirationDate);

        RecordRef.SetView(FilterView);
    end;

    procedure SetSingleDateExpirationDateFilter(DateFieldNo: Integer; ExpirationDate: Date; var RecordRef: RecordRef; FilterGroup: Integer; NullDateReplacementValue: Date)
    var
        RetentionPolicyLog: Codeunit "Retention Policy Log";
        FilterView: Text;
    begin
        if DateFieldNo = 0 then
            RetentionPolicyLog.LogError(LogCategory(), StrSubstNo(DateFieldNoMustHaveAValueErr, RecordRef.Number, RecordRef.Caption));
        RecordRef.FilterGroup := FilterGroup;

        if (ExpirationDate >= NullDateReplacementValue) and (DateFieldNo in [RecordRef.SystemCreatedAtNo, RecordRef.SystemModifiedAtNo]) then
            FilterView := StrSubstNo(SingleDateFilterExclWithNullTxt, DateFieldNo, '''''', ExpirationDate - 1)
        else
            FilterView := StrSubstNo(SingleDateFilterExclTxt, DateFieldNo, ExpirationDate - 1);

        RecordRef.SetView(FilterView);
    end;

    local procedure LogCategory(): Enum "Retention Policy Log Category"
    var
        RetentionPolicyLogCategory: Enum "Retention Policy Log Category";
    begin
        exit(RetentionPolicyLogCategory::"Retention Policy - Apply");
    end;

    internal procedure MaxNumberOfRecordsToDelete(): Integer
    begin
        exit(10000)
    end;

    internal procedure NumberOfRecordsToDeleteBuffer(): Integer
    begin
        exit(0)
    end;

    local procedure Count(RecordRef: RecordRef): Integer;
    begin
        if RecordRef.ReadPermission() then
            exit(RecordRef.Count())
        else
            exit(RetenPolFiltering.Count(RecordRef));
    end;

    local procedure AppendStartedByUserMessage(Message: Text[2048]; UserInvokedRun: Boolean): Text[2048];
    begin
        if UserInvokedRun then
            exit(CopyStr(Message + ' ' + StartedByUserLbl, 1, 2048));
        exit(Message)
    end;

    /// <summary>
    /// Determines if the retention policy was automatically created and enabled during install / upgrade and no user has modified it since.
    /// </summary>
    /// <param name="RetentionPolicySetup">The retention policy setup record.</param>
    /// <returns>True if the retention policy was automatically created and enabled during install / upgrade and no user has modified it since. Otherwise, false.</returns>
    local procedure IsSystemEnabledPolicy(RetentionPolicySetup: Record "Retention Policy Setup"): Boolean
    var
        OneHour: Duration;
    begin
        OneHour := 60 * 60 * 1000;
        exit((RetentionPolicySetup.SystemCreatedBy = SystemUserSIDTxt) and (RetentionPolicySetup.SystemModifiedBy = SystemUserSIDTxt)
              and (RetentionPolicySetup.SystemModifiedAt - RetentionPolicySetup.SystemCreatedAt < OneHour));
    end;
}