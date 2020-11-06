#requires -version 5.1
#requires -module PSScriptTools

[CmdletBinding()]
Param()
Function Get-Status {

    [cmdletbinding(DefaultParameterSetName = 'name')]
    [alias("gst")]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the name of a computer',
            ParameterSetName = 'name')
        ]
        [ValidateNotNullOrEmpty()]
        [string]$Computername = $env:computername,
        [Parameter(ParameterSetName = 'name')]
        [pscredential]$Credential,
        [Parameter(ParameterSetName = 'Session', ValueFromPipeline)]
        [CimSession]$Cimsession,
        [switch]$AsString,
        [Parameter(HelpMessage="Enable with grapical trace window")]
        [switch]$Trace
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        if ($trace) {
            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Using Trace"
            $global:TraceEnabled = $True
            $traceTitle = "{0} Trace Log" -f $($myinvocation.MyCommand)
            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $traceTitle"
            Trace-Message -Title $traceTitle
            Trace-Message "Starting $($myinvocation.mycommand)"
        }
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using parameter set $($pscmdlet.ParameterSetName)"
        Trace-Message -message "Using parameter set: $($pscmdlet.ParameterSetName)"
        $sessParams = @{
            ErrorAction  = 'stop'
            computername = $null
        }
        $cimParams = @{
            ErrorAction = 'stop'
            classname   = $null
        }

        if ($pscmdlet.ParameterSetName -eq 'name') {
            Trace-Message -message "Create a temporary Cimsession"
            $sessParams.Computername = $Computername
            if ($Credential) {
                $sessParams.Credential = $credential
            }

            Try {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating temporary cimsession to $computername"
                $Cimsession = New-CimSession @sessParams
                $tempsession = $True
            }
            catch {
                Write-Error $_
                #bail out
                return
            }
        }

        if ($Cimsession) {

            $hash = [ordered]@{
                Computername = $cimsession.computername.toUpper()
            }
            Try {
                $cimParams.classname = 'Win32_OperatingSystem'
                $cimParams.CimSession = $Cimsession
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Querying $($cimparams.classname)"
                Trace-Message  "Querying $($cimparams.classname)"
                $OS = Get-CimInstance @cimParams
                $uptime = (Get-Date) - $OS.lastBootUpTime
                $hash.Add("Uptime", $uptime)

                $pctFreeMem = [math]::Round(($os.FreePhysicalMemory / $os.TotalVisibleMemorySize) * 100, 2)
                $hash.Add("PctFreeMem", $pctFreeMem)

                $cimParams.classname = 'Win32_Logicaldisk'
                $cimParams.filter = "drivetype=3"

                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Querying $($cimparams.classname)"
                Trace-Message  "Querying $($cimparams.classname)"
                Get-CimInstance @cimParams | ForEach-Object {
                    $name = "PctFree{0}" -f $_.deviceid.substring(0, 1)
                    $pctFree = [math]::Round(($_.FreeSpace / $_.size) * 100, 2)
                    $hash.add($name, $pctfree)
                }

                Trace-Message -message "Creating new object"
                $hash | Out-String | Trace-Message
                $status = New-Object PSObject -Property $hash

                if ($AsString) {
                    Trace-Message "Formatting result as a string"
                    $upstring = $uptime.toString().substring(0, $uptime.toString().LastIndexOf("."))

                    if (($IsWindows -AND $IsCoreCLR) -OR ($PSEdition -eq 'Desktop')) {
                        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Formatting for PowerShell 7.x"
                        Trace-Message -message "Formatting for PowerShell 7.x"
                        #strip the milliseconds off the uptime
                        $string = "$([char]0x1b)[38;5;47m{0}$([char]0x1b)[0m Up:{1}" -f $status.computername, $upstring
                    }
                    Else {
                        $string = "{0} Up:{1}" -f $status.computername, $upstring
                    }

                    #Get free properties
                    $free = $status.psobject.properties | Where-Object Name -match PctFree

                    foreach ($item in $free) {
                        $sName = $item.name -replace "Pct", "%"
                        if (($IsWindows -AND $IsCoreCLR) -OR ($PSEdition -eq 'Desktop')) {
                            #Colorize values
                            Trace-Message -message "Colorizing output"
                            if ([double]$item.value -le 20) {
                                #red
                                $value = "$([char]0x1b)[91m$($item.value)$([char]0x1b)[0m"
                            }
                            elseif ([double]$item.value -le 50) {
                                #yellow
                                $value = "$([char]0x1b)[93m$($item.value)$([char]0x1b)[0m"
                            }
                            else {
                                #green
                                $value = "$([char]0x1b)[92m$($item.value)$([char]0x1b)[0m"
                            }
                        }
                        else {
                            $value = $item.Value
                        }

                        $string += " {0}:{1}" -f $sname, $value

                    } #foreach item in free

                    $string
                }
                else {
                    $status
                }
            }
            catch {
                Write-Error $_
            }

            #only remove the cimsession if it was created in this function
            if ($tempsession) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing temporary cimsession"
                Trace-Message "Removing temporary cimsession"
                Remove-CimSession -CimSession $Cimsession
            }
        } #if cimsession
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
        Trace-Message -message "Ending $($myinvocation.mycommand)"
        #make sure tracing is turned off
        $global:TraceEnabled = $False
    } #end
} #close function

$data = Get-Status -trace

#define the Escape character
$e = "$([char]0x1b)"

# a helper function to format values with ANSI escape codes
Function ansifmt {
    Param([double]$Value)

    if ($value -le 20) {
        #red
        "$([char]0x1b)[91m$($value)$([char]0x1b)[0m"
    }
    elseif ($value -le 50) {
        #yellow
        "$([char]0x1b)[93m$($value)$([char]0x1b)[0m"
    }
    else {
        #green
        "$([char]0x1b)[92m$($value)$([char]0x1b)[0m"
    }
}

#format values
$mem = "{0:00.00}" -f $data.pctFreemem
$disk = "{0:00.00}" -f $data.PctFreeC

#format the values for the graph
$pctMem = $data.PctFreeMem/100
$pctDisk = $data.PctFreeC/100

#add some style to the computername
$comp = "$(New-ANSIBar -Range (235..245) -Gradient)$e[38;5;200m  $($data.Computername)  $e[0m$(New-ANSIBar -Range (245..235) -Gradient)"
$head = Add-Border -text $comp -Character $psspecialchar.diamond -ANSIBorder "$e[93m" | Out-String

$out = @"

$head

Uptime      : $($data.uptime) $e[92m$($psspecialchar.uptriangle)$e[0m
%FreeMemory : $(ansifmt $mem) $(New-RedGreenGradient -percent $pctMem -Character $psspecialchar.lozenge)
%FreeC      : $(ansifmt $disk) $(New-RedGreenGradient -percent $pctDisk -Character $psspecialchar.BlackSquare)
Date        : $(Get-Date -format u)

"@

$out

