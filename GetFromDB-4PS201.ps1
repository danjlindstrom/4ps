$DatabaseServer = 'SQL04'
$DatabaseName = '4psse_800_201_dev'
$MyWorkFolder = 'c:\source\NAVWorkFolder' 
$MyWorkFolder = (Join-Path $MyWorkFolder $DatabaseName)

$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client'
$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'

#load this folder settings for current user
#(Join-Path $PowerShellPath ('Settings-'+$env:USERNAME+'.ps1'))

#invoke-expression 
& 'C:\Source\NAVWorkFolder\powershell\ExportSourceFromDatabase.ps1'
