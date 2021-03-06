Workflow New-ServerConfiguration {

Param()

Write-Verbose -Message "Starting $($workflowcommandname)"

#services to be configured
$autoservices = @("wuauserv","spooler","w32Time","MpsSvc","RemoteRegistry")
$disabledServices = @("PeerDistSvc","browser","fax","efs")

#folders to be created
$folders="C:\Work","C:\Company\Logs","C:\Company\Reports","C:\Scripts"

Parallel {
#these commands can happen in parallel since there are no
#dependencies

    Sequence {
        #Create new folder structure
        Write-Verbose -message "Creating default folders"
        foreach ($folder in $Workflow:folders) {
          Write-verbose -Message "Testing $folder"      
          if (-Not (Test-Path -Path $folder)) {
            Write-Verbose -Message "Creating $folder"
            New-Item -Path $folder -ItemType Directory
          }
          else {
            Write-Verbose -Message "$folder already exists"
          }
        } #foreach
    } #sequence

    #Configure auto start service settings
    foreach -parallel ($service in $workflow:autoservices) {  
        Write-Verbose -Message "Configuring autostart on $service"
        Set-Service -Name $service -StartupType Automatic
    } #foreach

    #Configure disabled service settings
    foreach -parallel ($service in $workflow:disabledServices) {
          Write-Verbose -Message "Configuring Disable on $service"
          Set-Service -Name $service -StartupType Disabled
    } #foreach 

} #parallel

#reboot and wait. This only works on remote computers.
Write-Verbose -message "Rebooting $pscomputername"
Restart-Computer -Force -Wait 

Write-Verbose -Message "Auditing service configuration"

InlineScript {  
    <#
      get services that were configured and export current configuration
      to an xml file. Running this in an inline script to avoid remoting
      artifacts in the exported output.
    #>
    $using:autoservices+$using:disabledServices | ForEach-Object -process {
      Get-WmiObject -class win32_service -filter "name='$_'"
     } | Select-Object -Property Name,StartMode,State,StartName | 
     Export-Clixml -Path C:\Company\Logs\ServiceAudit.xml
}

Write-Verbose -Message "Ending $($workflowcommandname)"

} #close Workflow
