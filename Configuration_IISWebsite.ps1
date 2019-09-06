Configuration IISWebsite 
{ 
    Node @("Server1","Server2") 
    { 
        WindowsFeature IIS 
        { 
            Ensure    = "Present" 
            Name      = "Web-Server" 
        } 

        WindowsFeature ASP 
        { 
            Ensure    = "Present" 
            Name      = "Web-Asp-Net45" 
        } 
    } 
}
