
<#
the duration specification - http://www.w3.org/TR/xmlschema-2/#duration

3.2.6.1 Lexical representation
The lexical representation for duration is the [ISO 8601] extended format PnYn MnDTnH nMnS, where nY represents the number of years, nM the number of months, nD the number of days, 'T' is the date/time separator, nH the number of hours, nM the number of minutes and nS the number of seconds. The number of seconds can include decimal digits to arbitrary precision.
#>

Function ConvertTo-LexicalTimeSpan {
    [cmdletbinding()]
    [OutputType("String")]
    Param(
        [Parameter(Position = 0, Mandatory,HelpMessage = "Enter a TimeSpan object", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [TimeSpan]$TimeSpan
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $TimeSpan"
        Try {
            [System.Xml.XmlConvert]::ToString($TimeSpan)
        }
        Catch {
            Throw $_
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close ConvertTo-LexicalTimeSpan

Function ConvertFrom-LexicalTimeSpan {
    [cmdletbinding()]
    [OutputType("string", "TimeSpan")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a lexical time string like P23DT3H43M. This is case-sensitive.", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$String,
        [Parameter(HelpMessage = "Format the TimeSpan as a string")]
        [switch]$AsString
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $($String.ToUpper()) to a TimeSpan"
        Try {
            #convert string to upper case to help the user out
            $r = [System.Xml.XmlConvert]::ToTimeSpan($String.ToUpper())
            if ($AsString) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Displaying as a TimeSpan string"
                $r.ToString()
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
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close ConvertFrom-LexicalTimeSpan