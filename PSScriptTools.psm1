
Get-ChildItem -path $PSScriptRoot\*.ps1 | foreach-object -process {
    . $_.FullName
}

$aliases = @()
$aliases+= Set-Alias -Name Tee-Verbose -Value Out-VerboseTee -PassThru
$aliases+= Set-Alias -Name occ -Value Out-ConditionalColor -PassThru
$aliases+= Set-Alias -Name pswho -Value Get-PSWho -PassThru
$aliases+= Set-Alias -Name cc -Value Copy-Command -PassThru
$aliases+= Set-Alias -Name fv -Value Format-Value -PassThru
$aliases+= Set-Alias -Name fp -value Format-Percent -PassThru
$aliases+= Set-Alias -name fs -value Format-String -PassThru

$exportParams = @{
    Function = 'Add-Border','Tee-Verbose','Write-Detail','Out-VerboseTee',
    'Get-PSWho','Out-ConditionalColor','New-RandomFileName','New-CustomFileName',
    'Copy-Command','Format-Value','Format-String','Format-Percent'
    Alias = $aliases.Name
}

Export-ModuleMember @exportParams
