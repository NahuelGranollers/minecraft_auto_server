# 🎮 Minecraft Auto Server Setup

> **Configuración automática de servidores Minecraft Java Edition en tu PC local**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-3.2-brightgreen.svg)](https://github.com/NahuelGranollers/minecraft_auto_server)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.10--1.21.10-red.svg)](https://www.minecraft.net/)
[![Bash](https://img.shields.io/badge/Bash-5.0+-black.svg)](https://www.gnu.org/software/bash/)

**Creado por:** [Nahuel Granollers](https://nahuelgranollers.com)

---

Crea un servidor Minecraft en 30 segundos sin conocimientos técnicos.

---

## ⚡ Inicio Rápido

```bash
git clone https://github.com/NahuelGranollers/minecraft_auto_server.git
cd minecraft_auto_server
chmod +x minecraft-server-setup.sh
./minecraft-server-setup.sh
```
## 🚀 Cómo Iniciar el Servidor

### Primera Vez
```bash
./minecraft-server-setup.sh
# Sigue los pasos (Modo Rápido o Experto)
# Selecciona "sí" cuando pregunte por iniciar
```

### Posteriores
```bash
cd minecraft_server
./start.sh
```

### Detener el Servidor
```bash
# En el cliente de Minecraft: /stop
# O en la terminal: Ctrl+C
```

---

## 📋 Requisitos

| Sistema | Soporte |
|---------|---------|
| Linux (Ubuntu/Debian) | ✅ Soportado |
| macOS | ✅ Soportado |
| Windows | ✅ Usa Git Bash o WSL2 |

**Necesitas:**
- Java 21+ (el script lo instala automáticamente)
- curl (generalmente preinstalado)
- Conexión a internet

### Windows - Git Bash

1. Descarga Git Bash: https://gitforwindows.org/
2. Instala con opciones por defecto
3. Abre Git Bash
4. Navega a la carpeta y ejecuta los comandos arriba

---

## 🚀 Dos Modos

### ⚡ Modo Rápido (Principiantes)
- Configura todo automáticamente
- Versión: 1.21.10 (Vanilla)
- RAM: 1GB mín - 4GB máx
- 20 jugadores máximo
- **Tiempo: 30 segundos**

### 🔧 Modo Experto (Avanzado)
- Personaliza versión, tipo, RAM, 25+ parámetros
- Elige versiones desde 1.10 a 1.21
- Vanilla, Paper o Forge
- **Tiempo: 2-5 minutos**

---

## 💾 RAM Recomendada

| Jugadores | Mínima | Máxima |
|-----------|--------|--------|
| 1-5 | 1 GB | 2-3 GB |
| 5-15 | 2 GB | 4-6 GB |
| 15-30 | 4 GB | 8 GB |
| 30+ | 6-8 GB | 12-16+ GB |

Tip: En Modo Experto, opción 13 te muestra esta tabla interactiva.

---

## 📡 Compartir con Amigos

Después de configurar, el script muestra tu dirección IP:PUERTO.

### Pasos para Abrirlo en el Router

1. Accede: `http://192.168.1.1` o `http://192.168.0.1`
2. Busca **"Port Forwarding"**
3. Nueva regla:
   - Puerto externo: `25565`
   - Puerto interno: `25565`
   - Protocolo: `TCP/UDP`
   - IP local: Tu IP privada (el script te la muestra)
4. Guarda y reinicia el router

### Conectar en Minecraft

1. Multijugador → Servidor directo
2. Pega: `[TU_IP_PUBLICA]:25565`
3. ¡Conecta!

---

## 🔧 Parámetros Personalizables (Modo Experto)

- Nombre del mundo
- Versión de Minecraft
- Tipo (Vanilla/Paper/Forge)
- Gamemode (Survival/Creative/Adventure)
- Dificultad (Peaceful/Easy/Normal/Hard)
- Máximo de jugadores
- RAM
- Distancia de visión
- PvP, Nether, End, Vuelo
- RCON y 15+ más

---

## 🆘 Problemas Comunes

**"No se puede ejecutar el script"**
```bash
chmod +x minecraft-server-setup.sh
```

**"Java no está instalado"**
- El script lo instala automáticamente
- Manual: `sudo apt install openjdk-21-jdk` (Linux) o `brew install openjdk@21` (macOS)

**"El servidor va lento"**
- Aumenta RAM en Modo Experto (opción 15)
- Reduce distancia de visión (opción 16)

**"No puedo conectarme desde internet"**
- ¿Abriste el puerto en el router?
- ¿Tu IP pública es correcta? Ejecuta: `curl ifconfig.me`
- ¿Esperaste 5 minutos? El router necesita tiempo

**Ver logs para más detalles:**
```bash
cat setup_debug.log
```

---
## 🖼️ Cambiar Icono
1. Reemplaza `server-icon.png` en la carpeta del servidor
2. Debe ser 64x64 píxeles (PNG)
3. El servidor la detecta automáticamente

## 📁 Estructura

```
tu_carpeta/
├── minecraft-server-setup.sh
├── README.md
└── minecraft_server/
    ├── server.jar
    ├── server.properties
    ├── start.sh
    ├── world/
    └── logs/
```

---

## 🎮 Comandos del Servidor (In-Game)

```
/stop - Parar servidor
/say [mensaje] - Mensaje global
/difficulty [nivel] - Cambiar dificultad
/gamemode [modo] [jugador] - Cambiar gamemode
/whitelist add [jugador] - Agregar a whitelist
/op [jugador] - Dar admin
```

---

## 📜 Licencia

Código abierto. Minecraft es propiedad de Mojang Studios.

Este proyecto está bajo la licencia **MIT**.

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

Ver [LICENSE](LICENSE) para más detalles.

---

## 📞 Soporte

¿Necesitas ayuda?

- 📧 Abre un [Issue](https://github.com/NahuelGranollers/minecraft_auto_server/issues)
- 💬 Crea una [Discusión](https://github.com/NahuelGranollers/minecraft_auto_server/discussions)

---

**Más ayuda:** Revisa `setup_debug.log` si hay errores.
