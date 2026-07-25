Function Format-BorderBox {
    [CmdletBinding()]
    [Alias('fbx')]
    [OutputType("String")]
    Param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'Enter the text to be displayed in the box. You can enter an array of strings including blank lines.'
        )]
        #blank lines should be allowed
        [string[]]$Text,

        [Parameter(HelpMessage = 'Enter an optional title.')]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(HelpMessage = 'Specify an ANSI or PSStyle sequence for the border color. The default is bright green.')]
        [ValidateNotNullOrEmpty()]
        [alias("bc")]
        [string]$BorderColor = "$([char]27)[92m"
    )

    Begin {
        #tags are used for categorizing the command
        #cmdTags = console,graphical
        $e = [char]27
        $reset = "$e[0m"
        #define the box line elements
        [string]$topLeft = [char]0x256d
        [string]$bottomRight = [char]0x256f
        [string]$topRight = [char]0x256e
        [string]$bottomLeft = [char]0x2570
        [string]$horizontal = [char]0x2500
        [string]$vertical = [char]0x2502

        #define a list to hold the strings
        $list = [System.Collections.Generic.List[string]]::new()
    } #begin
    Process {
        if ($Host.Name -eq 'Windows PowerShell ISE Host') {
            Write-Warning "This command is not supported in the PowerShell ISE"
            return
        }
        foreach ($line in $Text) {
            $list.Add($line)
        }
    } #process
    End {
        #process the list of strings stripping off any ANSI codes
        $longestLine = ($list | ForEach-Object { $_ -replace '\x1b\[[0-9;]*m', '' } | Sort-Object -Property Length | Select-Object length -Last 1).length
        $width = $longestLine + 2
        $box = @'

{0}{1}{2}{3}{4}{5}{6}

'@ -f $borderColor, $TopLeft, ($horizontal * 2), $Title, ($horizontal * ($width - $Title.Length - 2)), $TopRight, $reset

        #Add each line to the head
        foreach ($line in $list) {
            #get the length of the line without any ANSI codes
            $rawLine = $line -replace '\x1b\[[0-9;]*m', ''
            $box += "$borderColor{0}$reset {1} {2}$borderColor{0}$reset`n" -f $vertical, $line, (' ' * ($width - $rawLine.length - 2))
        }

        $box += '{0}{1}{2}{3}{4}' -f $borderColor, $bottomLeft, ($horizontal * $width), $bottomRight, $reset
        #display the boxed text
        $box
    } #end
}
#EOF
