$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client'
$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

#C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe  -NoExit -ExecutionPolicy RemoteSigned " & ' C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\NavModelTools.ps1 ' "
#C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe  -NoExit -ExecutionPolicy RemoteSigned " & ' C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1 ' "
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
Import-Module (join-path $NavClientFolder 'NavModelTools.ps1')
#Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'
#$NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
#Import-Module $NavIdeFile -DisableNameChecking

#$NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
#Import-Module $NavToolFile -DisableNameChecking

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
#Split all NAV objects into individual files
if (!(test-path $BaseAppFolder)) {  New-Item -path $BaseAppFolder -ItemType directory}
#Create-FolderIfNotExists $BaseAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $BaseAppFolder -PassThru -Force -PreserveFormatting

#DevApp
#Split all NAV objects into individual files
#if (!(test-path $DevAppFolder)) {  New-Item -path $DevAppFolder -ItemType directory}
#Create-FolderIfNotExists $DevAppFolder
#Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $DevAppFolder -PassThru -Force -PreserveFormatting
#Remove-NAVApplicationObjectLanguage -Source $DevAppFolder -Destination $DevAppFolder -Force
#Remove app properties
#Set-NAVApplicationObjectProperty -TargetPath $DevAppFolder -ModifiedProperty No -DateTimeProperty '' # -VersionListProperty '' 
$MyDevObjectsFile = $DevAppFolder + '.txt'
Move-Item -Path $MyAllObjectsFile -Destination $MyDevObjectsFile -Force
C:\utils\split.exe $MyDevObjectsFile 

#Languages
#if (!(test-path $LanguageFolder)) {  New-Item -path $LanguageFolder -ItemType directory}
#Create-FolderIfNotExists $LanguageFolder
#Export-NAVApplicationLanguageByFile2Folder -MyAllObjectsFile $MyAllObjectsFile -CurrentLanguage ENU -LanguageFolder $LanguageFolder
#Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force

#Help
#if (!(test-path $HelpFolder)) {  New-Item -path $HelpFolder -ItemType directory}
#Create-FolderIfNotExists $HelpFolder

