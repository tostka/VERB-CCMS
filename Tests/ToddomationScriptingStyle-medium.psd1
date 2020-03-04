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