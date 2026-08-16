param(
  [Parameter(Mandatory=$true)][ValidateSet('inspect','apply')][string]$Mode,
  [Parameter(Mandatory=$true)][string]$InputDwg,
  [Parameter(Mandatory=$true)][string]$WorkDir,
  [string]$Plan,
  [string]$OutputDwg,
  [string]$CoreConsole
)

$ErrorActionPreference = 'Stop'
function Get-AcadScriptPath([string]$Path) {
  $resolved = (Resolve-Path -LiteralPath $Path).Path
  try {
    $fso = New-Object -ComObject Scripting.FileSystemObject
    if (Test-Path -LiteralPath $resolved -PathType Leaf) { return $fso.GetFile($resolved).ShortPath }
    return $fso.GetFolder($resolved).ShortPath
  } catch {
    return $resolved
  }
}
$inputPath = (Resolve-Path -LiteralPath $InputDwg).Path
if ([IO.Path]::GetExtension($inputPath) -ine '.dwg') { throw 'InputDwg must be a .dwg file.' }
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
$workPath = (Resolve-Path -LiteralPath $WorkDir).Path
$commonDocs = [Environment]::GetFolderPath('CommonDocuments')
$acadStage = Join-Path $commonDocs "CodexCadRunner\run-$PID"
New-Item -ItemType Directory -Force -Path $acadStage | Out-Null

if (-not $CoreConsole) {
  $candidate = Get-ChildItem -LiteralPath 'C:\Program Files\Autodesk' -Filter accoreconsole.exe -Recurse -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending | Select-Object -First 1
  if (-not $candidate) { throw 'AutoCAD Core Console was not found. Install AutoCAD or pass -CoreConsole.' }
  $CoreConsole = $candidate.FullName
}
$corePath = (Resolve-Path -LiteralPath $CoreConsole).Path
$localDwg = Join-Path $workPath 'source-copy.dwg'
Copy-Item -LiteralPath $inputPath -Destination $localDwg -Force
$scriptPath = Join-Path $workPath "$Mode.scr"
$logPath = Join-Path $workPath "$Mode.log"

if ($Mode -eq 'inspect') {
  $inspectorSource = Join-Path $PSScriptRoot 'inspect_dwg.lsp'
  $inspector = Join-Path $acadStage 'inspect_dwg.lsp'
  Copy-Item -LiteralPath $inspectorSource -Destination $inspector -Force
  $report = Join-Path $workPath 'dwg-report.tsv'
  $stagedReport = Join-Path $acadStage 'dwg-report.tsv'
  $env:CODEX_DWG_REPORT = $stagedReport
  $inspectorForAcad = Get-AcadScriptPath $inspector
  $lines = @('(setvar "SECURELOAD" 0)', "(load `"$($inspectorForAcad.Replace('\','/'))`")", 'DWGINSPECT', '_QUIT', '_Y')
} else {
  if (-not $Plan -or -not $OutputDwg) { throw 'Apply mode requires -Plan and -OutputDwg.' }
  $planPath = (Resolve-Path -LiteralPath $Plan).Path
  if ([IO.Path]::GetExtension($OutputDwg) -ine '.dwg') { throw 'OutputDwg must end in .dwg.' }
  $outputFull = [IO.Path]::GetFullPath($OutputDwg)
  if ($outputFull -eq $inputPath) { throw 'Refusing to overwrite the source drawing.' }
  $stagedPlan = Join-Path $acadStage 'annotation-plan.lsp'
  Copy-Item -LiteralPath $planPath -Destination $stagedPlan -Force
  $planForAcad = Get-AcadScriptPath $stagedPlan
  $outputForAcad = Join-Path $acadStage 'annotated-output.dwg'
  $lines = @('(setvar "SECURELOAD" 0)', "(load `"$($planForAcad.Replace('\','/'))`")", 'APPLYANNOTATIONS', '_SAVEAS', '_2018', $outputForAcad, '_QUIT', '_Y')
}
Set-Content -LiteralPath $scriptPath -Value $lines -Encoding ASCII
& $corePath /i $localDwg /s $scriptPath /l en-US 2>&1 | Tee-Object -LiteralPath $logPath
if ($LASTEXITCODE -ne 0) { throw "AutoCAD Core Console failed with exit code $LASTEXITCODE. See $logPath" }
if ($Mode -eq 'inspect') {
  if (-not (Test-Path -LiteralPath $stagedReport)) { throw "Inspection report was not created. See $logPath" }
  Copy-Item -LiteralPath $stagedReport -Destination $report -Force
  Get-Item -LiteralPath $report
} else {
  if (-not (Test-Path -LiteralPath $outputForAcad)) { throw "Output DWG was not created. See $logPath" }
  Copy-Item -LiteralPath $outputForAcad -Destination $outputFull -Force
  Get-Item -LiteralPath $outputFull
}
