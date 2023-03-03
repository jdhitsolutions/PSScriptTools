#requires -version 5.1
#requires -module PSScriptTools

Function New-Password {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, HelpMessage = "Enter a 8+ character string to 'seed' the password.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_.length -ge 8 })]
        [string]$SeedText
    )
    Begin {
        Write-Detail "Starting $($MyInvocation.MyCommand)" -Prefix begin | Write-Verbose
        $hash = @{
            a = "@"
            q = "$"
            e = "3"
            i = "!"
            j = ";"
            g = "}"
            o = "*"
            k = "<"
            c = "<"
        }
        #define a temp file to store results
        $tmpfile = New-RandomFileName -UseTempFolder -Extension log
    } #begin

    Process {
        Write-Detail "Using seed '$SeedText'" | Write-Verbose
        Format-String $SeedText -Randomize -Replace $hash -Case Alternate | Tee-Object -FilePath $tmpfile -Append
    } #process

    End {
        Write-Detail "See $tmpfile for results." -Prefix end | Write-Verbose
        Write-Detail "Ending $($MyInvocation.MyCommand)" -Prefix end | Write-Verbose
    } #end

} #close New-Password


'applepies','PSMaster','skldjgb23' | New-Password -verbose
# New-Password PowerShell

# New-Password 'password' | New-Password

# New-RandomFilename | New-Password