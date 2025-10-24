#!/bin/bash

archivo="usuarios.txt"

# Verificar existencia
if [[ ! -f "$archivo" ]]; then
    echo "ERROR: El archivo $archivo no existe"
    exit 1
fi
while IFS=: read -r usuario contrasena; do
    # Saltar líneas vacías
    [[ -z "$usuario" || -z "$contrasena" ]] && {
        echo "Entrada inválida (usuario o contraseña vacía), saltando..."
        continue
    }

    # Verificar si ya existe el usuario
    if id "$usuario" &>/dev/null; then
        echo "El usuario $usuario ya existe, saltando..."
        continue
    fi

    # Crear usuario y asignar contraseña
    useradd -m -s /bin/bash "$usuario"
    if echo "$usuario:$contrasena" | chpasswd; then
        echo "Usuario $usuario creado exitosamente"
    else
        echo "Error al asignar la contraseña a $usuario"
    fi

done < "$archivo"
