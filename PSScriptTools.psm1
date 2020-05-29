#enable verbose messaging in the psm1 file
if ($myinvocation.line -match "-verbose") {
    $VerbosePreference = "continue"
}
Write-Verbose "Loading public functions"

Get-ChildItem -path $PSScriptRoot\functions\*.ps1 | ForEach-Object -process {
    Write-Verbose $_.fullname
    . $_.FullName
}

Write-Verbose "Define the global PSAnsiFileMap variable"
$json = "psansifilemap.json"
#test for user version
$userjson = Join-Path -path $HOME -ChildPath $json
$modjson = Join-Path -path $PSScriptRoot -ChildPath $json

if (Test-Path -path $userjson) {
    $map = $userjson
}
else {
    $map = $modjson
}

Set-Variable -Name PSAnsiFileMap -value (Get-Content -path $map | ConvertFrom-Json) -Scope Global

Write-Verbose "Define special character map"
$global:PSSpecialChar = @{
    FullBlock        = ([char]0x2588)
    LightShade       = ([char]0x2591)
    MediumShade      = ([char]0x2592)
    DarkShade        = ([char]0x2593)
    BlackSquare      = ([char]0x25A0)
    WhiteSquare      = ([char]0x25A1)
    BlackSmallSquare = ([char]0x25AA)
    WhiteSmallSquare = ([char]0x25AB)
    UpTriangle       = ([char]0x25B2)
    DownTriangle     = ([char]0x25BC)
    Lozenge          = ([char]0x25CA)
    WhiteCircle      = ([char]0x25CB)
    BlackCircle      = ([char]0x25CF)
    WhiteFace        = ([char]0x263A)
    BlackFace        = ([char]0x263B)
    SixPointStar     = ([char]0x2736)
    Diamond          = ([char]0x2666)
    Club             = ([char]0x2663)
    Heart            = ([char]0x2665)
    Spade            = ([char]0x2660)
    Section          = ([char]0x00A7)
    RightPointer     = ([char]0x25BA)
    LeftPointer      = ([char]0x25C4)
    BlackRectangle   = ([char]0x25CA)
}

Write-Verbose "Defining the variable `$PSSamplePath to the samples folder for this module"
$global:PSSamplePath = Join-Path -path $PSScriptroot -ChildPath Samples

Write-Verbose "Add ToDo options to the ISE or VS Code"
if ($psEditor) {
    #This may not be working in newer versions of the PowerShell extension under PowerShell 7
    Write-Verbose "Defining VSCode additions"
    $sb = {
        Param(
            [Microsoft.PowerShell.EditorServices.Extensions.EditorContext]$context
        )

        $prompt = "What do you need to do?"
        $title = "To Do"
        $item = Invoke-InputBox -Title $title -Prompt $prompt
        $todo = "# [$(Get-Date)] TODO: $item"
        $context.CurrentFile.InsertText($todo)
    }
    $rParams = @{
        Name           = "Insert.ToDo"
        DisplayName    = "Insert ToDo"
        ScriptBlock    = $sb
        SuppressOutput = $false
    }
    Register-EditorCommand @rParams
}
elseif ($psise) {
    Write-Verbose "Defining ISE additions"

    if ($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.DisplayName -notcontains "ToDo") {

        $action = {
            $prompt = "What do you need to do?"
            $title = "To Do"
            $item = Invoke-InputBox -Title $title -Prompt $prompt
            $todo = "# [$(Get-Date)] TODO: $item"
            $psise.CurrentFile.Editor.InsertText($todo)
            #jump cursor to the end
            $psise.CurrentFile.editor.SetCaretPosition($psise.CurrentFile.Editor.CaretLine, $psise.CurrentFile.Editor.CaretColumn)
        }
        #add the action to the Add-Ons menu
        $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("ToDo", $Action, "Ctrl+Alt+2" ) | Out-Null
    }
}
