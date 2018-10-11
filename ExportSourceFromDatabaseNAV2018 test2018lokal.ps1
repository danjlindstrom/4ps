$MyObjectFilter = 'ID=..49999|100000..'
$MyObjectFilter = $MyObjectFilter +'|60500..60510'  #rekab old
$MyObjectFilter = $MyObjectFilter +'|81600..81800'  #assemblin
$MyObjectFilter = $MyObjectFilter +'|82400..82499'  #radiator
$MyObjectFilter = $MyObjectFilter +'|83000..83099'  #trs
$MyObjectFilter = $MyObjectFilter +'|83200..83299'  #rekab
$MyObjectFilter = $MyObjectFilter +'|86200..86269|87100..87199'  #strukton
$MyObjectFilter = $MyObjectFilter +'|89100..89199'  #dynniq
#$MyObjectFilter = $MyObjectFilter + ';Date=''''|0701..'
$fromDate = Get-Date ((Get-Date).AddDays(-10))  -Format FileDate
$MyObjectFilter = $MyObjectFilter + ';Date=''''|'+$fromdate+'..'
$MyObjectFilter = 'Date=''''|'+$fromdate+'..'

#$MyObjectFilter = 'Locked=1'
#$MyObjectFilter = $MyObjectFilter +';Type=codeunit' 
#$MyObjectFilter = $MyObjectFilter +';Type=pag' 
#$MyObjectFilter = $MyObjectFilter +';Type=xml' 
#$MyObjectFilter = $MyObjectFilter +';Type=table' 
#$MyObjectFilter = $MyObjectFilter +';Type=cod' 
#$MyObjectFilter = 'modified=1' 
#$MyObjectFilter = 'ID=50000..81000'

#$MyObjectFilter = 'Type=table' #'ID=..49999|100000..'
#$MyObjectFilter = 'Type=cod' #'ID=..49999|100000..'
#$MyObjectFilter = 'version list=*SE*|*NO*'
#$MyObjectFilter = 'version list=*NAV*'
#$MyObjectFilter = 'version list=*PE*'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 
$SkipLang = $false
$SkipLang = $true

$DatabaseInstance = 'SQL2016'
$DatabaseServer = 'danlin01t550'
#$DatabaseName   = '4PSW1_1000_015_00_Alpha'
$DatabaseName   = '4PSSE_1100_015_dev'
#$DatabaseName   = 'Demo Database NAV SE (11-0-08)'
#$DatabaseName   = 'Demo Database NAV NO (11-0-08)'
#$DatabaseName   = 'Demo Database NAV W1 (11-0-08)'


$MyWorkFolder   = (Join-Path $MyWorkBaseFolder $DatabaseServer$DatabaseInstance-$DatabaseName)

if (!($DatabaseInstance -eq '')) { $DatabaseServer = (Join-Path $DatabaseServer $DatabaseInstance) }
if ($DatabaseName.StartsWith("4PSNL")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("4PSW1")) { $DatabaseName = $DatabaseName.ToUpper();$MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }
if ($DatabaseName.StartsWith("Demo")) { $MyWorkFolder = (Join-Path $MyWorkBaseFolder _$DatabaseName) }


$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\110\RoleTailored Client'



$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
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
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
write-output "filters:    $MyObjectFilter"
if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
#Create-FolderIfNotExist $MyWorkFolder
####
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

write-output "Remove app properties before 1st split    $MyAllObjectsFile"
Set-NAVApplicationObjectProperty -TargetPath $MyAllObjectsFile -ModifiedProperty No -DateTimeProperty ''

#Remove-NAVApplicationObjectLanguage -Source $MyAllObjectsFile -Destination $MyAllObjectsFile -LanguageId 'SVE' -Force
#Remove-NAVApplicationObjectLanguage -Source $MyAllObjectsFile -Destination $MyAllObjectsFile -LanguageId 'NOR' -Force
#Remove-NAVApplicationObjectLanguage -Source $MyAllObjectsFile -Destination $MyAllObjectsFile -LanguageId 'FIN' -Force

if ($false) {
    ForEach ($ctry in 'SVE','NOR','FIN')  {
        echo ('Remove NAVApplicationObjectLanguage ' + $ctry)
        Remove-NAVApplicationObjectLanguage -Source $MyAllObjectsFile -Destination $MyAllObjectsFile -LanguageId $ctry -Force
    }
}

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

if ($SkipLang) {
    Remove-NAVApplicationObjectLanguage -Source $MyAllObjectsFile -Destination $MyAllObjectsFile -LanguageId $ctry -Force
}

Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $DevAppFolder -PassThru -Force -PreserveFormatting

if ($SkipLang) { exit }

write-output "Remove NAVApplicationObjectLanguage     $DevAppFolder"
Remove-NAVApplicationObjectLanguage -Source $DevAppFolder -Destination $DevAppFolder -Force
#Remove app properties
#echo 'Remove app properties'
#Set-NAVApplicationObjectProperty -TargetPath $DevAppFolder -ModifiedProperty No -DateTimeProperty '' # -VersionListProperty '' 




#exit


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
