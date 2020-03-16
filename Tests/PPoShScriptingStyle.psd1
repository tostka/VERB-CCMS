@{
    Severity = @('Error', 'Warning', 'Information')
    IncludeRules = @(   
                   'PSAvoidDefaultValueForMandatoryParameter',
                   'PSAvoidDefaultValueSwitchParameter',
                   'PSAvoidGlobalAliases',
                   'PSAvoidGlobalFunctions',
                   'PSAvoidGlobalVars',
                   'PSAvoidUsingPlainTextForPassword',
                   'PSAvoidTrapStatement',
                   'PSAvoidUninitializedVariable',
                   'PSAvoidUsingCmdletAliases',
                   'PSAvoidUsingComputerNameHardcoded',
                   'PSAvoidUsingConvertToSecureStringWithPlainText',
                   'PSAvoidUsingEmptyCatchBlock',
                   'PSAvoidUsingFilePath',
                   'PSAvoidUsingInvokeExpression',
                   'PSAvoidUsingPlainTextForPassword',
                   'PSAvoidUsingPositionalParameters',
                   'PSAvoidUsingUserNameAndPasswordParams',
                   'PSAvoidUsingWMICmdlet',
                   'PSAvoidUsingWriteHost',
                   'PSDSC*',
                   'PSMisleadingBacktick',
                   'PSMissingModuleManifestField',
                   'PSPlaceCloseBrace',
                   'PSPlaceOpenBrace',
                   'PSPossibleIncorrectComparisonWithNull',
                   'PSProvideCommentHelp'
                   'PSReservedCmdletChar',
                   'PSReservedParams',
                   'PSReturnCorrectTypesForDSCFunctions',
                   'PSShouldProcess',
                   'PSStandardDSCFunctionsInResource',
                   'PSUseApprovedVerbs',
                   'PsUseBOMForUnicodeEncodedFile',
                   'PSUseCmdletCorrectly',
                   'PSUseConsistentIndentation',
                   'PSUseConsistentWhitespace',
                   'PSUseIdenticalMandatoryParametersForDSC',
                   'PSUseIdenticalParametersForDSC',
                   'PSUseDeclaredVarsMoreThanAssignments',
                   'PSUseLiteralInitializerForHashtable',
                   'PSUseOutputTypeCorrectly',
                   'PSUsePSCredentialType',
                   'PSUseShouldProcessForStateChangingFunctions',
                   'PSUseSingularNouns',
                   'PSUseSupportsShouldProcess',
                   'PSUseVerboseMessageInDSCResource'
                   )

    Rules = @{
        PSPlaceCloseBrace = @{
            Enable = $true
            NoEmptyLineBefore = $true
            IgnoreOneLineBlock = $true
            NewLineAfter = $true
        }

        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
            NewLineAfter = $true
            IgnoreOneLineBlock = $true
        }

        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator = $true
            CheckSeparator = $true
        }
    }
}
# SIG # Begin signature block
# MIIELgYJKoZIhvcNAQcCoIIEHzCCBBsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUI/LaBpjwkXImH6tV34qXhz9q
# Pm6gggI4MIICNDCCAaGgAwIBAgIQWsnStFUuSIVNR8uhNSlE6TAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDEyMjkxNzA3MzNaFw0zOTEyMzEyMzU5NTlaMBUxEzARBgNVBAMTClRvZGRT
# ZWxmSUkwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALqRVt7uNweTkZZ+16QG
# a+NnFYNRPPa8Bnm071ohGe27jNWKPVUbDfd0OY2sqCBQCEFVb5pqcIECRRnlhN5H
# +EEJmm2x9AU0uS7IHxHeUo8fkW4vm49adkat5gAoOZOwbuNntBOAJy9LCyNs4F1I
# KKphP3TyDwe8XqsEVwB2m9FPAgMBAAGjdjB0MBMGA1UdJQQMMAoGCCsGAQUFBwMD
# MF0GA1UdAQRWMFSAEL95r+Rh65kgqZl+tgchMuKhLjAsMSowKAYDVQQDEyFQb3dl
# clNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3SCEGwiXbeZNci7Rxiz/r43gVsw
# CQYFKw4DAh0FAAOBgQB6ECSnXHUs7/bCr6Z556K6IDJNWsccjcV89fHA/zKMX0w0
# 6NefCtxas/QHUA9mS87HRHLzKjFqweA3BnQ5lr5mPDlho8U90Nvtpj58G9I5SPUg
# CspNr5jEHOL5EdJFBIv3zI2jQ8TPbFGC0Cz72+4oYzSxWpftNX41MmEsZkMaADGC
# AWAwggFcAgEBMEAwLDEqMCgGA1UEAxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZp
# Y2F0ZSBSb290AhBaydK0VS5IhU1Hy6E1KUTpMAkGBSsOAwIaBQCgeDAYBgorBgEE
# AYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwG
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSYh+9G
# /2D3YDifCOCqKe6baQQ2izANBgkqhkiG9w0BAQEFAASBgLMzY5QLlrsU1d5XTOJZ
# wsC7/YYtobwtZhGytR05x59h0GloLPEGqqFJyfoqyreknAtFhGwiveHJ44ldWw/H
# 3bFv21TAS5Z/ybQFe1RhvQ+P5D3H8Ss5gjoILlR7vLzpe3SM6FVLWh9DROta8M8o
# Foh7VPTHRRlN3Ffi/4ZLST0n
# SIG # End signature block
