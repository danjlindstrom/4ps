$MyObjectFilter = 'ID=..49999|78700..78899|89100..89199|100000..'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 


$DatabaseServer = 'sql04'
#$DatabaseServer = 'danlin01t550'
$DatabaseName = '4psse_900_001_dev'
$MyWorkFolder = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)
#invoke-expression 
& 'C:\Source\NAVWorkFolder\powershell\ExportSourceFromDatabaseNAV2016.ps1'



cd $MyWorkFolder
