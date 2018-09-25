#requires -version 5.0
Function ConvertTo-Markdown {
    <#
.Synopsis
Convert pipeline output to a markdown document.
.Description
This command is designed to accept pipelined output and create a markdown document. The pipeline output will formatted as a text block. You can optionally define a title, content to appear before the output and content to appear after the output.

The command does not create a text file. You need to pipe results from this command to a cmdlet like Out-File or Set-Content. See examples.
.Parameter Title
Specify a top level title. You do not need to include any markdown.
.Parameter PreContent
Enter whatever content you want to appear before converted input. You can use whatever markdown you wish.
.Parameter PostContent
Enter whatever content you want to appear after converted input. You can use whatever markdown you wish.
.Parameter Width
Specify the document width. Depending on what you intend to do with the markdown from this command you may want to adjust this value.
.Example
PS C:\> Get-Service Bits,Winrm | Convertto-Markdown -title "Service Check" -precontent "## $($env:computername)" -postcontent "_report $(Get-Date)_" 

# Service Check

## THINK51

```text

 Status   Name               DisplayName
 ------   ----               -----------
 Running  Bits               Background Intelligent Transfer Ser...
 Running  Winrm              Windows Remote Management (WS-Manag...
```

_report 07/20/2018 18:40:52_

.Example
PS C:\> Get-Service Bits,Winrm | Convertto-Markdown -title "Service Check" -precontent "## $($env:computername)" -postcontent "_report $(Get-Date)_" | Out-File c:\work\svc.md

Re-run the previous command and save output to a file.

.Example
PS C:\> $computers = "srv1","srv2","srv4"
PS C:\> $Title = "System Report"
PS C:\> $footer = "_report run $(Get-Date) by $($env:USERDOMAIN)\$($env:USERNAME)_"
PS C:\> $sb =  {
>> $os = get-ciminstance -classname win32_operatingsystem -property caption,lastbootUptime
>> [PSCustomObject]@{
>> PSVersion = $PSVersionTable.PSVersion
>> OS = $os.caption
>> Uptime = (Get-Date) - $os.lastbootUpTime
>> SizeFreeGB = (Get-Volume -DriveLetter C).SizeRemaining /1GB
>> }
>> }
PS C:\> $out = Convertto-Markdown -title $Title
PS C:\> foreach ($computer in $computers) {
>>  $out+= Invoke-command -scriptblock $sb -ComputerName $computer -HideComputerName |
>>  Select-Object -Property * -ExcludeProperty RunspaceID |
>>  ConvertTo-Markdown -PreContent "## $($computer.toUpper())"
>> }
PS C:\>$out += ConvertTo-Markdown -PostContent $footer
PS C:\>$out | set-content c:\work\report.md

Here is an example that create a series of markdown fragments for each computer and at the end creates a markdown document.
.Link
Convertto-HTML
.Link
Out-File

.Notes
Learn more about PowerShell: https://jdhitsolutions.com/blog/essential-powershell-resources/

.Inputs
[object]
#>

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
        [int]$Width = 80
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
            #convert data to strings and trim each line
            Write-Verbose "[END    ] Converting data to strings"
            [string]$trimmed = (($data | Out-String -Width $width).split("`n")).ForEach( {"$($_.trimend())`n"})
            Write-Verbose "[END    ] Adding to markdown"
            $text += @"
``````text
$($trimmed.trimend())
``````

"@
        }

        If ($postcontent) {
            Write-Verbose "[END    ] Adding postcontent"
            $text += "`n"
            $text += $postcontent
        }
        #write the markdown to the pipeline
        $text
        Write-Verbose "[END    ] Ending $($myinvocation.MyCommand)"
    } #end

} #close ConvertTo-Markdown