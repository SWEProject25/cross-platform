param(
  [string]$InputFile  = 'test.json',
  [string]$OutputFile = 'test_fixed.json'
)

$s = Get-Content -Raw -LiteralPath $InputFile
$s = $s -replace '("operationId":\s*"[^_]*_)','"operationId": "'
Set-Content -Encoding UTF8 -LiteralPath $OutputFile -Value $s
