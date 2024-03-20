# Define la ruta de origen y destino de los archivos DLL
$origen = "\\EquipoOrigen\c$\Ruta\Origen"
$destino = "\\EquipoDestino\c$\Ruta\Destino"

# Comprueba si la carpeta de destino existe en el equipo remoto, si no, créala
Invoke-Command -ComputerName EquipoDestino -ScriptBlock {
    param($path)
    if (-not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path -Force
    }
} -ArgumentList $destino

# Copia los archivos DLL del origen al destino en el equipo remoto
Copy-Item -Path "$origen\*.dll" -Destination $destino -ToSession (New-PSSession -ComputerName EquipoDestino)

# Opcional: Registra los archivos DLL en el equipo remoto
Invoke-Command -ComputerName EquipoDestino -ScriptBlock {
    param($path)
    foreach ($dll in Get-ChildItem -Path $path -Filter *.dll) {
        $result = Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s $($dll.FullName)" -PassThru -Wait
        if ($result.ExitCode -eq 0) {
            Write-Host "Archivo DLL registrado correctamente: $($dll.Name)"
        } else {
            Write-Host "Error al registrar el archivo DLL: $($dll.Name)"
        }
    }
} -ArgumentList $destino

Write-Host "Transferencia de archivos DLL completada."
