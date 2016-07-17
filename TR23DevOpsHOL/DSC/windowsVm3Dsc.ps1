Configuration Main
{

Param ( [string] $nodeName )

Import-DscResource -ModuleName PSDesiredStateConfiguration

Node $nodeName
  {
	File OmsDirectory
	{
		Ensure = "Present"
		Type = "Directory"
		DestinationPath = "C:\OMS"
	}

	Script DownloadOmsAgent
	{
		TestScript = {
			Test-Path "C:\OMS\MMASetup-AMD64.exe"
		}
		SetScript ={
			$source = "http://download.microsoft.com/download/3/1/7/317DCEEB-5E48-47B0-A849-D8A2B1D7795C/MMASetup-AMD64.exe"
			$dest = "C:\OMS\MMASetup-AMD64.exe"
			Invoke-WebRequest $source -OutFile $dest
		}
		GetScript = {@{Result = "DownloadOmsAgent"}}
		DependsOn = "[File]OmsDirectory"
	}

	#Package InstallOmsAgent
	#{
	#    Ensure = "Present"  
	#    Path  = "C:\OMS\MMASetup-AMD64.exe"
	#    Name = "NAME"
	#    ProductId = "{GUID}"
	#    Arguments = "ARGS"
	#    DependsOn = "[Script]DownloadOmsAgent"
	#}
  }
}