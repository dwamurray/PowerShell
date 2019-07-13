<#
 
        Author : Gordon McDonald
        -------------------------
       
        .Synopsis
            Gets DCOM, Services and membership information of local groups in remote computer
        .Description
            NOTE: This script by default queries the membership details of local administrators group on remote computers.
                                                It has a provision to query any local group in remote server, not just administrators group.
        .Parameter ComputerName
            Computer Name(s) which you want to query for the above information
                                .Parameter LocalGroupName
                                                Name of the local group which you want to query for membership information. It queries 'Administrators' group when
                                                this parameter is not specified
       
        Usage
        --------------------------
       
        .Example
            Get-LG.ps1 -ComputerName srvmem1, srvmem2
       
        .Example - Multiple servers from a Text File list
                                                Get-LG.ps1 -ComputerName (get-content c:\temp\servers.txt)
      
                                               
#>
 
[CmdletBinding()]
Param(
                [Parameter(       ValueFromPipeline=$true,
                                                                ValueFromPipelineByPropertyName=$true
                                                                )]
                [string[]]
                $ComputerName = $env:ComputerName,
                [Parameter()]
                [string]
                $LocalGroupName = "Administrators"
 
)
Begin {
 
    # Script Will Create a "Server Discovery" Folder in the C Drive and Will Timestamp it to differentiate from other folders of the same name.   
    
    $TimeStamp = (Get-Date -f dd-MM-y" "hh-mm-ss)
    $OutputDirRoot = md -Path "C:\Server Discovery - $TimeStamp" -force
}
Process {
                ForEach($Computer in $ComputerName) {
        $OutputFileAdmin = Join-Path $OutputDirRoot "$Computer - LocalAdmins.csv"          #Local Admins Save File
        $OutputFileDCOM = Join-Path $OutputDirRoot "$Computer - DCOM.txt"                  #DCOM Save File
        $OutputFileSV = Join-Path $OutputDirRoot "$Computer - Services.txt"                #Services Save File
        $OutputFileScht = Join-Path $OutputDirRoot "$Computer - Scheduled Tasks.txt"       #Scheduled Tasks Save File
 
        Add-Content -Path $OutPutFileAdmin -Value "ComputerName, LocalGroupName, Status, MemberType, MemberDomain, MemberName"
        Write-host "Working on $Computer"
        If(!(Test-Connection -ComputerName $Computer -Count 1 -Quiet)) {
                                                Write-Host "$Computer is offline. Proceeding with next computer"
                                                Add-Content -Path $OutputFileAdmin -Value "$Computer,$LocalGroupName,Offline"
            Add-Content -Path $OutputfileDCOM -Value "$Computer,Offline"
            Add-Content -Path $OutputfileSV -Value "$Computer,Offline"
            Add-Content -Path $OutputfileScht -Value "$Computer,Offline"
           
                                                Continue
                                } else {
                                                Write-Verbose "Working on $computer"
           
            #Get DCOM Data
            get-wmiobject -class "Win32_DCOMApplicationSetting" –computername $Computer | fl appid, caption, description, localservice,
            remoteservername, runasuser >> $OutputFileDCOM
           
            #Get Services Data
            get-wmiobject -class "win32_service" –computername $Computer| fl displayname, name, state, startmode, startname >> $OutputFileSV
                                               
            #Get Scheduled Tasks Data (2000 - 2012)
         
            Schtasks /s $Computer /query  /v >> $OutputFileScht
         
            #Get Local Admin Data
            try {
                                                                $group = [ADSI]"WinNT://$Computer/$LocalGroupName"
                                                                $members = @($group.Invoke("Members"))
                                                                Write-Verbose "Successfully queries the members of $computer"
                                                                if(!$members) {
                                                                                Add-Content -Path $OutputFileAdmin -Value "$Computer,$LocalGroupName,NoMembersFound"
                                                                                Write-Verbose "No members found in the group"
                                                                                continue
                                                                }
                                                }
                                                catch {
                                                                Write-Verbose "Failed to query the members of $computer"
                                                                Add-Content -Path $OutputFileAdmin -Value "$Computer,,FailedToQuery"
                                                                Continue
                                                }
                                                foreach($member in $members) {
                                                                try {
                                                                                $MemberName = $member.GetType().Invokemember("Name","GetProperty",$null,$member,$null)
                                                                                $MemberType = $member.GetType().Invokemember("Class","GetProperty",$null,$member,$null)
                                                                                $MemberPath = $member.GetType().Invokemember("ADSPath","GetProperty",$null,$member,$null)
                                                                                $MemberDomain = $null
                                                                                if($MemberPath -match "^Winnt\:\/\/(?<domainName>\S+)\/(?<CompName>\S+)\/") {
                                                                                                if($MemberType -eq "User") {
                                                                                                                $MemberType = "LocalUser"
                                                                                                } elseif($MemberType -eq "Group"){
                                                                                                                $MemberType = "LocalGroup"
                                                                                                }
                                                                                                $MemberDomain = $matches["CompName"]
                                                                                } elseif($MemberPath -match "^WinNT\:\/\/(?<domainname>\S+)/") {
                                                                                                if($MemberType -eq "User") {
                                                                                                                $MemberType = "DomainUser"
                                                                                                } elseif($MemberType -eq "Group"){
                                                                                                                $MemberType = "DomainGroup"
                                                                                                }
                                                                                                $MemberDomain = $matches["domainname"]
                                                                                } else {
                                                                                                $MemberType = "Unknown"
                                                                                                $MemberDomain = "Unknown"
                                                                                }
                                                                Add-Content -Path $OutPutFileAdmin -Value "$Computer, $LocalGroupName, SUCCESS, $MemberType, $MemberDomain, $MemberName"
                                                                } catch {
                                                                                Write-Verbose "failed to query details of a member. Details $_"
                                                                                Add-Content -Path $OutputFileAdmin -Value "$Computer,,FailedQueryMember"
                                                                }
                                                }
                                }
                }
}
End {}