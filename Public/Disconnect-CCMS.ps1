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
if(!(get-alias | Where-Object{$_.name -like "dccms"})) {Set-Alias 'dccms' -Value 'Disconnect-CCMS' ; } ;