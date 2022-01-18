
Function Out-Copy {
    [cmdletbinding()]
    [alias("oc")]
    Param(
        [Parameter(
            Position=0,
            Mandatory,
            ValueFromPipeline
        )]
        [object]$InputObject,
        [ValidateNotNullorEmpty()]
        [int]$Width = 80,
        [switch]$CommandOnly,
        [Parameter(HelpMessage = "Include any Ansi formatting.")]
        [switch]$Ansi
    )

    Begin {
        Write-Verbose "[$($myinvocation.mycommand) BEGIN  ] Starting the command"
        #initialize a collection to hold all incoming data
        $data = [system.collections.generic.list[object]]::New()

        #initialize a here-string for the clipboard copy
        $Text = @"
"@

        #parse out the Out-Copy command
        $Invoked = $MyInvocation.Line
        $cmd = $Invoked.substring(0, $invoked.LastIndexOf("|"))
        Write-Verbose "[$($myinvocation.mycommand) BEGIN  ] Capturing output from: $cmd"

        $Idle = $True
    } #begin

    Process {
        #only display the verbose message once
        if ($idle) {
            Write-Verbose "[$($myinvocation.mycommand) PROCESS] Capturing pipeline input"
            $Idle = $False
        }
        #add each input to the collection as a string
        $data.Add($InputObject)

    } #process

    End {
        #format data as string
        $datastrings = $data | Out-String -Width $width
        #write data to the pipeline
        Write-Verbose "[$($myinvocation.mycommand) END    ] Here is the captured command output"
        if ($PSBoundParameters.ContainsKey("Ansi")) {
            Write-Verbose "[$($myinvocation.mycommand) END    ] Including any Ansi formatting"
        }
        else {
            #strip off ANSI sequences
            Write-Verbose "[$($myinvocation.mycommand) END    ] Removing any Ansi formatting"
            [regex]$ansiopen = "$([char]0x1b)\[\d+[\d;]+m"
            [regex]$ansiclose= "$([char]27)\[0m"
            $datastrings = $ansiopen.replace($datastrings,"") -replace $ansiclose,""
        }

        if ($CommandOnly) {
            Write-Verbose "[$($myinvocation.mycommand) END    ] Copying command statement only to the clipboard"
            $Text += $cmd
        }
        else {
            #convert data to text
            Write-Verbose "[$($myinvocation.mycommand) END    ] Getting current prompt"

            #insert a prompt
            $text += "PS $($pwd)> "

            #add the command expression
            $text += $cmd

            #insert a blank line to make the output prettier
            $text += "`n"
            Write-Verbose "[$($myinvocation.mycommand) END    ] Converting data to text"
            #using a regular expression to try and clean up the output
            $text += $datastrings  -replace "(?<=\S*)\s+`r`n$", "`r`n"
        }

        Write-Verbose "[$($myinvocation.mycommand) END    ] Copy text to the clipboard"
        Set-Clipboard -Value $text
        Write-Verbose "[$($myinvocation.mycommand) END    ] Ending the command"
    } #end

}
