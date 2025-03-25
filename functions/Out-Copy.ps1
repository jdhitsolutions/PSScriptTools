
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
        [ValidateNotNullOrEmpty()]
        [int]$Width = 80,
        [switch]$CommandOnly,
        [Parameter(HelpMessage = "Include any Ansi formatting.")]
        [switch]$Ansi
    )

    Begin {
        Write-Verbose "[$($MyInvocation.MyCommand) BEGIN  ] Starting the command"
        #initialize a collection to hold all incoming data
        $data = [system.collections.generic.list[object]]::New()

        #initialize a here-string for the clipboard copy
        $Text = @"
"@

        #parse out the Out-Copy command
        $Invoked = $MyInvocation.Line
        $cmd = $Invoked.substring(0, $invoked.LastIndexOf("|"))
        Write-Verbose "[$($MyInvocation.MyCommand) BEGIN  ] Capturing output from: $cmd"

        $Idle = $True
    } #begin

    Process {
        #only display the verbose message once
        if ($idle) {
            Write-Verbose "[$($MyInvocation.MyCommand) PROCESS] Capturing pipeline input"
            $Idle = $False
        }
        #add each input to the collection as a string
        $data.Add($InputObject)

    } #process

    End {
        #format data as string
        $DataStrings = $data | Out-String -Width $width
        #write data to the pipeline
        Write-Verbose "[$($MyInvocation.MyCommand) END    ] Here is the captured command output"
        if ($PSBoundParameters.ContainsKey("Ansi")) {
            Write-Verbose "[$($MyInvocation.MyCommand) END    ] Including any Ansi formatting"
        }
        else {
            #strip off ANSI sequences
            Write-Verbose "[$($MyInvocation.MyCommand) END    ] Removing any Ansi formatting"
            [regex]$AnsiOpen = "$([char]0x1b)\[\d+[\d;]+m"
            [regex]$AnsiClose= "$([char]27)\[0m"
            $DataStrings = $AnsiOpen.replace($DataStrings,"") -replace $AnsiClose,""
        }

        if ($CommandOnly) {
            Write-Verbose "[$($MyInvocation.MyCommand) END    ] Copying command statement only to the clipboard"
            $Text += $cmd
        }
        else {
            #convert data to text
            Write-Verbose "[$($MyInvocation.MyCommand) END    ] Getting current prompt"

            #insert a prompt
            $text += "PS $($pwd)> "

            #add the command expression
            $text += $cmd

            #insert a blank line to make the output prettier
            $text += "`n"
            Write-Verbose "[$($MyInvocation.MyCommand) END    ] Converting data to text"
            #using a regular expression to try and clean up the output
            $text += $DataStrings  -replace "(?<=\S*)\s+`r`n$", "`r`n"
        }

        Write-Verbose "[$($MyInvocation.MyCommand) END    ] Copy text to the clipboard"
        Set-Clipboard -Value $text
        Write-Verbose "[$($MyInvocation.MyCommand) END    ] Ending the command"
    } #end

}
