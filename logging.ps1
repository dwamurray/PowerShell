####################################################################################################################################
# Setting up Logging
####################################################################################################################################
 
#Enabling executing script
Set-ExecutionPolicy Unrestricted -force
 
#Load the Powershell snapin for SharePoint
Try
{
     if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) {
           Add-PSSnapin Microsoft.SharePoint.PowerShell;
     }
}
Catch [System.Exception] 
{ 
     write-host "SharePoint Powershell snapin:"+$_.Message -foregroundcolor Red
}
 
#Logging functions
Set-Variable logFile -Scope Script
function LogInfo($message)
{
     $date= Get-Date
     $outContent = "[$date]`tInfo`t`t$message`n"
     Add-Content "Log\$Script:logFile" $outContent
}
 
function LogError($message)
{
     $date= Get-Date
     $outContent = "[$date]`tError`t`t $message`n"
     Add-Content "Log\$Script:logFile" $outContent
}
 
function ConfigureLogger()
{
     
     if((Test-Path Log) -eq $false)
     {
           $LogFolderCreationObj=New-Item -Name Log -type directory
     }
     $date= Get-Date -UFormat "%Y-%m-%d %H-%M-%S" 
     $Script:logFile="SPPortal-Install1 $date.log"
     Add-Content "Log\$logFile" "Date`t`t`tCategory`t`tDetails"
}
 
ConfigureLogger
 

####################################################################################################################################
#Restarting the services
####################################################################################################################################
#Start the Admin service if it is not started
Restart-Service "SPAdminV4"
if ($(Get-Service "SPAdminV4").Status -eq "Running")   
{   
 LogInfo("Re-Started the SharePoint 2010 Administration Service.")
} 
Else{
 Write-Host "SharePoint 2010 Administration service could not be started."
 LogError("SharePoint 2010 Administration service could not be started.")
 Exit
}
 
#Start the Timer service if it is not started
Restart-Service "SPTimerV4"
if ($(Get-Service "SPAdminV4").Status -eq "Running")   
{   
 LogInfo("Re-Started the SharePoint 2010 Timer Service.")
}   
Else{
 Write-Host "SharePoint 2010 Timer service could not be started."
 LogError("SharePoint 2010 Timer service could not be started.")
 Exit
}