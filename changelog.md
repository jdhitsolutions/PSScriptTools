# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

## [Unreleased]
### Changed
- Changed required module from the soon to be deprecated `ThreadJob` to `Microsoft.PowerShell.ThreadJob`.

### Removed
- Removed sample script `today.ps1` because `ConvertTo-ASCIIArt` is no longer part of this module.

### Fixed
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

## [v2.46.0] - 2023-03-03

### Changed

- General code cleanup and formatting.
- Modified module to only load ANSI file format features if PSStyle is not detected.
- Modified `psparameterinfo.format.ps1xml` to highlight True values with an ANSI highlight color.
- Modified `Get-FolderSizeInfo` to use `System.Collections.Generic.List[]` in place of `ArrayList`.
- Modified back-end processing for the help PDF file to reduce its size.
- Restored header to `Get-PSScriptTools`.
- Help updates.
- Revised Changelog layout.
- Updated `README.md`.

### Fixed

- Fixed a bug in `Get-GitSize` that was failing to get hidden items in the `.git` folders. Also modified the command to use `Get-FolderSizeInfo` which is faster than using `Get-ChildItem`.
- Modified `Get-PSScriptTools` to properly return version information.

### Added

- Added function `Get-TypeMember` with format file `pstypemember.format.ps1xml` and type extension `pstypemember.types.ps1xml`. The function has an alias of `gtm`.
- Added the parameter `MainBranch` to `Remove-MergedGitBranch` to allow the user to specify the name of their main or master branch. The default is `master`.

### Deprecated

- Marked `Out-ConditionalColor` and `Set-ConsoleColor` as deprecated. They will be removed in a future release.

## [v2.45.0] - 2022-09-16

- Fixed help typo for `Get-PSUnique` [PR 133](https://github.com/jdhitsolutions/PSScriptTools/pull/133). Thank you @fiala-sns.
- Updated `Get-WindowsVersion` to include `DisplayVersion`, e.g. `22H2`.
- Modified format file `windowsversion.format.ps1xml` to replace `ReleaseID` with the `DisplayVersion` value.
- Revised `Get-WindowsVersion` to use `systeminfo` to retrieve the operating system name and if that fails, fall back to using the registry entry. The registry entry for Windows 11 typically still shows Windows 10.
- Help updates.
- Updated `README.md`.

## [v2.43.0] - 2022-04-04

- Fixed VSCode snippets to run in a PowerShell 7 integrated console. [Issue #124](https://github.com/jdhitsolutions/PSScriptTools/issues/124)
- Updated `Show-AnsiSequence` to fix a display bug that was dropping values. [Issue #125](https://github.com/jdhitsolutions/PSScriptTools/issues/125)
- Removed `ConvertTo-ASCIIArt` as the online resource no longer appears to exist. [Issue #127](https://github.com/jdhitsolutions/PSScriptTools/issues/127)
- Updated missing online help links.
- Updated `Get-FoldersizeInfo` to better handle null values. [Issue #129](https://github.com/jdhitsolutions/PSScriptTools/issues/129)
- Added new sample script `today.ps1`.
- Help updates.
- Updated `README.md`.

## Archive

If you need to see older change history, look at the [Archive ChangeLog](https://github.com/jdhitsolutions/PSScriptTools/blob/master/Archive-ChangeLog.md) online.

[Unreleased]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.50.0..HEAD
[2.50.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.49.0..v2.50.0
[2.49.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.48.0..v2.49.0
[v2.48.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.47.0..v2.48.0
[v2.47.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.46.0..v2.47.0
[v2.46.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.45.0..v2.46.0
[v2.45.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.44.0..v2.45.0
[v2.44.0]: https://github.com/jdhitsolutions/PSScriptTools/compare/v2.43.0..v2.44.0