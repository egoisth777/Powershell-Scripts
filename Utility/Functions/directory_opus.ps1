# Open Drectory Opus with specified path
function op {
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path = "."
    )
    
    # Resolve the path to get the full path (especially important for ".")
    $resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue
    
    if (-not $resolvedPath) {
        Write-Error "Invalid path: $Path"
        return
    }
    
    # Default Directory Opus executable path
    # Adjust this path if your Directory Opus is installed in a different location
    $dopusPath = "C:\Application\Productivity\Directory Opus\dopus.exe"
    
    # Check if Directory Opus executable exists
    if (-not (Test-Path $dopusPath)) {
        # Try common alternative installation paths
        $alternativePaths = @(
            "C:\Program Files (x86)\GPSoftware\Directory Opus\dopus.exe",
            "${env:ProgramFiles}\GPSoftware\Directory Opus\dopus.exe",
            "${env:ProgramFiles(x86)}\GPSoftware\Directory Opus\dopus.exe"
        )
        
        $dopusPath = $alternativePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
        
        if (-not $dopusPath) {
            Write-Error "Directory Opus executable not found. Please update the script with the correct path."
            return
        }
    }
    
    # Start Directory Opus with the specified path
    try {
        Start-Process -FilePath $dopusPath -ArgumentList """$($resolvedPath.Path)""" -ErrorAction Stop
        Write-Host "Opened Directory Opus at: $($resolvedPath.Path)" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to open Directory Opus: $_"
    }
}

#endregion
