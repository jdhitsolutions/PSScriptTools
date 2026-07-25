function ConvertTo-TitleCase {
   [cmdletbinding()]
   [OutputType('string')]
   [alias('totc', 'title')]
   param(
      [Parameter(
         Position = 0,
         Mandatory,
         ValueFromPipeline,
         HelpMessage = 'Text to convert to title case'
      )]
      [ValidateNotNullOrEmpty()]
      [string]$Text
   )
   begin {
      #tags are used for categorizing the command
      #cmdTags = scripting

      Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
      Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
   } #begin
   process {
      Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting: $text"
      $low = $text.ToLower()
      (Get-Culture).TextInfo.ToTitleCase($low)
   }
   end {
      Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
   } #end
}
#EOF
