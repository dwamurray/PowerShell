function get-serverinfo {

BEGIN {}

PROCESS {

$computername = $_

$os = get-wmiobject win32_operatingsystem `
-computer $computername

$disk = get-wmiobject win32_logicaldisk `
-filter "DeviceID='C'" `
-computer $computername

$obj = new-object -typename psobject

$obj | add-member -membertype noteproperty `
-name computername -value $computername

$obj | add-member -membertype noteproperty `
-name buildnumber -value ($os.buildnumber)

$obj | add-member -membertype noteproperty `
-name SPVersion -value ($os.servicepackmajorversion)

$obj | add-member -membertype noteproperty `
-name sysdrivefre -value ($disk.free / 1MB -as [int])

Write-output $obj
       
        }

END{}
                          }

Get-content names.txt | get-serverinfo | format-table -auto
