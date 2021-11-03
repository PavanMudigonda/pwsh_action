$tagName = $env:GITHUB_REF -replace 'refs/tags/',''
$githubHeaders = @{ Authorization = "token $($env:GITHUB_TOKEN)" }
$githubRepo = $env:GITHUB_REPOSITORY
$listRelsUrl = "https://api.github.com/repos/$($githubRepo)/releases"
$listRelsResp = Invoke-WebRequest -Headers $githubHeaders $listRelsUrl

$listRels = $listRelsResp.Content | ConvertFrom-Json
if (-not ($listRels.Count)) {
  throw "list releases response did not resolve to any releases"
}
else {
  Write-Output "Found [$($listRels.Count)] release(s)."
}

$thisRel = $listRels | Where-Object { $_.tag_name -eq $tagName }
if (-not $thisRel) {
  throw "could not find release for tag [$tagName]"
}
else {
  Write-Output "Found release [$($thisRel.tag_name)][$($thisRel.url)]"
}

$uploadUrl = $thisRel.upload_url.Replace(
  '{?name,label}','?name=pwsh-github-action-base-dist.zip')
$uploadHeaders = @{
  "Authorization" = "token $($env:GITHUB_TOKEN)"
  "Content-Type" = "application/zip"
}
Write-Output "Adding asset to [$uploadUrl]"
$uploadResp = Invoke-WebRequest -Headers $uploadHeaders $uploadUrl `
  -InFile pwsh-github-action-base-dist.zip
