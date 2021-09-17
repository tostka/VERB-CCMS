# verb-ccms.psm1


<#
.SYNOPSIS
VERB-CCMS - o365 Security & Compliance PS Module-related generic functions
.NOTES
Version     : 1.0.16.0
Author      : Todd Kadrie
Website     :	https://www.toddomation.com
Twitter     :	@tostka
CreatedDate : 12/26/2019
FileName    : VERB-CCMS.psm1
License     : MIT
Copyright   : (c) 12/26/2019 Todd Kadrie
Github      : https://github.com/tostka
AddedCredit : REFERENCE
AddedWebsite:	REFERENCEURL
AddedTwitter:	@HANDLE / http://twitter.com/HANDLE
REVISIONS
* 12/26/2019 - 1.0.0.0
* 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
* 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
* 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
* 7:58 PM 11/20/2019 spliced over current updated MFA supporting verb-EXO content adapted to CCMS
* 12:58 PM 6/5/2019 updated the echo from Exo -> Security & Compliance
* 1:02 PM 11/7/2018 added Disconnect-PssBroken
# 9:04 PM 7/11/2018 synced to tsksid-incl-ServerApp.ps1
.DESCRIPTION
VERB-CCMS - o365 Security & Compliance PS Module-related generic functions
.EXAMPLE
.EXAMPLE
.LINK
https://github.com/tostka/verb-CCMS
#>


$script:ModuleRoot = $PSScriptRoot ;
$script:ModuleVersion = (Import-PowerShellDataFile -Path (get-childitem $script:moduleroot\*.psd1).fullname).moduleversion ;

#*======v FUNCTIONS v======



#*------v cccmsCMW.ps1 v------
function cccmsCMW {Connect-CCMS -cred $credO365CMWCSID}

#*------^ cccmsCMW.ps1 ^------

#*------v cccmsTOL.ps1 v------
function cccmsTOL {Connect-CCMS -cred $credO365TOLSID}

#*------^ cccmsTOL.ps1 ^------

#*------v cccmsTOR.ps1 v------
function cccmsTOR {Connect-CCMS -cred $credO365TORSID}

#*------^ cccmsTOR.ps1 ^------

#*------v cccmsVEN.ps1 v------
function cccmsVEN {Connect-CCMS -cred $credO365VENCSID}

#*------^ cccmsVEN.ps1 ^------

#*------v Connect-CCMS.ps1 v------
Function Connect-CCMS {
    <#
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2020-05-27
    FileName    : Connect-CCMS.ps1
    License     : MIT License
    Copyright   : (c) 2020 Todd Kadrie
    Github      : https://github.com/tostka
    Tags        : Powershell
    AddedCredit : REFERENCE
    AddedWebsite:	URL
    AddedTwitter:	URL    REVISIONS   :
    * 2:44 PM 3/2/2021 added console TenOrg color support
    * 7:13 AM 7/22/2020 replaced codeblock w get-TenantTag()
    * 12:18 PM 5/27/2020 updated cbh, moved alias:cccms win func
    * 4:17 PM 5/14/2020 fixed fundemental typos, in port over from verb-exo, mfa is just sketched in... we don't have it enabled, so it needs live debugging to update
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .PARAMETER  ProxyEnabled
    Use Proxy-Aware SessionOption settings [-ProxyEnabled]
    .PARAMETER  CommandPrefix
    [noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab ]
    .PARAMETER  Credential
    Credential to use for this connection [-credential 'logon@DOMAIN.com']
    .INPUTS
    None. Does not accepted piped input.
    .OUTPUTS
    None. Returns no objects or output.
    .EXAMPLE
    Connect-CCMS
    Connect using defaults, and leverage any pre-set $global:o365cred variable
    .EXAMPLE
    Connect-CCMS -CommandPrefix cc -credential (Get-Credential -credential logon@DOMAIN.com)  ;
    Connect an explicit credential, and use 'cc' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>
    [CmdletBinding()]
    [Alias('cccms')]
   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'cc',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ;
    $verbose = ($VerbosePreference -eq "Continue") ;
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ;

    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){
      $CommandPrefix='cc' ;
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ;

    $sTitleBarTag="CCMS" ;
    $TentantTag=get-TenantTag -Credential $Credential ;
    if($TentantTag -ne 'TOR'){
        # explicitly leave this tenant (default) untagged
        $sTitleBarTag += $TentantTag ;
    } ;

    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ;
        ErrorAction         = 'Stop' ;
    } ;

    if($MFA){
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter      = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;

            if ($showDebug) { write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ;
            $ExoPSModule = Get-ChildItem @ExoPSModuleSearchProperties |
            Where-Object { $_.FullName -notmatch '_none_' } |
            Sort-Object LastWriteTime |
            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll', '.psd1' ;
            if (!(Get-Module $ExoPSModule.FullName -ListAvailable -ErrorAction 0 )) {
                write-verbose -verbose:$true  "Unable to`nGet-Module $($ExoPSModule.FullName) -ListAvailable`ndiverting to hardcoded exoMFAModule`nRequires that it be locally copied below`n$env:userprofile\documents\WindowsPowerShell\Modules\exoMFAModule\`n " ;
                # go to a hard load path $env:userprofile\documents\WindowsPowerShell\Modules\exoMFAModule\
                $ExoPSModuleSearchProperties = @{
                    Path        = "$($env:userprofile)\documents\WindowsPowerShell\Modules\exoMFAModule\" ;
                    Filter      = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                    Recurse     = $true ;
                    ErrorAction = 'Stop' ;
                } ;
                $ExoPSModule = Get-ChildItem @ExoPSModuleSearchProperties |
                Where-Object { $_.FullName -notmatch '_none_' } |
                Sort-Object LastWriteTime |
                Select-Object -Last 1 ;
                # roll an otf psd1+psm1 module
                # pull the broken ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                $NewExoPSModuleManifestProps = @{
                    Path        = $ExoPSModuleManifest ;
                    RootModule  = $ExoPSModule.Name
                    Author      = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName = 'jb365' ;
                } ;
                if (Get-Content "$($env:userprofile)\Documents\WindowsPowerShell\Modules\exoMFAModule\Microsoft.Exchange.Management.ExoPowershellModule.manifest" | Select-String '<assemblyIdentity\sname="mscorlib"\spublicKeyToken="b77a5c561934e089"\sversion="(\d\.\d\.\d\.\d)"\s/>' | Where-Object { $_ -match '(\d\.\d\.\d\.\d)' }) {
                    $NewExoPSModuleManifestProps.add('ModuleVersion', $matches[0]) ;
                } ;
            } else {
                # roll an otf psd1+psm1 module
                $NewExoPSModuleManifestProps = @{
                    Path          = $ExoPSModuleManifest ;
                    RootModule    = $ExoPSModule.Name
                    ModuleVersion = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author        = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName   = 'jb365' ;
                } ;
            } ;
            if ($showDebug) { write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ;
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1', '.psd1' ;
            $CreateExoPSSessionPs1 = $CreateExoPSSessionPs1 |
            Get-Content | Where-Object { -not ($_ -like 'Write-Host*') } ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                Path          = $CreateExoPSSessionManifest ;
                RootModule    = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1', '.psm1') -Leaf ;
                ModuleVersion = '1.0' ;
                Author        = 'Todd Kadrie (https://github.com/tostka)' ;
                CompanyName   = 'toddomation.com' ;
            } ;
            if ($showDebug) { write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ;
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;

        try {
            # trying to refactor to get MFA coded in (untested, everything seems doc'd to use Connect-IPPSSession -UserPrincipalName)
            <#
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://outlook.office365.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            $global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            if ($showDebug) { write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ;
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if ($showDebug) { write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ;
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            #>
            Connect-IPPSSession -UserPrincipalName $Credential.UserName ;

            Add-PSTitleBar $sTitleBarTag -verbose:$($VerbosePreference -eq "Continue") ;
        } catch {
            Write-Warning -Message "Failed to connect to EXO via the imported EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;


    } else {

        # 9:17 AM 3/15/2017 Connect-CCMS: add quotes around all string/non-boolean/non-int values in the splat
        $CCMSsplat=@{
            ConfigurationName="Microsoft.Exchange" ;
            ConnectionUri="https://ps.compliance.protection.outlook.com/powershell-liveid/" ;
            Authentication="Basic" ;
            AllowRedirection=$true;
        } ;
        # just use the passed $Credential vari
        if ($Credential) {
            $CCMSsplat.Add("Credential",$Credential);
            write-verbose "(using cred:$($credential.username))" ; 
        } ;

        If ($ProxyEnabled) {
            $CCMSsplat.Add("sessionOption",$(New-PsSessionOption -ProxyAccessType IEConfig -ProxyAuthentication basic));
            Write-Host "Connecting to Security & Compliance via Proxy"  ;
        } Else {
            Write-Host "Connecting to Security & Compliance"  ;
        } ;

        Try {
            #$global:ExoPSSession = New-PSSession @EXOsplat ;
            $Global:CCMSSession = New-PSSession @CCMSsplat ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;

        $pltPSS=[ordered]@{
            Session                 =$Global:CCMSSession
            Prefix                  =$CommandPrefix ;
            DisableNameChecking     =$true  ;
            AllowClobber            =$true ;
            ErrorAction             = 'Stop' ;
        } ;
        if($showDebug){
            write-host -foregroundcolor green "`n$((get-date).ToString('HH:mm:ss')):Import-PSSession w`n$(($pltPSS|out-string).trim())" ;
        } ;

        Try {
            #$Global:CCMSModule = Import-Module (Import-PSSession $Global:CCMSSession -Prefix $CommandPrefix -DisableNameChecking -AllowClobber) -Global -Prefix $CommandPrefix -PassThru -DisableNameChecking   ;
            $Global:CCMSModule = Import-Module (Import-PSSession @pltPSS) -Global -Prefix $CommandPrefix -PassThru -DisableNameChecking -ErrorAction Stop  ;
            <# rem'd unimplemented
            if(($PSFgColor = (Get-Variable  -name "$($TenOrg)Meta").value.PSFgColor) -AND ($PSBgColor = (Get-Variable  -name "$($TenOrg)Meta").value.PSBgColor)){
                write-verbose "(setting console colors:$($TenOrg)Meta.PSFgColor:$($PSFgColor),PSBgColor:$($PSBgColor))" ; 
                $Host.UI.RawUI.BackgroundColor = $PSBgColor
                $Host.UI.RawUI.ForegroundColor = $PSFgColor ; 
            } ;
            #>
            Add-PSTitleBar 'cc' -verbose:$($VerbosePreference -eq "Continue");
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
    } ;
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;

}

#*------^ Connect-CCMS.ps1 ^------

#*------v Disconnect-CCMS.ps1 v------
Function Disconnect-CCMS {
    <#
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2020-
    FileName    : 
    License     : MIT License
    Copyright   : (c) 2020 Todd Kadrie
    Github      : https://github.com/tostka
    Tags        : Powershell
    AddedCredit : REFERENCE
    AddedWebsite:	URL
    AddedTwitter:	URL
    REVISIONS   :
    * 2:44 PM 3/2/2021 added console TenOrg color support
    # 12:19 PM 5/27/2020 updated cbh, moved alias:dccms win func
    # 1:18 PM 11/7/2018 added Disconnect-PssBroken
    # 12:42 PM 6/20/2018 ported over from disconnect-exo
    .DESCRIPTION
    I use this to smoothly cleanup connections.
    .INPUTS
    None. Does not accepted piped input.
    .OUTPUTS
    None. Returns no objects or output.
    .EXAMPLE
    Disconnect-CCMS;
    .LINK
    https://social.technet.microsoft.com/Forums/msonline/en-US/f3292898-9b8c-482a-86f0-3caccc0bd3e5/exchange-powershell-monitoring-remote-sessions?forum=onlineservicesexchange
    #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ;
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ;
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ;
    Disconnect-PssBroken ;
    Remove-PSTitlebar 'CCMS' -verbose:$($VerbosePreference -eq "Continue") ;
    [console]::ResetColor()  # reset console colorscheme
}

#*------^ Disconnect-CCMS.ps1 ^------

#*------v rccmsCMW.ps1 v------
function rccmsCMW {Reconnect-CCMS -cred $credO365CMWCSID}

#*------^ rccmsCMW.ps1 ^------

#*------v rccmsTOL.ps1 v------
function rccmsTOL {Reconnect-CCMS -cred $credO365TOLSID}

#*------^ rccmsTOL.ps1 ^------

#*------v rccmsTOR.ps1 v------
function rccmsTOL{reconnect-CCMS -cred $credO365TOLSID}

#*------^ rccmsTOR.ps1 ^------

#*------v rccmsVEN.ps1 v------
function rccmsVEN {Reconnect-CCMS -cred $credO365VENCSID}

#*------^ rccmsVEN.ps1 ^------

#*------v Reconnect-CCMS.ps1 v------
Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Version     : 1.0.0
Author      : Todd Kadrie
Website     :	http://www.toddomation.com
Twitter     :	@tostka / http://twitter.com/tostka
CreatedDate : 2020-
FileName    : 
License     : MIT License
Copyright   : (c) 2020 Todd Kadrie
Github      : https://github.com/tostka
Tags        : Powershell
AddedCredit : REFERENCE
AddedWebsite:	URL
AddedTwitter:	URL
    REVISIONS   :
    * 12:16 PM 5/27/2020 updated cbh, moved alias:rccms win func
    * 4:20 PM 5/14/2020 trimmed redundant func defs from bottom
    * 2:53 PM 5/14/2020 added test & local spec for $rgxCCMSPsHostName, wo it, it can't detect disconnects
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    .PARAMETER  Credential
    Credential to use for this connection [-credential 's-todd.kadrie@toro.com'] 
    .INPUTS
    None. Does not accepted piped input.
    .OUTPUTS
    None. Returns no objects or output.
    .EXAMPLE
    Reconnect-CCMS; 
    .LINK
    https://social.technet.microsoft.com/Forums/msonline/en-US/f3292898-9b8c-482a-86f0-3caccc0bd3e5/exchange-powershell-monitoring-remote-sessions?forum=onlineservicesexchange
    #>
    [CmdletBinding()]
    [Alias('rccms')]
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    if(!$rgxCCMSPsHostName){$rgxCCMSPsHostName="ps\.compliance\.protection\.outlook\.com" } ; # comes from infr file
    if( !(Get-PSSession|Where-Object{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}

#*------^ Reconnect-CCMS.ps1 ^------

#*======^ END FUNCTIONS ^======

Export-ModuleMember -Function cccmsCMW,cccmsTOL,cccmsTOR,cccmsVEN,Connect-CCMS,Disconnect-CCMS,rccmsCMW,rccmsTOL,rccmsTOL,rccmsVEN,Reconnect-CCMS -Alias *


# SIG # Begin signature block
# MIIELgYJKoZIhvcNAQcCoIIEHzCCBBsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIIDuiIToIiBg9aA//Q2BNEGB
# ycWgggI4MIICNDCCAaGgAwIBAgIQWsnStFUuSIVNR8uhNSlE6TAJBgUrDgMCHQUA
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
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQp8yNY
# 6zhERW1+h81P2/1U5VOx8TANBgkqhkiG9w0BAQEFAASBgCnxfKybvLjN1UwP3J1o
# D1YaTerfbya5cphwyc2GFcCwyO0hKhTKPOBVGarmRMJpMgbC9mEEWVgJB/2+RG6I
# 0HY45yjmr1cX1eN1lc3HigF0sg8VbIAFHOU2U0zhT6ltfjsbTE7j/BK9H8s03t28
# AOi0Z+8UDm80xvSa21chFrF9
# SIG # End signature block
