# 🎮 Minecraft Auto Server Setup

> **Configuración automática de servidores Minecraft Java Edition en tu PC local**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-3.0-brightgreen.svg)](https://github.com/NahuelGranollers/minecraft_auto_server)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.10-red.svg)](https://www.minecraft.net/)
[![Bash](https://img.shields.io/badge/Bash-5.0+-black.svg)](https://www.gnu.org/software/bash/)

**Creado por:** [Nahuel Granollers](https://nahuelgranollers.com)

---

## ✨ Características

### 🚀 Automatización Total
- **Descarga automática** del servidor Minecraft (Vanilla, Paper, Forge)
- **Configuración asistida** con interfaz interactiva
- **Inicio automático** del servidor después de configurar
- **Generación automática** de icono del servidor
- **Validación inteligente** de todas las entradas

### 🎛️ Configuración Personalizable
- **20+ parámetros** configurables en modo avanzado
- **Control de RAM** (mínima y máxima)
- **MOTD personalizado** (descripción del servidor)
- **Control total** del puerto, dificultad, modo de juego
- **Plantillas rápidas** o configuración avanzada

### 🎨 Interfaz Profesional
- **Colores y emojis** para mejor UX
- **Validaciones robustas** de entradas
- **Mensajes claros** y en español
- **Progreso visual** durante la configuración
- **Resumen final** con toda la información

### 🌐 Compartir Fácilmente
- **Mensaje de compartir automático** con IP y puerto
- **Instrucciones paso a paso** para tus amigos
- **Formato profesional** listo para copiar y pegar
- **Información de red local y pública**

### 🔒 Seguridad y Control
- **Validación de puertos** (1-65535)
- **Validación de RAM** y memoria
- **Protección de nombre** de carpeta
- **EULA automático**
- **Respaldos y permisos** correctos

---

## 📋 Tabla de Características

| Característica | Vanilla | Paper | Forge |
|---|:---:|:---:|:---:|
| Descarga automática | ✅ | ✅ | ❌ |
| Configuración | ✅ | ✅ | ✅ |
| Inicio automático | ✅ | ✅ | ✅ |
| Icono predeterminado | ✅ | ✅ | ✅ |
| Plugins/Mods | ❌ | ✅ | ❌ |
| Optimizaciones | ✅ | ✅ | ✅ |

---

## 🎯 Inicio Rápido

### Requisitos Previos
- **Bash** 5.0+
- **Java** 21+ (se instala automáticamente si falta)
- **curl** o **wget** (para descargas)
- **Linux, macOS o WSL** en Windows

### Instalación

```bash
# 1. Clona el repositorio
git clone https://github.com/NahuelGranollers/minecraft_auto_server.git
cd minecraft_auto_server

# 2. Dale permisos de ejecución
chmod +x minecraft-server-setup.sh

# 3. Ejecuta el script
./minecraft-server-setup.sh
```

### Primer Uso

El script te guiará paso a paso:

1. **Selecciona versión** de Minecraft (1.21.10, 1.21.8, etc.)
2. **Elige tipo** de servidor (Vanilla, Paper, Forge)
3. **Configuración rápida** (nombre, puerto, dificultad)
4. **Configuración avanzada** (opcional - 20+ parámetros)
5. **Descarga y configuración** automática
6. **¿Iniciar ahora?** - El servidor se arranca automáticamente

---

## 🎮 Pantallas de Ejemplo

### Pantalla Inicial
```
════════════════════════════════════════
Configurador Automatizado de Servidor Minecraft v3.0
Última versión: 1.21.10
© Copyright 2025 - Nahuel Granollers
Configuración Avanzada + Inicio Automático + Icono + Compartir
════════════════════════════════════════
```

### Selección de Versión
```
════════════════════════════════════════
Selecciona la Versión de Minecraft
════════════════════════════════════════

Versiones disponibles:
  1) 1.21.10
  2) 1.21.8
  3) 1.21.6
  4) 1.21.4
  5) 1.20.1

Selecciona una versión (1-5): 
```

### Configuración Avanzada
```
════════════════════════════════════════
⚙️  CONFIGURACIÓN AVANZADA
════════════════════════════════════════

Selecciona un parámetro para editar:

  1)  Nombre de carpeta contenedora   (Actual: minecraft_server)
  2)  MOTD (Descripción servidor)     (Actual: Un Servidor de Minecraft)
  3)  Nombre del mundo (nivel)        (Actual: world)
  ...
  20) RAM mínima del servidor         (Actual: 1GB)
  21) RAM máxima del servidor         (Actual: 4GB)
  22) Ver resumen actual
  23) Volver al menú principal
```

### Mensaje de Compartir
```
╔════════════════════════════════════════════════════════════════╗
║              ✅ SERVIDOR CONFIGURADO Y LISTO                  ║
╚════════════════════════════════════════════════════════════════╝

┌─ DATOS DE CONEXIÓN ─────────────────────────────────────────┐
│                                                               │
│  🌐 IP Pública      : 192.168.1.100                          │
│  🔌 Puerto          : 25565                                  │
│  👥 Máx Jugadores   : 20                                     │
│  🎮 Modo            : Survival                               │
│  ⚒️  Versión        : 1.21.10                                │
│  📝 MOTD            : Mi Servidor Epic                       │
│                                                               │
│  ✂️  COPIAR Y PEGAR A TUS AMIGOS:                            │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │ 192.168.1.100:25565                                     │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
│  📌 INSTRUCCIONES PARA TUS AMIGOS:                           │
│     1. Abre Minecraft Java Edition                          │
│     2. Click en "Multijugador"                              │
│     3. Click en "Servidor directo"                          │
│     4. Pega: 192.168.1.100:25565                            │
│     5. ¡Conecta!                                            │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚙️ Configuración Detallada

### Parámetros Disponibles

#### Básicos
| Parámetro | Descripción | Default |
|---|---|---|
| **Carpeta contenedora** | Nombre principal del servidor | minecraft_server |
| **MOTD** | Descripción en lista de servidores | Un Servidor de Minecraft |
| **Nombre del mundo** | Carpeta del mundo/nivel | world |
| **Puerto** | Puerto de conexión | 25565 |

#### Gameplay
| Parámetro | Descripción | Default |
|---|---|---|
| **Modo de juego** | survival/creative/adventure/spectator | survival |
| **Dificultad** | peaceful/easy/normal/hard | easy |
| **PvP** | Combate entre jugadores | true |
| **Vuelo** | Permitir vuelo en modo no-creativo | false |

#### Jugadores
| Parámetro | Descripción | Default |
|---|---|---|
| **Máximo de jugadores** | Límite de conexiones | 20 |
| **Modo online** | Verificación de cuentas Mojang | true |
| **Lista blanca** | Solo jugadores autorizados | false |
| **Protección spawn** | Radio de protección (bloques) | 16 |

#### Mundo
| Parámetro | Descripción | Default |
|---|---|---|
| **Semilla** | Semilla del mundo (vacío = aleatoria) | (aleatoria) |
| **Distancia de visión** | Chunks visibles (3-32) | 10 |
| **Altura máxima** | Límite de altura de construcción | 320 |

#### Rendimiento
| Parámetro | Descripción | Default |
|---|---|---|
| **RAM mínima** | RAM inicial asignada | 1 GB |
| **RAM máxima** | RAM máxima permitida | 4 GB |

#### Avanzado
| Parámetro | Descripción | Default |
|---|---|---|
| **RCON** | Control remoto del servidor | false |
| **Puerto RCON** | Puerto para RCON | 25575 |
| **Bloques de comandos** | Bloques de comando funcionales | false |

---

## 🗂️ Estructura de Carpetas

```
Tu carpeta de ejecución/
│
├── minecraft-server-setup.sh        # El script principal
├── README.md                         # Este archivo
├── icon.png                          # Icono predeterminado (descargado)
│
└── minecraft_server/                 # Carpeta del servidor (configurable)
    ├── server.jar                    # Servidor Minecraft
    ├── start.sh                      # Script de inicio
    ├── eula.txt                      # Aceptación EULA
    ├── server.properties             # Configuración del servidor
    ├── server-icon.png               # Icono del servidor
    ├── plugins/                      # Carpeta de plugins (si es Paper)
    │
    └── world/                        # Carpeta del mundo (configurable)
        ├── level.dat                 # Datos del mundo
        ├── region/                   # Regiones del mundo
        └── ...
```

---

## 🚀 Cómo Iniciar el Servidor

### Primera Vez
```bash
./minecraft-server-setup.sh
# Sigue los pasos y selecciona "sí" cuando pregunte por iniciar
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

## 🔌 Conectar Amigos

### Conexión Local (Mismo WiFi/Red)
1. Usa la **IP Privada** mostrada: `192.168.1.X`
2. Tus amigos se conectan con: `192.168.1.X:25565`

### Conexión Remota (Internet)
1. **Abre el puerto en el router:**
   - Accede a la configuración del router
   - Busca "Port Forwarding"
   - Reenvía puerto 25565 a tu IP local
2. **Comparte la IP Pública** mostrada por el script
3. Tus amigos se conectan con: `IP_PÚBLICA:25565`

### Pasos en Minecraft
1. Minecraft Java Edition
2. Multijugador
3. Servidor directo
4. Pega: `IP:PUERTO`
5. ¡Conecta!

---

## 📦 Tipos de Servidor

### Vanilla
- **Descripción:** Servidor oficial de Minecraft sin modificaciones
- **Ventajas:** Ligero, rápido, estable
- **Desventajas:** Sin plugins ni mods
- **Uso:** Supervivencia pura

### Paper
- **Descripción:** Servidor basado en Spigot, optimizado
- **Ventajas:** Mejor rendimiento, soporta plugins
- **Desventajas:** Requiere configuración de plugins
- **Uso:** SMP con customización

### Forge
- **Descripción:** Servidor con soporte para mods
- **Ventajas:** Libertad creativa con mods
- **Desventajas:** Instalación manual, mayor consumo de recursos
- **Uso:** Modpacks y experiencias customizadas

---

## 💾 Resumen de Configuración

Después de configurar, el script genera un resumen:

```
════════════════════════════════════════
¡Configuración Completada!
════════════════════════════════════════

📁 Estructura de Carpetas:
   Carpeta contenedora: minecraft_server
   Ruta completa      : /ruta/minecraft_server
   Mundo (nivel)      : /ruta/minecraft_server/world

🎮 Configuración del servidor:
   Tipo: Paper
   Versión: 1.21.10
   MOTD (Descripción): Mi Servidor Epic
   Modo: Survival
   Dificultad: Normal
   Jugadores máximo: 20
   Puerto: 25565
   Modo online: true

💾 Configuración de Memoria:
   RAM mínima: 1GB
   RAM máxima: 8GB

🌐 Información de Red:
   IP Privada (localhost): 192.168.1.100:25565
   IP Pública (amigos): 203.0.113.45:25565
```

---

## ⚡ Optimizaciones Incluidas

### Rendimiento
- ✅ Control automático de distancia de visión
- ✅ Asignación optimizada de RAM
- ✅ Garbage collector mejorado en Java
- ✅ Recomendaciones según hardware

### Seguridad
- ✅ EULA automático
- ✅ Protección de spawn
- ✅ Lista blanca disponible
- ✅ RCON con contraseña

### Usabilidad
- ✅ Validación completa de entradas
- ✅ Mensajes de error claros
- ✅ Reintentos automáticos de descarga
- ✅ Resúmenes y confirmaciones

---

## 🐛 Solución de Problemas

### Error: "Java no está instalado"
```bash
# Opción 1: El script lo instala automáticamente
# Opción 2: Instala manualmente
sudo apt install openjdk-21-jdk  # Ubuntu/Debian
brew install openjdk@21          # macOS
```

### Error: "Puerto ya en uso"
```bash
# Cambia el puerto en configuración avanzada
# O usa uno disponible: 25566, 25567, etc.
```

### Conexión rechazada desde Internet
1. Verifica que el puerto esté abierto en el router
2. Comprueba que la IP pública sea correcta
3. Desactiva firewall temporalmente para probar
4. Usa la IP privada si están en la misma red

### Servidor muy lento
1. Aumenta la RAM máxima (configuración avanzada)
2. Reduce la distancia de visión
3. Limita máximo de jugadores
4. Usa Paper en lugar de Vanilla

### El mundo no se carga
```bash
# Verifica que la carpeta del mundo existe
cd minecraft_server
ls -la  # Busca la carpeta del nivel

# Si falta, el servidor la crea automáticamente en el siguiente inicio
```

---

## 📝 Recomendaciones

### Para 1-5 Jugadores
```
RAM mínima: 1 GB
RAM máxima: 2-3 GB
Distancia de visión: 8 chunks
Tipo: Vanilla o Paper
```

### Para 5-15 Jugadores
```
RAM mínima: 2 GB
RAM máxima: 4-6 GB
Distancia de visión: 10 chunks
Tipo: Paper (recomendado)
```

### Para 15+ Jugadores
```
RAM mínima: 4 GB
RAM máxima: 8-12 GB
Distancia de visión: 8-10 chunks
Tipo: Paper + Plugins de optimización
```

---

## 🎨 Personalización

### Cambiar Icono
1. Reemplaza `server-icon.png` en la carpeta del servidor
2. Debe ser 64x64 píxeles (PNG)
3. El servidor la detecta automáticamente

### Cambiar MOTD
```bash
# Edita server.properties
vi server.properties

# Busca: motd=Tu Descripción
# Cambia a: motd=Nueva Descripción
```

### Cambiar Dificultad en Vivo
```bash
# En el chat del servidor:
/difficulty hard
```

### Agregar Plugins (Paper)
1. Descarga plugins .jar
2. Copia a `minecraft_server/plugins/`
3. Reinicia con `/stop` y `./start.sh`

---

## 📚 Recursos Útiles

- 🎮 [Minecraft.net](https://www.minecraft.net)
- 📖 [Wiki Minecraft](https://minecraft.wiki)
- 📦 [PaperMC](https://papermc.io)
- 🔧 [SpigotMC](https://www.spigotmc.org)
- 🌐 [Curse Forge](https://www.curseforge.com)

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**.

```
Copyright © 2025 Nahuel Granollers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

Ver [LICENSE](LICENSE) para más detalles.

---

## 👤 Autor

**Nahuel Granollers**
- 🌐 [nahuelgranollers.com](https://nahuelgranollers.com)
- 💻 [GitHub](https://github.com/NahuelGranollers)
- 🎬 Motion Designer & Web Developer

---

## 🤝 Contribuciones

¿Tienes ideas para mejorar? ¡Las contribuciones son bienvenidas!

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## ⭐ Si Te Gusta, ¡Dale una Estrella!

```
⭐ ← Presiona aquí arriba
```

Esto ayuda a más personas a encontrar el proyecto.

---

## 📞 Soporte

¿Necesitas ayuda?

- 📧 Abre un [Issue](https://github.com/NahuelGranollers/minecraft_auto_server/issues)
- 💬 Crea una [Discusión](https://github.com/NahuelGranollers/minecraft_auto_server/discussions)
- 🐦 Sígueme en redes sociales

---

**Hecho con ❤️ por [Nahuel Granollers](https://nahuelgranollers.com)**

---

## 🎯 Roadmap Futuro

- [ ] Interfaz gráfica (GUI)
- [ ] Gestor de backups automático
- [ ] Plugin manager integrado
- [ ] Monitor de rendimiento
- [ ] Actualizaciones automáticas
- [ ] Soporte para Windows (nativo)
- [ ] Estadísticas y logs
- [ ] Web dashboard de administración

---

**Última actualización:** 12 de Noviembre de 2025 | **Versión:** 3.0
