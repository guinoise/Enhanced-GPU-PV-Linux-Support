Function Update-DriverDisk {
    Write-Host "Create/Update driver disk image"
    wsl ./scripts/create_driver_image.sh
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error while creating disk image"
    }
}