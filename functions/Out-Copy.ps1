
Function Out-Copy {
    [cmdletbinding()]
    Param(
        [Parameter(Position=0,Mandatory, ValueFromPipeline)]
        [object]$InputObject,
        [ValidateNotNullorEmpty()]
        [int]$Width = 80,
        [switch]$CommandOnly
    )

    Begin {
        Write-Verbose "[$($myinvocation.mycommand) BEGIN  ] Starting the command"
        #initialize a collection to hold all incoming data
        $Data = [system.collections.generic.list[object]]::New()

        #initialize a here-string for the clipboard copy
        $Text = @"
"@

        #parse out the Out-Copy command
        $Invoked = $MyInvocation.Line
        $cmd = $Invoked.substring(0, $invoked.LastIndexOf("|"))
        Write-Verbose "[$($myinvocation.mycommand) BEGIN  ] Capturing output from $cmd"

        $Idle = $True
    } #begin

    Process {
        #only display the verbose message once
        if ($idle) {
            Write-Verbose "[$($myinvocation.mycommand) PROCESS] Capturing pipeline input"
            $Idle = $False
        }
        #add each input to the collection
        $data.Add($InputObject)

    } #process

    End {
        #write data to the pipeline
        Write-Verbose "[$($myinvocation.mycommand) END    ] Here is the captured command output"
        $data

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
            $text += ($data | Out-String -Width $Width) -replace "(?<=\S*)\s+`r`n$", "`r`n"
        }

        Write-Verbose "[$($myinvocation.mycommand) END    ] Copy text to the clipboard"
        Set-Clipboard -Value $text
        Write-Verbose "[$($myinvocation.mycommand) END    ] Ending the command"
    } #end

}
