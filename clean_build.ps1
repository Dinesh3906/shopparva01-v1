Write-Host "Stopping Dart processes..."
Get-Process dart -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process flutter -ErrorAction SilentlyContinue | Stop-Process -Force

$buildDir = "build"
if (Test-Path $buildDir) {
    Write-Host "Removing build directory..."
    Remove-Item $buildDir -Recurse -Force -ErrorAction SilentlyContinue
    # Double check and wait a moment for handles to release
    Start-Sleep -Seconds 1
    if (Test-Path $buildDir) {
         Write-Host "Retrying removal of build directory..."
         Remove-Item $buildDir -Recurse -Force -ErrorAction Continue
    }
}
Write-Host "Cleanup complete."
