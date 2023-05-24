Configuration WindowsWebServer {

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xWebAdministration, xIisLogging, xWebConfigProperty

    Node localhost {

        WindowsFeature WebServerRole
        {
		    Name = "Web-Server"
		    Ensure = "Present"
        }

        WindowsFeature WebManagementConsole
        {
            Name = "Web-Mgmt-Console"
            Ensure = "Present"
        }

        WindowsFeature WebManagementService
        {
            Name = "Web-Mgmt-Service"
            Ensure = "Present"
        }

        WindowsFeature ASPNet48
        {
		    Ensure = "Present"
		    Name = "Web-Asp-Net48"
        }

        WindowsFeature HTTPRedirection
        {
            Name = "Web-Http-Redirect"
            Ensure = "Present"
        }

        WindowsFeature CustomLogging
        {
            Name = "Web-Custom-Logging"
            Ensure = "Present"
        }

        WindowsFeature LogginTools
        {
            Name = "Web-Log-Libraries"
            Ensure = "Present"
        }

        WindowsFeature RequestMonitor
        {
            Name = "Web-Request-Monitor"
            Ensure = "Present"
        }

        WindowsFeature Tracing
        {
            Name = "Web-Http-Tracing"
            Ensure = "Present"
        }

        WindowsFeature BasicAuthentication
        {
            Name = "Web-Basic-Auth"
            Ensure = "Present"
        }

        WindowsFeature WindowsAuthentication
        {
            Name = "Web-Windows-Auth"
            Ensure = "Present"
        }

        WindowsFeature ApplicationInitialization
        {
            Name = "Web-AppInit"
            Ensure = "Present"
        }

        WindowsFeature IISManagement  
        {  
            Ensure          = 'Present'
            Name            = 'Web-Mgmt-Console'
            DependsOn       = '[WindowsFeature]WebServerRole'
        } 

		xIisLogging Logging
        {
            Logflags             = @('Date','Time','ClientIP','UserName','SiteName','ComputerName','ServerIP','ServerPort','Method','UriStem','UriQuery','HttpStatus','HttpSubStatus','Win32Status','BytesSent','BytesRecv','TimeTaken','ProtocolVersion','Host','UserAgent','Referer')
            LoglocalTimeRollover = $true
            LogPeriod            = 'Daily'
            LogFormat            = 'W3C'
			LogCustomFields    = @(
                MSFT_xLogCustomField
                {
                    LogFieldName = 'Content-Type'
                    SourceName   = 'Content-Type'
                    SourceType   = 'RequestHeader'
                }
                MSFT_xLogCustomField
                {
                    LogFieldName = 'X-Forwarded-For'
                    SourceName   = 'X-Forwarded-For'
                    SourceType   = 'RequestHeader'
                }
        }
		
		xWebConfigProperty
        {
            # WebsitePath  = 'IIS:\Sites\Default Web Site'
            Filter       = 'system.webServer/security/requestFiltering'
            PropertyName = 'removeServerHeader'
            Value        = 'true'
            Ensure       = 'Present'
        }

      }
}