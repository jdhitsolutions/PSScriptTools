# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

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

## v2.39.0

+ Updated `Test-WithCulture` to include additional Verbose output.
+ Added command [Get-FileExtensionInfo](docs/Get-FileExtensionInfo.md) with format file `FileExtensionInfo.format.ps1xml'. This command will require PowerShell 7.
+ Added `New-PSDynamicParameter` and `New-PSDynamicParameterForm`.
+ Incorporated pull request [#116](https://github.com/jdhitsolutions/PSScriptTools/pull/116) to fix bug with `Get-ParameterInfo` when the command has a `count` parameter. Thanks @ninmonkey.
+ Added command [Get-LastModifiedFile](docs/Get-LastModifiedFile.md) and its alias *glm*.
+ Help updates.
+ Updated `README.md`.

## v2.38.0

+ Added `Get-PSUnique` function with an alias of `gpsu`. ([Issue #109](https://github.com/jdhitsolutions/PSScriptTools/issues/109)).
+ Modified `Show-AnsiSequence` to default to `Foreground` when using `-Type` ([Issue #110](https://github.com/jdhitsolutions/PSScriptTools/issues/110)).
+ Cleaned up module manifest.
+ Updated `New-PSFormatXML` to __not__ create the ps1xml file if a bad property is detected ([Issue #111](https://github.com/jdhitsolutions/PSScriptTools/issues/111)).
+ Modified `New-PSFormatXML` to __not__ add an explicit declaration. This means the files will now be saved in the correct UTF-8 format and not UTF-8 with BOM.
+ Modified TODO VSCode command to put date at the end. Otherwise, it breaks the `Better Comments` extension.
+ Added `Set-LocationToFile` which is only loaded when importing the module in VS Code or the PowerShell ISE.
+ Re-saved all `.ps1xml` files as `UTF-8`.
+ Added custom type extension files `fileinfo.types.ps1xml` and `system.diagnostics.process.types.ps1xml`.
+ Updated `README.md`.

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

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md) online.
