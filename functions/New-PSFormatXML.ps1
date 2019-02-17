
Function New-PSFormatXML {
    [cmdletbinding(SupportsShouldProcess)]
    [alias("nfx")]
    [Outputtype("None", "System.IO.FileInfo")]

    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "Specify an object to analyze and generate or update a ps1xml file.")]
        [object]$InputObject,
        [Parameter(HelpMessage = "Enter a set of properties to include. The default is all.")]
        [string[]]$Properties,
        [Parameter(HelpMessage = "Specify the object typename. If you don't, then the command will use the detected object type from the Inputobject.")]
        [string]$Typename,
        [Parameter(HelpMessage = "Specify whether to create a table or list view")]
        [ValidateSet("Table", "List")]
        [string]$FormatType = "Table",
        [string]$ViewName = "default",
        [Parameter(Mandatory, HelpMessage = "Enter full filename and path for the format.ps1xml file.")]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [switch]$Append,
        [switch]$Passthru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

        #convert the parent path into a real file system path
        $parent = Convert-Path -Path (Split-Path -Path $path)
        #reconstruct the path
        $realPath = Join-Path -Path $parent -ChildPath (Split-Path -Path $path -Leaf)

        if (-Not $Append) {
            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Initializing a new XML document"
            [xml]$Doc = New-Object System.Xml.XmlDocument

            #create declaration
            $dec = $Doc.CreateXmlDeclaration("1.0", "UTF-8", $null)
            #append to document
            $doc.AppendChild($dec) | Out-Null

            $text = @"

format type data generated $(Get-Date)
by $env:USERDOMAIN\$env:username

"@

            $doc.AppendChild($doc.CreateComment($text)) | Out-Null

            #create Configuration Node
            $config = $doc.CreateNode("element", "Configuration", $null)
            $viewdef = $doc.CreateNode("element", "ViewDefinitions", $null)

        }
        elseif ($Append -AND (Test-Path -path $realPath)) {
            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Opening format document $RealPath"
            [xml]$Doc = Get-Content -Path $realPath
        }
        else {
            Throw "Failed to find $Path"
        }
        $view = $doc.CreateNode("element", "View", $null)
        $view.AppendChild($doc.CreateComment("Created $(Get-Date) by $env:USERDOMAIN\$env:username")) | Out-Null
        $name = $doc.CreateElement("Name")
        $name.InnerText = $ViewName
        $view.AppendChild($name) | Out-Null
        $select = $doc.createnode("element", "ViewSelectedBy", $null)

        if ($FormatType -eq 'Table') {
            $table = $doc.CreateNode("element", "TableControl", $null)
            $headers = $doc.CreateNode("element", "TableHeaders", $null)
            $TableRowEntries = $doc.CreateNode("element", "TableRowEntries", $null)
            $entry = $doc.CreateNode("element", "TableRowEntry", $null)
        }
        else {
            $list = $doc.CreateNode("element", "ListControl", $null)
            $ListEntries = $doc.CreateNode("element", "ListEntries", $null)
            $ListEntry = $doc.CreateNode("element", "ListEntry", $null)
        }
        $counter = 0
    } #begin

    Process {
        If ($counter -eq 0) {

            if ($Typename) {
                $tname = $TypeName
            }
            else {
                $tname = $Inputobject.psobject.typenames[0]
            }
            $tnameElement = $doc.CreateElement("TypeName")
            $tnameElement.InnerText = $tname
            $select.AppendChild($tnameElement) | Out-Null
            $view.AppendChild($select) | Out-Null

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating an format document for object type $tname "

            #get property members
            $members = $Inputobject.psobject.properties
            if ($properties) {
                $members = $members.where( {$properties -contains $_.name})
            }
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing $($members.name.count) properties"

            $comment = @"

            By default the entries use property names, but you can replace them with scriptblocks.
            <Scriptblock>`$_.foo /1mb -as [int]</Scriptblock>

"@
            if ($FormatType -eq 'Table') {

                $items = $doc.CreateNode("element", "TableColumnItems", $null)
                $items.AppendChild($doc.CreateComment($comment)) | Out-Null

                foreach ($member in $members) {
                    $th = $doc.createNode("element", "TableColumnHeader", $null)

                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS]... $($member.name)"
                    $label = $doc.CreateElement("Label")
                    $label.InnerText = $member.Name
                    $th.AppendChild($label) | Out-Null
                    $width = $doc.CreateElement("Width")
                    <#
                        set initial width to value length + 3
                        Use the width of whichever is longer, the name or value
                    #>

                    $longest = $Member.value.tostring().length, $member.name.length | Sort-Object | Select-Object -last 1
                    $width.InnerText = $longest + 3
                    $th.AppendChild($width) | Out-Null

                    $align = $doc.CreateElement("Alignment")
                    $align.InnerText = "left"
                    $th.AppendChild($align) | Out-Null
                    $headers.AppendChild($th) | Out-Null

                    $tci = $doc.CreateNode("element", "TableColumnItem", $null)
                    $prop = $doc.CreateElement("PropertyName")
                    $prop.InnerText = $member.name
                    $tci.AppendChild($prop) | Out-Null
                    $items.AppendChild($tci) | Out-Null
                }
            }
            else {
                #create a list
                $items = $doc.CreateNode("element", "ListItems", $null)
                $items.AppendChild($doc.CreateComment($comment)) | Out-Null
                foreach ($member in $members) {
                    $li = $doc.createNode("element", "ListItem", $null)

                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS]... $($member.name)"

                    $li = $doc.CreateNode("element", "ListItem", $null)
                    $label = $doc.CreateElement("Label")
                    $label.InnerText = $member.Name
                    $li.AppendChild($label) | Out-Null
                    $prop = $doc.CreateElement("PropertyName")
                    $prop.InnerText = $member.name
                    $li.AppendChild($prop) | Out-Null
                    $items.AppendChild($li) | Out-Null
                }
            }
            $counter++
        }
        else {
            Write-Warning "Ignoring this object. I can only handle one instance of an object."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Finalizing XML"
        #Add elements to each parent
        if ($FormatType -eq 'Table') {
            $entry.AppendChild($items) | Out-Null
            $TableRowEntries.AppendChild($entry) | Out-Null
            $table.AppendChild($doc.CreateComment("Delete the AutoSize node if you want to use the defined widths.")) | Out-Null
            $auto = $doc.CreateElement("AutoSize")
            $table.AppendChild($auto) | Out-Null
            $table.AppendChild($headers) | Out-Null
            $table.AppendChild($TableRowEntries) | Out-Null

            $view.AppendChild($table) | Out-Null
        }
        else {
            $listentry.AppendChild($items) | Out-Null
            $listentries.AppendChild($listentry) | Out-Null
            $list.AppendChild($listentries) | Out-Null
            $view.AppendChild($list) | Out-Null
        }

        if ($append) {
            Write-Verbose "[$((Get-Date).TimeofDay) END    ] Appending to existing XML"
            $doc.Configuration.ViewDefinitions.AppendChild($View) | Out-Null
        }
        else {
            $viewdef.AppendChild($view) | Out-Null
            $config.AppendChild($viewdef) | Out-Null
            $doc.AppendChild($config) | Out-Null
        }

        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Saving to $realpath"
        if ($PSCmdlet.ShouldProcess($realPath, "Adding $formattype view $viewname")) {
            $doc.Save($realPath)
            if ($Passthru) {
                Get-Item $realPath
            }
        }

        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close New-PSFormatXML

