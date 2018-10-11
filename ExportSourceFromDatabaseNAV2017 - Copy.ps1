$MyObjectFilter = 'ID=..49999|100000..'
$MyObjectFilter = 'ID=..49999|99573..'
$MyObjectFilter = 'ID=..49999|50000..'
#$MyObjectFilter = 'Type=table' #'ID=..49999|100000..'
#$MyObjectFilter = 'Type=cod' #'ID=..49999|100000..'
#$MyObjectFilter = 'version list=*SE*|*NO*|*FI*|*DK*'
#$MyObjectFilter = 'version list=*NAV*'
#$MyObjectFilter = 'version list=*PE*'
#$MyObjectFilter = 'version list=*'
#$MyObjectFilter = 'Type=rep' #'ID=..49999|100000..'
#$MyObjectFilter = 'version list=*0.1*'
#$MyObjectFilter = 'date=21..'

$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 


$DatabaseServer = 'sql04'
#$DatabaseServer = 'danlin01t550'
#$DatabaseName   = '4psse_1000_011'
$DatabaseName   = '4psse_1000_011_dev'
$DatabaseName   = '4psse_1000_011_demo'
#$DatabaseName   = '4psse_71_100_dev'
#$DatabaseName   = '4psse_71_110_dev'
#$DatabaseName   = '4psw1_1000_011_00'
#$DatabaseName   = '4psse_900_001_release'
#$DatabaseName   = 'Demo Database NAV W1 (10-0-4)'
#$DatabaseName   = 'Demo Database NAV DK (10-0-4)'
#$DatabaseName   = 'Demo Database NAV SE (10-0-4) PE'
#$DatabaseName   = 'Radiator_4PS_NAV_prod01_2017'
$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)
$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseName)

#$DatabaseServer = 'sql04'



$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client'
$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

#C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe  -NoExit -ExecutionPolicy RemoteSigned " & ' C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\NavModelTools.ps1 ' "
#C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe  -NoExit -ExecutionPolicy RemoteSigned " & ' C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1 ' "
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
#Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\NavModelTools.ps1'
#Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1'
$NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
Import-Module $NavIdeFile -DisableNameChecking

$NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
Import-Module $NavToolFile -DisableNameChecking

$NavIde = (Join-Path $NavClientFolder '\finsql.exe')
$MyWorkFile = 'AllObjects'

$BaseAppFolder = (Join-Path $MyWorkFolder 'BaseApp')
$LanguageFolder = (Join-Path $MyWorkFolder 'Language')
$DevAppFolder = (Join-Path $MyWorkFolder 'DevApp')
$HelpFolder = (Join-Path $MyWorkFolder 'Help')

$DevAppsFolder = (Join-Path $MyWorkFolder 'DevApps')

#Export all objects from DB
if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
#Create-FolderIfNotExist $MyWorkFolder
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force



#BaseApp
##Split all NAV objects into individual files incl LocalLang
#if (!(test-path $BaseAppFolder)) {  New-Item -path $BaseAppFolder -ItemType directory}
##Create-FolderIfNotExists $BaseAppFolder
#Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $BaseAppFolder -PassThru -Force -PreserveFormatting

#DevApp
#Split all NAV objects into individual files
if (!(test-path $DevAppFolder)) {  New-Item -path $DevAppFolder -ItemType directory}
#Create-FolderIfNotExists $DevAppFolder
echo 'Split-NAVApplicationObjectFile'
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $DevAppFolder -PassThru -Force -PreserveFormatting
Get-Content $DevAppFolder/men*.txt | Set-Content $MyWorkFolder/MenuSuite.txt

echo 'Remove-NAVApplicationObjectLanguage'
Remove-NAVApplicationObjectLanguage -Source $DevAppFolder -Destination $DevAppFolder -Force
#Remove app properties
echo 'Set-NAVApplicationObjectProperty'
Set-NAVApplicationObjectProperty -TargetPath $DevAppFolder -ModifiedProperty No -DateTimeProperty '' # -VersionListProperty '' 

#. C:\Source\NAVWorkFolder\powershell\renamelocalfiles.ps1

#Languages
if (!(test-path $LanguageFolder)) {  New-Item -path $LanguageFolder -ItemType directory}
##Create-FolderIfNotExists $LanguageFolder
##Export-NAVApplicationLanguageByFile2Folder -MyAllObjectsFile $MyAllObjectsFile -CurrentLanguage ENU -LanguageFolder $LanguageFolder
echo 'Export-NAVApplicationObjectLanguage'
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force
$LanguageFolder = (Join-Path $MyWorkFolder $MyWorkFile) + 'Lang.txt'
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force

#Help
#if (!(test-path $HelpFolder)) {  New-Item -path $HelpFolder -ItemType directory}
#Create-FolderIfNotExists $HelpFolder

