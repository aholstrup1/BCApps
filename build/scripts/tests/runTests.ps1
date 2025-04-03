
# This function generates a JSON Web Token (JWT) for GitHub App authentication.
# https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-json-web-token-jwt-for-a-github-app
function Get-JsonWebToken() {
    param(
        [string] $gitHubAppClientId,
        [string] $privateKey
    )
    $header = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @{
                    alg = "RS256"
                    typ = "JWT"
                }))).TrimEnd('=').Replace('+', '-').Replace('/', '_');
      
    $payload = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @{
                    iat = [System.DateTimeOffset]::UtcNow.AddSeconds(-10).ToUnixTimeSeconds()
                    exp = [System.DateTimeOffset]::UtcNow.AddMinutes(10).ToUnixTimeSeconds()
                    iss = $gitHubAppClientId 
                }))).TrimEnd('=').Replace('+', '-').Replace('/', '_');
      
    $rsa = [System.Security.Cryptography.RSA]::Create()
    $rsa.ImportFromPem($privateKey)
      
    $signature = [Convert]::ToBase64String($rsa.SignData([System.Text.Encoding]::UTF8.GetBytes("$header.$payload"), [System.Security.Cryptography.HashAlgorithmName]::SHA256, [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)).TrimEnd('=').Replace('+', '-').Replace('/', '_')
    $jwt = "$header.$payload.$signature"
    Write-Host $jwt
    return $jwt
}

function Get-GitHubAppAuthToken {
    Param(
        [string] $gitHubAppClientId,
        [string] $privateKey,
        [string] $api_url = "https://api.github.com",
        [string] $repository,
        [string[]] $repositories = @()
    )

    Write-Host "Using GitHub App with ClientId $gitHubAppClientId for authentication"
    $jwt = Get-JsonWebToken -gitHubAppClientId $gitHubAppClientId -privateKey $privateKey
    $headers = @{
        "Accept"               = "application/vnd.github+json"
        "Authorization"        = "Bearer $jwt"
        "X-GitHub-Api-Version" = "2022-11-28"
    }
    Write-Host "Get App Info $api_url/repos/$repository/installation"
    $appinfo = Invoke-RestMethod -Method GET -UseBasicParsing -Headers $headers -Uri "$api_url/repos/$repository/installation"
    $body = @{}
    # If repositories are provided, limit the requested repositories to those
    if ($repositories) {
        $body += @{ "repositories" = @($repositories | ForEach-Object { $_.SubString($_.LastIndexOf('/') + 1) } ) }
    }
    Write-Host "Get Token Response $($appInfo.access_tokens_url) with $($body | ConvertTo-Json -Compress)"
    $tokenResponse = Invoke-RestMethod -Method POST -UseBasicParsing -Headers $headers -Body ($body | ConvertTo-Json -Compress) -Uri $appInfo.access_tokens_url
    return $tokenResponse.token
}

# There's a GitHub variable in the repo called ClientId. Get it from there.
$token = Get-GitHubAppAuthToken -gitHubAppClientId $ENV:CLIENT_ID -privateKey $ENV:PRIVATE_KEY -repository "aholstrup1/BCApps"
$token | gh auth login --with-token
gh pr comment 827 --repo "aholstrup1/BCApps" --body "test3"