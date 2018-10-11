$DatabaseName   = '4psse_1000_011_dev'
#$DatabaseName   = '4psse_71_100_dev'
#$DatabaseName   = '4psse_71_110_dev'
#$DatabaseName   = '4psw1_1000_011_00'
#$DatabaseName   = '4psse_900_001_release'
#$DatabaseName   = 'Demo Database NAV W1 (10-0-4)'
#$DatabaseName   = 'Demo Database NAV DK (10-0-4)'
#$DatabaseName   = 'Demo Database NAV SE (10-0-4) PE'

$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 


$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)
$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseName)

$DatabaseServer = 'sql04'



$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client'
$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
$NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
Import-Module $NavIdeFile -DisableNameChecking

$NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
Import-Module $NavToolFile -DisableNameChecking

$NavIde = (Join-Path $NavClientFolder '\finsql.exe')
$MyWorkFile = 'AllObjects'


if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

echo 'Export-NAVApplicationObjectLanguage'
$LanguageFolder = (Join-Path $MyWorkFolder $MyWorkFile) + 'Lang.txt'
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force


