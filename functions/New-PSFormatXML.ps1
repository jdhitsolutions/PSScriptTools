
Function New-PSFormatXML {
    [cmdletbinding(SupportsShouldProcess)]
    [alias("nfx")]
    [OutputType("None", "System.IO.FileInfo")]

    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "Specify an object to analyze and generate or update a ps1xml file.")]
        [object]$InputObject,
        [Parameter(HelpMessage = "Enter a set of properties to include. The default is all. If specifying a Wide entry, only specify a single property.")]
        [string[]]$Properties,
        [Parameter(HelpMessage = "Specify the object typename. If you don't, then the command will use the detected object type from the Inputobject.")]
        [string]$Typename,
        [Parameter(HelpMessage = "Specify whether to create a table ,list or wide view")]
        [ValidateSet("Table", "List","Wide")]
        [string]$FormatType = "Table",
        [string]$ViewName = "default",
        [Parameter(Mandatory, HelpMessage = "Enter full filename and path for the format.ps1xml file.")]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(HelpMessage = "Specify a property name to group on.")]
        [ValidateNotNullOrEmpty()]
        [string]$GroupBy,
        [Parameter(HelpMessage="Wrap long lines. This only applies to Tables.")]
        [Switch]$Wrap,
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
            [xml]$Doc = New-Object -TypeName System.Xml.XmlDocument

            #create declaration
            $dec = $Doc.CreateXmlDeclaration("1.0", "UTF-8", $null)
            #append to document
            [void]$doc.AppendChild($dec)

            $text = @"

format type data generated $(Get-Date) by $env:USERDOMAIN\$env:username

"@

            [void]$doc.AppendChild($doc.CreateComment($text))

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
        [void]$view.AppendChild($doc.CreateComment("Created $(Get-Date) by $env:USERDOMAIN\$env:username"))
        $name = $doc.CreateElement("Name")
        $name.InnerText = $ViewName
        [void]$view.AppendChild($name)
        $select = $doc.createnode("element", "ViewSelectedBy", $null)

        if ($GroupBy) {
            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Grouping by $GroupBy"

            $groupcomment = @"

            You can also use a scriptblock to define a custom property name.
            You must have a Label tag.
            <ScriptBlock>`$_.machinename.toUpper()</ScriptBlock>
            <Label>Computername</Label>

            Use <Label> to set the displayed value.

"@
            $group = $doc.CreateNode("element", "GroupBy", $null)
            [void]$group.AppendChild($doc.CreateComment($groupcomment))
            $groupProp = $doc.CreateNode("element", "PropertyName", $null)
            $groupProp.InnerText = $GroupBy
            $groupLabel = $doc.CreateNode("element", "Label", $null)
            $groupLabel.InnerText = $GroupBy
            [void]$group.AppendChild($groupProp)
            [void]$group.AppendChild($groupLabel)
        }

        Switch ($FormatType) {
            "Table" {
                $table = $doc.CreateNode("element", "TableControl", $null)
                $headers = $doc.CreateNode("element", "TableHeaders", $null)
                $TableRowEntries = $doc.CreateNode("element", "TableRowEntries", $null)
                $entry = $doc.CreateNode("element", "TableRowEntry", $null)
                if ($Wrap) {
                    Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Adding Wrap"
                    $wrapelement = $doc.CreateNode("element","Wrap",$null)
                    [void]($entry.AppendChild($wrapelement))
                }
            }
            "List" {
                $list = $doc.CreateNode("element", "ListControl", $null)
                $ListEntries = $doc.CreateNode("element", "ListEntries", $null)
                $ListEntry = $doc.CreateNode("element", "ListEntry", $null)
            }
            "Wide" {
                $Wide = $doc.CreateNode("element","WideControl",$null)
                $wideEntries = $doc.CreateNode("element", "WideEntries", $null)
                $WideEntry = $doc.CreateNode("element", "WideEntry", $null)
            }
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
            #you can't use [void] on a property assignment and we don't want to see the XML result
            $tnameElement.InnerText = $tname
            [void]$select.AppendChild($tnameElement)
            [void]$view.AppendChild($select)

            if ($group) {
                [void]$view.AppendChild($group)
            }

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating an format document for object type $tname "

            #get property members
            $objProperties = $Inputobject.psobject.properties
            $members = @()
            if ($properties) {
                foreach ($property in $properties) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Validating property: $property"
                    $test = ($objProperties).where( {$_.name -like $property})
                    if ($test) {
                        $members += $test
                    }
                    else {
                        Write-Warning "Can't find a property called $property on this object. Did you enter it correctly?"
                    }
                }
            }
            else {
                #use auto detected properties
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Auto detected $($objProperties.name.count) properties"
                $members = $objProperties
            }

            #remove GroupBy property from collection of properties
            if ($GroupBy) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing GroupBy property $GroupBy from the list of properties"
                $members = $members | Where-Object {$_.name -ne $GroupBy}
            }
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing $($members.name.count) properties"

            $comment = @"

            By default the entries use property names, but you can replace them with scriptblocks.
            <ScriptBlock>`$_.foo /1mb -as [int]</ScriptBlock>

"@
            if ($FormatType -eq 'Table') {

                $items = $doc.CreateNode("element", "TableColumnItems", $null)
                [void]$items.AppendChild($doc.CreateComment($comment))

                foreach ($member in $members) {
                    $th = $doc.createNode("element", "TableColumnHeader", $null)

                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS]... $($member.name)"
                    $label = $doc.CreateElement("Label")
                    $label.InnerText = $member.Name
                    [void]$th.AppendChild($label)
                    $width = $doc.CreateElement("Width")
                    <#
                        set initial width to value length + 3
                        Use the width of whichever is longer, the name or value
                    #>

                    $longest = $Member.value.tostring().length, $member.name.length | Sort-Object | Select-Object -last 1
                    $width.InnerText = $longest + 3
                    [void]$th.AppendChild($width)

                    $align = $doc.CreateElement("Alignment")
                    $align.InnerText = "left"
                    [void]$th.AppendChild($align)
                    [void]$headers.AppendChild($th)

                    $tci = $doc.CreateNode("element", "TableColumnItem", $null)
                    $prop = $doc.CreateElement("PropertyName")
                    $prop.InnerText = $member.name
                    [void]$tci.AppendChild($prop)
                    [void]$items.AppendChild($tci)
                }
            }
            elseif ($FormatType  -eq 'List') {
                #create a list
                $items = $doc.CreateNode("element", "ListItems", $null)
                [void]$items.AppendChild($doc.CreateComment($comment))
                foreach ($member in $members) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS]... $($member.name)"

                    $li = $doc.CreateNode("element", "ListItem", $null)
                    $label = $doc.CreateElement("Label")
                    $label.InnerText = $member.Name
                    [void]$li.AppendChild($label)
                    $prop = $doc.CreateElement("PropertyName")
                    $prop.InnerText = $member.name
                    [void]$li.AppendChild($prop)
                    [void]$items.AppendChild($li)
                }
            }
            else {
                #create Wide
                $item = $doc.CreateNode("element","WideItem",$null)
                [void]$item.AppendChild($doc.CreateComment($comment))
                $prop = $doc.CreateElement("PropertyName")
                 Write-Verbose "[$((Get-Date).TimeofDay) PROCESS]... $($members[0].name)"
                $prop.InnerText = $members[0].name
                [void]$item.AppendChild($prop)

            }
            $counter++
        }
        else {
            Write-Warning "Ignoring this object. I only need one instance of an object to create the ps1xml file. Your file will still be created."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Finalizing XML"
        #Add elements to each parent
        if ($FormatType -eq 'Table') {
            [void]$entry.AppendChild($items)
            [void]$TableRowEntries.AppendChild($entry)
            [void]$table.AppendChild($doc.CreateComment("Delete the AutoSize node if you want to use the defined widths."))
            $auto = $doc.CreateElement("AutoSize")
            [void]$table.AppendChild($auto)
            [void]$table.AppendChild($headers)
            [void]$table.AppendChild($TableRowEntries)

            [void]$view.AppendChild($table)
        }
        elseif ($FormatType -eq  'List') {
            [void]$listentry.AppendChild($items)
            [void]$listentries.AppendChild($listentry)
            [void]$list.AppendChild($listentries)
            [void]$view.AppendChild($list)
        }
        else {
            #Wide
            [void]$WideEntry.AppendChild($item)
            [void]$wideEntries.AppendChild($WideEntry)
            [void]$Wide.AppendChild($wideEntries)
            [void]$view.AppendChild($Wide)
        }

        if ($append) {
            Write-Verbose "[$((Get-Date).TimeofDay) END    ] Appending to existing XML"
            [void]$doc.Configuration.ViewDefinitions.AppendChild($View)
        }
        else {
            [void]$viewdef.AppendChild($view)
            [void]$config.AppendChild($viewdef)
            [void]$doc.AppendChild($config)
        }

        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Saving to $realpath"
        if ($PSCmdlet.ShouldProcess($realPath, "Adding $formattype view $viewname")) {
            $doc.Save($realPath)
            if ($Passthru) {
                Get-Item $realPath
                #If you run this command in VS Code and specify -passthru, then open the file
                #for further editing
                if ($host.name -match "Visual Studio Code") {
                    Open-EditorFile -Path $realpath
                }
            }
        }

        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close New-PSFormatXML

