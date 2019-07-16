Function Get-RSS {
[cmdletbinding()]
Param (
[Parameter(Position=0,ValueFromPipeline=$True,
ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullOrEmpty()]
[ValidatePattern("^http")]
[Alias('url')]
[string[]]$Path="http://powershell.org/wp/feed/"
)

Begin {
    Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"  

    #a regex to strip out html tags
    [regex]$rx="<(.|\n)+?>"
} #begin

Process {
    foreach ($item in $path) {
        $data = Invoke-RestMethod -Method GET -Uri $item
        foreach ($entry in $data) {
            #link tag might vary
            if ( $entry.origLink) {
                $link = $entry.origLink
            }
            elseif ($entry.Link) { 
                $link = $entry.link
            }
            else { 
                $link = "undetermined"
                }

            #Description might be an XML doc or a string

            if ($entry.description -is [string]) {
                $description = 
[CA]$rx.Replace($entry.Description.Trim(),"").Trim()
            }
            elseif ($entry.description -is [System.Xml.XmlElement]) {
                $description = 
[CA]$rx.Replace($entry.Description.innerText,"").Trim()
            }
            else {
                #use whatever is found
                $description = $entry.description
            }

            #create a custom object
            [pscustomobject][ordered]@{
                Title = $entry.title
                Published = $entry.pubDate -as [datetime]
                Description = $description
                Link = $Link
            } #hash
        } #foreach entry
    } #foreach item

} #process

End {
    Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
} #end

} #end Get-RSS
