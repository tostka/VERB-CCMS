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