
function Remove-MergedBranch {
    [CmdletBinding(SupportsShouldProcess)]
    [alias('rmb')]
    [OutputType('String')]

    param (
        [Parameter(
            Position = 0,
            HelpMessage = 'Specify the name of your master branch.'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$MainBranch = 'master',
        [Parameter(HelpMessage = 'Remove all merged branches except current and master with no prompting.')]
        [Switch]$Force
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = scripting
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
        #verify this is a git repo
        $t = git status 2>$null
        if ($t) {
            #get branches
            $branches = (git branch --merged $MainBranch | Where-Object { $_ -notmatch "^\*|$MainBranch" })
            if ($branches.count -ge 1) {
                Write-Verbose "Found $($branches.count) branches"
                $repo = Split-Path . -Leaf
                foreach ($branch in $branches.trim()) {
                    if ($PSCmdlet.ShouldProcess($branch, 'Remove merged branch')) {
                        if ($force) {
                            git branch -d $branch
                        }
                        elseif ($PSCmdlet.ShouldContinue($branch, "Remove merged branch from $($repo)?")) {
                            git branch -d $branch
                        }
                    }
                }
            }
            else {
                Write-Host 'No merged branches found to remove.' -ForegroundColor Yellow
            }
        }
        else {
            Write-Warning $error[0]
        }
    } #process

    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end

} #close function
#EOF
