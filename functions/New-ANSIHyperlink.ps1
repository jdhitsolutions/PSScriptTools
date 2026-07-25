Function New-ANSIHyperlink {
    [cmdletbinding()]
    [OutputType('string')]
    [alias('ahl')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "The text to display in the link"
        )]
        [ValidateNotNullOrEmpty()]
        [alias("Text","LinkText")]
        [string]$DisplayText,

        [Parameter(
            Position =1,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "The URL link. This should be an http: or file:// link"
        )]
        [ValidateNotNullOrEmpty()]
        [alias("Url","Uri")]
        [ValidatePattern("^(http(s)?)|(file):")]
        [string]$Link,

        [Parameter(HelpMessage = "Specify an optional ANSI style sequence. The command will automatically use a solid underline. You don't need to include the closing reset.")]
        [ValidateNotNullOrEmpty()]
        [string]$Style,

        [Parameter(HelpMessage = "Display the ANSI string as a plain text string.")]
        [switch]$AsString
        )

    Begin {
        #tags are used for categorizing the command
        #cmdTags = ansi,scripting
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        if ($Host.Name -eq 'Windows PowerShell ISE Host') {
            Write-Warning "This command is not supported in the PowerShell ISE"
            return
        }
        if ($Style) {
            If ($Style -match "^$([char]27).*m") {
                $styleString = $Style -Replace [char]27,"{esc}"
                $reset = "$([char]27)[0m"
                $DisplayText = "{0}$DisplayText{1}" -f $Style,$reset
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Formatting the text as $style$styleString$reset"
            }
            else {
                Write-Warning "$Style does not appear to be a valid ANSI escape sequence"
                Return
            }
        }

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating a hyperlink for '$DisplayText' pointing to $link."
        #Always use a solid underline
        $out = "{0}$link{1}{3}$DisplayText{2}{0}{1}{2}" -f "$([char]27)]8;;","$([char]27)\","$([char]27)[0m","$([char]27)[4m"
        if ($AsString) {
            if ($IsCoreClr) {
                $esc = "``e"
            }
            else {
                $esc = '$([char]27)'
            }
            $out -replace [char]27,$esc
        }
        else {
            $out
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close New-ANSIHyperlink
#EOF
