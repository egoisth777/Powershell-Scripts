# PSREADLINE CONFIGURATION
#REGION PSREADLINE CONFIGURATION
# @Author Yueyang Li
#
#
#
#
##################################
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+w" -Function ForwardWord
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{ InlinePrediction = $PSStyle.Background.green}

#ENDREGION