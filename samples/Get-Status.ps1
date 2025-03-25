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
        [CimSession]$CimSession,
        [switch]$AsString,
        [Parameter(HelpMessage="Enable with graphical trace window")]
        [switch]$Trace
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        if ($trace) {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Using Trace"
            $global:TraceEnabled = $True
            $traceTitle = "{0} Trace Log" -f $($MyInvocation.MyCommand)
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $traceTitle"
            Trace-Message -Title $traceTitle
            Trace-Message "Starting $($MyInvocation.MyCommand)"
        }
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Using parameter set $($PSCmdlet.ParameterSetName)"
        Trace-Message -message "Using parameter set: $($PSCmdlet.ParameterSetName)"
        $SessParams = @{
            ErrorAction  = 'stop'
            computername = $null
        }
        $cimParams = @{
            ErrorAction = 'stop'
            ClassNamer   = $null
        }

        if ($PSCmdlet.ParameterSetName -eq 'name') {
            Trace-Message -message "Create a temporary CimSession"
            $SessParams.Computername = $Computername
            if ($Credential) {
                $SessParams.Credential = $credential
            }

            Try {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating temporary CimSession to $computername"
                $CimSession = New-CimSession @SessParams
                $TempSession = $True
            }
            catch {
                Write-Error $_
                #bail out
                return
            }
        }

        if ($CimSession) {

            $hash = [ordered]@{
                Computername = $CimSession.computername.ToUpper()
            }
            Try {
                $cimParams.ClassNamer = 'Win32_OperatingSystem'
                $cimParams.CimSession = $CimSession
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Querying $($cimParams.ClassNamer)"
                Trace-Message  "Querying $($cimParams.ClassNamer)"
                $OS = Get-CimInstance @cimParams
                $uptime = (Get-Date) - $OS.lastBootUpTime
                $hash.Add("Uptime", $uptime)

                $pctFreeMem = [math]::Round(($os.FreePhysicalMemory / $os.TotalVisibleMemorySize) * 100, 2)
                $hash.Add("PctFreeMem", $pctFreeMem)

                $cimParams.ClassNamer = 'Win32_Logicaldisk'
                $cimParams.filter = "DriveType=3"

                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Querying $($cimParams.ClassNamer)"
                Trace-Message  "Querying $($cimParams.ClassNamer)"
                Get-CimInstance @cimParams | ForEach-Object {
                    $name = "PctFree{0}" -f $_.deviceid.substring(0, 1)
                    $pctFree = [math]::Round(($_.FreeSpace / $_.size) * 100, 2)
                    $hash.add($name, $pctFree)
                }

                Trace-Message -message "Creating new object"
                $hash | Out-String | Trace-Message
                $status = New-Object PSObject -Property $hash

                if ($AsString) {
                    Trace-Message "Formatting result as a string"
                    $UpString = $uptime.ToString().substring(0, $uptime.ToString().LastIndexOf("."))

                    if (($IsWindows -AND $IsCoreCLR) -OR ($PSEdition -eq 'Desktop')) {
                        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Formatting for PowerShell 7.x"
                        Trace-Message -message "Formatting for PowerShell 7.x"
                        #strip the milliseconds off the uptime
                        $string = "$([char]0x1b)[38;5;47m{0}$([char]0x1b)[0m Up:{1}" -f $status.computername, $UpString
                    }
                    Else {
                        $string = "{0} Up:{1}" -f $status.computername, $UpString
                    }

                    #Get free properties
                    $free = $status.PSObject.properties | Where-Object Name -match PctFree

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

                        $string += " {0}:{1}" -f $sName, $value

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

            #only remove the CimSession if it was created in this function
            if ($TempSession) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Removing temporary CimSession"
                Trace-Message "Removing temporary CimSession"
                Remove-CimSession -CimSession $CimSession
            }
        } #if CimSession
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
        Trace-Message -message "Ending $($MyInvocation.MyCommand)"
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
$mem = "{0:00.00}" -f $data.pctFreeMem
$disk = "{0:00.00}" -f $data.PctFreeC

#format the values for the graph
$pctMem = $data.PctFreeMem/100
$pctDisk = $data.PctFreeC/100

#add some style to the computername
$comp = "$(New-ANSIBar -Range (235..245) -Gradient)$e[38;5;200m  $($data.Computername)  $e[0m$(New-ANSIBar -Range (245..235) -Gradient)"
$head = Add-Border -text $comp -Character $PSSpecialChar.diamond -ANSIBorder "$e[93m" | Out-String

$out = @"

$head

Uptime      : $($data.uptime) $e[92m$($PSSpecialChar.UpTriangle)$e[0m
%FreeMemory : $(ansifmt $mem) $(New-RedGreenGradient -percent $pctMem -Character $PSSpecialChar.lozenge)
%FreeC      : $(ansifmt $disk) $(New-RedGreenGradient -percent $pctDisk -Character $PSSpecialChar.BlackSquare)
Date        : $(Get-Date -format u)

"@

$out

