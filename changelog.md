# Change Log for PSScriptTools

## v2.0.0

+ Added `New-PSFormatXml` and its alias `nfx`
+ Raised minimum PowerShell version to 5.1
+ Modified manifest to support both `Desktop` and `Core`
+ Added `Remove-Runspace`
+ Modified `ConvertTo-WPFGrid` to autosize the display and support an automatic refresh
+ Modified `ConvertTo-WPFGrid` to use a runspace (Issue #22)
+ Updated `README.md`
+ Updated help documentation
+ Raised version number to reflect a number of potentially breaking changes.

## v1.8.1

+ minor corrections to `Compare-Module` (Issue #21)

## v1.8.0

+ fixed typo in `Write-Detail` (Thanks @AndrewPla)
+ Added `Compare-Module` function (Issue #19)
+ Added `Get-WindowsVersion` function (Issue #20)
+ Added `Get-WindowsVersionString` function
+ Updated `README.md`
+ Updated module manifest
+ reorganized module
+ Updated Pester test for `Test-Expression`
+ Updated external help file

## v1.7.0

+ Added `New-WPFMessagebox` function. (Issue #11)
+ Added alias `nmb` for `New-WPFMessageBox`
+ Added icon files for WPF Message box
+ Updated `README.md`

## v1.6.0

+ Added `Optimize-Text` and its alias `ot`
+ Added `Show-Tree`
+ Help and documentation updates

## v1.5.1

+ code cleanup for the published module in the PowerShell Gallery

## v1.5.0

+ Added `Select-First` and its alias `first`
+ Added `Select-Last` and its alias `last`
+ Added `Get-MyVariable` and its alias `gmv`
+ Added `New-PSDriveHere` and its alias `npsd`
+ Updated `README.md`

## v1.4.0

+ Added hashtable tools
+ Updated `README.md`
+ minor code cleanup

## v1.3.0

+ Fixed documentation errors for `Out-ConditionalColor` (Issue #13)
+ Added alias definitions to functions
+ Added my `Test-Expression` commands (Issue #14)
+ Added my `Find-CimClass` function (Issue #16)
+ Added my `ConvertTo-Markdown` function (Issue #17)
+ Added `ConvertTo-WPFGrid` (Issue #15)
+ help cleanup and updates
+ Code cleanup and formatting

## v1.2.0

+ Updated `Write-Detail`
+ Updated README

## v1.1.0

+ Cleaned up ToDo code (Issue #12)
+ Updated README
+ Help cleanup

## v1.0.1

+ fixed version number mistake
+ updated README.md

## v1.0.0

+ initial release to the PowerShell Gallery

## v0.5.0

+ Added `Get-PSLocation` function (Issue #4)
+ Added `Get-PowerShellEngine` function (Issue #5)
+ Added `Out-More` and alias `om` (Issue #10)
+ Added icon to manifest
+ Added `Invoke-InputBox` and alias `ibx`
+ Added code to insert ToDo comments for the ISE and VSCode (Issue #7)
+ Updated README
+ Updated documentation

## v0.4.0

+ Added `Copy-Command` (Issue #2)
+ Updated `Copy-Command` to open new file in the ISE or VSCode
+ Added Format functions (Issue #3)
+ Updated help
+ Added new sample files

## v0.3.0

+ Added help documentation
+ Updated README
+ Added samples
+ Reverted `Get-PSWho` to not trim when using -AsString
+ Added code to `New-CustomFileName` to preserve case for non-placeholders
+ Modified `Out-VerboseTee` to turn on VerboseTee

## v0.2.0

+ Modified verbose output to use Write-Detail
+ Expanded aliases to full cmdlet names
+ Modified `Get-PSWho` to trim when using -AsString
+ Added `Out-ConditionalColor`
+ Added `Get-RandomFileName`
+ Added `New-CustomFileName`

## v0.1.0

+ initial module