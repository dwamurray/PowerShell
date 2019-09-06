workflow Set-LOBAppConfiguration {

    parallel {

        InlineScript {
            New-Item -Path HKLM:\SOFTWARE\Company\LOBApp\Settings
            New-ItemProperty -Path HKLM:\SOFTWARE\Company\LOBApp\Settings `
                             -Name Rebuild `
                             -Value 0
        }

        InlineScript {
            Set-Service -Name LOBApp -StartupType Automatic
            Start-Service -Name LOBApp
        }
       
        InlineScript {
            Register-PSSessionConfiguration `
                -Path C:\CorpApps\LOBApp\LOBApp.psc1 `
                -Name LOBApp
        }

        InlineScript {
            Import-Module LOBAppTools
            Set-LOBRebuildMode -Mode 1
        }

    }

} 
