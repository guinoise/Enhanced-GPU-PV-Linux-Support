<#
    .SYNOPSIS
    Prepare the environment to create an Ubuntu VM with vGPU support (via WSL2)

    .DESCRIPTION
    Download (if required) the ISO from Ubuntu and setup the WSL environment for Ubuntu
    
    .PARAMETER Flavor
    Ubuntu flavor, desktop or server. Default to server.

    .PARAMETER UbuntuVersion
    The Ubuntu version to download, default to 24.04.1

    .PARAMETER Architecture
    Ubuntu ISO architecture, default to amd64

    .PARAMETER Force
    Overwrite the ISO file if already downloaded

    .INPUTS
    None. You can't pipe objects to Add-Extension.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Prepare-Environement.ps1

#>  
param(
    [Parameter()]
    [ValidateSet('desktop','server')]
    [string[]]
    $Flavor= "server",

    [string]
    $UbuntuVersion = "24.04.1",

    [string]
    $Architecture= "amd64",

    [switch]
    $Force
)

switch ($Flavor) {
    "server" {$iso="server.iso"; $image="live-server"}
    "desktop" {$iso="desktop.iso"; $image="desktop"}
}

Import-Module $PSSCriptRoot\Utils.psm1

$Major= $UbuntuVersion.Substring(0, $UbuntuVersion.LastIndexOf('.'))
$WSL_Image = "Ubuntu-${Major}" 
$link="https://releases.ubuntu.com/${UbuntuVersion}/ubuntu-${UbuntuVersion}-${image}-${Architecture}.iso"

Write-Host "Ubuntu version : ${UbuntuVersion} Major : ${Major}"
Write-Host "ISO file : ${iso}"
Write-Host "Download URL: ${link}"
Write-Host "WSL Image : ${WSL_Image}"

if (-Not (Test-Path -Path $iso -PathType Leaf) -or $Force) {
    Write-Host "Downloading from ubuntu"
    Invoke-WebRequest $link -OutFile $iso
} else {
    Write-Warning "ISO file already downloaded. Use -Force to overwrite"
}

Write-Host "Set WSL default image to ${WSL_Image}"
wsl --set-default ${WSL_Image}
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error setting WSL default image. The command issued was : wsl --set-default ${WSL_Image}"
    Write-Error "Set WSL environement."
    Write-Warning "Available images (wsl --list --online) :"
    wsl --list --online
}

Write-Host "Prepare driver archive wsl.tgz"
wsl tar -C /usr/lib -czf wsl.tgz wsl


