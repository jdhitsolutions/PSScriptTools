# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

## v2.43.0

+ Fixed VSCode snippets to run in a PowerShell 7 integrated console. [Issue #124](https://github.com/jdhitsolutions/PSScriptTools/issues/124)
+ Updated `Show-AnsiSequence` to fix a display bug that was dropping values. [Issue #125](https://github.com/jdhitsolutions/PSScriptTools/issues/125)
+ Removed `ConvertTo-ASCIIArt` as the online resource no longer appears to exist. [Issue #127](https://github.com/jdhitsolutions/PSScriptTools/issues/127)
+ Updated missing online help links.
+ Updated `Get-FoldersizeInfo` to better handle null values. [Issue #129](https://github.com/jdhitsolutions/PSScriptTools/issues/129)
+ Added new sample script `today.ps1`.
+ Help updates.
+ Updated `README.md`.

## v2.42.0

+ Updated module manifest to load required .NET assembly for `Convert-HTMLtoAnsi`. [Issue #124](https://github.com/jdhitsolutions/PSScriptTools/issues/124)
+ Updated `Show-AnsiSequence` to fix a display bug that was dropping values. [Issue #125](https://github.com/jdhitsolutions/PSScriptTools/issues/125)
+ Updated missing online help links.
+ Added new sample script `today.ps1`.
+ Help updates.
+ Updated `README.md`.

## v2.41.0

+ Added function `Copy-CommandHistory` with an alias of `ch`.
+ Updated `Out-Copy` to ignore ANSI unless specified. [Issue #118](https://github.com/jdhitsolutions/PSScriptTools/issues/118)
+ Added an alias of `oc` for `Out-Copy`.
+ Updated `New-PSFormatXML` to fix ReadOnly property error. [Issue #121](https://github.com/jdhitsolutions/PSScriptTools/issues/121)
+ Updated `Get-ModuleCommand` to include version information and to accept pipeline input.
+ Updated `modulecommand.format.ps1xml` with a new table view called `version`.
+ Updated missing online help links.
+ Updated `README.md`.

## v2.40.0

+ Updated parameter validation for IP address in `Get-WhoIs` to allow addresses with 255 in an octet. [Issue #117](https://github.com/jdhitsolutions/PSScriptTools/issues/117).
+ Updated help files with missing online links.
+ Added command `Convert-HtmlToAnsi` with an alias of `cha`.
+ Modified `Convertto-Markdown` to add a `AsList` parameter. [Issue #114](https://github.com/jdhitsolutions/PSScriptTools/issues/114)
+ Updated `README.md`.

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md) online.
