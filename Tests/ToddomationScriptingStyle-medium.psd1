@{
    Severity = @('Error', 'Warning', 'Information')
    ExcludeRules = @(
        'PSProvideCommentHelp',
        'PSAvoidUsingWriteHost',
        'PSAvoidGlobalVars',
        'PSUseCmdletCorrectly',
        'PSUseConsistentWhitespace',
        'PSUseApprovedVerbs',
        'PSAvoidUsingCmdletAliases',
        'PSUseDeclaredVarsMoreThanAssignments'
    )
    IncludeRules = @(   
        'PSAvoidDefaultValueForMandatoryParameter',
        'PSAvoidDefaultValueSwitchParameter',
        'PSAvoidGlobalAliases',
        'PSAvoidGlobalFunctions',
        'PSAvoidUsingPlainTextForPassword',
        'PSAvoidTrapStatement',
        'PSAvoidUninitializedVariable',
        'PSAvoidUsingComputerNameHardcoded',
        'PSAvoidUsingConvertToSecureStringWithPlainText',
        'PSAvoidUsingEmptyCatchBlock',
        'PSAvoidUsingFilePath',
        'PSAvoidUsingInvokeExpression',
        'PSAvoidUsingPlainTextForPassword',
        'PSAvoidUsingPositionalParameters',
        'PSAvoidUsingUserNameAndPasswordParams',
        'PSAvoidUsingWMICmdlet',
        'PSDSC*',
        'PSMisleadingBacktick',
        'PSMissingModuleManifestField',
        'PSPlaceOpenBrace',
        'PSPossibleIncorrectComparisonWithNull',
        'PSReservedCmdletChar',
        'PSReservedParams',
        'PSReturnCorrectTypesForDSCFunctions',
        'PSShouldProcess',
        'PSStandardDSCFunctionsInResource',
        'PsUseBOMForUnicodeEncodedFile',
        'PSUseConsistentIndentation',
        'PSUseIdenticalMandatoryParametersForDSC',
        'PSUseIdenticalParametersForDSC',
        'PSUseLiteralInitializerForHashtable',
        'PSUseOutputTypeCorrectly',
        'PSUsePSCredentialType',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSUseSingularNouns',
        'PSUseSupportsShouldProcess',
        'PSUseVerboseMessageInDSCResource',
        'PSPlaceCloseBrace',
        'PSPlaceOpenBrace',
        'PSUseConsistentWhitespace'
                   )

    Rules = @{
        PSPlaceCloseBrace = @{
            Enable = $true
            NoEmptyLineBefore = $false
            IgnoreOneLineBlock = $true
            NewLineAfter = $false
        }

        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
            NewLineAfter = $false
            IgnoreOneLineBlock = $true
        }

        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckOpenBrace = $false
            CheckOpenParen = $false
            CheckOperator = $false
            CheckSeparator = $false
        }
    }
}
# SIG # Begin signature block
# MIIELgYJKoZIhvcNAQcCoIIEHzCCBBsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUQqa1N9aXTDYq7UHg6IyFTSlp
# LEigggI4MIICNDCCAaGgAwIBAgIQWsnStFUuSIVNR8uhNSlE6TAJBgUrDgMCHQUA
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
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT+6l5j
# Lp2PlpdZuQyMgPleivpfLjANBgkqhkiG9w0BAQEFAASBgCJ8p4mZeOXRJRzAuWCi
# YABvtl861V1fT2RqgXyB+4e1z6v4CEvmvymXjgyu1MrY7KCPkiwvocdIUAT2XmKz
# GHYZ/KG+rEsPtYp6rpDe70TGc91C//9KJksvHd1OqLqSM3b8tGh11eqPdtNpPo8E
# FbSnUSM1sq9BTNkNvVPl/zYF
# SIG # End signature block
