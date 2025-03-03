# CONDA INITIALIZE
#REGION CONDA INITIALIZE
# !! Contents within this block are managed by 'conda init' !!

try{

  If (Test-Path "E:\dev\envs\anaconda3\Scripts\conda.exe") {
    (& "E:\dev\envs\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
  }
  Write-Host "Conda initialized successfully!" -ForegroundColor Green
}
catch{
  Write-Host "Error initializing conda: $_" -ForegroundColor Red
}
#ENDREGION