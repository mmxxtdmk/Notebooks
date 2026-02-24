# build.ps1 - FINAL clean version (PowerShell 5.1 safe, no Unicode)

Write-Host "Rendering notebook to docs/index.html..." -ForegroundColor Cyan

# === Automatically find repository root (works even if script is in subfolder) ===
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = $scriptDir

while (-not (Test-Path (Join-Path $repoRoot "REACT_NATIVE_META_QUEST_APP_INSTRUCTION.ipynb"))) {
    $parent = Split-Path $repoRoot -Parent
    if ($parent -eq $repoRoot -or $parent -eq $null) {
        Write-Host "Error: Could not find repository root" -ForegroundColor Red
        Write-Host "Make sure the notebook is in the root folder" -ForegroundColor Yellow
        exit 1
    }
    $repoRoot = $parent
}

Write-Host "Repository root found: $repoRoot" -ForegroundColor DarkGray

# === Activate venv from root ===
$venvActivate = Join-Path $repoRoot "venv\Scripts\Activate.ps1"

if (Test-Path $venvActivate) {
    . $venvActivate
    Write-Host "venv activated successfully" -ForegroundColor Green
    
    # Run from root
    Set-Location $repoRoot
    
    jupyter nbconvert --to html --template full "REACT_NATIVE_META_QUEST_APP_INSTRUCTION.ipynb" --output docs/index.html

    Write-Host "Notebook rendered successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "   git add docs/index.html; git commit -m 'Update live guide'; git push" -ForegroundColor White
    Write-Host ""
    Write-Host "Live site -> https://mmxxtdmk.github.io/react-native-meta-quest-starter/" -ForegroundColor Magenta
} else {
    Write-Host "venv not found at: $venvActivate" -ForegroundColor Red
    Write-Host "Please ensure the venv folder is in the repository root." -ForegroundColor Yellow
}