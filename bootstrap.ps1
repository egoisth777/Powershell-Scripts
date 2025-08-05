#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Bootstrap script to set up the Scripts environment
.DESCRIPTION
    This script:
    1. Sets up the ENV VARs on Windows:
        A. Creates a global environment variable "SCRIPTS" pointing to the Scripts folder
        B. Creates a global environment variable "GIT_LOC" pointing to the Git Installation
        
    2. Creates a symbolic link from $LOCALAPPDATA/nvim to $SCRIPTS/Nvim-Config
    3. Creates a symbolic link from $PSHOME/Profile.ps1 to all_users_all_hosts.ps1
    
.NOTES
    This script requires Administrator privileges to create symbolic links and modify system environment variables.
#>

[CmdletBinding()]
param()

# Function definitions
function Bootstrap-Success {
    Write-Host "`n🎉 Bootstrap completed successfully!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Restart your PowerShell session or run: refreshenv" -ForegroundColor White
    Write-Host "2. Verify the SCRIPTS environment variable: `$env:SCRIPTS" -ForegroundColor White
    Write-Host "3. Your PowerShell profile will now load automatically" -ForegroundColor White
}

function Bootstrap-Failed {
    Write-Error "Bootstrap failed: $($_.Exception.Message)"
    Write-Host "Make sure you're running this script as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Starting Scripts environment bootstrap..." -ForegroundColor Green

# Get the Scripts directory (parent of Powershell-Scripts)
$ScriptsPath = Split-Path -Parent $PSScriptRoot
$PowershellScriptsPath = $PSScriptRoot

Write-Host "Scripts directory: $ScriptsPath" -ForegroundColor Yellow
Write-Host "PowerShell Scripts directory: $PowershellScriptsPath" -ForegroundColor Yellow

try {
    # A. Create global environment variable SCRIPTS
    Write-Host "`n1a. Setting up SCRIPTS environment variable..." -ForegroundColor Cyan
    
    # Set system environment variable
    [Environment]::SetEnvironmentVariable("SCRIPTS", $ScriptsPath, [EnvironmentVariableTarget]::Machine)
    
    # Also set for current session
    $env:SCRIPTS = $ScriptsPath
    
    Write-Host "   ✓ SCRIPTS environment variable set to: $ScriptsPath" -ForegroundColor Green
} catch {
    Write-Error "Failed to set SCRIPTS environment variable: $($_.Exception.Message)"
}


try {
    # B. Create a new environment variable named $GIT_LOC
    Write-Host "`n1b. Setting up GIT_LOC environment variable..." -ForegroundColor Cyan

    $gitlocstr = Get-Command git | Select-Object -ExpandProperty Path
    $gitlocstr = $gitlocstr.Replace("git.exe", "")
    $gitlocstr = $gitlocstr -replace "\\cmd\\?$", ""
    $env:GIT_LOC = $gitlocstr # Set it for current session
    [Environment]::SetEnvironmentVariable("GIT_LOC", $gitlocstr, [EnvironmentVariableTarget]::Machine)
    Write-Host "   ✓ GIT_LOC environment variable set to: $gitlocstr" -ForegroundColor Green
} catch {
    Write-Error "Failed to set GIT_LOC environment variable: $($_.Exception.Message)"
    Bootstrap-Failed
    exit 1
}
    

<#
2. Creating Symbolic Links
    A. Nvim Config
    B. PowerShell Profile
#> 
try {
    Write-Host "`n2a. Setting up Nvim configuration symbolic link..." -ForegroundColor Cyan
    
    $NvimLocalPath = "$env:LOCALAPPDATA\nvim"
    $NvimConfigPath = "$ScriptsPath\Nvim-Config"
    # Check if Nvim-Config exists
    if (-not (Test-Path $NvimConfigPath)) {
        Write-Warning "Nvim-Config directory not found at: $NvimConfigPath"
        Write-Host "   ⚠ Skipping Nvim symbolic link creation" -ForegroundColor Yellow
    } else {
        # Remove existing nvim folder if it exists and is not a symbolic link
        if (Test-Path $NvimLocalPath) {
            $item = Get-Item $NvimLocalPath
            if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
                Write-Host "   → Existing symbolic link found, removing..." -ForegroundColor Yellow
                Remove-Item $NvimLocalPath -Force
            } else {
                Write-Host "   → Existing nvim directory found, backing up to nvim.backup..." -ForegroundColor Yellow
                if (Test-Path "$NvimLocalPath.backup") {
                    Remove-Item "$NvimLocalPath.backup" -Recurse -Force
                }
                Move-Item $NvimLocalPath "$NvimLocalPath.backup"
            }
        }
        
        # Create the symbolic link
        New-Item -ItemType SymbolicLink -Path $NvimLocalPath -Target $NvimConfigPath -Force | Out-Null
        Write-Host "   ✓ Symbolic link created: $NvimLocalPath → $NvimConfigPath" -ForegroundColor Green
    }
} catch {
    Write-Error "Failed to create Nvim configuration symbolic link: $($_.Exception.Message)"
    Bootstrap-Failed
    exit 1
}

# 3.b Create Symbolic link for PowerShell Profile
try {
    Write-Host "`n3. Setting up PowerShell profile symbolic link..." -ForegroundColor Cyan
    
    $ProfilePath = "$PSHOME\Profile.ps1"
    $AllUsersProfilePath = "$PowershellScriptsPath\all_users_all_hosts.ps1"
    
    # Check if all_users_all_hosts.ps1 exists
    if (-not (Test-Path $AllUsersProfilePath)) {
        Write-Error "all_users_all_hosts.ps1 not found at: $AllUsersProfilePath"
        return
    }
    
    # Remove existing Profile.ps1 if it exists and is not a symbolic link
    if (Test-Path $ProfilePath) {
        $item = Get-Item $ProfilePath
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Host "   → Existing Profile.ps1 symbolic link found, removing..." -ForegroundColor Yellow
            Remove-Item $ProfilePath -Force
        } else {
            Write-Host "   → Existing Profile.ps1 found, backing up to Profile.ps1.backup..." -ForegroundColor Yellow
            if (Test-Path "$ProfilePath.backup") {
                Remove-Item "$ProfilePath.backup" -Force
            }
            Move-Item $ProfilePath "$ProfilePath.backup"
        }
    }
    
    # Create the symbolic link
    New-Item -ItemType SymbolicLink -Path $ProfilePath -Target $AllUsersProfilePath -Force | Out-Null
    Write-Host "   ✓ Symbolic link created: $ProfilePath → $AllUsersProfilePath" -ForegroundColor Green
    
} catch {
    Write-Error "Failed to create PowerShell profile symbolic link: $($_.Exception.Message)"
    Bootstrap-Failed
    exit 1
}

Bootstrap-Success
