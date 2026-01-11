$serverFile = "d:\shopparva v1\backend\server.js"
$newLogicFile = "d:\shopparva v1\backend\new_search_logic.js"

$lines = Get-Content $serverFile
$newLogic = Get-Content $newLogicFile

$startIndex = -1
$endIndex = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -like "*app.get('/api/v1/products/search', (req, res) => {*") {
        $startIndex = $i
    }
    if ($startIndex -ne -1 -and $lines[$i] -like "*// Prioritize Visible Products*") {
        $endIndex = $i
        break
    }
}

if ($startIndex -ne -1 -and $endIndex -ne -1) {
    Write-Host "Replacing lines $startIndex to $($endIndex-1)"
    # PS array slicing
    if ($startIndex -eq 0) {
        $pre = @()
    } else {
        $pre = $lines[0..($startIndex-1)]
    }
    
    $post = $lines[$endIndex..($lines.Count-1)]
    
    $final = $pre + $newLogic + $post
    $final | Set-Content $serverFile -Encoding UTF8
    Write-Host "Done."
} else {
    Write-Host "Markers not found. Start: $startIndex End: $endIndex"
}
