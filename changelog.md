# Change Log for PSScriptTools

## v2.15.0

+ Added `Get-FolderSizeInfo` and its alias `gsi` along with a corresponding format.ps1xml file.
+ Fixed IsWindows bug in `New-WPFMessageBox` (Issue #59)
+ Fixed IsWindows bug in `Convertto-WPFGrid`, `Find-CimClass`, `Test-ExpressionForm`, `Get-WindowsVersion`,`Get-WindowsVersionString` and `Invoke-InputBox` by using a new function `Test-IsPSWindows`
+ Updated `Get-PSWho` to better work cross-platform
+ Help updates
+ Updated `README.md`

## v2.14.1

+ Fixed bug in `Save-GitSetup` that relies on `$IsWindows` (Issue #58). Now this command should work on Windows PowerShell 5.1 as well.
+ Updated help for `Save-GitSetup`
+ Updated help files with missing online links

## v2.14.0

+ Updated `New-PSFormatXML` to support Wide table formats (Issue #55)
+ Updated `Test-ExpressionForm` to better handle non-Windows platforms
+ Added `Save-GitSetup` to download the latest x64 version of `git`
+ Modified `New-CustomFileName` to support a new template element, `%hour24` (Issue #57)
+ Added `tv` alias to `Out-VerboseTee`
+ Added `ConvertTo-LexicalTimespan`
+ Added `ConvertFrom-LexicalTimespan`
+ Updated manifest description
+ Updated help for `Get-PowerShellEngine`
+ Updated `README.md`

## v2.13.0

+ Added `New-RunspaceCleanupJob` command to be used with WPF commands running in a new runspace
+ Modified `ConvertTo-WPFGrid` to clean up runspace when closed. (Issue #25)
+ Modified `ConvertTo-WPFGrid` to attempt to run on all platforms and gracefully fail where it won't work. (Issue #56)
+ Added 'Convert-EventLogRecord' function and its alias `clr`
+ Added `Rename-Hashtable` function and its alias `rht`
+ Updated `Convertto-Markdown` to include options to format as a table
+ Updated module manifest to export `ConvertTo-WPFGrid` to all hosts. Code in the command will determine compatibility.
+ Updated `Find-FileItem` to work better cross-platform
+ Updated `New-WPFMessagebox` to work on PowerShell 7 on Windows platforms.
+ Help Updates
+ Modified module and manifest to export all functions regardless of edition. Any OS limitations will be handled on a per command basis.
+ Updated `README.md`

## v2.12.0

+ Help updates
+ Replaced GitHub online help links with bit.ly short links
+ Minor updates to `README.md`
+ Updated `Out-More` to work better with output from `Get-Help`.

## v2.11.0

+ Added a grouping feature to `New-PSFormatXML` (Issue #54)
+ Modified `New-PSFormatXML` to open the XML file if the command is run in VS Code as part of `-Passthru`
+ Help updates

## v2.10.0

+ Added `Test-WithCulture`
+ Fixed typo in `Copy-Command` help
+ Created yaml formatted help files
+ Updated `README.md`
+ Updated help documentation with online links
+ Updated `PSScriptTools.md`

## v2.9.0

+ Added `ConvertFrom-Text` and its alias `cft` (Issue #53)
+ Updated `ConvertTo-UTC` to include an option to format result as a sortable string. (Issue #52)
+ Added `Get-WhoIs` and `whoisresult.format.ps1xml`
+ help documentation clean up
+ Updated and reorganized `README.md`

## v2.8.0

+ Added `Get-FileItem` with an alias of `pswhere`
+ Renamed `timezonedata.format.ps1xml` to all lower case.
+ Replaced using `Out-Null` to use `[void]` in `Convertto-WPFGrid`,
 `New-PSFormatXML`, `Copy-Command`,`New-WPFMessageBox`, `Write-Detail`,
 `Test-Expression`,`Invoke-Inputbox` (Issue #47)
+ Revised warning message in `New-PSFormatXML` (Issue #50)
+ Fixed icon path error in `New-WPFMessageBox`

## v2.7.0

+ Modified `ConvertTo-LocalTime` to allow for locations supporting Daylight Saving Time (Issue #44)
+ Fixed bug in `New-PSFormatXML` that wasn't using auto detected property names (Issue #45)
+ Added `Get-TZList` and `Get-TZData` commands
+ Added format file `timeZoneData.format.ps1xml`
+ Modified `ConvertTo-WPFGrid` to allow the user to control which gridlines are displayed
+ Modified `New-CustomFilename` to improve parameter help.
+ Modified `New-CustomFilename` to add %seconds.
+ Modified `New-CustomFilename` so that %month, %day and %minute will use a leading zero if necessary
+ Added new help examples for `New-CustomFilename`
+ Help updates
+ File re-organization
+ Updated `README.md`

## v2.6.0

+ Modified `Convertto-WPFGrid` to set maximum size equal to total available working area (Issue #36)
+ Modified `Convertto-WPFGrid` to change cursor on refresh and display a refresh message in the title bar
+ Added InitializationScript option for `ConvertTo-WPFGrid` (Issue #42)
+ Added `ConvertTo-LocalTime` with an alias of `clt`
+ Updated `README.md`
+ Help updates

## v2.5.0

+ fixed bug which was hiding the horizontal scroll bar in `ConvertTo-WPFGrid` (Issue #40)
+ fixed bug which prevented status bar from updating when manually refreshing in `ConvertTo-WPFGrid` (Issue #34)
+ Changed time display in `ConvertTo-WPFGrid` as a timespan instead of raw seconds (Issue #41)
+ Markdown help cleanup
+ Added `Set-ConsoleTitle`
+ Added `Set-ConsoleColor`
+ Updated `README.md`

## v2.4.0

+ Made datagrid in `ConvertTo-WPFGrid` read-only (Issue #38)
+ Modified datagrid in `ConvertTo-WPFGrid` to better handle resizing (Issue #36)
+ Modified statusbar in `ConvertTo-WPFGrid` to better handle resizing (Issue #37)
+ Modified form in `ConvertTo-WPFGrid` to better fit in the screen and not exceed the screen area (Issue #39)
+ Added parameter to allow usage of local variables in `ConvertTo-WPFGrid` (Issue #35)
+ Help updates
+ Reorganized `README.md`

## v2.3.0

+ Fixed bug in `ConvertTo-WPFGrid` that wasn't updating last update time. (Issue #30)
+ Modified `ConvertTo-WPFGrid` to allow user to load their profile scripts into the runspace. (Issue #29)
+ Modified auto sizing code in `ConvertTo-WPFGrid`
+ Modified `ConvertTo-WPFGrid` to automatically display scroll bars when necessary.
+ Modified `New-PSFormatXML` to display a warning on invalid property names. (Issue #33)
+ Added `Get-myTimeInfo`, `ConvertTo-UTCTime` and `ConvertFrom-UTCTime` (Issue #31)
+ help updates
+ Updated `README.md`

## v2.2.0

+ Code revisions in `ConvertTo-WPFGrid` (Issue #27)
+ Updated `Get-ParameterInfo` to reflect dynamic parameters (Issue #28)
+ Updated `Get-PSLocation` to better reflect locations and use a custom format file.
+ Updated `Get-WindowsVersion` with custom type for format file. Also better handling of non-Windows platforms.
+ Updated `Get-WindowsVersionString` to include the computername.
+ Updated `New-WPFMessageBox` to gracefully exit if running on PowerShell Core.
+ Updated `Test-ExpressionForm` to gracefully exit if running on PowerShell Core.
+ Updated `New-RandomFilename` to better reflect locations using `[environment]`
+ Modified manifest to be more aware of PSEdition and only load compatible commands.
+ Help updates
+ Updated `README.md`

## v2.1.0

+ Added parameter to allow user to specify a type name with `New-PSFormatXML` (Issue #26)
+ Added `Get-ParameterInfo` command with an alias of `gpi`
+ Updated help for `Optimize-Text`
+ Help updates
+ Updated `README.md`

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
