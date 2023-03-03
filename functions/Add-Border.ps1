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
        Write-Detail "Starting $($MyInvocation.MyCommand)" -Prefix begin | Write-Verbose
        $tabs = "`t" * $tab
        Write-Detail "Using a tab of $tab" -Prefix BEGIN | Write-Verbose

        Write-Detail "Using border character $Character" -Prefix begin | Write-Verbose
        $ansiClear = "$([char]0x1b)[0m"
        if ($PSBoundParameters.ContainsKey("ANSIBorder")) {
            Write-Detail "Using an ANSI border Color" -Prefix Begin | Write-Verbose
            $Character = "{0}{1}{2}" -f $PSBoundParameters.ANSIBorder, $Character, $ansiClear
        }

        #define regex expressions to detect ANSI escapes. Need to subtract their
        #length from the string if used. Issue #79
        [regex]$ansiOpen = "$([char]0x1b)\[\d+[\d;]+m"
        [regex]$ansiEnd = "$([char]0x1b)\[0m"

    } #begin

    Process {

        if ($PSCmdlet.ParameterSetName -eq 'single') {
            Write-Detail "Processing '$text'" -Prefix PROCESS | Write-Verbose
            #get length of text
            $adjust = 0
            if ($ansiOpen.IsMatch($text)) {
                $adjust += ($ansiOpen.matches($text) | Measure-Object length -sum).sum
                $adjust += ($ansiEnd.matches($text) | Measure-Object length -sum).sum
                Write-Detail "Adjusting text length by $adjust." -Prefix PROCESS | Write-Verbose
            }

            $len = $text.Length - $adjust
            if ($PSBoundParameters.ContainsKey("ANSIText")) {
                Write-Detail "Using an ANSIText color" -Prefix PROCESS | Write-Verbose
                $text = "{0}{1}{2}" -f $PSBoundParameters.ANSIText, $text, $AnsiClear
            }
        }
        else {
            Write-Detail "Processing text block" -Prefix PROCESS | Write-Verbose
            #test if text block is already using ANSI
            if ($ansiOpen.IsMatch($textBlock)) {
                Write-Detail "Text block contains ANSI sequences" -Prefix PROCESS | Write-Verbose
                $txtArray | ForEach-Object -begin {$tempLen = @()} -process {
                    $adjust = 0
                    $adjust += ($ansiOpen.matches($_) | Measure-Object length -sum).sum
                    $adjust += ($ansiEnd.matches($_) | Measure-Object length -sum).sum
                    Write-Detail "Length detected as $($_.length)" -Prefix PROCESS | Write-Verbose
                    Write-Detail "Adding adjustment $adjust" -Prefix PROCESS | Write-Verbose
                    $tempLen += $_.length - $adjust
                }
                $len = $tempLen | Sort-Object -Descending | Select-Object -first 1

            }
            elseif ($PSBoundParameters.ContainsKey("ANSIText")) {
                Write-Detail "Using ANSIText for the block" -prefix PROCESS | Write-Verbose
                $txtArray = $textBlock.split("`n").Trim() | ForEach-Object {"{0}{1}{2}" -f $PSBoundParameters.ANSIText, $_, $AnsiClear}
                $len = ($txtArray | Sort-Object -property length -Descending | Select-Object -first 1 -expandProperty length) - ($PSBoundParameters.ANSIText.length + 4)
            }
            else {
                Write-Detail "Processing simple text block" -prefix PROCESS | Write-Verbose
                $txtArray = $textBlock.split("`n").Trim()
                $len = $txtArray | Sort-Object -property length -Descending | Select-Object -first 1 -expandProperty length
            }
            Write-Detail "Added $($txtArray.count) text block elements" -Prefix PROCESS | Write-Verbose
        }

        Write-Detail "Using a length of $len" -Prefix PROCESS | Write-Verbose
        #define a horizontal line
        $hzline = $Character * ($len + 4)

        if ($PSCmdlet.ParameterSetName -eq 'single') {
            Write-Detail "Defining Single body" -prefix PROCESS | Write-Verbose
            $body = "$tabs$Character $text $Character"
        }
        else {
            Write-Detail "Defining textBlock body" -prefix PROCESS | Write-Verbose
            [string[]]$body = $null
            foreach ($item in $txtArray) {
                if ($item) {
                    Write-Detail "$item [$($item.length)]" -Prefix PROCESS | Write-Verbose
                }
                else {
                    Write-Detail "detected blank line" -Prefix PROCESS | Write-Verbose
                }
                if ($ansiOpen.IsMatch($item)) {
                    $adjust = $len
                    $adjust += ($ansiOpen.matches($item) | Measure-Object length -sum).sum
                    $adjust += ($ansiEnd.matches($item) | Measure-Object length -sum).sum
                    Write-Detail "Adjusting length to $adjust" -prefix PROCESS | Write-Verbose
                    $body += "$tabs$Character $(($item).PadRight($adjust)) $Character`r"

                }
                elseif ($PSBoundParameters.ContainsKey("ANSIText")) {
                    #adjust the padding length to take the ANSI value into account
                    $adjust = $len + ($PSBoundParameters.ANSIText.length + 4)
                    Write-Detail "Adjusting length to $adjust" -prefix PROCESS | Write-Verbose

                    $body += "$tabs$Character $(($item).PadRight($adjust)) $Character`r"
                }
                else {
                    $body += "$tabs$Character $(($item).PadRight($len)) $Character`r"
                }
            } #foreach item in txtArray
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
        Write-Detail "Ending $($MyInvocation.MyCommand)" -prefix END | Write-Verbose
    } #end

} #close function
