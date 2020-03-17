#rebuild-module.ps1

<#
.SYNOPSIS
rebuild-module.ps1 - Rebuild verb-CCMS & publish to localrepo
.NOTES
Version     : 1.0.0
Author      : Todd Kadrie
Website     : http://www.toddomation.com
Twitter     : @tostka / http://twitter.com/tostka
CreatedDate : 2020-03-17
FileName    : rebuild-module.ps1
License     : MIT License
Copyright   : (c) 2020 Todd Kadrie
Github      : https://github.com/tostka
Tags        : Powershell
REVISIONS
* 8:49 AM 3/17/2020 init
.DESCRIPTION
rebuild-module.ps1 - Rebuild verb-CCMS & publish to localrepo
.PARAMETER Whatif
Parameter to run a Test no-change pass [-Whatif switch]
.INPUTS
None. Does not accepted piped input.
.OUTPUTS
None. Returns no objects or output
.EXAMPLE
.\rebuild-module.ps1 -whatif ; 
Rebuild pass with -whatif
.EXAMPLE
.\rebuild-module.ps1
Non-whatif rebuild
.LINK
https://github.com/tostka
#>
[CmdletBinding()]
PARAM(
    [Parameter(HelpMessage="Whatif Flag  [-whatIf]")]
    [switch] $whatIf
) ;
    $Verbose = ($VerbosePreference -eq 'Continue') ; 
    write-verbose -verbose:$verbose "`$PSBoundParameters:`n$(($PSBoundParameters|out-string).trim())" ; 

.\process-NewModule.ps1 -ModuleName "verb-CCMS" -ModDirPath "C:\sc\verb-CCMS" -Repository "`$localPSRepo" -Merge -showdebug -whatif:$($whatif) ;