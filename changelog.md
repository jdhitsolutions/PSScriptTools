# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

## v2.37.0

+ Updated `Convertto-WPFGrid` to better handle non-standard property names. ([Issue #108](https://github.com/jdhitsolutions/PSScriptTools/issues/108)).
+ Modified custom format files that use ANSI to test if host name matches 'console' or 'code' to support VSCode.
+ Modified `Summary` view in `psparameterinfo.format.ps1xml` to not use autosizing.
+ Added `<AutoSize/>` back to `serviceansi.format.ps1xml` so that ANSI output displays properly.
+ Modified `Show-ANSI` and `Get-PSAnsiFileMap` to use `[char]27` instead of `[char]0x1b` for Windows PowerShell sessions.
+ Modified ANSI sequences in format files to use `[char]27`. ([Issue #107](https://github.com/jdhitsolutions/PSScriptTools/issues/107)).
+ Modified ANSI sequences in format files recognize a remote PSSession. ([Issue #106](https://github.com/jdhitsolutions/PSScriptTools/issues/106)).
+ Update `Get-PSLocation` to work in a PowerShell remoting session where there is no profile.  ([Issue #104](https://github.com/jdhitsolutions/PSScriptTools/issues/104)).
+ Updated help.
+ Updated `README.md`.

## v2.36.0

+ Update `Get-MyVariable` to make it more compatible with PowerShell 7 ([Issue #103](https://github.com/jdhitsolutions/PSScriptTools/issues/103)). This also makes the command now compatible with the PowerShell ISE.
+ Added table view called `Simple` to format file for Aliases.
+ Modified `Options` table view in `alias.format.ps1xml` to highlight read-only aliases in Red using ANSI if running in a PowerShell console host.
+ Updated `Get-PSLocation` to include `$PSHome`.
+ Modified module to only dot source `Get-MyCounter.ps1` if running Windows. The file contains a class definition that uses a Windows-only reference and PowerShell "scans" the file before it dot sources it, which throws an exception on non-Windows platforms.
+ Added command `Get-PSSessionInfo` and an alias of `gsin`. The command uses a new format file, `pssessioninfo.format.ps1xml`.
+ Added command `Test-IsElevated`.
+ Updated `Get-PSWho` to included elevated information for non-Windows platforms.
+ Added format file `pswho.format.ps1xml`.
+ Help updates
+ Updated `README.md`.

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

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md)
