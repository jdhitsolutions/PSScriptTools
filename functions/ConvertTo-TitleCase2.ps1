Function ConvertTo-TitleCase {
   [cmdletbinding()]
   [OutputType("string")]
   [alias("totc", "title")]
   Param(
      [Parameter(
         Position = 0,
         Mandatory,
         ValueFromPipeline,
         HelpMessage = "Text to convert to title case"
         )]
      [ValidateNotNullOrEmpty()]
      [string]$Text
   )
   Begin {
      Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
   } #begin
   Process {
      Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting: $text"
      $low = $text.ToLower()
      (Get-Culture).TextInfo.ToTitleCase($low)
   }
   End {
      Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
   } #end
}