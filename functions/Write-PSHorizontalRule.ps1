enum psRuleTextStyle {
    none = 0
    bold = 1
    faint = 2
    italic = 3
    blink = 5
    reverse = 7
}

enum psRuleWeight {
    Thin
    Thick
}
enum psRuleAlignment {
    Left
    Center
    Right
}
function Write-PSHorizontalRule {
    [cmdletbinding()]
    [OutputType('String')]
    [Alias('pshr')]

    param(
        [Parameter(
            Position = 0,
            HelpMessage = 'How long do you want the line in characters? The value is NOT a percentage. The default is the full window width.'
        )]
        [int]$Width = $Host.UI.RawUi.WindowSize.Width,

        [Parameter(HelpMessage = 'Specify the line weight.')]
        [Alias('Weight')]
        [psRuleWeight]$LineWeight = 'Thin',

        [Parameter(HelpMessage = "Specify an ANSI or `$PSStyle.Foreground setting for the line color. The default is BrightGreen.")]
        [ValidateNotNullOrEmpty()]
        [string]$Style = "$([char]27)[92m",

        [Parameter(HelpMessage = 'Specify an optional caption or title.')]
        [ValidateNotNullOrEmpty()]
        [Alias('Caption')]
        [string]$Title,

        [Parameter(HelpMessage = 'Specify the title alignment. This will have effect unless you specify a title.')]
        [psRuleAlignment]$Alignment = 'Left',

        [Parameter(HelpMessage = 'Specify an optional text style for the title. This will have no effect without a title. The default is none.')]
        [psRuleTextStyle[]]$TitleStyle = 'none'

    )
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Detected PowerShell host $($host.name)"
        Write-Information $PSBoundParameters -Tags runtime
        [string]$line = switch ($LineWeight) {
            'Thick' { [char]0x25AC }
            'Thin' { [char]0x2500 }
        }
        Write-Information "Using dash $line" -Tags runtime
        [string]$reset = "$([char]27)[0m"

        if ($TitleStyle -ne 'none') {
            [string]$textStyle = '{0}[{1}m' -f [char]27, ($TitleStyle.value__ -join ';')
        }
    } #begin
    process {
        #adjust width to allow for style
        $Width -= 2 #$Style.Length
        if ($Title.Length -ge $Width) {
            Write-Warning 'The title length exceeds the horizontal rule width.'
            #bail out return
            return
        }

        #calculate horizontal rule segments
        switch ($Alignment) {
            'Left' {
                $lead = $line * 2
                $balance = $Width - $Title.Length - $lead.Length
                $endSegment = ($line * $Balance)
            }
            'Center' {
                #this will be approximate depending on the total width
                $balance = $Width - $Title.Length
                $lead = $line * ($balance / 2)
                $endSegment = $lead
            }
            'Right' {
                $balance = $Width - $Title.length - 2
                $lead = $line * $balance
                $endSegment = $line * 2
            }
        }

        Write-Debug "Title length = $($Title.Length)"
        Write-Debug "Lead length = $($lead.Length)"
        Write-Debug "EndSegment length = $($endSegment.length)"
        Write-Debug "Using calculated width $Width"
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating a $($LineWeight.ToString().ToLower()) horizontal line of width $Width"

        "$Style{0}$textStyle{1}$Reset$Style{2}$Reset" -f $lead, $Title, $endSegment

    } #process
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}