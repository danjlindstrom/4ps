$MyObjectFilter = 'ID=..49999|81600..81800|100000..'
#$MyObjectFilter = $MyObjectFilter + ';Date=''''|01..'
#$MyObjectFilter = 'Type=table' #'ID=..49999|100000..'
#$MyObjectFilter = 'Type=cod' #'ID=..49999|100000..'
#$MyObjectFilter = 'version list=*SE*|*NO*'
#$MyObjectFilter = 'version list=*NAV*'
#$MyObjectFilter = 'version list=*PE*'
#$MyObjectFilter = $MyObjectFilter + ';Date=24..'
#$MyObjectFilter = 'Type=rep' #'ID=..49999|100000..'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 


#$DatabaseInstance = ''
#$DatabaseServer = 'sql07'
#$DatabaseName   = '4psse_1000_011_dev'
$DatabaseName   = '4psse_1000_011_release'

#$DatabaseServer = 'danlin01t550'
#$DatabaseName   = 'NO_DB_4PS_Prod_01'
#$DatabaseName   = 'Demo Database NAV NO (10-0-3)'
#$DatabaseName   = 'Demo Database NAV SE (10-0-3)'
#$DatabaseName   = 'Demo Database NAV SE (09-0-7)'
#$DatabaseName   = 'Demo Database NAV SE (10-0-4) PE'
#$DatabaseName   = 'Demo Database NAV 4PS Nordic (10-0-3)'

$DatabaseInstance = 'SQL2016'
#if (!($DatabaseInstance -eq '')) { 
$DatabaseServer = 'danlin01t550'
#$DatabaseName   = 'NO_DB_4PS_Test_2017_01'
#$DatabaseName   = '4PSNL_1000-012-011'
#}



$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseServer$DatabaseInstance-$DatabaseName)

if (!($DatabaseInstance -eq '')) { $DatabaseServer = (Join-Path $DatabaseServer $DatabaseInstance) }



$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100 - CU11\RoleTailored Client'
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


#Import-Module 'C:\Program Files\Microsoft Dynamics NAV\100\Service\Microsoft.Dynamics.Nav.Management.psd1'
#Import-Module 'C:\Program Files\Microsoft Dynamics NAV\100\Service\Microsoft.Dynamics.Nav.Apps.Management.psd1'


$NavIde = (Join-Path $NavClientFolder '\finsql.exe')
$MyWorkFile = 'AllObjects'

$BaseAppFolder = (Join-Path $MyWorkFolder 'BaseApp')
$LanguageFolder = (Join-Path $MyWorkFolder 'Language')
$DevAppFolder = (Join-Path $MyWorkFolder 'DevApp')
$HelpFolder = (Join-Path $MyWorkFolder 'Help')

$DevAppsFolder = (Join-Path $MyWorkFolder 'DevApps')

#Import-NAVServerLicense -ServerInstance 'kund-assemblin-011-lokal' -LicenseData ([Byte[]]$(Get-Content -Path "C:\Users\danlin\Documents\4806984 itero 4ps nl 2017 20170615.flf" -Encoding Byte)) -Database NavDatabase 
#C:\Users\danlin\Documents\4806984 itero 4ps nl 2017 20170615.flf

#Export all objects from DB
echo 'Export NAVApplicationObject'
if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
#Create-FolderIfNotExist $MyWorkFolder
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

#C:\Users\danlin\Documents\4806984 itero 4ps nl 2017 20170615.flf
#C:\Navision\imtech\5377250_NAV2017.flf

echo 'Remove app properties'
Set-NAVApplicationObjectProperty -TargetPath $MyAllObjectsFile -ModifiedProperty No -DateTimeProperty ''

#BaseApp
echo 'Split BaseApp NAVApplicationObjectFile'
##Split all NAV objects into individual files incl LocalLang
if (!(test-path $BaseAppFolder)) {  New-Item -path $BaseAppFolder -ItemType directory}
##Create-FolderIfNotExists $BaseAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $BaseAppFolder -PassThru -Force -PreserveFormatting

#DevApp
echo 'Split DevApp NAVApplicationObjectFile'
#Split all NAV objects into individual files
if (!(test-path $DevAppFolder)) {  New-Item -path $DevAppFolder -ItemType directory}
#Create-FolderIfNotExists $DevAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $DevAppFolder -PassThru -Force -PreserveFormatting
echo 'Remove NAVApplicationObjectLanguage'
Remove-NAVApplicationObjectLanguage -Source $DevAppFolder -Destination $DevAppFolder -Force
#Remove app properties
#echo 'Remove app properties'
#Set-NAVApplicationObjectProperty -TargetPath $DevAppFolder -ModifiedProperty No -DateTimeProperty '' # -VersionListProperty '' 

#Languages
if (!(test-path $LanguageFolder)) {  New-Item -path $LanguageFolder -ItemType directory}
##Create-FolderIfNotExists $LanguageFolder
##Export-NAVApplicationLanguageByFile2Folder -MyAllObjectsFile $MyAllObjectsFile -CurrentLanguage ENU -LanguageFolder $LanguageFolder
echo 'Export NAVApplicationObjectLanguage ALL'
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force
echo 'Export NAVApplicationObjectLanguage SVE'
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination (join-path $MyWorkFolder '\langSVE.txt') -Force -LanguageId "SVE"
echo 'Export NAVApplicationObjectLanguage ENU'
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination (join-path $MyWorkFolder '\langENU.txt') -Force -LanguageId "ENU"
echo 'Export NAVApplicationObjectLanguage NOR'
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination (join-path $MyWorkFolder '\langNOR.txt') -Force -LanguageId "NOR"

#Help
#if (!(test-path $HelpFolder)) {  New-Item -path $HelpFolder -ItemType directory}
#Create-FolderIfNotExists $HelpFolder
