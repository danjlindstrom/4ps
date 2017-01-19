Import-Module posh-git
c:
cd C:\Source\NAVWorkFolder\4psse_900_001_dev
Get-GitStatus
#git remote add origin https://github.com/itero4ps/4psse_900_001_dev
git pull origin

. (C:\Source\NAVWorkFolder\powershell\GetFromDB-4PS001dev.ps1)

git add .\DevApp\*.TXT
git commit -m "auto commit DevApp"
git add .\Language\*.TXT
git commit -m "auto commit Language"
git push
