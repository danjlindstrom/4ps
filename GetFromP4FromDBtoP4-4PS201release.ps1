$MyObjectFilter = 'ID=..49999|82400..82499|82600..82699|82600..82699|100000..'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$DatabaseServer = 'sql04'
$DatabaseName = '4psse_800_201_release'
$MyWorkFolder = 'c:\source\NAVWorkFolder' 
$MyWorkFolder = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)
$CommitDate = Get-Date -format o

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

#invoke-expression, get new objects from Database
& 'C:\Source\NAVWorkFolder\powershell\ExportSourceFromDatabaseNAV2015.ps1'

cd $MyWorkFolder
p4 revert -a //...
#p4 submit -d "auto commit $DatabaseName $CommitDate"
