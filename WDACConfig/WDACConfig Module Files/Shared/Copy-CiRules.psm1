Function Copy-CiRules {
    <#
    .DESCRIPTION
        Copies the rules from one CI policy XML file to another
    .PARAMETER SourceFile
        The source CI policy XML file
    .PARAMETER DestinationFile
        The destination CI policy XML file
    .INPUTS
        System.IO.FileInfo
    .OUTPUTS
        System.Void
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    Param (
        [Parameter (Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [System.IO.FileInfo]$SourceFile,

        [Parameter (Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        [System.IO.FileInfo]$DestinationFile
    )

    # Load the XML files as objects
    [Xml.XmlDocument]$SourceFileContent = Get-Content -Path $SourceFile
    [Xml.XmlDocument]$DestinationFileContent = Get-Content -Path $DestinationFile

    # Replace the rules block in $DestinationFileContent with the rules block in $SourceFileContent
    # Use the ImportNode method to create a copy of the rules node from $SourceFileContent
    # The second parameter ($true) indicates a deep clone, meaning that the node and its descendants are copied
    # https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmldocument.importnode
    [Xml.XmlNode]$Rules = $DestinationFileContent.ImportNode($SourceFileContent.SiPolicy.Rules, $true)
    # Use the ReplaceChild method to replace the rules node in $DestinationFileContent with the copied node
    [System.Void]$DestinationFileContent.SiPolicy.ReplaceChild($Rules, $DestinationFileContent.SiPolicy.Rules)

    # Save the modified XML file
    $DestinationFileContent.Save($DestinationFile)
}
Export-ModuleMember -Function Copy-CiRules

# SIG # Begin signature block
# MIILkgYJKoZIhvcNAQcCoIILgzCCC38CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA3Y4loEgscxiwI
# F8O+3L1t/bRrN7CdqoE9p5ZotL7SGKCCB9AwggfMMIIFtKADAgECAhMeAAAABI80
# LDQz/68TAAAAAAAEMA0GCSqGSIb3DQEBDQUAME8xEzARBgoJkiaJk/IsZAEZFgNj
# b20xIjAgBgoJkiaJk/IsZAEZFhJIT1RDQUtFWC1DQS1Eb21haW4xFDASBgNVBAMT
# C0hPVENBS0VYLUNBMCAXDTIzMTIyNzExMjkyOVoYDzIyMDgxMTEyMTEyOTI5WjB5
# MQswCQYDVQQGEwJVSzEeMBwGA1UEAxMVSG90Q2FrZVggQ29kZSBTaWduaW5nMSMw
# IQYJKoZIhvcNAQkBFhRob3RjYWtleEBvdXRsb29rLmNvbTElMCMGCSqGSIb3DQEJ
# ARYWU3B5bmV0Z2lybEBvdXRsb29rLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAKb1BJzTrpu1ERiwr7ivp0UuJ1GmNmmZ65eckLpGSF+2r22+7Tgm
# pEifj9NhPw0X60F9HhdSM+2XeuikmaNMvq8XRDUFoenv9P1ZU1wli5WTKHJ5ayDW
# k2NP22G9IPRnIpizkHkQnCwctx0AFJx1qvvd+EFlG6ihM0fKGG+DwMaFqsKCGh+M
# rb1bKKtY7UEnEVAsVi7KYGkkH+ukhyFUAdUbh/3ZjO0xWPYpkf/1ldvGes6pjK6P
# US2PHbe6ukiupqYYG3I5Ad0e20uQfZbz9vMSTiwslLhmsST0XAesEvi+SJYz2xAQ
# x2O4n/PxMRxZ3m5Q0WQxLTGFGjB2Bl+B+QPBzbpwb9JC77zgA8J2ncP2biEguSRJ
# e56Ezx6YpSoRv4d1jS3tpRL+ZFm8yv6We+hodE++0tLsfpUq42Guy3MrGQ2kTIRo
# 7TGLOLpayR8tYmnF0XEHaBiVl7u/Szr7kmOe/CfRG8IZl6UX+/66OqZeyJ12Q3m2
# fe7ZWnpWT5sVp2sJmiuGb3atFXBWKcwNumNuy4JecjQE+7NF8rfIv94NxbBV/WSM
# pKf6Yv9OgzkjY1nRdIS1FBHa88RR55+7Ikh4FIGPBTAibiCEJMc79+b8cdsQGOo4
# ymgbKjGeoRNjtegZ7XE/3TUywBBFMf8NfcjF8REs/HIl7u2RHwRaUTJdAgMBAAGj
# ggJzMIICbzA8BgkrBgEEAYI3FQcELzAtBiUrBgEEAYI3FQiG7sUghM++I4HxhQSF
# hqV1htyhDXuG5sF2wOlDAgFkAgEIMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4GA1Ud
# DwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBsGCSsGAQQBgjcVCgQOMAwwCgYIKwYB
# BQUHAwMwHQYDVR0OBBYEFOlnnQDHNUpYoPqECFP6JAqGDFM6MB8GA1UdIwQYMBaA
# FICT0Mhz5MfqMIi7Xax90DRKYJLSMIHUBgNVHR8EgcwwgckwgcaggcOggcCGgb1s
# ZGFwOi8vL0NOPUhPVENBS0VYLUNBLENOPUhvdENha2VYLENOPUNEUCxDTj1QdWJs
# aWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9u
# LERDPU5vbkV4aXN0ZW50RG9tYWluLERDPWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRp
# b25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgccG
# CCsGAQUFBwEBBIG6MIG3MIG0BggrBgEFBQcwAoaBp2xkYXA6Ly8vQ049SE9UQ0FL
# RVgtQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZp
# Y2VzLENOPUNvbmZpZ3VyYXRpb24sREM9Tm9uRXhpc3RlbnREb21haW4sREM9Y29t
# P2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0
# aG9yaXR5MA0GCSqGSIb3DQEBDQUAA4ICAQA7JI76Ixy113wNjiJmJmPKfnn7brVI
# IyA3ZudXCheqWTYPyYnwzhCSzKJLejGNAsMlXwoYgXQBBmMiSI4Zv4UhTNc4Umqx
# pZSpqV+3FRFQHOG/X6NMHuFa2z7T2pdj+QJuH5TgPayKAJc+Kbg4C7edL6YoePRu
# HoEhoRffiabEP/yDtZWMa6WFqBsfgiLMlo7DfuhRJ0eRqvJ6+czOVU2bxvESMQVo
# bvFTNDlEcUzBM7QxbnsDyGpoJZTx6M3cUkEazuliPAw3IW1vJn8SR1jFBukKcjWn
# aau+/BE9w77GFz1RbIfH3hJ/CUA0wCavxWcbAHz1YoPTAz6EKjIc5PcHpDO+n8Fh
# t3ULwVjWPMoZzU589IXi+2Ol0IUWAdoQJr/Llhub3SNKZ3LlMUPNt+tXAs/vcUl0
# 7+Dp5FpUARE2gMYA/XxfU9T6Q3pX3/NRP/ojO9m0JrKv/KMc9sCGmV9sDygCOosU
# 5yGS4Ze/DJw6QR7xT9lMiWsfgL96Qcw4lfu1+5iLr0dnDFsGowGTKPGI0EvzK7H+
# DuFRg+Fyhn40dOUl8fVDqYHuZJRoWJxCsyobVkrX4rA6xUTswl7xYPYWz88WZDoY
# gI8AwuRkzJyUEA07IYtsbFCYrcUzIHME4uf8jsJhCmb0va1G2WrWuyasv3K/G8Nn
# f60MsDbDH1mLtzGCAxgwggMUAgEBMGYwTzETMBEGCgmSJomT8ixkARkWA2NvbTEi
# MCAGCgmSJomT8ixkARkWEkhPVENBS0VYLUNBLURvbWFpbjEUMBIGA1UEAxMLSE9U
# Q0FLRVgtQ0ECEx4AAAAEjzQsNDP/rxMAAAAAAAQwDQYJYIZIAWUDBAIBBQCggYQw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQx
# IgQgtwykq1bS93s5eouS7y6CnoktOEGZXay2Lj0sxqOO4zswDQYJKoZIhvcNAQEB
# BQAEggIAnXRDX1xdm0eu7I7cAurZ/FUzSmwhqWwxLapU6wor8rUYA67oYbAZpRpX
# ZAta3RwhArvnlREV7gaQlfR3X/roixUtwmd6awTIWYNW5D42NCvs7xvxYbp/aP//
# ZfdGbtHlLxZtA9O97aNz8R4Womx/PBcejRBt7Tl3F2j/Oo3pGN0Y2bK2hoqMNX7u
# NB0aiN5ZqIWsLOZm2Fzn1z2be+zqXmf9kTGctjeNMIh4vPvZQoPxPpHw6foKpUOu
# 4GiGWvzAxxl2lGlABcO3OxMeQwUHi0+aU7uIQn5eSVvx7ehsAUsKCx3FWTx2E6St
# H8NBZ4iKUHfB1BSeJDS3dFm2aAy0dhR/rgZkSJSSdyPhB8lAXw2lDfXaiVQR+IFS
# DKQMBEf1ITA7kBgaJ/CKnRKpM18qOYXJdRdUkjnVobNyKEY24EwQ/usRbTcE0fEa
# 4/OhNdjaq8vsBKgK3eAHInycnPj/gQqtt7R0k85QptOH0TPBxfbJrhiWCp+23UdT
# alY28RbHDqNe2U96D46lw4R1YMdpZt2X3327TukfgOLghNejzM7radYqlh526dd4
# sCcBakd1d2D4U9brCniHYRl7op24UdGUBup/zY9520Z6CawkUfD7KfoO2gWUQVoy
# Ro76zAlIdQY5RDw9a8/HP+XOoVXvqSQDpsPeGAHaY+LsAy8LQqk=
# SIG # End signature block
