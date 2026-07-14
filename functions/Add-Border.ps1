#add a border around a string of text

<#
originally published at
 https://gist.github.com/jdhitsolutions/0bbd6b64c107d7da23e65359c4d0e25c

 #>
Function Add-Border {
    [CmdletBinding(DefaultParameterSetName = "single")]
    [alias('ab')]
    [OutputType([System.String])]

    Param(
        # The string of text to process
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = 'single'
            )]
        [ValidateNotNullOrEmpty()]
        [string]$Text,

        [Parameter(
            Position = 0,
            Mandatory,
            ParameterSetName = 'block'
            )]
        [ValidateNotNullOrEmpty()]
        [Alias("tb")]
        [string[]]$textBlock,

        # The character to use for the border. It must be a single character.
        [ValidateNotNullOrEmpty()]
        [alias("border")]
        [string]$Character = "*",

        # add blank lines before and after text
        [Switch]$InsertBlanks,

        # insert X number of tabs
        [int]$Tab = 0,

        [Parameter(HelpMessage = "Enter an ANSI escape sequence to color the border characters." )]
        [string]$ANSIBorder,

        [Parameter(HelpMessage = "Enter an ANSI escape sequence to color the text." )]
        [string]$ANSIText
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"
        $tabs = "`t" * $tab
        Write-Verbose "Using a tab of $tab"

        Write-Verbose "Using border character $Character"
        $ansiClear = "$([char]0x1b)[0m"
        if ($PSBoundParameters.ContainsKey("ANSIBorder")) {
            Write-Verbose "Using an ANSI border Color"
            $Character = "{0}{1}{2}" -f $PSBoundParameters.ANSIBorder, $Character, $ansiClear
        }

        #define regex expressions to detect ANSI escapes. Need to subtract their
        #length from the string if used. Issue #79
        [regex]$ansiOpen = "$([char]0x1b)\[\d+[\d;]+m"
        [regex]$ansiEnd = "$([char]0x1b)\[0m"

    } #begin

    Process {

        if ($PSCmdlet.ParameterSetName -eq 'single') {
            Write-Verbose "Processing '$text'"
            #get length of text
            $adjust = 0
            if ($ansiOpen.IsMatch($text)) {
                $adjust += ($ansiOpen.matches($text) | Measure-Object length -sum).sum
                $adjust += ($ansiEnd.matches($text) | Measure-Object length -sum).sum
                Write-Verbose "Adjusting text length by $adjust."
            }

            $len = $text.Length - $adjust
            if ($PSBoundParameters.ContainsKey("ANSIText")) {
                Write-Verbose "Using an ANSIText color"
                $text = "{0}{1}{2}" -f $PSBoundParameters.ANSIText, $text, $AnsiClear
            }
        }
        else {
            Write-Verbose "Processing text block"
            #test if text block is already using ANSI
            if ($ansiOpen.IsMatch($textBlock)) {
                Write-Verbose "Text block contains ANSI sequences"
                $txtArray | ForEach-Object -begin {$tempLen = @()} -process {
                    $adjust = 0
                    $adjust += ($ansiOpen.matches($_) | Measure-Object length -sum).sum
                    $adjust += ($ansiEnd.matches($_) | Measure-Object length -sum).sum
                    Write-Verbose "Length detected as $($_.length)"
                    Write-Verbose "Adding adjustment $adjust"
                    $tempLen += $_.length - $adjust
                }
                $len = $tempLen | Sort-Object -Descending | Select-Object -first 1

            }
            elseif ($PSBoundParameters.ContainsKey("ANSIText")) {
                Write-Verbose "Using ANSIText for the block"
                $txtArray = $textBlock.split("`n").Trim() | ForEach-Object {"{0}{1}{2}" -f $PSBoundParameters.ANSIText, $_, $AnsiClear}
                $len = ($txtArray | Sort-Object -property length -Descending | Select-Object -first 1 -expandProperty length) - ($PSBoundParameters.ANSIText.length + 4)
            }
            else {
                Write-Verbose "Processing simple text block"
                $txtArray = $textBlock.split("`n").Trim()
                $len = $txtArray | Sort-Object -property length -Descending | Select-Object -first 1 -expandProperty length
            }
            Write-Verbose "Added $($txtArray.count) text block elements"
        }

        Write-Verbose "Using a length of $len"
        #define a horizontal line
        $hzLine = $Character * ($len + 4)

        if ($PSCmdlet.ParameterSetName -eq 'single') {
            Write-Verbose "Defining Single body"
            $body = "$tabs$Character $text $Character"
        }
        else {
            Write-Verbose "Defining textBlock body"
            [string[]]$body = $null
            foreach ($item in $txtArray) {
                if ($item) {
                    Write-Verbose "$item [$($item.length)]"
                }
                else {
                    Write-Verbose "detected blank line"
                }
                if ($ansiOpen.IsMatch($item)) {
                    $adjust = $len
                    $adjust += ($ansiOpen.matches($item) | Measure-Object length -sum).sum
                    $adjust += ($ansiEnd.matches($item) | Measure-Object length -sum).sum
                    Write-Verbose "Adjusting length to $adjust"
                    $body += "$tabs$Character $(($item).PadRight($adjust)) $Character`r"

                }
                elseif ($PSBoundParameters.ContainsKey("ANSIText")) {
                    #adjust the padding length to take the ANSI value into account
                    $adjust = $len + ($PSBoundParameters.ANSIText.length + 4)
                    Write-Verbose "Adjusting length to $adjust"

                    $body += "$tabs$Character $(($item).PadRight($adjust)) $Character`r"
                }
                else {
                    $body += "$tabs$Character $(($item).PadRight($len)) $Character`r"
                }
            } #foreach item in txtArray
        }
        Write-Verbose "Defining top border"
        [string[]]$out = "`n$tabs$hzLine"
        $lines = $body.split("`n")
        Write-Verbose "Adding $($lines.count) lines" | Write-Verbose
        if ($InsertBlanks) {
            Write-Verbose "Prepending blank line"
            $out += "$tabs$character $((" ")*$len) $character"
        }
        foreach ($item in $lines ) {
            $out += $item
        }
        if ($InsertBlanks) {
            Write-Verbose "Appending blank line"
            $out += "$tabs$character $((" ")*$len) $character"
        }
        Write-Verbose "Defining bottom border"
        $out += "$tabs$hzLine"
        #write the result to the pipeline
        $out
    } #process

    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end

} #close function
