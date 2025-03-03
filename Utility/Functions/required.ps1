# More Unix like aliases for PWSH native commands
# Set some useful aliases for PWSH
##############################
New-Alias -Name python3 -Value python -Force
New-Alias -Name which -Value where.exe -Force
New-Alias -Name grep -Value Select-String -Force
New-Alias -Name touch -Value New-Item -Force
##############################

# Some frequently used functions
function Get-RequiredAliases {
    Get-Alias | Where-Object Source -match 'required.ps1'
}

Export-ModuleMember -Function Get-RequiredAliases
Export-ModuleMember -Alias python3, which, grep, touch



