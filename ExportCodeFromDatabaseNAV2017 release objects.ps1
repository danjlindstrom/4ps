$HFlevel = '06'
$HFsublevel = 'RC'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100 - CU15\RoleTailored Client'



$MyWorkBaseFolder = 'K:\4PS\08_2013 Dev Project\Fobs to hotfix\Merge to release\10.00-011-'
$fobfile4psname = '4PSW1 10-00-011-07-SE-'

$DatabaseServer = 'sql07'
$DatabaseName   = '4psse_1000_011_release'

$MyWorkFolder   = $MyWorkBaseFolder + $HFlevel

$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
$NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
Import-Module $NavIdeFile -DisableNameChecking

$NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
Import-Module $NavToolFile -DisableNameChecking

$NavIde = (Join-Path $NavClientFolder '\finsql.exe')

#Export all objects from DB
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + '.fob'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
$MyObjectFilter = 'ID=..49999|100000..2000000053;Locked=0'
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + '.txt'
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

$MyObjectFilter = 'ID=60500..60510;Locked=0'  #rekab

$MyObjectFilter = 'ID=81600..81800;Locked=0'  #assemblin
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + ' Assemblin.fob'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

$MyObjectFilter = 'ID=82400..82499;Locked=0'  #radiator
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + ' Radiator.fob'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

$MyObjectFilter = 'ID=83000..83099;Locked=0'  #trs
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + ' Trs.fob'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

$MyObjectFilter = 'ID=83200..83299;Locked=0'  #rekab
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + ' Rekab.fob'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

$MyObjectFilter = 'Type=men;ID=1056'  #exflow
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + ' Exflow menu.fob'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force

$MyObjectFilter = 'ID=86200..86269|87100..87199;Locked=0'  #strukton
$MyAllObjectsFile = (Join-Path $MyWorkFolder $fobfile4psname$HFlevel$HFsublevel) + ' Strukton.fob'
write-output "Export NAVApplicationObject    $MyAllObjectsFile"
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force
