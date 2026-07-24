function Get-ProcessTree {
  [cmdletbinding()]
  [OutputType('PSProcessTree', 'PSProcessTree#User')]
  [alias('gpt')]
  param(
    [Parameter(
      Mandatory,
      Position = 0,
      ValueFromPipelineByPropertyName,
      HelpMessage = 'Specify a process ID'
    )]
    [ValidateNotNullOrEmpty()]
    [Alias('ProcessID', 'PID')]
    [int]$ID,

    [Parameter(HelpMessage = 'Include the process owner.')]
    [switch]$IncludeUserName
  )

  begin {
    Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    if ($MyInvocation.CommandOrigin -eq 'Runspace') {
      #Hide this  when the command is called from another command
      Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    }
    $data = [System.Collections.Generic.List[System.Diagnostics.Process]]::new()

    <#
    Adding a custom type name to the process object to allow for additional
    custom formatting
    #>
    if ($IncludeUserName) {
      $psName = 'PSProcessTree#User'
    }
    else {
      $psName = 'PSProcessTree'
    }
  } #begin

  process {
    if ($PSEdition -eq 'Desktop') {
      Write-Warning "This command requires PowerShell 7"
      Return
    }
    Write-Information $PSBoundParameters
    do {
      Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting process ID $ID"
      try {
        $r = Get-Process -Id $id -IncludeUserName:$IncludeUserName -ErrorAction Stop
        #Add the initial process
        if ($data.count -eq 0 -or ($r.parent)) {
          $data += $r
          $id = $r.Parent.ID
        }
      } #try
      catch {
        $_
        return
      }
    } while ($r.parent)
    if ($id) {
      #add the top parent if parents found
      $data += $r
    }

    Write-Information $data
    #Show oldest first to depict a hierarchy
    $data | ForEach-Object {
      #insert a new custom typename
      $_.PSObject.TypeNames.Insert(0, $psName)
      $_
    } | Sort-Object -Property StartTime
  } #process

  end {
    Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
  } #end

} #close Get-ProcessTree


function Show-ProcessTree {
  [cmdletbinding()]
  [OutputType('String')]
  [alias('spt')]

  param(
    [Parameter(
      Mandatory,
      Position = 0,
      ValueFromPipelineByPropertyName,
      HelpMessage = 'Specify a process ID'
    )]
    [ValidateNotNullOrEmpty()]
    [Alias('ProcessID', 'PID')]
    [int]$ID,

    [Parameter(HelpMessage = 'Include the process owner.')]
    [switch]$IncludeUserName
  )

  begin {
    Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"

    $reset = "`e[0m"
    $lineColor = "`e[92m"
    $nameStyle = "`e[3;93m"
    $userStyle = "`e[38;5;192m"
    $idStyle = "`e[38;5;200m"
    $timeStyle = "`e[38;5;159m"
  } #begin
  process {

    if ($PSEdition -eq 'Desktop') {
      Write-Warning "This command requires PowerShell 7"
      Return
    }
    Write-Information $PSBoundParameters
    $p = Get-ProcessTree -ID $id -IncludeUserName:$IncludeUserName
    if ($p[0] -is [system.diagnostics.process]) {
      Write-Information $p
      Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Displaying tree view"
      $indent = 0
      if ($IncludeUserName) {
        $branch = "$nameStyle{0}$reset -> ID: $idStyle{1}$reset StartTime: $timeStyle{2}$reset [$userStyle{3}$reset]" -f $p[0].ProcessName, $p[0].ID, $p[0].StartTime,$p[0].UserName
      }
      else {
        $branch = "$nameStyle{0}$reset -> ID: $idStyle{1}$reset StartTime: $timeStyle{2}$reset" -f $p[0].ProcessName, $p[0].ID, $p[0].StartTime
      }

      #insert a blank lines before and after the tree display for improved readability
      "`n+{0}" -f $branch

      for ($i = 1; $i -lt $p.count; $i++) {
        if ($IncludeUserName) {
          $branch = "$nameStyle{0}$reset -> ID: $idStyle{1}$reset StartTime: $timeStyle{2}$reset [$userStyle{3}$reset]" -f $p[$i].ProcessName, $p[$i].ID, $p[$i].StartTime,$p[$i].UserName
        }
        else {
          $branch = "$nameStyle{0}$reset -> ID: $idStyle{1}$reset StartTime: $timeStyle{2}$reset" -f $p[$i].ProcessName, $p[$i].ID, $p[$i].StartTime
        }
        "{0}$lineColor{1}{5}{2}`n{0}$lineColor{3}{4}{5}:$branch" -f "`e[$($indent)C", [char]0x2502, "`e[1D", [char]0x2514, (([char]0x2500 -as [string]) * 4), $reset
        $indent += 6
      }
      "`n"
    } #if process data
    else {
      Write-Warning "Failed to find process with process ID $ID."
    }
  } #process
  end {
    Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
  } #end
}