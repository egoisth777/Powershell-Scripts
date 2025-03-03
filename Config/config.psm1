# All users, All Hosts file settings
# Author @Yueyang Li
#
#
# Import all submodules
#####################################################


# Load the functions from scripts
$FunctionsPath = Join-Path $PSScriptRoot "Functions"
Get-ChildItem -Path $FunctionsPath -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}


# Export Region
#####################################################
Export-ModuleMember -Function *
Export-ModuleMember -Alias *
#####################################################