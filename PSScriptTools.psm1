
dir $PSScriptRoot\*.ps1 | foreach {
    . $_.FullName
}

Set-Alias -Name Tee-Verbose -Value Out-TeeVerbose

$exportParams = @{
    Function = 'Add-Border','Tee-Verbose','Write-Detail','Out-VerboseTee' 
    Alias =  'Tee-Verbose'
}

Export-ModuleMember @exportParams

