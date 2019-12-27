#*------v Function Connect-CCMS v------
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
function cccmstor {Connect-CCMS -cred $credO365TORSID};