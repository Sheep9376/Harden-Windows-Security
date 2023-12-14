if (!$IsWindows) {
    Throw 'The WDACConfig module only runs on Windows operation systems.'
}

# Create tamper resistant global variables (if they don't already exist)
try {
    if ((Test-Path -Path 'Variable:\Requiredbuild') -eq $false) { New-Variable -Name 'Requiredbuild' -Value '22621.2428' -Option 'Constant' -Scope 'Script' -Description 'Minimum required OS build number' -Force }
    if ((Test-Path -Path 'Variable:\OSBuild') -eq $false) { New-Variable -Name 'OSBuild' -Value ([System.Environment]::OSVersion.Version.Build) -Option 'Constant' -Scope 'Script' -Description 'Current OS build version' -Force }
    if ((Test-Path -Path 'Variable:\UBR') -eq $false) { New-Variable -Name 'UBR' -Value (Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'UBR') -Option 'Constant' -Scope 'Script' -Description 'Update Build Revision (UBR) number' -Force }
    if ((Test-Path -Path 'Variable:\FullOSBuild') -eq $false) { New-Variable -Name 'FullOSBuild' -Value "$OSBuild.$UBR" -Option 'Constant' -Scope 'Script' -Description 'Create full OS build number as seen in Windows Settings' -Force }
}
catch {
    Throw 'Could not set the required global variables.'
}

# A constant variable that is automatically imported in the caller's environment and used to detect the main module's root directory
# Create it only if it's not already present, helps when user tries to import the module over and over again without closing the PowerShell session
try {
    Get-Variable -Name 'HardeningModulePath' -ErrorAction Stop | Out-Null
}
catch {
    try {
        New-Variable -Name 'HardeningModulePath' -Value ($PSScriptRoot) -Option 'Constant' -Scope 'Global' -Description 'Storing the value of $PSScriptRoot in a global constant variable to allow the internal functions to use it when navigating the module structure' -Force
    }
    catch {
        Throw 'Could not set the HardeningModulePath required global variable.'
    }
}

# Make sure the current OS build is equal or greater than the required build number
if (-NOT ([System.Decimal]$FullOSBuild -ge [System.Decimal]$Requiredbuild)) {
    Throw [System.PlatformNotSupportedException] "You are not using the latest build of the Windows OS. A minimum build of $Requiredbuild is required but your OS build is $FullOSBuild`nPlease go to Windows Update to install the updates and then try again."
}

# check if user's OS is Windows Home edition
if ((Get-CimInstance -ClassName Win32_OperatingSystem).OperatingSystemSKU -eq '101') {
    Throw 'Windows Home edition detected, exiting...'
}
