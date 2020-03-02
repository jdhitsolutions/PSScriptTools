
Function Remove-MergedBranch {

    [CmdletBinding(SupportsShouldProcess)]
    [alias("rmb")]
    [Outputtype("String")]

    Param (
        [Parameter(HelpMessage = "Remove all merged branches except current and master with no prompting.")]
        [Switch]$Force
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"
    } #begin

    Process {
        #verify this is a git repo
        $t = git status 2>$null
        if ($t) {
            #get branches
            $branches = (git branch --merged master | Where-Object {$_ -notmatch "^\*|master"})
            if ($branches.count -ge 1) {
                Write-Verbose "Found $($branches.count) branches"
                $repo = Split-Path . -Leaf
                foreach ($branch in $branches.trim()) {
                    if ($pscmdlet.ShouldProcess($branch, "Remove merged branch")) {
                        if ($force) {
                            git branch -d $branch
                        }
                        elseif ($pscmdlet.shouldcontinue($branch, "Remove merged branch from $($repo)?")) {
                            git branch -d $branch
                        }
                    }
                }
            }
            else {
                Write-Host "No merged branches found to remove." -ForegroundColor Yellow
            }
        }
        else {
            Write-Warning $error[0]
        }
    } #process


    End {
        Write-Verbose "Ending $($MyInvocation.Mycommand)"
    } #end

} #close function