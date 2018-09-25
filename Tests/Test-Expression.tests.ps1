#pester tests for Test-Expression

Import-Module ..\Test-Expression -force

InModuleScope Test-Expression {

Describe "Test-Expression" {
   
    It "Should have an alias" {
      (Get-Alias tex).ResolvedCommand.Name | Should Be "Test-Expression"
    }

    It "Should do a single test" {
        $result = Test-Expression -expression {1..50}
        $result.Tests | Should Be 1
        $result.TestInterval | Should be 500
        $result.AverageMS | Should BeGreaterThan 0
    }

    It "Should allow setting an interval" {
        $result = Test-Expression -expression {1..50} -interval .1
        $result.TestInterval | Should Be 100
    }

    It "Should allow setting a random interval" {
        $result = Test-Expression -expression {1..50} -randomMinimum .1 -randomMaximum .5 -count 2
        $result.TestInterval | Should Be "Random"
    }

    It "Should allow for multiple tests" {
        $result = Test-Expression -expression {1..50} -count 5 -interval .1
        $result.Tests | Should Be 5
        $result.TrimmedMS | Should BeGreaterThan 0
    }

    It "Should accept scriptblock arguments" {
        $sb = {Param([int]$x,[int]$y) $x..$y}
        $result = Test-Expression -expression $sb -argument 1,100
        $result.Tests | Should Be 1
    }

    It "Should include the expression when asked" {
       $result = Test-Expression -expression {1..50} -IncludeExpression
       $result.Expression.GetType().Name | Should Be "ScriptBlock"
       $result.Expression.ToString() | Should Be "1..50"
    }

} #Describe


} #module scope
