# PSREADLINE CONFIGURATION
#REGION PSREADLINE CONFIGURATION
# @Author Yueyang Li
#
#
#
#
##################################

# Function to initialize oh-my-posh
function Initialize-OhMyPosh {
    try {
        oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomicBit.omp.json" | Invoke-Expression
        Write-Host "Oh My Posh initialized successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error initializing Oh My Posh: $_" -ForegroundColor Red
    }
}

# Initialize Oh My Posh when this script is loaded
Initialize-OhMyPosh

# Export the function so it can be called manually if needed
Export-ModuleMember -Function Initialize-OhMyPosh
