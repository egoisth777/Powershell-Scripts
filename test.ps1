# Try to import the meta_module if it exists
$metaModulePath = "E:\repos\Scripts\Powershell-Scripts\meta_module.psm1"
if (Test-Path $metaModulePath) {
    Import-Module $metaModulePath -ErrorAction SilentlyContinue
}

# Import the Utility module directly
Write-Host "Importing Utility module..." -ForegroundColor Yellow
Import-Module "$PSScriptRoot\Utility\Utility.psd1" -ErrorAction Stop
Write-Host "Utility module imported successfully!" -ForegroundColor Green

# Import the Config module directly
Write-Host "Importing Config module..." -ForegroundColor Yellow
Import-Module "$PSScriptRoot\Config\Config.psd1" -ErrorAction Stop
Write-Host "Config module imported successfully!" -ForegroundColor Green

# Test the aliases
try {
    $aliases = @("python3", "which", "grep", "touch")
    foreach ($alias in $aliases) {
        $aliasInfo = Get-Alias $alias -ErrorAction Stop
        Write-Host "Alias $alias -> $($aliasInfo.Definition)" -ForegroundColor Cyan
    }
} catch {
    Write-Host "Error testing aliases: $_" -ForegroundColor Red
}

# Test the Get-RequiredAliases function if it exists
if (Get-Command Get-RequiredAliases -ErrorAction SilentlyContinue) {
    Write-Host "Required aliases:" -ForegroundColor Yellow
    Get-RequiredAliases | Format-Table Name, Definition
}

# Test the Initialize-OhMyPosh function if it exists
if (Get-Command Initialize-OhMyPosh -ErrorAction SilentlyContinue) {
    Write-Host "Oh My Posh is available. You can reinitialize it by running Initialize-OhMyPosh" -ForegroundColor Yellow
}
