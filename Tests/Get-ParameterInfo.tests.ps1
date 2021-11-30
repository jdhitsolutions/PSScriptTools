#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }

BeforeAll {
    Import-Module "$PSScriptRoot/../PSScriptTools.psm1" -Force # -verbose
}

Describe 'Get-ParameterInfo' {
    It "Should Not Compare <_>'s -Count Parameter" -ForEach @(
        Get-Command 'Get-Random'
        # You only need to test one case, it either works, or not.
        # The Hard-coded test is a lot faster, I Kept the query to document why Get-Random was chosen.
        # Get-Command | Where-Object { $_.Parameters.Keys -contains 'Count' } | Select-Object -First 1
    ) {
        {
            Get-Command $_ | Get-ParameterInfo -ea stop
        } | Should -Not -Throw -Because 'Key "count" was shadowing the dictionary property'
    }
}