$MyObjectFilter = '-Filter "ID=..49999|81600..81799|100000.."'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$DatabaseServer = 'sql04'
#$DatabaseServer = 'danlin01t550'
$DatabaseName = '4psse_71_100_dev'

$MyWorkFolder = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)

#invoke-expression 
& 'C:\Source\NAVWorkFolder\powershell\ExportSourceFromDatabaseNAV2013.ps1'
