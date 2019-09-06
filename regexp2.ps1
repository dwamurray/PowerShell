$Computername="LON-DC01"

Switch -regex ($Computername) {

"^SYR"  {
    #run Syracuse location code
    }
"^LAS" {
    #run Las Vegas location code
    }
"^LON" {
    #run London location code
    }
"DC" {
    #run Domain controller specific code
    } 
"FP" {
    #run file/print specific code
    }
"WEB" {
    #run IIS specific code
    }
Default {Write-Warning "No code found $computername"}
}
