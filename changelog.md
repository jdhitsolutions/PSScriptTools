# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

## v2.35.0

+ Added `ConvertTo-TitleCase` command with aliases of `totc` and `title`.
+ Added `New-FunctionItem` command with an alias of `nfi` to create functions on-the-fly.
+ Added `Show-FunctionItem` command with an alias of `sfi` to display a function.
+ Modified format files to test the console when using ANSI formatting. ([Issue #102](https://github.com/jdhitsolutions/PSScriptTools/issues/102))
+ Modified ANSI functions to display a warning when run in the PowerShell ISE and exit.
+ Updated `Get-PSScriptTools` to not use ANSI in the header when running in a non-console host.
+ Updated `Get-CommandSyntax` to not use ANSI formatting when running in a non-console host.
+ Updated `README.md`.

## v2.34.1

+ Updated `license.txt` with the new year.
+ Added missing online help links.
+ Fixed bug in `Get-ParameterInfo` that failed to display dynamic parameters when using a command alias. ([Issue #101](https://github.com/jdhitsolutions/PSScriptTools/issues/101))
+ Modified format file for `PSParameterInfo` to display `Mandatory` and `IsDynamic` values in color when the value is `$True`.

## v2.34.0

+ Fixed typo bug in `Get-PSScriptTools` that was failing to get command aliases. ([Issue #99](https://github.com/jdhitsolutions/PSScriptTools/issues/99))
+ Modified `Get-PSScriptTools` to improve performance. Assuming that all exported functions are using standard verbs.
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
+ Modified `ConvertTo-Markdown` to handle properties with line returns when formatting as a table. (I[Issue #97](https://github.com/jdhitsolutions/PSScriptTools/issues/97))
+ Code cleanup in sample script files.
+ Added sample file `CounterMarkdown.ps1`.
+ Updated `README.md`.

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md)
