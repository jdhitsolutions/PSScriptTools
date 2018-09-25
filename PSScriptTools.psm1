
Get-ChildItem -path $PSScriptRoot\*.ps1 | foreach-object -process {
    . $_.FullName
}

#add ToDo options to the ISE or VS Code
if ($psEditor) {
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
    Register-EditorCommand -Name "Insert.ToDo" -DisplayName "Insert ToDo" -ScriptBlock $sb -SuppressOutput
    
}
elseif ($psise) {
    $action = { 
       
        $prompt = "What do you need to do?"
        $title = "To Do"
        $item = Invoke-Inputbox -Title $title -Prompt $prompt
        $todo = "# [$(Get-Date)] TODO: $item"
        $psise.CurrentFile.Editor.InsertText($todo)
        #jump cursor to the end
        $psise.CurrentFile.editor.SetCaretPosition($psise.CurrentFile.Editor.CaretLine,$psise.CurrentFile.Editor.CaretColumn)
    }
    
    #add the action to the Add-Ons menu
    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("ToDo",$Action,"Ctrl+Alt+2" ) | Out-Null
}
