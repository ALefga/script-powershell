#ruta origen:  e:\tlmp11\dll
#ruta destino : \\vm-CO02\c$\tlmp11\dll y \\vm-CO03\c$\tlmp11\dll

$origen = "e:\tlmp11\dll"
$destino1 = "\\vm-CO02\c$\tlmp11\dll"
$destino2 = "\\vm-CO03\c$\tlmp11\dll"

Write-Host "Copiando archivos DLL a $destino1"
Robocopy $origen $destino1 /E /Z /COPYALL /R:5 /W:5

Write-Host "Copiando archivos DLL a $destino2"
Robocopy $origen $destino2 /E /Z /COPYALL /R:5 /W:5

Write-Host "Proceso completado." 
