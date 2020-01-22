
Function Convert-EventLogRecord {

    [cmdletbinding()]
    [alias("clr")]

    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]]$LogRecord
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

    Process {
        foreach ($record in $LogRecord) {
            Write-Verbose "[PROCESS] Processing event id $($record.ID) from $($record.logname) log on $($record.machinename)"
            Write-Verbose "[PROCESS] Creating XML data"
            [xml]$r = $record.ToXml()

            $h = [ordered]@{
                LogName     = $record.LogName
                RecordType  = $record.LevelDisplayName
                TimeCreated = $record.TimeCreated
                ID          = $record.Id
            }

            if ($r.Event.EventData.Data.Count -gt 0) {
                Write-Verbose "[PROCESS] Parsing event data"
                if ($r.Event.EventData.Data -is [array]) {
                <#
                 I only want to enumerate with the For loop if the data is an array of objects
                 If the data is just a single string like Foo, then when using the For loop,
                 the data value will be the F and not the complete string, Foo.
                 #>
                for ($i = 0; $i -lt $r.Event.EventData.Data.count; $i++) {

                    $data = $r.Event.EventData.data[$i]
                    #test if there is structured data or just text
                    if ($data.name) {
                        $Name = $data.name
                        $Value = $data.'#text'
                    }
                    else {
                        Write-Verbose "[PROCESS] No data property name detected"
                        $Name = "RawProperties"
                        #data will likely be an array of strings
                        [string[]]$Value = $data
                    }

                    if ($h.Contains("RawProperties")) {
                        Write-Verbose "[PROCESS] Appending to RawProperties"
                        $h.RawProperties += $value
                    }
                    else {
                        Write-Verbose "[PROCESS] Adding $name"
                        $h.add($name, $Value)
                    }
                } #for data
                } #data is an array
                else {
                    $data = $r.Event.EventData.data
                    if ($data.name) {
                        $Name = $data.name
                        $Value = $data.'#text'
                    }
                    else {
                        Write-Verbose "[PROCESS] No data property name detected"
                        $Name = "RawProperties"
                        #data will likely be an array of strings
                        [string[]]$Value = $data
                    }

                    if ($h.Contains("RawProperties")) {
                        Write-Verbose "[PROCESS] Appending to RawProperties"
                        $h.RawProperties += $value
                    }
                    else {
                        Write-Verbose "[PROCESS] Adding $name"
                        $h.add($name, $Value)
                    }
                }
            } #if data
            else {
                Write-Verbose "[PROCESS] No event data to process"
            }

            $h.Add("Message", $record.Message)
            $h.Add("Keywords", $record.KeywordsDisplayNames)
            $h.Add("Source", $record.ProviderName)
            $h.Add("Computername", $record.MachineName)

            Write-Verbose "[PROCESS] Creating custom object"
            New-Object -TypeName PSObject -Property $h
        } #foreach record
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}