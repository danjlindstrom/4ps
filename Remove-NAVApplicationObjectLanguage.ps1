$MyWorkBaseFolder = 'C:\Navision\Microsoft Navision\Attain11xx\CU 08 NAV 2018\APPLICATION\CUObjects.txt' 
$FilePrefix = 'NAV.11.0.23572'

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
$MyOrigCtry = 'W1'
$MyOriginalPath =  (join-path $MyWorkBaseFolder ('\' + $FilePrefix + '.' + $MyOrigCtry + '.ENU'))

ForEach ($ctry in 'DK','FI','NO','SE','W1')  {
    $MyAllObjectsFile = (join-path $MyWorkBaseFolder ('\' + $FilePrefix + '.' + $ctry + '.CUObjects.txt')) 
    $MyDestObjectsDir = (join-path $MyWorkBaseFolder '') 
    $MyMergedFolder = (Join-Path $MyWorkBaseFolder 'Target')

    $MyDestObjectsFile = (join-path $MyDestObjectsDir ('\' + $FilePrefix + '.' + $ctry + '.CUObjects.ENU.txt')) 
    
    write-output "Remove app properties before 1st split    $MyAllObjectsFile"
    Set-NAVApplicationObjectProperty -TargetPath $MyAllObjectsFile -ModifiedProperty No -DateTimeProperty ''
    
    echo ('Split NAVApplicationObjectLanguage ' + $ctry)
    Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination ( join-path $MyDestObjectsDir ( '\'+$FilePrefix+'.' + $ctry  )) -PassThru -Force -PreserveFormatting


    echo ('Remove NAVApplicationObjectLanguage ' + $ctry)
    Remove-NAVApplicationObjectLanguage -Source $MyAllObjectsFile -Destination $MyDestObjectsFile -Force
    
    echo ('Split NAVApplicationObjectLanguage ' + $ctry + '.ENU')
    Split-NAVApplicationObjectFile -Source $MyDestObjectsFile -Destination ( join-path $MyDestObjectsDir ( '\'+$FilePrefix+'.' + $ctry + '.ENU' )) -PassThru -Force -PreserveFormatting


    $MyModifiedPath = ( join-path $MyDestObjectsDir ( '\'+$FilePrefix+'.' + $ctry + '.ENU' ))
    $MyTargetPath = $MyTargetPath # ( join-path $MyDestObjectsDir 'Target') 
    $MyResultPath = ( join-path $MyDestObjectsDir 'Result')
    
    echo ('OriginalPath '+  $MyOriginalPath)
    echo ('ModifiedPath '+ $MyModifiedPath)
    echo ('TargetPath '+ $MyTargetPath)
    echo ('ResultPath '+$MyResultPath)
#    Merge-NAVApplicationObject -OriginalPath $MyOriginalPath -TargetPath $MyTargetPath -ModifiedPath $MyModifiedPath -ResultPath $MyResultPath -Force


    $MyOrigCtry = $ctry
#    $MyOriginalPath =  $MyTargetPath 
}
