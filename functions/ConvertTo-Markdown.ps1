
Function ConvertTo-Markdown {

[cmdletbinding()]
    [outputtype([string[]])]
    [alias('ctm')]

    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$Inputobject,
        [Parameter()]
        [string]$Title,
        [string[]]$PreContent,
        [string[]]$PostContent,
        [ValidateScript( {$_ -ge 10})]
        [int]$Width = 80,
        #display results as a markdown table
        [switch]$AsTable
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting $($myinvocation.MyCommand)"
        #initialize an array to hold incoming data
        $data = @()

        #initialize an empty here string for markdown text
        $Text = @"

"@
        If ($title) {
            Write-Verbose "[BEGIN  ] Adding Title: $Title"
            $Text += "# $Title`n`n"
        }
        If ($precontent) {
            Write-Verbose "[BEGIN  ] Adding Precontent"
            $Text += $precontent
            $text += "`n`n"
        }

    } #begin
    Process {
        #add incoming objects to data array
        Write-Verbose "[PROCESS] Adding processed object"
        $data += $Inputobject

    } #process
    End {
        #add the data to the text
        if ($data) {
            if ($AsTable) {
                Write-Verbose "[END    ] Formatting as a table"
                $names = $data[0].psobject.Properties.name
                $head = "| $($names -join " | ") |"
                $text += $head
                $text += "`n"

                $bars = "| $(($names -replace '.','-') -join " | ") |"

                $text += $bars
                $text += "`n"

                foreach ($item in $data) {
                    $line = "| "
                    $values = @()
                    for ($i = 0; $i -lt $names.count; $i++) {
                        
                        #if an item value contains return and new line replace them with <br> Issue #97
                        if ($item.($names[$i]) -match "`n") {
                            Write-Verbose "[END    ] Replacing line returns for property $($names[$i])"
                            [string]$val = $($item.($names[$i])).replace("`r`n","<br>") -join ""
                            Write-Verbose $val
                        }
                        else {
                            [string]$val = $item.($names[$i])
                        }
                        
                        $values += $val
                    }
                    $line += $values -join " | "
                    $line += " |"
                    $text += $line
                    $text += "`r"
                }
            }
            else {
                #convert data to strings and trim each line
                Write-Verbose "[END    ] Converting data to strings"
                [string]$trimmed = (($data | Out-String -Width $width).split("`n")).ForEach({ "$($_.trim())`n" })
                Write-Verbose "[END    ] Adding to markdown"
                $clean = $($trimmed.trimend())
                $text += @"
``````text
$clean
``````

"@

            } #else as text
        } #if $data
        If ($postcontent) {
            Write-Verbose "[END    ] Adding postcontent"
            $text += "`n"
            $text += $postcontent
        }

        #write the markdown to the pipeline
        $text.TrimEnd()
        Write-Verbose "[END    ] Ending $($myinvocation.MyCommand)"
    } #end


} #close ConvertTo-Markdown