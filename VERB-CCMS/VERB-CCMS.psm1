# VERB-CCMS.psm1
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
# VERB-CCMS.psm1
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
# VERB-CCMS.psm1
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
# VERB-CCMS.psm1
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
# VERB-CCMS.psm1
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
# VERB-CCMS.psm1
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
# VERB-CCMS.psm1
# SIG # End signature block
# To6eGA3l4o9qHEfQqx7n1gS/
# VERB-CCMS.psm1


  <#
  .SYNOPSIS
  VERB-CCMS - o365 Security & Compliance PS Module-related generic functions
  .NOTES
  Version     : 1.0.0.0
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









Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}

Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }

if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}







Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}

# SIG # Begin signature block
# MIIELgYJKoZIhvcNAQcCoIIEHzCCBBsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUO3Gmd1A0kC+Kr43VX6k9kAmO
# 8eigggI4MIICNDCCAaGgAwIBAgIQWsnStFUuSIVNR8uhNSlE6TAJBgUrDgMCHQUA
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
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSROG78
# 6tulZXEaE1zA2mcrAMePWDANBgkqhkiG9w0BAQEFAASBgHrfE955DIHHrOyaFh8G
# Q947YMhkVUdxpBzzwmJot6QTNsmKNy0XAFUlRh5G0NVQWF67MipWGLVVdgJNwg2x
# 2Ycrhigkkb7A47irLgYxuJYvdsHGAVIyJMXRjRhVjT74vW9vUfDPwBfpXiR8nd/z
# To6eGA3l4o9qHEfQqx7n1gS/
# SIG # End signature block

Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}

Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }

if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}

Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}

Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}

Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }

if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}

Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}
Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }
if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}
Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}
Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }
if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}
Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}
Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }
if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}
Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}
Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }
if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}
Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}
Function Connect-CCMS {
    <# 
    .SYNOPSIS
    Connect-CCMS - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: : Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    * 10:55 AM 12/6/2019 Connect-CCMS: added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to CCMS: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION
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
    Connect-CCMS -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ; 
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
#>

   Param(
        [Parameter(HelpMessage="Use Proxy-Aware SessionOption settings [-ProxyEnabled]")][boolean]$ProxyEnabled = $False,  
        [Parameter(HelpMessage="[noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab]")][string]$CommandPrefix = 'exo',
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ; 
    
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ 
      $CommandPrefix='cc' ; 
      write-verbose -verbose:$true  "(asserting Prefix:$($CommandPrefix)" ;
    } ; 

    $sTitleBarTag="SOL" ; 
    if($Credential){
        switch -regex ($Credential.username.split('@')[1]){
            "toro\.com" {
                # leave untagged
             } 
             "torolab\.com" {
                $sTitleBarTag = $sTitleBarTag + "tlab"
            } 
            "(charlesmachineworks\.onmicrosoft\.com|charlesmachine\.works)" {
                $sTitleBarTag = $sTitleBarTag + "cmw"
            } 
        } ; 
    } ; 
    
    $ImportPSSessionProps = @{
        AllowClobber        = $true ;
        DisableNameChecking = $true ;
        Prefix              = $CommandPrefix ; 
        ErrorAction         = 'Stop' ;
    } ;
    
    if($MFA){
        #$CreateEXOPSSession = (Get-ChildItem -Path $Env:LOCALAPPDATA\Apps\2.0* -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName ; 
        <# 2:37 PM 11/12/2019 LYN-8DCZ1G2 $CreateEXOPSSession returns:
        C:\Users\kadritss\AppData\Local\Apps\2.0\D8EN8V94.BC1\KNNJHR2J.BBV\micr..tion_5329ec537c0b4b5c_0010.0000_9fc624cd0073956e
        #>
        
        try {
            $ExoPSModuleSearchProperties = @{
                Path        = "$($env:LOCALAPPDATA)\Apps\2.0\" ;
                Filter     = 'Microsoft.Exchange.Management.ExoPowerShellModule.dll' ;
                Recurse     = $true ;
                ErrorAction = 'Stop' ;
            } ;
            
            if($showDebug){write-host -foregroundcolor green "Get-ChildItem w`n$(($ExoPSModuleSearchProperties|out-string).trim())" } ; 
            $ExoPSModule =  Get-ChildItem @ExoPSModuleSearchProperties |
                            Where-Object {$_.FullName -notmatch '_none_'} |
                            Sort-Object LastWriteTime |
                            Select-Object -Last 1 ;
            Import-Module $ExoPSModule.FullName -ErrorAction:Stop ;
            $ExoPSModuleManifest = $ExoPSModule.FullName -replace '\.dll','.psd1' ;
            $NewExoPSModuleManifestProps = @{
                    Path            = $ExoPSModuleManifest ;
                    RootModule      = $ExoPSModule.Name
                    ModuleVersion   = "$((Get-Module $ExoPSModule.FullName -ListAvailable).Version.ToString())" ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewExoPSModuleManifestProps|out-string).trim())" } ; 
            New-ModuleManifest @NewExoPSModuleManifestProps ;
            Import-Module $ExoPSModule.FullName -Global -ErrorAction:Stop ;
            $CreateExoPSSessionPs1 = Get-ChildItem -Path $ExoPSModule.PSParentPath -Filter 'CreateExoPSSession.ps1' ;
            $CreateExoPSSessionManifest = $CreateExoPSSessionPs1.FullName -replace '\.ps1','.psd1' ;
            $CreateExoPSSessionPs1 =    $CreateExoPSSessionPs1 |
                                        Get-Content |
                                        Where-Object {-not ($_ -like 'Write-Host*')} ;
            $CreateExoPSSessionPs1 -join "`n" |
            Set-Content -Path "$($CreateExoPSSessionManifest -replace '\.psd1','.psm1')" ;
            $NewCreateExoPSSessionManifest = @{
                    Path            = $CreateExoPSSessionManifest ;
                    RootModule      = Split-Path -Path ($CreateExoPSSessionManifest -replace '\.psd1','.psm1') -Leaf ;
                    ModuleVersion   = '1.0' ;
                    Author          = 'Jeremy Bradshaw (https://github.com/JeremyTBradshaw)' ;
                    CompanyName     = 'jb365' ;
            } ;
            if($showDebug){write-host -foregroundcolor green "New-ModuleManifest w`n$(($NewCreateExoPSSessionManifest|out-string).trim())" } ; 
            New-ModuleManifest @NewCreateExoPSSessionManifest ;
            Import-Module "$($ExoPSModule.PSParentPath)\CreateExoPSSession.psm1" -Global -ErrorAction:Stop ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ;
        
        try {
            $global:UserPrincipalName = $Credential.Username ;
            $global:ConnectionUri = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId' ;
            $global:AzureADAuthorizationEndpointUri = 'https://login.windows.net/common' ;
            $global:PSSessionOption = New-PSSessionOption -CancelTimeout 5000 -IdleTimeout 43200000 ;
            #$global:BypassMailboxAnchoring = $false ;
            $ExoPSSession = @{
                UserPrincipalName               = $global:UserPrincipalName ;
                ConnectionUri                   = $global:ConnectionUri ;
                AzureADAuthorizationEndpointUri = $global:AzureADAuthorizationEndpointUri ;
                PSSessionOption                 = $global:PSSessionOption ;
                BypassMailboxAnchoring          = $global:BypassMailboxAnchoring ;
            } ;
            #if ($PSBoundParameters.Credential) {$ExoPSSession['Credential'] = $Credential}
            if($showDebug){write-host -foregroundcolor green "New-ExoPSSession w`n$(($ExoPSSession|out-string).trim())" } ; 
            $ExoPSSession = New-ExoPSSession @ExoPSSession -ErrorAction:Stop ;
            if($showDebug){write-host -foregroundcolor green "Import-PSSession w`n$(($ImportPSSessionProps|out-string).trim())" } ; 
            #Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Global -DisableNameChecking -ErrorAction:Stop ;
            # 11:51 AM 11/20/2019 add prefx 
            Import-Module (Import-PSSession $ExoPSSession @ImportPSSessionProps) -Prefix $CommandPrefix -Global -DisableNameChecking -ErrorAction:Stop ;
            UpdateImplicitRemotingHandler ;
            
             # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag ;
        
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
        $EXOsplat.Add("Credential",$Credential);
            
       
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
            Add-PSTitleBar 'EXO' ;
        } catch {
            Write-Warning -Message "Tried but failed to import the EXO PS module.`n`nError message:" ;
            throw $_ ;
        } ; 
    } ;  
    if($CommandPrefix){ "(Connected to CCMS: Cmds prefixed [verb]-$($CommandPrefix)[Noun])" ; } ;
    
} ; #*------^ END Function Connect-CCMS ^------
if(!(get-alias | ?{$_.name -like "cccms"})) {Set-Alias 'cccms' -Value 'Connect-CCMS' ; } ;
function cccmstol {Connect-CCMS -cred $credO365TOLSID};
function cccmscmw {Connect-CCMS -cred $credO365CMWCSID};
function cccmstor {Connect-CCMS -cred $credO365TORSID}
Function Disconnect-CCMS {
    <# 
    .SYNOPSIS
    Disconnect-CCMS - Disconnects any PSS to https://ps.outlook.com/powershell/ (cleans up session after a batch or other temp work is done)
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
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
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    if($Global:CCMSModule){$Global:CCMSModule | Remove-Module -Force ; } ; 
    if($Global:CCMSSession){$Global:CCMSSession | Remove-PSSession ; } ; 
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ; 
    Disconnect-PssBroken ; 
    Remove-PSTitlebar 'CCMS' ; 
} ; #*------^ END Function Disconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; }
if(!(test-path function:\Disconnect-PssBroken)) { 
    #*------v Function Disconnect-PssBroken v------
    Function Disconnect-PssBroken {
        <# 
        .SYNOPSIS
        Disconnect-PssBroken - Remove all local broken PSSessions
        .NOTES
        Author: Todd Kadrie
        Website:	http://tinstoys.blogspot.com
        Twitter:	http://twitter.com/tostka
        REVISIONS   :
        * 12:56 PM 11/7/2f018 fix typo $s.state.value, switched tests to the strings, over values (not sure worked at all)
        * 1:50 PM 12/8/2016 initial version
        .DESCRIPTION
        Disconnect-PssBroken - Remove all local broken PSSessions
        .INPUTS
        None. Does not accepted piped input.
        .OUTPUTS
        None. Returns no objects or output.
        .EXAMPLE
        Disconnect-PssBroken ; 
        .LINK
        #>
        Get-PsSession |?{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------
}
Function Reconnect-CCMS {
    <# 
    .SYNOPSIS
    Reconnect-CCMS - Test and reestablish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 2:42 PM 11/19/2019 started roughing in mfa support
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 CCMS variant, works
    .DESCRIPTION
    I use this for routine test/reconnect of CCMS.
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
    
    Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,  
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ; 
    
    # appears MFA may not properly support passing back a session vari, so go right to strict hostname matches
    #if ($CCMSSession.state -eq 'Broken' -or !$CCMSSession) {Disconnect-CCMS; Start-Sleep -Seconds 3; Connect-CCMS} ;     
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($CCMSSession.state -ne 'Opened' -AND $CCMSSession.Availability -ne 'Available') -or !$CCMSSession) {
    if( !(Get-PSSession|?{($_.ComputerName -match $rgxCCMSPsHostName) -AND ($_.State -eq 'Opened') -AND ($_.Availability -eq 'Available')}) ){
      if($showdebug){ write-host -foregroundcolor yellow "$((get-date).ToString('HH:mm:ss')):Reconnecting:No existing PSSESSION matching $($rgxCCMSPsHostName) with valid Open/Availability:$((Get-PSSession|?{$_.ComputerName -match $rgxCCMSPsHostName}| ft -a State,Availability |out-string).trim())" } ; 
      Disconnect-CCMS; Disconnect-PssBroken ;Start-Sleep -Seconds 3; 
      if(!$Credential){
          Connect-CCMS ; 
      } else { 
          Connect-CCMS -Credential:$($Credential) ; 
      } ; 
      
  } ;     
}#*------^ END Function Reconnect-CCMS ^------
if(!(get-alias | ?{$_.name -like "rccms"})) {Set-Alias 'rccms' -Value 'Reconnect-CCMS' ; } ;
function rccmstol {Reconnect-CCMS -cred $credO365TOLSID};
function rccmscmw {Reconnect-CCMS -cred $credO365CMWCSID};
function rccmstor {Reconnect-CCMS -cred $credO365TORSID}