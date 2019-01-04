#requires -module PSScriptTools

Function New-Password {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, HelpMessage = "Enter a 8+ character string to 'seed' the password.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {$_.length -ge 8})]
        [string]$SeedText
    )
    Begin {
        Write-Detail "Starting $($myinvocation.mycommand)" -prefix begin | Write-Verbose
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
        $tmpfile = New-RandomFileName -UseTempFolder
    } #begin

    Process {
        Write-Detail "Using seed '$SeedText'" | Write-Verbose
        Format-string $SeedText -Randomize -Replace $hash -case Alternate | Tee-Object -FilePath $tmpfile -Append
    } #process

    End {
        Write-Detail "See $tmpfile for results." -prefix end | Write-Verbose
        Write-Detail "Ending $($myinvocation.mycommand)" -prefix end | Write-Verbose
    } #end

} #close New-Password


# New-Password PowerShell

# 'applepies','PSMaster','skldjgb23' | new-password -verbose

# New-Password 'password' | New-Password

# New-RandomFilename | New-Password