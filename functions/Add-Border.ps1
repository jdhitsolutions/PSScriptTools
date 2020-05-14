#add a border around a string of text

<#
originally published at
 https://gist.github.com/jdhitsolutions/0bbd6b64c107d7da23e65359c4d0e25c

 #>
Function Add-Border {
    [CmdletBinding(DefaultParameterSetName = "single")]

    Param(
        # The string of text to process
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = 'single')]
        [ValidateNotNullOrEmpty()]
        [string]$Text,

        [Parameter(Position = 0, Mandatory, ParameterSetName = 'block')]
        [ValidateNotNullOrEmpty()]
        [string[]]$TextBlock,

        # The character to use for the border. It must be a single character.
        [ValidateNotNullOrEmpty()]
        [string]$Character = "*",

        # add blank lines before and after text
        [Switch]$InsertBlanks,

        # insert X number of tabs
        [int]$Tab = 0,

        [Parameter(HelpMessage ="Enter an ANSI escape sequence to color the border characters." )]
        [string]$ANSIBorder,

        [Parameter(HelpMessage ="Enter an ANSI escape sequence to color the text." )]
        [string]$ANSIText
    )

    Begin {
        Write-Detail "Starting $($myinvocation.mycommand)" -Prefix begin | Write-Verbose
        $tabs = "`t" * $tab
        Write-Detail "Using a tab of $tab" -Prefix BEGIN | Write-Verbose

        Write-Detail "Using border character $Character" -Prefix begin | Write-Verbose

        if ($PSEdition -eq 'Desktop') {
            $ansiClear = "$([char]0x1b)[0m"
        }
        else {
            $ansiClear = "`e[0m"
        }
        if ($PSBoundParameters.ContainsKey("ANSIBorder")) {
            Write-Detail "Using an ANSI border Color" -Prefix Begin | Write-Verbose
            $Character = "{0}{1}{2}" -f $PSBoundParameters.ANSIBorder,$Character,$ansiClear
        }

     } #begin

    Process {

        if ($pscmdlet.ParameterSetName -eq 'single') {
            Write-Detail "Processing '$text'" -Prefix PROCESS | Write-Verbose
            #get length of text
            $len = $text.Length
            if ($PSBoundParameters.ContainsKey("ANSIText")) {
                Write-Detail "Using an ANSIText color" -Prefix PROCESS | Write-Verbose
                $text = "{0}{1}{2}" -f $PSBoundParameters.ANSIText,$text,$AnsiClear
            }
        }
        else {
            Write-Detail "Processing text block" -Prefix PROCESS | Write-Verbose
            if ($PSBoundparameters.ContainsKey("ANSIText")) {
                    Write-Detail "Using ANSIText for the block" -prefix PROCESS | Write-Verbose
                $txtarray = $textblock.split("`n").Trim() | foreach-object {"{0}{1}{2}" -f $PSBoundParameters.ANSIText,$_,$AnsiClear}

                $len = ($txtarray | Sort-Object -property length -Descending | Select-Object -first 1 -expandProperty length) - ($psboundparameters.ANSIText.length+4)
            }
            else {
                 $txtarray = $textblock.split("`n").Trim()
                 $len = $txtarray | Sort-Object -property length -Descending | Select-Object -first 1 -expandProperty length
            }
            Write-Detail "Added $($txtarray.count) text block elements" -Prefix PROCESS | Write-Verbose
          }

        Write-Detail "Using a length of $len" | Write-Verbose
        #define a horizontal line
        $hzline = $Character * ($len + 4)

        if ($pscmdlet.ParameterSetName -eq 'single') {
            Write-Detail "Defining Single body" -prefix PROCESS | Write-Verbose
            $body = "$tabs$Character $text $Character"
        }
        else {
            Write-Detail "Defining Textblock body" -prefix PROCESS | Write-Verbose
            [string[]]$body = $null
            foreach ($item in $txtarray) {
                    Write-Detail $item -Prefix PROCESS | write-Verbose
                 if ($PSBoundparameters.ContainsKey("ANSIText")) {
                    #adjust the padding length to take the ANSI value into account
                    $adjust = $len+($psboundparameters.ANSIText.length+4)
                    Write-Detail "Adjusting length to $adjust" -prefix PROCESS | Write-Verbose
                    $body += "$tabs$Character $(($item).PadRight($adjust)) $Character`r"
                }
                else {

                    $body += "$tabs$Character $(($item).PadRight($len)) $Character`r"
                }
            } #foreach item in txtarray
        }
        Write-Detail "Defining top border" -Prefix PROCESS | Write-Verbose
        [string[]]$out = "`n$tabs$hzline"
        $lines = $body.split("`n")
        Write-Detail "Adding $($lines.count) lines" | Write-Verbose
        if ($InsertBlanks) {
            Write-Detail "Prepending blank line" -Prefix PROCESS | Write-Verbose
            $out += "$tabs$character $((" ")*$len) $character"
        }
        foreach ($item in $lines ) {
            $out += $item
        }
        if ($InsertBlanks) {
            Write-Detail "Appending blank line" -Prefix PROCESS | Write-Verbose
            $out += "$tabs$character $((" ")*$len) $character"
        }
        Write-Detail "Defining bottom border" -Prefix PROCESS | Write-Verbose
        $out += "$tabs$hzline"
        #write the result to the pipeline
        $out
    } #process

    End {
        Write-Detail "Ending $($myinvocation.mycommand)" -prefix END | Write-Verbose
    } #end

} #close function
