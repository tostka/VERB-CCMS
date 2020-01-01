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
        Get-PsSession |Where-Object{$_.State -ne 'Opened' -or $_.Availability -ne 'Available'} | Remove-PSSession -Verbose ;
    } ; #*------^ END Function Disconnect-PssBroken ^------