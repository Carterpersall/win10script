#Cryptographic Settings v1.1
#By Todd Maxey
#https://github.com/ToddMaxey/Settings-for-TLS-and-.Net-to-enforce-strong-crypto

Write-Host " "
Write-Host "This will set .NETFramework v2.0.50727, .NETFramework v4.0.30319 to utilize strong cryptographic and force these version it use the machines cryptographic settings." -ForegroundColor Green
Write-Host " "
Write-Host "The WinHTTP setting will be set to use TLS 1.2" -ForegroundColor Green
Write-Host " "
Write-Host "It will also disabled SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1, RC4 Ciphers and enabled TLS 1.2 and if this is a Windows 10 build 18362+ it will enabled TLS 1.3" -ForegroundColor Green
Write-Host " "
Write-Host "This script maakes registry changes! Be sure to have a backup of the machine before proceesing" -ForegroundColor Red
Write-Host " "
Write-Host "Pausing.... Hit Enter to continue or ctrl+c to escape" -ForegroundColor yellow
Read-host " "

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

#Initialization
$version = $Null
$SessionTime = (get-date -f dddd-MMMM-dd-yyyy-HH.mm.ss)
$FilePath = $path+$env:computername+" "+$SessionTime+".reg"
$path = "C:\temp\registry backups\"

#Determine of path exist and if not create path
If(!(test-path $path))
{
New-Item -ItemType Directory -Force -Path $path
}


# .Net settings to force Strong crypto and use system TLS settings

New-ItemProperty –Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727\" -Name SystemDefaultTlsVersions -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727\" -Name SchUseStrongCrypto -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727\" -Name SystemDefaultTlsVersions -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727\" -Name SchUseStrongCrypto -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319\" -Name SystemDefaultTlsVersions -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319\" -Name SchUseStrongCrypto -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\" -Name SystemDefaultTlsVersions -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\" -Name SchUseStrongCrypto -PropertyType "DWORD" -value "00000001" -Force



# Disable SSL 2.0, SSL 30, TLS 1.0 and TLS 1.1
# Enabled TLS 1.3 and if this is a Windows 10 build 10.0.18362+ enabled TLS 1.3

New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" -Name "SSL 2.0" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0" -Name "Client" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0" -Name "Server" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client" -Name "Enabled" -PropertyType "DWORD" -Value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server" -Name "Enabled" -PropertyType "DWORD" -Value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" -Name "SSL 3.0" -Force 
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0" -Name "Client" -Force 
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0" -Name "Server" -Force 
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" -Name "TLS 1.0" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0" -Name "Client" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0" -Name "Server" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" -Name "TLS 1.1" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000001" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" -Name "TLS 1.2" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name "Enabled" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name "Enabled" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000000" -Force

# Disable Rc4

New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers" -Name "RC4 40/128" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128" -Name "Enabled" -PropertyType "DWORD" -value "00000000" -Force

#Get OS information
$version = [System.Environment]::OSVersion.Version

If (($version.Major -ige 10) -and ($version.Build -ige 18362)){
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" -Name "TLS 1.3" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3" -Name "Client" -Force
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3" -Name "Server" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Name "Enabled" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server" -Name "Enabled" -PropertyType "DWORD" -value "00000001" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000000" -Force
New-ItemProperty –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server" -Name "DisabledByDefault" -PropertyType "DWORD" -value "00000000" -Force
}
{else Write-host "OS is not the right version for TLS 1.3"} 

#WinHttp setting to TLS 1.2
New-ItemProperty –Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" -Name "DefaultSecureProtocols" -PropertyType "DWORD" -value 0x800  -Force

#Done
Write-Host " "
Write-Host "All Done - REBOOT, Pretty Please, with sugar on top..." -ForegroundColor Green
Write-Host " "