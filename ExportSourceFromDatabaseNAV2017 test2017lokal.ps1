$MyObjectFilter = 'ID=..49999|100000..'
$MyObjectFilter = $MyObjectFilter +'|60500..60510'  #rekab old
$MyObjectFilter = $MyObjectFilter +'|81600..81800'  #assemblin
$MyObjectFilter = $MyObjectFilter +'|82400..82499'  #radiator
$MyObjectFilter = $MyObjectFilter +'|83000..83099'  #trs
$MyObjectFilter = $MyObjectFilter +'|83200..83299'  #rekab
$MyObjectFilter = $MyObjectFilter +'|86200..86269|87100..87199'  #strukton
$MyObjectFilter = $MyObjectFilter +'|89100..89199'  #dynniq
$fromDate = Get-Date ((Get-Date).AddDays(-14))  -Format FileDate
$MyObjectFilter = $MyObjectFilter + ';Date=''''|'+$fromdate+'..'

#$MyObjectFilter = 'Locked=1' 
#$MyObjectFilter = 'modified=1' 

#$MyObjectFilter = 'version list=*SE*|*NO*'
#$MyObjectFilter = 'version list=*NAV*'
#$MyObjectFilter = 'version list=*PE*'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$SkipLang = $true
$cu17 = $false

$DatabaseInstance = 'SQL2016'
$DatabaseServer = 'danlin01t550'
$DatabaseName   = 'NO_DB_4PS_Prod_01'
#$DatabaseName   = 'NO_DB_4PS_Test_2017_01'
#$DatabaseName   = 'Rekab_4PS_NAV_Prod'
$DatabaseName   = 'Radiator_4PS_NAV_prod'
#$DatabaseName   = 'Radiator_4PS_NAV_test'

#$DatabaseName   = '4PSSE-1000-04'

#$DatabaseName   = 'Demo Database NAV SE (10-0-15)'
#$DatabaseName   = '4PSNL_1000-013-08'
#$DatabaseName   = '4PSW1_1000_011_07'

if ($cu17) {
$DatabaseName   = '4PSW1_1000_015_01_A'
}

#$DatabaseInstance = 'SQL2012'
#$DatabaseName   = 'nav2017prodnordics'

$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseServer$DatabaseInstance-$DatabaseName)

if (!($DatabaseInstance -eq '')) { $DatabaseServer = (Join-Path $DatabaseServer $DatabaseInstance) }
if ($DatabaseName.StartsWith("4PSNL")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("4PSW1")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("Demo")) { $MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }


$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100 - CU15\RoleTailored Client'
#$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100 - CU17\RoleTailored Client'
$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
$NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
Import-Module $NavIdeFile -DisableNameChecking

$NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
Import-Module $NavToolFile -DisableNameChecking

if ($cu17) {
    $MyObjectFilter = 'ID=..49999|100000..'
    
    $NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100 - CU17\RoleTailored Client'
    $NavIde = (Join-Path $NavClientFolder '\finsql.exe')

    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
    $NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
    Import-Module $NavIdeFile -DisableNameChecking

    $NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
    Import-Module $NavToolFile -DisableNameChecking
}

$NavIde = (Join-Path $NavClientFolder '\finsql.exe')
$MyWorkFile = 'AllObjects'

$BaseAppFolder = (Join-Path $MyWorkFolder 'BaseApp')
$LanguageFolder = (Join-Path $MyWorkFolder 'Language')
$DevAppFolder = (Join-Path $MyWorkFolder 'DevApp')
$HelpFolder = (Join-Path $MyWorkFolder 'Help')

$DevAppsFolder = (Join-Path $MyWorkFolder 'DevApps')

#Export all objects from DB
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
write-output "filters:    $MyObjectFilter"
if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
#Create-FolderIfNotExist $MyWorkFolder
####
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

write-output "Remove app properties before 1st split    $MyAllObjectsFile"
Set-NAVApplicationObjectProperty -Target $MyAllObjectsFile -ModifiedProperty No -DateTimeProperty ''

#BaseApp
echo 'Split BaseApp NAVApplicationObjectFile'
##Split all NAV objects into individual files incl LocalLang
if (!(test-path $BaseAppFolder)) {  New-Item -path $BaseAppFolder -ItemType directory}
##Create-FolderIfNotExists $BaseAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $BaseAppFolder -PassThru -Force -PreserveFormatting

if ($SkipLang) { exit }

#DevApp
write-output "Split NAVApplicationObjectFile before removal of lang    $DevAppFolder"
#Split all NAV objects into individual files
if (!(test-path $DevAppFolder)) {  New-Item -path $DevAppFolder -ItemType directory}
#Create-FolderIfNotExists $DevAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $DevAppFolder -PassThru -Force -PreserveFormatting
write-output "Remove NAVApplicationObjectLanguage     $DevAppFolder"
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
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination (join-path $MyWorkFolder ('\langALL.txt')) -Force 
ForEach ($ctry in 'SVE','ENU','NOR','NLD','ENG')  {
    echo ('Export NAVApplicationObjectLanguage ' + $ctry)
    Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination (join-path $MyWorkFolder ('\langTMP.txt')) -Force -LanguageId $ctry
    echo ('Cleaning ' + $ctry)
    (Get-Content (join-path $MyWorkFolder ('\langTMP.txt'))) -notmatch "L999:$" | Out-File (join-path $MyWorkFolder ('\lang' + $ctry + '.txt')) -Force -Encoding default
}
Remove-Item (join-path $MyWorkFolder ('\langTMP.txt'))
