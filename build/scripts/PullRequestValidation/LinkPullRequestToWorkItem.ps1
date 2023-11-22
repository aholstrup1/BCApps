using module ..\GitHub\GitHubPullRequest.class.psm1
using module ..\GitHub\GitHubIssue.class.psm1

param(
    [Parameter(Mandatory = $true)]
    [string] $PullRequestNumber,
    [Parameter(Mandatory = $true)]
    [string] $Repository
)

function Update-GitHubPullRequest() {
    param(
        [Parameter(Mandatory = $false)]
        [string] $Repository,
        [Parameter(Mandatory = $false)]
        [object] $PullRequest,
        [Parameter(Mandatory = $false)]
        [string[]] $IssueIds
    )

    foreach ($issueId in $IssueIds) {
        Write-Host "Trying to link issue $issueId to pull request $PullRequestNumber"
        $issue = [GitHubIssue]::Get($issueId, $Repository)
        $adoWorkItems = $issue.GetLinkedADOWorkitems()
        if ((-not $issue.IsLinked()) -or (-not $adoWorkItems)) {
            continue
        }


        $pullRequestBody = $PullRequest.PullRequest.body
        foreach ($adoWorkItem in $adoWorkItems) {
            if ($pullRequestBody -notmatch "AB#$($adoWorkItem)") {
                $pullRequestBody += "`r`nFixes AB#$($adoWorkItem)"
            } else {
                Write-Host "Pull request already linked to ADO workitem AB#$($adoWorkItem.id)"
            }
        }

        $PullRequest.PullRequest.body = $pullRequestBody
        $pullRequest.Update()
    }
}

$pullRequest = [GitHubPullRequest]::Get($PullRequestNumber, $Repository)
$issueIds = $pullRequest.GetLinkedIssueIDs()

Write-Host "Updating pull request $PullRequestNumber with linked issues $issueIds"

Update-GitHubPullRequest -Repository $Repository -PullRequest $PullRequest -IssueIds $issueIds
