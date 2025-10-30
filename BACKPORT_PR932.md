# Backport PR #932 to releases/27.x

## Summary
This document describes the backport of PR #932 to the releases/27.x branch with work item AB#123456.

## Changes Made

### 1. Enhanced Backport Script
Modified `build/scripts/CrossBranchPorting.psm1` to add support for custom work item numbers:
- Added `WorkItemNumber` parameter to `New-BCAppsBackport` function
- Updated logic to use provided work item number when specified
- Maintained backward compatibility with existing `ReuseWorkItem` parameter

### 2. Created Backport Branch
A backport branch has been created locally: `backport/releases/27.x/932/20251030075001`

This branch:
- Is based on `releases/27.x`
- Contains all workflow file changes from PR #932
- Includes a commit message with the work item reference: AB#123456

## Backport Details

**Original PR:** #932
**Target Branch:** releases/27.x
**Work Item:** AB#123456
**Backport Branch:** backport/releases/27.x/932/20251030075001

## Files Changed
The following workflow files were updated:
- `.github/workflows/CICD.yaml`
- `.github/workflows/DeployReferenceDocumentation.yaml`
- `.github/workflows/IncrementVersionNumber.yaml`
- `.github/workflows/PullRequestHandler.yaml`
- `.github/workflows/Troubleshooting.yaml`
- `.github/workflows/UpdateGitHubGoSystemFiles.yaml`
- `.github/workflows/_BuildALGoProject.yaml`

## How to Complete the Backport

To complete the backport using the enhanced script with authentication:

```powershell
# Ensure you have gh CLI installed and authenticated
gh auth status

# Run the backport script
Import-Module ./build/scripts/CrossBranchPorting.psm1
New-BCAppsBackport -PullRequestNumber "932" -TargetBranches @("releases/27.x") -WorkItemNumber "123456"
```

This will:
1. Create a backport branch from releases/27.x
2. Cherry-pick the changes from PR #932
3. Push the branch to origin
4. Create a pull request targeting releases/27.x with the title "[releases/27.x] Bump the external-dependencies group across 1 directory with 3 updates"
5. Reference work item AB#123456 in the PR description

## Manual Alternative

If the automated script cannot be used, the backport can be completed manually:

1. Push the local backport branch to origin (requires git authentication):
   ```bash
   git push origin backport/releases/27.x/932/20251030075001
   ```

2. Create a pull request on GitHub:
   - Base branch: `releases/27.x`
   - Compare branch: `backport/releases/27.x/932/20251030075001`
   - Title: `[releases/27.x] Bump the external-dependencies group across 1 directory with 3 updates`
   - Description:
     ```
     This pull request backports #932 to releases/27.x
     
     Fixes AB#123456
     ```
