
<#
the duration specification - http://www.w3.org/TR/xmlschema-2/#duration

3.2.6.1 Lexical representation
The lexical representation for duration is the [ISO 8601] extended format PnYn MnDTnH nMnS, where nY represents the number of years, nM the number of months, nD the number of days, 'T' is the date/time separator, nH the number of hours, nM the number of minutes and nS the number of seconds. The number of seconds can include decimal digits to arbitrary precision.
#>

Function ConvertTo-LexicalTimespan {
    [cmdletbinding()]
    [OutputType("String")]
    Param(
        [Parameter(Position = 0, Mandatory,HelpMessage = "Enter a timespan object", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [timespan]$Timespan
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting $Timespan"
        Try {
            [System.Xml.XmlConvert]::ToString($Timespan)
        }
        Catch {
            Throw $_
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close ConvertTo-LexicalTimespan

Function ConvertFrom-LexicalTimespan {
    [cmdletbinding()]
    [OutputType("string", "timespan")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a lexical time string like P23DT3H43M. This is case-sensitive.", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$String,
        [Parameter(HelpMessage = "Format the timespan as a string")]
        [switch]$AsString
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting $($String.toUpper()) to a timespan"
        Try {
            #convert string to upper case to help the user out
            $r = [System.Xml.XmlConvert]::ToTimeSpan($String.ToUpper())
            if ($AsString) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Displaying as a timespan string"
                $r.toString()
            }
            else {
                $r
            }
        }
        Catch {
            Throw $_
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close ConvertFrom-LexicalTimespan