$MyObjectFilter = 'ID=..49999|81600..81799|100000..'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$DatabaseServer = 'sql04'
$DatabaseName = '4psse_71_100_dev'
$MyWorkFolder = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)
$CommitDate = Get-Date -format o

if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}

#Import-Module posh-git
c:
cd $MyWorkFolder


$p4user = 'danlin'
#$p4workspace = $DatabaseServer + '-' + $DatabaseName

p4 set P4CLIENT=$DatabaseServer-$DatabaseName
#p4 set P4PORT='itero-app01.iteroab.local:1666'
p4 set P4USER='danlin'
#p4 -c $DatabaseServer'-'$DatabaseName -p $env:P4PORT -u $p4user -q sync -f
p4 -q sync -f
p4 edit $MyWorkFolder'\...'


#git remote add origin https://github.com/itero4ps/4psse_71_100_dev
#git fetch origin  #get all from remote repo
#git reset --hard origin/master  #reset local status to same as remote repo
#git clean -f -d  #delete all files/folders not in remote repo

#invoke-expression, get new objects from Database
& 'C:\Source\NAVWorkFolder\powershell\ExportSourceFromDatabaseNAV2013.ps1'

#cd $MyWorkFolder
#git add .\DevApp\*.TXT
#git add .\DevApps\*.txt
#git add .\Language\*.TXT
#git add .\Fobs\*.zip
#git commit -m "auto commit $DatabaseName $CommitDate"

#git push origin master

p4 revert -a //...
#p4 submit -d "auto submit" 
