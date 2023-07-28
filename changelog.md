# Change Log for PSScriptTools

This file contains the most recent change history for the PSScriptTools module.

## v2.48.0

### Added

- Added parameter `ProviderName` to `Get-CommandSyntax to let the user specify a provider.`[Issue #139](https://github.com/jdhitsolutions/PSScriptTools/issues/139)

### Changed

- Modified `Get-ParameterInfo` to sort output by parameter set. [Issue #138](https://github.com/jdhitsolutions/PSScriptTools/issues/138)
- Modified the format file for `psparameterinfo` objects to use a table as the default.
- Added `EnumOnly` parameter to `Get-TypeMember` [Issue #135](https://github.com/jdhitsolutions/PSScriptTools/issues/135)
- Help updates

## v2.47.0

### Changed

- Added missing online help links.
- Updated module description in the manifest.
- Added `EnableLN` parameter alias to `Get-FolderSizeInfo`.
- Help updates.
- Update `Get-TypeMember` to identify properties that are enumerations.
- Updated format file for `Get-TypeMember` to highlight enum properties.
- Updated `README.md`.

## v2.46.0

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

## v2.45.0

- Fixed help typo for `Get-PSUnique` [PR 133](https://github.com/jdhitsolutions/PSScriptTools/pull/133). Thank you @fiala-sns.
- Updated `Get-WindowsVersion` to include `DisplayVersion`, e.g. `22H2`.
- Modified format file `windowsversion.format.ps1xml` to replace `ReleaseID` with the `DisplayVersion` value.
- Revised `Get-WindowsVersion` to use `systeminfo` to retrieve the operating system name and if that fails, fall back to using the registry entry. The registry entry for Windows 11 typically still shows Windows 10.
- Help updates.
- Updated `README.md`.

## v2.44.0

- Updated `Show-ANSISequence` to fix a bug where foreground samples where included when specifying background. [Issue #130](https://github.com/jdhitsolutions/PSScriptTools/issues/130)
- Updated contributing guidelines.
- Updated `README.md`.

## v2.43.0

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
