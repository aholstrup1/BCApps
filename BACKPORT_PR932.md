# Backport PR #932 to releases/27.x

## Summary
This document describes the backport of PR #932 to the releases/27.x branch with work item AB#123456.

## Changes Made

### 1. Enhanced Backport Script
Modified `build/scripts/CrossBranchPorting.psm1` to add support for custom work item numbers:
- Added `WorkItemNumber` parameter to `New-BCAppsBackport` function
- Updated logic to use provided work item number when specified
- Maintained backward compatibility with existing `ReuseWorkItem` parameter

### 2. Created GitHub Actions Workflow
Created `.github/workflows/Complete-Backport-PR932.yaml` workflow that:
- Can be manually triggered via workflow_dispatch
- Uses the enhanced backport script with proper authentication
- Automatically creates the backport branch based on `releases/27.x`
- Applies all changes from PR #932
- Includes work item reference AB#123456
- Creates a pull request targeting releases/27.x

## Backport Details

**Original PR:** #932  
**Target Branch:** releases/27.x  
**Work Item:** AB#123456  
**Workflow:** `.github/workflows/Complete-Backport-PR932.yaml`

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

### Option 1: Using GitHub Actions Workflow (Recommended)

1. Navigate to the Actions tab in the GitHub repository
2. Select the "Complete Backport PR 932" workflow
3. Click "Run workflow"
4. Select the branch to run from (this branch: `copilot/backport-pr-932-to-releases-27-x`)
5. Click "Run workflow" button

The workflow will automatically:
- Create a backport branch from releases/27.x
- Cherry-pick the changes from PR #932
- Push the branch to origin
- Create a pull request targeting releases/27.x with work item AB#123456

### Option 2: Using PowerShell Script Locally

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

## Summary

The backport has been prepared and can be completed by running the GitHub Actions workflow or using the PowerShell script with proper authentication. All necessary changes have been made to support custom work item numbers in the backport process.
