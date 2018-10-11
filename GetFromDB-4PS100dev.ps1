$MyObjectFilter = 'ID=..49999|81600..81799|100000..'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$DatabaseServer = 'sql04'
$DatabaseServer = 'danlin01t550'
$DatabaseName = '4psse_71_100_dev'
#$DatabaseName = 'Kund_Imtech_Nordic_Prod_01'
$DatabaseName = 'NO_DB_4PS_Prod_01'



$MyWorkFolder = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)
$MyWorkFolder = (Join-Path $MyWorkBaseFolder $DatabaseName)

$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\71\RoleTailored Client'
$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
$NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
Import-Module $NavIdeFile -DisableNameChecking

#$NavToolFile = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1'
$NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
Import-Module $NavToolFile -DisableNameChecking

$NavIde = (Join-Path $NavClientFolder '\finsql.exe')
$MyWorkFile = 'BaseApp'

$BaseAppFolder = (Join-Path $MyWorkFolder 'BaseApp')
$LanguageFolder = (Join-Path $MyWorkFolder 'Language')
#$DevAppFolder = (Join-Path $MyWorkFolder 'DevApp')
$DevAppFolder = $BaseAppFolder 
#$HelpFolder = (Join-Path $MyWorkFolder 'Help')

$DevAppsFolder = (Join-Path $MyWorkFolder 'DevApps')


#Export all objects from DB
if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
#Create-FolderIfNotExist $MyWorkFolder
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force
Export-NAVApplicationObject -DatabaseName $DatabaseName -Path $MyAllObjectsFile -DatabaseServer $DatabaseServer -Filter $MyObjectFilter -Force

$FobFolder = (Join-Path $MyWorkFolder 'Fobs')
if (!(test-path $FobFolder)) {  New-Item -path $FobFolder -ItemType directory}
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllTables.fob') -Filter ($MyObjectFilter+';Type=table') -Force
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllPages.fob') -Filter ($MyObjectFilter+';Type=page') -Force
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'Allcodeunit.fob') -Filter ($MyObjectFilter+';Type=codeunit') -Force
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllQuery.fob') -Filter ($MyObjectFilter+';Type=Query') -Force
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllXMLport.fob') -Filter ($MyObjectFilter+';Type=XMLport') -Force
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllMenusuite.fob') -Filter ($MyObjectFilter+';Type=menusuite') -Force
#Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllReports.fob') -Filter ($MyObjectFilter+';Type=report') -Force
#Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllTables.zip') -Path (Join-Path $FobFolder 'AllTables.fob') -Force
#Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllPages.zip') -Path (Join-Path $FobFolder 'AllPages.fob') -Force
#Compress-Archive -DestinationPath (Join-Path $FobFolder 'Allcodeunit.zip') -Path (Join-Path $FobFolder 'Allcodeunit.fob') -Force
#Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllQuery.zip') -Path (Join-Path $FobFolder 'AllQuery.fob') -Force
#Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllXMLport.zip') -Path (Join-Path $FobFolder 'AllXMLport.fob') -Force
#Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllMenusuite.zip') -Path (Join-Path $FobFolder 'AllMenusuite.fob') -Force
#Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllReports.zip') -Path (Join-Path $FobFolder 'AllReports.fob') -Force

#BaseApp
#Split all NAV objects into individual files
if (!(test-path $BaseAppFolder)) {  New-Item -path $BaseAppFolder -ItemType directory}
#Create-FolderIfNotExists $BaseAppFolder
#Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $BaseAppFolder -PassThru -Force -PreserveFormatting
C:\utils\split.exe $MyAllObjectsFile

#DevApp
#Split all NAV objects into individual files
#if (!(test-path $DevAppFolder)) {  New-Item -path $DevAppFolder -ItemType directory}
#Create-FolderIfNotExists $DevAppFolder
#Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $DevAppFolder -PassThru -Force -PreserveFormatting
#Remove-NAVApplicationObjectLanguage -Source $DevAppFolder -Destination $DevAppFolder -Force
#Remove app properties
#Set-NAVApplicationObjectProperty -Target $DevAppFolder -ModifiedProperty No -DateTimeProperty '' -PassThru # -VersionListProperty '' 

#if (!(test-path $DevAppsFolder)) {  New-Item -path $DevAppsFolder -ItemType directory}
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Codeunit.txt -Source $BaseAppFolder\COD*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\MenuSuite.txt -Source $BaseAppFolder\MEN*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Page.txt -Source $BaseAppFolder\PAG*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Query.txt -Source $BaseAppFolder\QUE*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Tables.txt -Source $BaseAppFolder\TAB*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\XMLPorts.txt -Source $BaseAppFolder\XML*.TXT  -Force

#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports1101.txt -Source $BaseAppFolder\REP1101*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports11XX.txt -Source $BaseAppFolder\REP11[2-9][2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports1X.txt -Source $BaseAppFolder\REP1[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports2X.txt -Source $BaseAppFolder\REP2[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports3X.txt -Source $BaseAppFolder\REP3[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports4X.txt -Source $BaseAppFolder\REP4[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports5X.txt -Source $BaseAppFolder\REP5[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports6X.txt -Source $BaseAppFolder\REP6[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports7X.txt -Source $BaseAppFolder\REP7[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports8X.txt -Source $BaseAppFolder\REP8[2-9]*.TXT  -Force
#Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports9X.txt -Source $BaseAppFolder\REP9[2-9]*.TXT  -Force
#Languages
#if (!(test-path $LanguageFolder)) {  New-Item -path $LanguageFolder -ItemType directory}
#Create-FolderIfNotExists $LanguageFolder
#Export-NAVApplicationLanguageByFile2Folder -MyAllObjectsFile $MyAllObjectsFile -CurrentLanguage ENU -LanguageFolder $LanguageFolder
#Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force

#Help
#if (!(test-path $HelpFolder)) {  New-Item -path $HelpFolder -ItemType directory}
#Create-FolderIfNotExists $HelpFolder

