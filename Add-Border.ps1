#add a border around a string of text

# https://gist.github.com/jdhitsolutions/0bbd6b64c107d7da23e65359c4d0e25c

Function Add-Border {
    <#
.Synopsis
Create a text border around a string.

.Description
This command will create a character or text based border around a line of text. You might use this to create a formatted text report or to improve the display of information to the screen.

.Parameter Text
A single line of text that will be wrapped in a border.

.Parameter Textblock
A multiline block of text. You might want to trim blank lines from the beginning, end or both.

.Parameter Character
The character to use for the border. It must be a single character.

.Parameter InsertBlanks
Insert blank lines before and after the text. The default behavior is to create a border box close to the text. See examples.

.Parameter $Tab
Insert the specified number of tab characters before the result.

.Example
PS C:\> add-border "PowerShell Wins!"
********************
* PowerShell Wins! *
********************

.Example
PS C:\> add-border "PowerShell Wins!" -tab 1

     ********************
     * PowerShell Wins! *
     ********************

Note that this example may not format properly in the console.
.Example
PS C:\> add-border "PowerShell Wins!" -character "-" -insertBlanks
--------------------
-                  -
- PowerShell Wins! -
-                  -
--------------------

.Example
PS C:\> add-border -textblock (get-service win* | out-string).trim()
**********************************************************************
* Status   Name               DisplayName                            *
* ------   ----               -----------                            *
* Stopped  WinDefend          Windows Defender Antivirus Service     *
* Running  WinHttpAutoProx... WinHTTP Web Proxy Auto-Discovery Se... *
* Running  Winmgmt            Windows Management Instrumentation     *
* Stopped  WinRM              Windows Remote Management (WS-Manag... *
**********************************************************************

Create a border around the output of a Get-Service command.
#>
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
        [validateScript( {$_.length -eq 1})]
        [string]$Character = "*",

        # add blank lines before and after text
        [Switch]$InsertBlanks,

        # insert X number of tabs
        [int]$Tab = 0
    )

    Begin {
        Write-Detail "Starting $($myinvocation.mycommand)" -Prefix begin | Write-Verbose
        $tabs = "`t" * $tab
        Write-Detail "Using a tab of $tab" -Prefix BEGIN | Write-Verbose
    } #begin

    Process {

        if ($pscmdlet.ParameterSetName -eq 'single') {
            Write-Detail "Processing '$text'" -Prefix PROCESS | write-Verbose
            #get length of text
            $len = $text.Length
        }
        else {
            Write-Detail "Processing text block" -Prefix PROCESS| Write-Verbose
            $txtarray = $textblock.split("`n").Trim()
            $len = $txtarray | sort-object -property length -Descending | select-object -first 1 -expandProperty length
        }
    
        Write-Detail "Using a length of $len" | Write-Verbose
        #define a horizontal line
        $line = $Character * ($len + 4)

        if ($insertBlanks -and ($pscmdlet.ParameterSetName -eq 'single')) {
            Write-Detail "Inserting blank lines" -Prefix PROCESS | write-verbose
            $body = @"
$tabs$character $((" ")*$len) $character
$tabs$Character $text $Character
$tabs$character $((" ")*$len) $character
"@
        }
        elseif ($insertBlanks -and ($pscmdlet.ParameterSetName -eq 'block')) {
            Write-Deail "Inserting blank lines in the block" -prefix Process | write-Verbose
            $body = @"
$tabs$character $((" ")*$len) $character
"@

            foreach ($line in $txtarray) {
                $body += "$tabs$Character  $(($item).PadRight($len)) $Character"
            }

            $body += "$tabs$character $((" ")*$len) $character"

        }
        elseif ($pscmdlet.ParameterSetName -eq 'single') {
            $body = "$tabs$Character $text $Character"
        }
        else {
        
            [string[]]$body = ""
            foreach ($item in $txtarray) {
                $body += "$tabs$Character $(($item).PadRight($len)) $Character`r"
            }
        }

        [string[]]$out = "`n$tabs$line"
        foreach ($b in $body.split("`n")) {
            $out += $b
        }
        $out += "$tabs$line"
        #write the result to the pipeline
        $out
    } #process

    End {
        Write-Detail "Ending $($myinvocation.mycommand)" -prefix END | Write-Verbose
    } #end

} #close function