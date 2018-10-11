$MyObjectFilter = 'ID=..49999|100000..'
#$MyObjectFilter = $MyObjectFilter +'|60500..60510'  #rekab old
$MyObjectFilter = $MyObjectFilter +'|81600..81800'  #assemblin
#$MyObjectFilter = $MyObjectFilter +'|82400..82499'  #radiator
#$MyObjectFilter = $MyObjectFilter +'|83000..83099'  #trs
$MyObjectFilter = $MyObjectFilter +'|83200..83299'  #rekab
#$MyObjectFilter = $MyObjectFilter +'|89100..89199'  #dynniq
$MyObjectFilter = $MyObjectFilter +'|87100..87199|86200..86269'  #strukton
#$MyObjectFilter = $MyObjectFilter + ';Date=''''|0501..'
$fromDate = Get-Date ((Get-Date).AddDays(-7))  -Format FileDate
#$MyObjectFilter = $MyObjectFilter + ';Date=''''|'+$fromdate+'..'

#$MyObjectFilter = 'Locked=1' 

#$MyObjectFilter = 'Type=table' #'ID=..49999|100000..'
#$MyObjectFilter = 'Type=cod' #'ID=..49999|100000..'
#$MyObjectFilter = 'version list=*SE*|*NO*'
#$MyObjectFilter = 'version list=*NAV*'
#$MyObjectFilter = 'version list=*PE*'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$DatabaseInstance = 'SQL2016'
$DatabaseServer = 'danlin01t550'
$DatabaseName   = 'Strukton_4PS_NAV_prod'

#$DatabaseInstance = 'SQL2012'
#$DatabaseName   = 'nav2017prodnordics'

if ($false) {
$DatabaseInstance = ''
$DatabaseServer = 'sql04'
#$DatabaseName   = '4PSW1_710_110_14'
$DatabaseName   = '4psse_71_110_dev'
}


$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseServer$DatabaseInstance-$DatabaseName)

if (!($DatabaseInstance -eq '')) { $DatabaseServer = (Join-Path $DatabaseServer $DatabaseInstance) }
if ($DatabaseName.StartsWith("4psnl")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("4psw1")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("Demo")) { $MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }







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
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllTables.fob') -Filter ($MyObjectFilter+';Type=table') -Force
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllPages.fob') -Filter ($MyObjectFilter+';Type=page') -Force
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'Allcodeunit.fob') -Filter ($MyObjectFilter+';Type=codeunit') -Force
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllQuery.fob') -Filter ($MyObjectFilter+';Type=Query') -Force
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllXMLport.fob') -Filter ($MyObjectFilter+';Type=XMLport') -Force
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllMenusuite.fob') -Filter ($MyObjectFilter+';Type=menusuite') -Force
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllReports.fob') -Filter ($MyObjectFilter+';Type=report') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllTables.zip') -Path (Join-Path $FobFolder 'AllTables.fob') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllPages.zip') -Path (Join-Path $FobFolder 'AllPages.fob') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'Allcodeunit.zip') -Path (Join-Path $FobFolder 'Allcodeunit.fob') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllQuery.zip') -Path (Join-Path $FobFolder 'AllQuery.fob') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllXMLport.zip') -Path (Join-Path $FobFolder 'AllXMLport.fob') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllMenusuite.zip') -Path (Join-Path $FobFolder 'AllMenusuite.fob') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllReports.zip') -Path (Join-Path $FobFolder 'AllReports.fob') -Force

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

#Languages
#if (!(test-path $LanguageFolder)) {  New-Item -path $LanguageFolder -ItemType directory}
#Create-FolderIfNotExists $LanguageFolder
#Export-NAVApplicationLanguageByFile2Folder -MyAllObjectsFile $MyAllObjectsFile -CurrentLanguage ENU -LanguageFolder $LanguageFolder
#Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force

#Help
#if (!(test-path $HelpFolder)) {  New-Item -path $HelpFolder -ItemType directory}
#Create-FolderIfNotExists $HelpFolder

