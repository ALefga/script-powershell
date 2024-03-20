# Define las computadoras donde buscarás sesiones de usuario
$computers1 = "VM-CO03"
$computers2 = "VM-CO02"
$sessions1 = @()
$sessions2 = @()

# Obtiene todas las sesiones de usuario activas en las computadoras especificadas para VM-CO03
foreach ($computer in $computers1) {
    Write-Host "Usuarios en línea en $computer"
    $sessions1 += (query user /server:$computer)
}

# Obtiene todas las sesiones de usuario activas en las computadoras especificadas para VM-CO02
foreach ($computer in $computers2) {
    Write-Host "Usuarios en línea en $computer"
    $sessions2 += (query user /server:$computer)
}

# Obtiene el nombre del usuario actual
$currentUserName = $env:USERNAME

# Inicializa las listas para los usuarios de cada equipo
$usersToDisconnectCO03 = @()
$usersToDisconnectCO02 = @()

# Filtra las sesiones para excluir al usuario actual para VM-CO03
foreach ($session in $sessions1) {
    $user = $session.Trim() -replace "\s+", " "
    $userName = $user.Split(" ")[0]
    
    # Verifica si el nombre de usuario actual no esta presente en la sesion
    if (($userName -ne $currentUserName) -and ($userName -ne "NOMBRE")) {
        # Obtiene el ID de sesion del usuario
        $sessionId = $user.Split(" ")[2]
        # Agrega el usuario y su ID de sesion a la lista correspondiente
        $usersToDisconnectCO03 += [PSCustomObject]@{
            nombre = $userName
            SesionId = $sessionId
            computadora = $computers1
        }
    }
}

# Filtra las sesiones para excluir al usuario actual para VM-CO02
foreach ($session in $sessions2) {
    $user = $session.Trim() -replace "\s+", " "
    $userName = $user.Split(" ")[0]
    
    # Verifica si el nombre de usuario actual no esta presente en la sesion
    if (($userName -ne $currentUserName) -and ($userName -ne "NOMBRE")) {
        # Obtiene el ID de sesion del usuario
        $sessionId = $user.Split(" ")[2]
        # Agrega el usuario y su ID de sesion a la lista correspondiente
        $usersToDisconnectCO02 += [PSCustomObject]@{
            nombre = $userName
            SesionId = $sessionId
            computadora = $computers2
        }
    }
}

# Ordena las listas de usuarios por nombre de usuario
$usersToDisconnectCO03 = $usersToDisconnectCO03 | Sort-Object nombre
$usersToDisconnectCO02 = $usersToDisconnectCO02 | Sort-Object nombre

# Muestra las listas de usuarios para desconectar en formato de tabla para VM-CO03
$usersCountCO03 = $usersToDisconnectCO03.Count
if ($usersCountCO03 -gt 0) {
    Write-Host "Usuarios para desconectar en $computers1 : $usersCountCO03"
    $usersToDisconnectCO03 | Format-Table -AutoSize
}

# Muestra las listas de usuarios para desconectar en formato de tabla para VM-CO02
$usersCountCO02 = $usersToDisconnectCO02.Count
if ($usersCountCO02 -gt 0) {
    Write-Host "Usuarios para desconectar en $computers2 : $usersCountCO02"
    $usersToDisconnectCO02 | Format-Table -AutoSize
}

# Pregunta si desea continuar
$confirmation = Read-Host "¿Deseas desconectar a estos usuarios? (si/no)"
if ($confirmation -eq "si") {
    # Desconecta las sesiones de los usuarios en VM-CO03
    foreach ($user in $usersToDisconnectCO03) {
        logoff $user.SesionId /server:$computers1
    }
    
    # Desconecta las sesiones de los usuarios en VM-CO02
    foreach ($user in $usersToDisconnectCO02) {
        logoff $user.SesionId /server:$computers2
    }
    
    Write-Host "Usuarios desconectados correctamente."
} else {
    Write-Host "Operación cancelada. No se desconectaron usuarios."
}
