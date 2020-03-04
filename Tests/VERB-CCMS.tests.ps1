# verb-CCMS.Tests.ps1

<#
.SYNOPSIS
verb-CCMS.ps1 - verb-CCMS Pester Tests
.NOTES
Version     : 1.0.0
Author      : Todd Kadrie
Website     :	http://www.toddomation.com
Twitter     :	@tostka / http://twitter.com/tostka
CreatedDate : 2020-
FileName    : verb-CCMS.Tests.ps1
License     : MIT License
Copyright   : (c) 2020 Todd Kadrie
Github      : https://github.com/tostka
Tags        : Powershell,Pester,Testing,Development
REVISIONS
.DESCRIPTION
.EXAMPLE
cd c:\sc\verb-CCMS\ ;
.\Tests\verb-CCMS.Tests.ps1
.LINK
https://github.com/tostka
#>

[CmdletBinding()]
PARAM() ;
$Verbose = ($VerbosePreference -eq 'Continue') ;

# patch in ISE support
if ($psISE){
    $ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath ;
    $ScriptBaseName = split-path -leaf $psise.currentfile.fullpath ;
    $ScriptNameNoExt = [system.io.path]::GetFilenameWithoutExtension($psise.currentfile.fullpath) ;
    $PSScriptRoot = $ScriptDir ;
    if($PSScriptRoot -ne $ScriptDir){ write-warning "UNABLE TO UPDATE BLANK `$PSScriptRoot TO CURRENT `$ScriptDir!"} ;
    $PSCommandPath = $psise.currentfile.fullpath ;
    if($PSCommandPath -ne $psise.currentfile.fullpath){ write-warning "UNABLE TO UPDATE BLANK `$PSCommandPath TO CURRENT `$psise.currentfile.fullpath!"} ;
}


$ModuleName = Split-Path (Resolve-Path "$PSScriptRoot\..\" ) -Leaf
$ModuleManifest = Resolve-Path "$PSScriptRoot\..\$ModuleName\$ModuleName.psd1"
$ProjectRoot  = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace('tests', '')
if(!(test-path $ProjectRoot\README.md)){
    throw "Unable to resolve ProjectRoot!" ;
}
$moduleComponents = Get-ChildItem $ProjectRoot  -Include *.psd1, *.psm1, *.ps1 -Exclude *.tests.ps1,PPoShScriptingStyle.psd1 -Recurse
$projectScripts = $moduleComponents | ?{$_.extension -eq '.ps1'} | sort name ;
$projectModules = $moduleComponents | ?{$_.extension -eq '.psm1'} | sort name ;
$projectDatafiles = $moduleComponents | ?{$_.extension -eq '.psd1'} | sort name ;
# enable to suit pref
#$scriptStylePath = (Resolve-Path "$ProjectRoot\Tests\PPoShScriptingStyle.psd1").path ;
$scriptStylePath = (Resolve-Path "$ProjectRoot\Tests\ToddomationScriptingStyle-medium.psd1").path ;

$smsg=@"

    ==Current Config:
    `$ModuleName:$ModuleName
    `$ProjectRoot :$ProjectRoot
    `$ModuleManifest:$ModuleManifest
    `$scriptStylePath:$scriptStylePath

    `$moduleComponents:
    $(($moduleComponents.fullname|ft -a | out-string).trim())" ;

    `$projectScripts:
    $(($projectScripts.fullname|ft -a | out-string).trim())" ;

    `$projectModules:
    $(($projectModules.fullname|ft -a | out-string).trim())" ;

    `$projectDatafiles:
    $(($projectDatafiles.fullname|ft -a | out-string).trim())" ;

"@ ;
write-verbose -verbose:$verbose $smsg ;

Get-Module $ModuleName | Remove-Module
Import-Module $ModuleManifest -Force

Describe 'Module Information' -Tags 'Command'{
    Context 'Manifest Testing' {
        It 'Valid Module Manifest' {
            {
                $Script:Manifest = Test-ModuleManifest -Path $ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }
        It 'Valid Manifest Name' {
            $Script:Manifest.Name | Should -Be $ModuleName
        }
        It 'Generic Version Check' {
            $Script:Manifest.Version -as [Version] | Should -Not -BeNullOrEmpty
        }
        It 'Valid Manifest Description' {
            $Script:Manifest.Description | Should -Not -BeNullOrEmpty
        }
        It 'Valid Manifest Root Module' {
            $Script:Manifest.RootModule | Should -Be "$ModuleName.psm1"
        }
        It 'Valid Manifest GUID' {
            $Script:Manifest.Guid | Should -Be "b9637e55-12be-4916-8000-a949f9426fa3"
        }
    }

    Context 'Exported Functions' {
        It 'Proper Number of Functions Exported' {
            $Exported = Get-Command -Module $ModuleName ;
            $ExportedCount = $Exported | Measure-Object | Select-Object -ExpandProperty Count

            $Files = Get-ChildItem -Path "$ProjectRoot\Public" -Filter *.ps1 -Recurse
            $FileCount = $Files | Measure-Object | Select-Object -ExpandProperty Count

            $smsg=@"

    ==Exported Details:
    `$ExportedCount:$ExportedCount
    $($Exported|out-string)
    `$FileCount:$FileCount
    $($Files|out-string)


"@ ;
            write-verbose -verbose:$verbose $smsg ;

            $ExportedCount | Should be $FileCount
        }
    }


}

Describe 'General - Testing all scripts and modules against the Script Analyzer Rules' {
    Context "Checking files to test exist and Invoke-ScriptAnalyzer cmdLet is available" {
        It "Checking files exist to test." {
            $moduleComponents.count | Should Not Be 0
        }
        It "Checking Invoke-ScriptAnalyzer exists." {
            { Get-Command Invoke-ScriptAnalyzer -ErrorAction Stop } | Should Not Throw
        }
    }
} 

#region PSSA Testing
<# Calling PS Script analyzer with Pester : PowerShell - https://www.reddit.com/r/PowerShell/comments/6tmprp/calling_ps_script_analyzer_with_pester/
Shepherd_Ra, 2018
#>
<#
Describe -Tags 'PSSA' -Name 'Testing against PSScriptAnalyzer rules' {
    Context 'PSSA Standard Rules' {
        $ScriptAnalyzerSettings = Get-Content -Path $scriptStylePath | Out-String | Invoke-Expression
        #$AnalyzerIssues = Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\MyScript.ps1" -Settings "$PSScriptRoot\..\ScriptAnalyzerSettings.psd1"
        $AnalyzerIssues = Invoke-ScriptAnalyzer -Path $ProjectRoot -Recurse -Settings $scriptStylePath
        $ScriptAnalyzerRuleNames = Get-ScriptAnalyzerRule | Select-Object -ExpandProperty RuleName
        forEach ($Rule in $ScriptAnalyzerRuleNames) {
            $Skip = @{Skip=$False}
            if ($ScriptAnalyzerSettings.ExcludeRules -notcontains $Rule) {
                # We still want it in the tests, but since it doesn't actually get tested we will skip
                $Skip = @{Skip = $True}
            }
            It "Should pass $Rule" @Skip {
                $Failures = $AnalyzerIssues | Where-Object -Property RuleName -EQ -Value $rule
                ($Failures | Measure-Object).Count | Should Be 0
            }
        }
    }
}
#>
<# above extended with updated rule skip logic - shows *all* rules, marks skips
#>
Describe -Tags 'PSSA' -Name 'Testing against PSScriptAnalyzer rules' {
    Context 'PSSA Standard Rules' {
        #$ScriptAnalyzerSettings = Get-Content -Path $scriptStylePath | Out-String | Invoke-Expression
        # avoiding use invoke-expr (which is a pssa violation), leveraging Import-PowerShellDataFile instead
        $ScriptAnalyzerSettings = Import-PowerShellDataFile -path $scriptStylePath 
        #$AnalyzerIssues = Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\MyScript.ps1" -Settings "$PSScriptRoot\..\ScriptAnalyzerSettings.psd1"
        $AnalyzerIssues = Invoke-ScriptAnalyzer -Path $ProjectRoot -Recurse -Settings $scriptStylePath
        # $moduleComponents
        #$AnalyzerIssues = Invoke-ScriptAnalyzer -Path $moduleComponents -Settings $scriptStylePath
        $ScriptAnalyzerRuleNames = Get-ScriptAnalyzerRule | Select-Object -ExpandProperty RuleName
        forEach ($Rule in $ScriptAnalyzerRuleNames) {
            $Skip = $false ; 
            if($ScriptAnalyzerSettings.IncludeRules -contains $Rule){$skip=$false } ; 
            if($ScriptAnalyzerSettings.ExcludeRules -contains $Rule){$Skip = $true } ;
            <#$Skip = $ScriptAnalyzerSettings.IncludeRules -notcontains $Rule
            $Skip = $ScriptAnalyzerSettings.ExcludeRules -contains $Rule
            #>
            It "Should pass $Rule" -Skip:$Skip {
                $Failures = $AnalyzerIssues | Where-Object -Property RuleName -EQ -Value $rule
                ($Failures | Measure-Object).Count | Should Be 0
            }
        }
    }
}

<#
Describe 'Testing against ScriptAnalyzer rules' {
    Context "Rules:$scriptStylePath" {
        $report = Invoke-ScriptAnalyzer -Path $ProjectRoot -Recurse -Settings $scriptStylePath
        #$scriptAnalyzerRules = Get-ScriptAnalyzerRule
        $rulesHash = Import-PowerShellDataFile -path $scriptStylePath ;
        #forEach ($rule in $scriptAnalyzerRules) {
        forEach ($rule in $ruleshash.IncludeRules) {        
            It "Should pass $rule" {
                If ($report.RuleName -contains $rule) {
                    $report |
                    Where RuleName -EQ $rule -outvariable failures |
                    Out-Default
                    $failures.Count | Should Be 0
                }
            }
        }
    }
}
#>

<#
Describe 'General - Testing all scripts and modules against the Script Analyzer Rules' {
    Context "Checking files to test exist and Invoke-ScriptAnalyzer cmdLet is available" {
        It "Checking files exist to test." {
            $moduleComponents.count | Should Not Be 0
        }
        It "Checking Invoke-ScriptAnalyzer exists." {
            { Get-Command Invoke-ScriptAnalyzer -ErrorAction Stop } | Should Not Throw
        }
    }

    Context "Checking component files against settings:$scriptStylePath" {
        #write-verbose -verbose:$verbose "Using Settings:$($scriptStylePath)"
        

        $Report = Invoke-ScriptAnalyzer -Path $ProjectRoot -Recurse -Settings $scriptStylePath ;

        $Report.count | Should Be 0

        if ($verbose) {
            write-verbose -verbose:$verbose "`n`$Report | group severity" 
            "$(($report | group severity | sort count | ft -auto count,name|out-string).trim())`n" ;

            write-verbose -verbose:$verbose "`n`$Report | group rulename"
            "$(($report | group rulename | sort count | ft -auto count,name|out-string).trim())`n" ;

            write-verbose -verbose:$verbose "`n`$Report | group scriptname"
            "$(($report | group scriptpath | sort -desc count | ft -auto count,name|out-string).trim())`n" ;

            write-verbose -verbose:$verbose "`n Detailed per script report:" ;
            foreach ($scriptrpt in $scriptreported ) {
                $sBnrS = "`n#*------v $($scriptrpt): v------" ;
                "$($sBnrS)" ;
                "$(($report |?{$_.scriptname -eq $scriptrpt} | sort rulename,message | ft -auto Severity,Line,RuleName,Message|out-string).trim())`n" ;
                "$($sBnrS.replace('-v','-^').replace('v-','^-'))" ;
            } ;
        };
    }

    #>



$ofile = join-path -path (split-path $scriptStylePath) -child "ScriptAnalyzer-Results-$(get-date -format 'yyyyMMdd-HHmmtt').xml" ;

Describe 'ScriptAnalyzer Report written to:$ofile' {    
    $Report | export-clixml -path $ofile
    #write-verbose -verbose:$verbose  "ScriptAnalyzer Report written to:`n$($ofile)" ;
} 

#endregion
     

