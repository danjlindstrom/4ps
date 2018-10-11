$MyObjectFilter = 'ID=..49999|100000..'
$MyObjectFilter = $MyObjectFilter +'|60500..60510'  #rekab
$MyObjectFilter = $MyObjectFilter +'|81600..81800'  #assemblin
$MyObjectFilter = $MyObjectFilter +'|82400..82499'  #radiator
$MyObjectFilter = $MyObjectFilter +'|83000..83099'  #trs
$MyObjectFilter = $MyObjectFilter +'|86200..86269|87100..87199'  #strukton
$MyObjectFilter = $MyObjectFilter +'|83200..83299'  #rekab
$fromDate = Get-Date ((Get-Date).AddDays(-10))  -Format FileDate
$MyObjectFilter = $MyObjectFilter + ';Date=''''|'+$fromdate+'..'
$MyObjectFilter = 'Date=''''|'+$fromdate+'..'
$SkipLang = $false
$SkipLang = $true

#$MyObjectFilter = 'modified=1' 
#$MyObjectFilter = 'ID=50000..81000'
#$MyObjectFilter = 'Type=table' 
#$MyObjectFilter = 'Type=cod' 
#$MyObjectFilter = 'Type=page' 
#$MyObjectFilter = 'version list=*SE*|*NO*'
#$MyObjectFilter = 'version list=*NAV*'
#$MyObjectFilter = 'version list=*PE*'
#$MyObjectFilter = 'Version List=*013*|*014*'
#$MyObjectFilter = "Version List='*s47*'"
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$DatabaseInstance = ''
$DatabaseServer = 'sql07'
$DatabaseName   = '4psse_1000_011_dev'
#$DatabaseName   = '4psse_1000_011_release'
#$DatabaseName   = '4psnl_1000_013'

#$DatabaseName   = 'Demo Database NAV NO (10-0-3)'
#$DatabaseName   = 'Demo Database NAV SE (10-0-3)'
#$DatabaseName   = 'Demo Database NAV SE (10-0-4) PE'
#$DatabaseName   = 'Demo Database NAV 4PS Nordic (10-0-3)'
$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseServer$DatabaseInstance-$DatabaseName)

#if (!($DatabaseInstance -eq '')) { $DatabaseServer = (Join-Path $DatabaseServer $DatabaseInstance) }
if ($DatabaseName.StartsWith("4psnl")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("4psw1")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("Demo")) { $MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }


$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
#$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100 - CU11\RoleTailored Client'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100 - CU15\RoleTailored Client'
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
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
write-output "filters:    $MyObjectFilter"
if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
#Create-FolderIfNotExist $MyWorkFolder
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

#C:\Users\danlin\Documents\4806984 itero 4ps nl 2017 20170615.flf
#C:\Navision\imtech\5377250_NAV2017.flf

write-output "Remove app properties before 1st split    $MyAllObjectsFile"
Set-NAVApplicationObjectProperty -TargetPath $MyAllObjectsFile -ModifiedProperty No -DateTimeProperty ''

#BaseApp
echo 'Split BaseApp NAVApplicationObjectFile'
##Split all NAV objects into individual files incl LocalLang
if (!(test-path $BaseAppFolder)) {  New-Item -path $BaseAppFolder -ItemType directory}
##Create-FolderIfNotExists $BaseAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $BaseAppFolder -PassThru -Force -PreserveFormatting


#DevApp
write-output "Split NAVApplicationObjectFile before removal of lang    $DevAppFolder"
#Split all NAV objects into individual files
if (!(test-path $DevAppFolder)) {  New-Item -path $DevAppFolder -ItemType directory}
#Create-FolderIfNotExists $DevAppFolder

if ($SkipLang) { 
    Remove-NAVApplicationObjectLanguage -Source $MyAllObjectsFile -Destination ($MyAllObjectsFile+'ENU.txt') 
    Split-NAVApplicationObjectFile -source ($MyAllObjectsFile+'ENU.txt') -Destination $DevAppFolder -PassThru -Force -PreserveFormatting
    Remove-Item ($MyAllObjectsFile+'ENU.txt')
    exit
}


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

#Help
#if (!(test-path $HelpFolder)) {  New-Item -path $HelpFolder -ItemType directory}
#Create-FolderIfNotExists $HelpFolder
