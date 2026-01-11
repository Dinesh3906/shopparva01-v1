$serverFile = "d:\shopparva v1\backend\server.js"
$mockFile = "d:\shopparva v1\backend\inject_mock_phones.js"

$lines = Get-Content $serverFile
$mockContent = Get-Content $mockFile

$injectionIndex = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -like "*app.get('/api/v1/products/search', (req, res) => {*") {
        $injectionIndex = $i
        break
    }
}

if ($injectionIndex -ne -1) {
    Write-Host "Injecting mock data at line $injectionIndex"
    
    $pre = $lines[0..($injectionIndex - 1)]
    $post = $lines[$injectionIndex..($lines.Count - 1)]
    
    $final = $pre + $mockContent + $post
    $final | Set-Content $serverFile -Encoding UTF8
    Write-Host "Done."
}
else {
    Write-Host "Injection marker not found."
}
