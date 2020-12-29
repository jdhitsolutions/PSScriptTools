# Change Log for PSScriptTools

This is the most recent change history for this module.

## v2.34.0

+ Fixed typo bug in `Get-PSScriptTools` that was failing to get command aliases. (Issue #99)
+ Modified `Get-PSScriptTools` to improve performance. Assuming that all exported functions use standard verbs.
+ Added `Get-PSAnsiFileMap`.
+ Added `Set-PSAnsiFileMapEntry`.
+ Added `Remove-PSAnsiFileMapEntry`.
+ Added `Export-PSAnsiFileMap`.
+ Added `Show-ANSISequence`.
+ Updated `filesystem.ansi.format.ps1xml` to use last matching pattern.
+ Modified `Show-Tree` to better handle piped-in file and directory objects.
+ Added an alias `ab` for `Add-Border`.
+ Added an alias of `nab` for `New-AnsiBar`.
+ Updated `README.md`.
+ Updated module description.
+ Help updates.

## v2.33.1

+ Fixed bug in `ConvertTo-WPFGrid` with refresh and timeout values. (Issue #98)
+ Added missing online help links.
+ Added a few related module links in `README.md`.

## v2.33.0

+ Added `Select-Before`,`Select-After`,`Select-Newest` and `Select-Oldest` and their respective aliases of *before*,*after*,*newest*, and *oldest*.
+ Added `Get-MyCounter` and a custom format file `mycounter.format.ps1xml`.
+ Added `Trace-Message` and its alias *trace*.
+ Added more Verbose messages to `Get-PSScriptTools`.
+ Code cleanup in `SelectFunctions.ps1`.
+ Modified `Get-PSScriptTools` to let you specify a verb. Updated command help.
+ Modified `ConvertTo-Markdown` to handle properties with line returns when formatting as a table. (Issue #97)
+ Code cleanup in sample script files.
+ Added sample file `CounterMarkdown.ps1`.
+ Updated `README.md`.

## v2.32.0

+ Added `ConvertTo-ASCIIArt` and its alias *cart*.
+ Added `Get-DirectoryInfo`, its alias *dw*, and a custom formatting file, `directorystat.format.ps1xml`.
+ Modified `Open-PSScriptToolsHelp` to use `Invoke-Item` to launch the PDF file. This should work better on non-Windows platforms.
+ Modified `Get-FormatView` to accept pipeline input for the `Typename` parameter. (Issue #95)
+ Modified `New-PSFormatXML` to use a static value width when using scriptblocks. (Issue #94)
+ Added `Out-Copy` and its alias *oc*.
+ Added `Get-CommandSyntax` and its alias *gsyn*.
+ Updated missing online help links.
+ Added a splash header to `Get-PSScriptTools`. The header writes to the host so it isn't part of the command output.
+ Updated `README.md`.

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md)
