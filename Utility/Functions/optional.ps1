# Alias for mklink
# $link: link loaction
# $target: target location (path)
function mklink($link, $target){
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}