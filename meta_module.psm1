# Meta Module - Imports and manages all submodules
# Author @Yueyang Li

# Get the directory where this script is located
$ModuleRoot = $PSScriptRoot

# Import all modules from the root directory
$Modules = Get-ChildItem -Path $ModuleRoot -Directory | Where-Object { 
    $_.Name -notin @('.git', 'Modules') -and 
    $_.Name -notmatch '^\..*' 
}

foreach ($Module in $Modules) {
    $ModuleName = $Module.Name
    $ModulePath = Join-Path $Module.FullName "$ModuleName.psd1"
    
    # If module has a manifest file, import it using that
    if (Test-Path $ModulePath) {
        Import-Module $ModulePath -Global
    } else {
        # Otherwise try to import the .psm1 file directly
        $ModulePath = Join-Path $Module.FullName "$ModuleName.psm1"
        if (Test-Path $ModulePath) {
          Import-Module $ModulePath -Global
        }
    }
}

# Export all imported functions and aliases to make them available
# when this meta module is imported
Export-ModuleMember -Function * -Alias *