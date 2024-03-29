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
    AddedTwitter:	URL    
    REVISIONS   :
    * 8:50 AM 3/1/2024 WIP, half way through editing in EOM340 support, NOT DONE
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

    revised 2/27/24: [Connect to Security & Compliance PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/exchange/connect-to-scc-powershell?view=exchange-ps)

    - USES eom: 
    Import-Module ExchangeOnlineManagement ;
    Connect-IPPSSession -UserPrincipalName <UPN> [-ConnectionUri <URL>] [-AzureADAuthorizationEndpointUri <URL>] [-DelegatedOrganization <String>] [-PSSessionOption $ProxyOptions]
    ## PARAMS: 
        ENVIRO: Microsoft 365 or Microsoft 365 GCC:
            -ConnectionUri: None. 
                The required value https://ps.compliance.protection.outlook.com/powershell-liveid/ is also the default value, so you don't need to use the ConnectionUri parameter in Microsoft 365 or Microsoft 365 GCC environments.
            -AzureADAuthorizationEndpointUri: None. 
                The required value https://login.microsoftonline.com/common is also the default value, so you don't need to use the AzureADAuthorizationEndpointUri parameter in Microsoft 365 or Microsoft 365 GCC environments.




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
