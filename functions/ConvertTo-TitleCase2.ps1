
Function ConvertTo-TitleCase {
   [cmdletbinding()]
   [Outputtype("string")]
   [alias("totc", "title")]
   Param(
      [Parameter(Mandatory, ValueFromPipeline,HelpMessage = "Text to convert to title case")]
      [ValidateNotNullOrEmpty()]
      [string]$Text
   )
   Begin {
      Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
   } #begin
   Process {
      Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting: $text"
      $low = $text.toLower()
      (Get-Culture).TextInfo.ToTitleCase($low)
   }
   End {
      Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
   } #end
}