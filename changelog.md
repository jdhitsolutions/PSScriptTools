# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

## [Unreleased]

## [3.2.0] - 2026-07-25

### Added

- Added tag comments and code to label or tag module commands. This information can be used with `Get-PSScriptTools`. Also added a new table view called `tags`.
- Added a property set called `TagInfo` for `PSScriptTool` objects.
- Added command `Write-PSHorizontalRule` with an alias of `pshr`.
- Added command `Format-BorderBox` with an alias of `fbx`.
- Added alias `wvers` for `Get-WindowsVersionString`.
- Added alias `sas` for `Show-AnsiSequence`.
- Added command `New-ANSIHyperLink` with an alias of `ahl` to make it easier to create a string with an embedded hyperlink.
- Added OnRemove event to the root module to clean up global variables and type extensions when removing the module from your PowerShell session.
- Added command `Get-ProcessTree` with an alias of `gpt` This command requires PowerShell 7.
- Added command `Show-ProcessTree` with an alias of `spt` This command requires PowerShell 7.
- Added commands for working with `[Enum]` classes. `Test-IsEnum` will return a simple Boolean value if the type is an enum. `Show-Enum` will display the enum values and their corresponding integer values. Output is formatted with a new custom format file `enumInfo.format.ps1xml`.

### Changed

- Added end-of-file markers at the end of each script file.
- Updated `New-RedGreenGradient`, `Show-ANSISequence`, and `New-ANSIBar` to abort if running in the PowerShell ISE.
- Updated `Get-ModuleCommand` to only return the first module when using `ListAvailable`.
- Updated `Show-Tree` to display tree lines in bright green when using `InColor`.
- Updated `Out-More` so that the `Count` parameter is now positional. Also added a second alias of `page` for the `Count` parameter.
- Updated PSScriptTools JSON data to include the online help link.
- Updated formatting for PSScriptTools in PowerShell 7 to add a link to online help for the command.
- Updated formatting for `Get-PSScriptTools` to display aliases italicized and in color.
- Updated `Show-AnsiSequence` to let the user specify the number of columns to display for Foreground and Background sequences. The default is 3.
- Updated `Show-AnsiSequence` to include optional parameters to page the output using `Out-More`.
- Update TypeMember functions with a custom transformation so that the user can specify a type name like `DateTime` or `[DateTime]`.
- Updated sample scripts.
- Updates to help documentation.
- Updated `README`.

### Fixed

- Added content about `Copy-HistoryCommand` to the README file. It had been previously accidentally omitted.
- Fixed missing alias, `gmc` for `Get-ModuleCommand`.

## [3.1.0] - 2026-07-14

### Added

- Added an alias of `Get-Path` to `Get-PathVariable`.
- Added a parameter to `Get-ParameterInfo` to show parameters by parameter set.
- Added command `Show-HiddenMember`.
- Added the parameter `NoComments` to `New-PSFormatXml` to suppress the default helper comments.
- Added a parameter alias `Property` for `Properties` in `New-PSFormatXML`.
- Added alias `isAdmin` to `Test-IsElevated`.

### Changed

- Updated `Get-FolderSizeInfo` to include ReparsePoints. __This is a potential breaking change__.
- Update README code samples to better fit the margins of the help PDF.
- Updated verbose output in commands to include PowerShell version information.
- Re-structured `Get-PSScriptTools`.
- Updated `Get-PSProfile` and list view to show file size.
- Updated `Get-PSProfile` to test for link target and use that for file size and last modified values.
- Updated formatting for `Get-PathVariable` to highlight paths that don't exist in red.
- Updates to sample script files.
- Updated `Save-GitSetup` to support downloading the ARM64 standalone setup file.
- Updated warning in `Get-TypeConstructor` to use type full name.
- Minor formatting update for `Get-TypeConstructor`.
- Updated `Convert-CommandToHashTable` to better handle a hashtable as a parameter value.
- Updated `ConvertTo-Hashtable` to using PSObject` to get property names.
- Updated `ConvertTo-Hashtable` to make an alphabetically sorted hashtable an ordered hashtable.
- Updated `Convert-HashtableToCode` to accept a standard or ordered hashtable as input.
- Revised `Get-MyVariable`. Removed the `-NoTypeInformation` and made it opt-in with -IncludeTypeInformation`. __This is a breaking change.__
- Revised `Get-MyVariable` to get initial variables from a new PowerShell instance.
- Revised `Get-MyAlias` to let user specify a name. The new version also skips aliases from common modules like PSReadline and Microsoft.PowerShell.PSResourceGet.
- Revised formatting for `Get-ModuleCommand` to add a link to online help for each command if running PowerShell 7.
- Updated `New-PSFormatXML` to incorporate a suggestion from [@scriptingstudio](https://github.com/scriptingstudio). [[Issue #155](https://github.com/jdhitsolutions/PSScriptTools/issues/155)]
- Updated `Get-PSProfile` to support non-Windows platforms. Reformatted the default table view.
- Updated `README`.
- Updated `Get-PSLocation` to include locations in `%PSModulePath%` Also corrected values for `HOME` and `Documents`. These changes also meant updating the custom formatting file..
- Updated `Get-PowerShellEngine` to define a type name (`PSEngine`) when writing a detailed object.
- Modified `Show-ANSISequence` to adjust number of columns to display in PowerShell 7.
- Code cleanup.
- Help updates.
- Replaced bit.ly online help links.

### Removed

- Removed `Get-TZDate` and `Get-TZList`. The online API is no longer available.
- Marked `Write-Detail` as deprecated and archived. __This might be a breaking change__

### Fixed

- Updated `Copy-HelpExample` to better handle changes in PowerShell 7 help.
- Corrected download link in `Save-GitSetup`.
- Fixed bug in formatting output from `Get-TypeConstructor`.
- Fixed bug in `Get-ModuleCommand` that failed to retrieve all command aliases.
- Fixed error in DirectoryStat sizeKB format view that wasn't showing values in KB.

## [3.0.0] - 2025-03-26

### Added

- Added command `Get-FileExtensionInfo`.
- Added command `Get-TypeConstructor` with an alias of `ctor` and a custom formatting file.
- Added commands `Get-PSScriptToolsTypeExtension` and `Import-PSScriptToolTypeExtension
- Added custom type extension file for `MeasureInfo` objects.

### Changed

- Updated formatting for `Get-PSProfile` to display profiles not found in red.
- Updating formatting for `Get-ModuleCommand` to display aliases using the command color and italicized.
- Modified `Convert-EventLogRecord` ([Issue #153](https://github.com/jdhitsolutions/PSScriptTools/issues/154))
- Merged [PR#153](https://github.com/jdhitsolutions/PSScriptTools/pull/153) Thanks [@jaols](https://github.com/jaols)
- Changed required module from the soon to be deprecated `ThreadJob` to `Microsoft.PowerShell.ThreadJob`.
- Major help updates and corrections.
- Updated `README.md`.

### Removed

- Removed sample script `today.ps1` because `ConvertTo-ASCIIArt` is no longer part of this module.

### Fixed

- Fixed download link in `Save-GitSetup`.
- Corrected wrong type name for the `FilePath` parameter in `Test-WithCulture`.
- Corrected a bug in `Get-PSWhoIs` that was failing when no organization information was present. [Issue #151](https://github.com/jdhitsolutions/PSScriptTools/issues/151)
- Corrected code typo on `Trace-Message`.

## [2.50.0] - 2024-07-13

### Added

- Added an argument completer for the `Name` parameter of `Show-FunctionItem`.
- Added a new `Property` parameter to `Get-PSUnique` to allow the user to specify a property or properties to use for comparison. The command will also display a warning if a comparison can't be made. [Issue #150](https://github.com/jdhitsolutions/PSScriptTools/issues/150)

### Changed

- Ongoing and general code cleanup.
- Removed previously deprecated commands `Set-ConsoleColor` and `Out-ConditionalColor`.
- Changed `Get-PSScriptTools` to use saved data from a JSON file instead of building the data from `Get-Command`, `Get-Alias`, and `Get-Help`. This also fixes display problems with the Synopsis property in Linux.
- Changed `Write-ANSIProgress` by adding a parameter to write to the host and not the pipeline.
- Updated `README`.

### Fixed

- Removed obsolete comment-based help for `New-PSDynamicParameter`.

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md) online.

[Unreleased]: https://github.com/jdhitsolutions/PSScriptTools/compare/v3.2.0..HEAD
[3.2.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v3.1.0..v3.2.0
[3.1.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v3.0.0..v3.1.0
[3.0.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.50.0..v3.0.0
[2.50.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.49.0..v2.50.0
