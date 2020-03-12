#enable verbose messaging in the psm1 file
if ($myinvocation.line -match "-verbose") {
    $VerbosePreference = "continue"
}
Write-Verbose "Loading public functions"

Get-ChildItem -path $PSScriptRoot\functions\*.ps1 | ForEach-Object -process {
    Write-Verbose $_.fullname
    . $_.FullName
}

#define the global PSAnsiFileMap variable
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

#add ToDo options to the ISE or VS Code
if ($psEditor) {
    #This may not be working in newer versions of the PowerShell extension under PowerShell 7
    Write-Verbose "Defining VSCode additions"
    $sb = {
        Param(
            [Microsoft.PowerShell.EditorServices.Extensions.EditorContext]$context
        )

        $prompt = "What do you need to do?"
        $title = "To Do"
        $item = Invoke-Inputbox -Title $title -Prompt $prompt
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
            $item = Invoke-Inputbox -Title $title -Prompt $prompt
            $todo = "# [$(Get-Date)] TODO: $item"
            $psise.CurrentFile.Editor.InsertText($todo)
            #jump cursor to the end
            $psise.CurrentFile.editor.SetCaretPosition($psise.CurrentFile.Editor.CaretLine, $psise.CurrentFile.Editor.CaretColumn)
        }
        #add the action to the Add-Ons menu
        $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("ToDo", $Action, "Ctrl+Alt+2" ) | Out-Null
    }
}
