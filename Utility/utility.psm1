# Load all function files from the Functions directory
$FunctionFiles = Get-ChildItem -Path "$PSScriptRoot\Functions" -Filter "*.ps1" -Exclude "optional.ps1"
foreach ($FunctionFile in $FunctionFiles) {
    . $FunctionFile.FullName
}

# Create a function to lazily load optional aliases
function Import-OptionalAliases {
    . "$PSScriptRoot\Functions\optional.ps1"
    Write-Host "Optional aliases have been loaded." -ForegroundColor Green
}

# Explicitly dot-source the required.ps1 file to ensure aliases are loaded
. "$PSScriptRoot\Functions\required.ps1"

# Export all functions from the module
Export-ModuleMember -Function *

# Export all aliases
Export-ModuleMember -Alias *

