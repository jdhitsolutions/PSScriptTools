function Show-HiddenMember {
    [cmdletbinding()]
    [OutputType("psHiddenMember")]
    [Alias('sm')]
    
    param(
        [Parameter(
            Position = 0, 
            Mandatory, 
            ValueFromPipeline, 
            HelpMessage = 'Pipe an object to this command'
        )]
        [Object]$InputObject,
        [System.Management.Automation.PSMemberTypes]$MemberType = 'All',
        [Parameter(HelpMessage = 'Exclude methods like get_Name and set_Name')]
        [Switch]$ExcludePropertyMethod
    )
    begin {
        $count = 0
    } #begin
    process {
        #assume all piped objects are the same type so only need to process the first one.
        $count++
        if ($count -le 1) {

            $normal = $InputObject | Get-Member -MemberType $MemberType
            $all = $InputObject | Get-Member -MemberType $MemberType -Force

            Write-Information $normal -Tags data
            Write-Information $all -Tags data

            #it is possible the object won't have the specified type
            if ($all -and $normal) {
                $diff = Compare-Object -ReferenceObject $normal -DifferenceObject $all -Property Name, MemberType |
                Select-Object Name, MemberType, @{Name = 'Type'; Expression = { $InputObject.GetType().FullName } } |
               Foreach-Object {
                #insert a custom type name
                $_.PSObject.TypeNames.Insert(0,'psHiddenMember')
                $_
                } 
            }
            elseif ((-not $normal) -and $all) {
                $diff = $all | Select-Object Name, MemberType, @{Name = 'Type'; Expression = { $InputObject.GetType().FullName } } |
                Foreach-Object {
                    #insert a custom type name
                    $_.PSObject.TypeNames.Insert(0,'psHiddenMember')
                    $_
                }
            }

            if ($diff) {
                Write-Information $diff -Tags data
                if ($ExcludePropertyMethod) {
                    $diff.where({ $_.Name -notmatch '\w+_\w+' })
                }
                else {
                    $diff
                }
            }
        } #count <= 1

    } #process
    end {
        #this script block is unused
    }
}
