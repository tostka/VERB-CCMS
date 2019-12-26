#*------v Function Reconnect-CCMS v------
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
function rccmstor {Reconnect-CCMS -cred $credO365TORSID};
