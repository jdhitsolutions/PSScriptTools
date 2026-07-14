# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

## [Unreleased]

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
- Updated verbose outpout in commands to include PowerShell version information.
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
- Changed `Get-PSScriptTools to use saved data from a JSON file instead of building the data from `Get-Command`, `Get-Alias`, and `Get-Help`. This also fixes display problems with the Synopsis property in Linux.
- Changed `Write-ANSIProgress` by adding a parameter to write to the host and not the pipeline.
- Updated `README`.

### Fixed

- Removed obsolete comment-based help for `New-PSDynamicParameter`.

## [2.49.0] - 2024-06-06

### Added

- Modified `ConvertTo-Markdown` to use `Property` and `Value` headings when converting to a list.
- Added CimMember functions `Get-CimNamespace`, `Get-CimClassMethod`, `Get-CimClassProperty`, `Get-CimClassPropertyQualifier`, `Get-CimClassName` and `Get-CimMember`. ([Issue #137](https://github.com/jdhitsolutions/PSScriptTools/issues/137))
- Added custom formatting for `Get-CimClassName`.
- Added the module `ThreadJob` as a module dependency to the manifest.

### Changed

- Modified module manifest to remove version logic on function export. Now exporting everything. If there is an OS limitation, try to handle it on a per-command basis. **This may be a breaking change**.
- Changed PDF manual theme from `github` to `github.dark`.
- Updated `Get-ParameterInfo` to recognize `ProgressAction` as a common parameter. This parameter was add in PowerShell 7.
- Updated the default table view for output from `Get-ModuleCommand` to include the module version number.
- Modified `Show-Tree` to better handle multi-string and binary values in the registry.
- Modified `Show-Tree` to use `PSStyle.FileInfo` for color information if detected. ([Issue #147](https://github.com/jdhitsolutions/PSScriptTools/issues/147))
- Updated `README.md`
- Revised `Get-FolderSizeInfo` to be more consistent between PowerShell versions. The command will skip counting all reparse points. **This may be a breaking change**. ([Issue #145](https://github.com/jdhitsolutions/PSScriptTools/issues/145))
- Re-wrote `Find-CimClass` to use `CimSession`.
- Revised `Get-ParameterInfo` to sort the output by default using ParameterSet, Position, and Name
- Help updates.

### Fixed

- Revised `Get-WindowsVersion` to handle non-English cultures. ([Issue #142](https://github.com/jdhitsolutions/PSScriptTools/issues/142))
- Fixed bug in `Convert-EventLogRecord` that failed on duplicate property name `ID`. ([Issue #143](https://github.com/jdhitsolutions/Scripts/issues/143))

## [v2.48.0] - 2023-07-28

### Added

- Added parameter `ProviderName` to `Get-CommandSyntax to let the user specify a provider.` [Issue #139](https://github.com/jdhitsolutions/PSScriptTools/issues/139)

### Changed

- Modified `Get-ParameterInfo` to sort output by parameter set. [Issue #138](https://github.com/jdhitsolutions/PSScriptTools/issues/138)
- Modified the format file for `psparameterinfo` objects to use a table as the default.
- Added `EnumOnly` parameter to `Get-TypeMember` [Issue #135](https://github.com/jdhitsolutions/PSScriptTools/issues/135)
- Help updates

## [v2.47.0] - 2023-05-25

### Changed

- Added missing online help links.
- Updated module description in the manifest.
- Added `EnableLN` parameter alias to `Get-FolderSizeInfo`.
- Help updates.
- Update `Get-TypeMember` to identify properties that are enumerations.
- Updated format file for `Get-TypeMember` to highlight enum properties.
- Updated `README.md`.

### Deprecated

- Marked `Out-ConditionalColor` and `Set-ConsoleColor` as deprecated. They will be removed in a future release.

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md) online.

[Unreleased]: https://github.com/jdhitsolutions/PSScriptTools/compare/v3.1.0..HEAD
[3.1.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v3.0.0..v3.1.0
[3.0.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.50.0..v3.0.0
[2.50.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.49.0..v2.50.0
[2.49.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.48.0..v2.49.0
[v2.48.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.47.0..v2.48.0
[v2.47.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.46.0..v2.47.0