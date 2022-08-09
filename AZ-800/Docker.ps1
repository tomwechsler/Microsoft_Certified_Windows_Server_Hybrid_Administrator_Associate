#Prep the container host
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

Install-Package -Name docker -ProviderName DockerMsftProvider

Restart-Computer -Force

#Verify install and that service is running
Get-Service Docker
docker info
docker version

#If necessary, "Start-Service Docker"
Start-Service Docker

docker pull mcr.microsoft.com/windows/nanoserver:ltsc2022
docker pull mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

#View Docker images
docker image ls

#Get CLI help
docker run --help

#Start container
docker run -it mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd.exe

docker run -d -p 80:80 mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022 ping -t localhost

#New folder c:\build

#Create Dockerfile

#Text in Dockerfile
#FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022
#RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html

#Build and run
docker build -t iis-dockerfile c:\build

docker run -d -p 80:80 iis-dockerfile ping -t localhost

#Isolation
docker run -d -p 80:80 --isolation=hyperv mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022 ping -t localhost