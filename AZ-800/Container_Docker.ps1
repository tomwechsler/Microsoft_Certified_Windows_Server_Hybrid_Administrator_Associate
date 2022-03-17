#Prep the container host
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

Install-Package -Name docker -ProviderName DockerMsftProvider

Restart-Computer -Force

Start-Service Docker

#Pull an image
docker pull mcr.microsoft.com/windows/nanoserver:ltsc2022

docker images

docker run -it --name nano1 --isolation=hyperv mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd.exe

#Try Windows Admin Center experience as well

#Build an image
docker build -t tim/iis:v1 .

docker run --name iis -d --isolation=hyperv -p 80:80 tim/iis:v1

docker ps -a

docker kill iis

docker rm iis

docker network ls
