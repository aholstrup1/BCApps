using module .\GitHubAPI.class.psm1

<#
    Class that represents a GitHub issue.
#>
class GitHubIssue {
    $IssueId
    $Repository
    $Issue

    hidden GitHubIssue([int] $IssueId, [string] $Repository) {
        $this.IssueId = $IssueId
        $this.Repository = $Repository

        $gitHubIssue = gh api "/repos/$Repository/issues/$IssueId" -H ([GitHubAPI]::AcceptJsonHeader) -H ([GitHubAPI]::GitHubAPIHeader) | ConvertFrom-Json
        if ($gitHubIssue.message) {
            # message property is populated when the issue is not found
            Write-Host "::Warning:: Could not get issue $IssueId from repository $Repository. Error: $($gitHubIssue.message)"
            $this.Issue = $null
            return
        }
        $this.Issue = $gitHubIssue
    }

    <#
        Gets the issue from GitHub.
    #>
    static [GitHubIssue] Get([int] $IssueId, [string] $Repository) {
        $gitHubIssue = [GitHubIssue]::new($IssueId, $Repository)

        if (-not $gitHubIssue.Issue) {
            return $null
        }

        return $gitHubIssue
    }

    <#
        Returns true if the issue is approved, otherwise returns false.
        Issue is considered approved if it has a label named "approved".
    #>
    [bool] IsApproved() {
        return $this.HasLabel("approved")
    }

    [bool] IsLinked() {
        return $this.HasLabel("Linked")
    }

    hidden [bool] HasLabel([string] $label) {
        if(-not $this.Issue.labels) {
            return $false
        }

        return $this.Issue.labels.name -contains $label
    }

    <#
        Gets the linked ADO workitem IDs from the pull request description.
        .returns
            An array of linked issue IDs.
    #>
    [int[]] GetLinkedADOWorkitems() {
        $workitemPattern = "AB#(\d+)" # e.g. "Fixes AB#1234"
        return $this.GetLinkedWorkItemIDs($workitemPattern)
    }

    hidden [int[]] GetLinkedWorkItemIDs($Patten) {
        if(-not $this.Issue.body) {
            return @()
        }

        $workitemMatches = Select-String $Patten -InputObject $this.Issue.body -AllMatches

        Write-Host "Found $($workitemMatches.Matches.Count) workitems in issue $($this.IssueId)"

        if(-not $workitemMatches) {
            return @()
        }

        $workitemIds = @()
        foreach($match in $workitemMatches.Matches) {
            Write-Host "Found workitem $($match.Groups[0].Value)"
            $workitemIds += $match.Groups[1].Value
        }
        return $workitemIds
    }

    <#
        Returns true if the issue is open, otherwise returns false.
    #>
    [bool] IsOpen() {
        if (-not $this.Issue.state) {
            return $false
        }

        return $this.Issue.state -eq "open"
    }

    [bool] IsPullRequest() {
        return $this.Issue.PSobject.Properties.name -eq "pull_request"
    }
}
