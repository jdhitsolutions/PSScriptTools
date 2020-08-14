

#an internal function for the actual testing
Function _TestMe {
    [cmdletbinding(DefaultParameterSetName = "Interval")]
    Param(
        [scriptblock]$Expression,
        [object[]]$ArgumentList,
        [ValidateScript( { $_ -ge 1 })]
        [int]$Count = 1,
        [Parameter(ParameterSetName = "Interval")]
        [ValidateRange(0, 60)]
        [double]$Interval = .5,
        [Parameter(ParameterSetName = "Random", Mandatory)]
        [Alias("min")]
        [double]$RandomMinimum,
        [Parameter(ParameterSetName = "Random", Mandatory)]
        [Alias("max")]
        [double]$RandomMaximum,
        [switch]$IncludeExpression
    )

    $TestData = 1..$count | ForEach-Object -begin {
        <#
          PowerShell doesn't seem to like passing a scriptblock as an
          argument when using Invoke-Command. It appears to pass it as
          a string so I'm recreating it as a scriptblock here.
         #>
        $script:testblock = [scriptblock]::Create($Expression)

    } -process {
        #invoke the scriptblock with any arguments and measure
        Measure-Command -Expression { $($script:testblock).Invoke(@($argumentlist)) } -OutVariable +out

        #} -outvariable +out
        #pause to mitigate any caching effects
        if ($RandomMinimum -AND $RandomMaximum) {
            $sleep = Get-Random -Minimum ($RandomMinimum * 1000) -Maximum ($RandomMaximum * 1000)
            $TestInterval = "Random"
        }
        else {
            $Sleep = ($Interval * 1000)
            $TestInterval = $Sleep
        }

        Start-Sleep -Milliseconds $sleep
    }

    $TestResults = $TestData |
    Measure-Object -Property TotalMilliseconds -Average -Maximum -Minimum |
    Select-Object -Property @{Name = "Tests"; Expression = { $_.Count } },
    @{Name = "TestInterval"; Expression = { $TestInterval } },
    @{Name = "AverageMS"; Expression = { $_.Average } },
    @{Name = "MinimumMS"; Expression = { $_.Minimum } },
    @{Name = "MaximumMS"; Expression = { $_.Maximum } },
    @{Name = "MedianMS"; Expression = {
            #sort the values to calculate the median and trimmed values
            $sort = $out.totalmilliseconds | Sort-Object

            #test if there are an even or odd number of elements
            if ( ($sort.count) % 2) {
                #odd number
                #subtract 1 because arrays start counting at 0
                $sort[(($sort.count - 1) / 2) -as [int]]
            }
            else {
                #even number
                #get middle two numbers and their average
                ($sort[($sort.count / 2)] + $sort[$sort.count / 2 + 1]) / 2
            }
        }
    },
    @{Name = "TrimmedMS"; Expression = {
            #values must be sorted in ascending order
            $data = $out.totalmilliseconds | Sort-Object
            #select elements from the second to next to last
            ($data[1..($data.count - 2)] | Measure-Object -Average).Average

        }
    }

    #add metadata
    $OS = Get-CimInstance -ClassName win32_operatingsystem
    $TestResults | Add-Member -MemberType Noteproperty -Name PSVersion -Value $PSVersionTable.PSVersion.ToString()
    $TestResults | Add-Member -MemberType Noteproperty -Name OS -Value $OS.caption

    if ($IncludeExpression) {
        Write-Verbose "Adding expression to output"
        $TestResults | Add-Member -MemberType Noteproperty -Name Expression -Value $Expression
        $TestResults | Add-Member -MemberType Noteproperty -Name Arguments -Value $ArgumentList
    }

    Write-Verbose "Inserting a new type name"
    $TestResults.psobject.typenames.insert(0, "my.TestResult")

    #write the result to the pipeline
    $testResults
} #_TestMe function

#exposed functions
Function Test-Expression {

    [cmdletbinding(DefaultParameterSetName = "Interval")]
    [alias("tex")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a scriptblock to test",
            ValueFromPipeline
        )]
        [Alias("sb")]
        [scriptblock]$Expression,

        [object[]]$ArgumentList,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateScript( { $_ -ge 1 })]
        [int]$Count = 1,

        [Parameter(
            ParameterSetName = "Interval",
            ValueFromPipelineByPropertyName)]
        [ValidateRange(0, 60)]
        [Alias("sleep")]
        [double]$Interval = .5,

        [Parameter(
            ParameterSetName = "Random",
            Mandatory
        )]
        [Alias("min")]
        [double]$RandomMinimum,

        [Parameter(
            ParameterSetName = "Random",
            Mandatory
        )]
        [Alias("max")]
        [double]$RandomMaximum,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("ie")]
        [switch]$IncludeExpression,

        [switch]$AsJob

    )

    Write-Verbose "Starting: $($MyInvocation.Mycommand)"
    Write-Verbose ($PSBoundParameters | Out-String)
    Write-Verbose "Measuring expression:"
    Write-Verbose ($Expression | Out-String)
    if ($ArgumentList) {
        Write-Verbose "Arguments: $($ArgumentList -join ",")"
    }

    if ($PSCmdlet.ParameterSetName -eq 'Interval') {
        Write-Verbose "$Count time(s) with a sleep interval of $interval seconds."
    }
    else {
        Write-Verbose "$Count time(s) with a random sleep interval between $RandomMinimum seconds and $RandomMaximum seconds."
    }

    If ($AsJob) {
        Write-Verbose "Running as a background job"
        [void]$PSBoundParameters.remove("AsJob")
        Start-Job -ScriptBlock {
            Param([hashtable]$Testparams)

            <#
          PowerShell doesn't seem to like passing a scriptblock as an
          argument when using Invoke-Command. It appears to pass it as
          a string so I'm recreating it as a scriptblock here.
        #>

            $expression = [scriptblock]::Create($Testparams.Expression)
            $TestParams.Expression = $Expression
            Test-Expression @testparams
        } -ArgumentList @($PSBoundParameters) -InitializationScript { Import-Module PSScriptTools}

    }
    else {

        [void]$PSBoundParameters.remove("AsJob")
        _TestMe @PSBoundParameters
    }

    Write-Verbose "Ending: $($MyInvocation.Mycommand)"

} #end function

Function Test-ExpressionForm {
    [cmdletbinding()]
    [alias("texf")]
    Param()

    if ((Test-IsPSWindows)) {

        Add-Type -AssemblyName PresentationFramework
        Add-Type -assemblyName PresentationCore

        [xml]$xaml = Get-Content $psscriptroot\form.xaml

        $reader = New-Object system.xml.xmlnodereader $xaml
        $form = [windows.markup.xamlreader]::Load($reader)

        $sb = $form.FindName("txtScriptBlock")
        $count = $form.FindName("txtCount")
        $results = $form.FindName("tbResults")
        $slider = $form.Findname("sliderStatic")
        $radioStatic = $form.FindName("radioStatic")
        $radioRandom = $form.FindName("radioRandom")
        $min = $form.FindName("txtMin")
        $Max = $form.FindName("txtMax")
        $argumentList = $form.FindName("txtArguments")
        $run = $form.FindName("btnRun")
        $quit = $form.Findname("btnQuit")

        #defaults
        $min.Text = 1
        $max.text = 5
        $min.IsEnabled = $False
        $max.IsEnabled = $false
        $slider.IsEnabled = $True

        $radioStatic.add_Checked( {
                $min.IsEnabled = $False
                $max.IsEnabled = $false
                $slider.IsEnabled = $True
            })

        $radioRandom.Add_checked( {
                $min.IsEnabled = $True
                $max.IsEnabled = $True
                $slider.IsEnabled = $False
            })

        $quit.add_click( { $form.close() })

        Function _refresh {
            #this is a function to refresh a UI element
            Param($element)

            $element.Dispatcher.invoke("render", [action] {})
            [System.Threading.Thread]::Sleep(50)

        }

        $run.add_click( {

                $results.text = "Testing...please wait"
                _refresh $results

                #uncomment for troubleshooting
                #write-host "running" -ForegroundColor green

                $form.Dispatcher.invoke([action] {
                        if ($sb.Text -notmatch "\w") {
                            Write-Warning "You must enter something to test!"
                            Return
                        }

                        $params = @{
                            Expression        = [scriptblock]::Create($sb.text)
                            Count             = $count.text -as [int]
                            IncludeExpression = $True
                        }

                        If ($argumentList.text) {
                            $params.Add("ArgumentList", ($argumentList.Text -split ","))
                        }

                        if ($radioStatic.IsChecked) {
                            $interval = [math]::round($slider.value, 1)
                            $params.Add("interval", $interval)
                        }
                        else {
                            [double]$minimum = [math]::Round($min.Text, 1)
                            [double]$maximum = [math]::Round($max.text, 1)
                            $params.Add("RandomMinimum", $minimum)
                            $params.Add("RandomMaximum", $maximum)
                        }

                        $form.Cursor = [System.Windows.Input.Cursors]::Wait
                        #uncomment for troubleshooting
                        #$params | out-string | write-host -ForegroundColor cyan

                        $script:out = Test-Expression @params -errorvariable ev
                        if ($script:out) {
                            $data = ($script:out | Select-Object -property * -exclude OS, Expression, Arguments | Out-String).Trim()
                        }
                        else {
                            $data = $ev.exception[0].message
                        }
                        $results.text = $data
                        $form.Cursor = [System.Windows.Input.Cursors]::Default
                    })
            })

        [void]$sb.Focus()
        [void]$form.ShowDialog()

        #write the current results to the pipeline after the form is closed.
        $script:out
    }
    else {
        Write-Warning "This command requires a Windows platform that supports WPF."
    }
}

