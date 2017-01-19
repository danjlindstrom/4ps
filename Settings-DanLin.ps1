$MyWorkFolder = (Join-Path ${env:HOMEPATH} 'NAVWorkFolder')
$MyWorkFile = 'AllObject.txt'

$BaseFolder = Split-Path -Path $PSScriptRoot -Parent

$BaseAppFolder = (Join-Path $BaseFolder 'BaseApp')
$LanguageFolder = (Join-Path $BaseFolder 'Language')
$DevAppFolder = (Join-Path $BaseFolder 'DevApp')
$HelpFolder = (Join-Path $BaseFolder 'Help')

$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client'
$PowerShellPath = 'C:\Users\danlin\Desktop\scm\'

$DatabaseServer = 'SQL04'
$DatabaseName = '4psse_900_001_dev'

# (Join-Path $PowerShellPath 'Load-NAVApplication.ps1')

$NavIde = (Join-Path $NavClientFolder 'finsql.exe')
