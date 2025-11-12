# 🎮 Minecraft Auto Server Setup

**¡Crea un servidor Minecraft en 30 segundos sin necesidad de conocimientos técnicos!**

Un script automatizado que descarga, configura e inicia un servidor Minecraft personalizado. Perfecto para jugar con amigos sin complicaciones.

---

## ⚡ Inicio Rápido (3 pasos)

### 1️⃣ **Descargar el Script**

Descarga el archivo `minecraft-server-setup.sh` desde el repositorio.

### 2️⃣ **Hacer el Script Ejecutable**

Abre una terminal en la carpeta donde descargaste el archivo y ejecuta:

```bash
chmod +x minecraft-server-setup.sh
```

### 3️⃣ **Ejecutar el Script**

```bash
./minecraft-server-setup.sh
```

**¡Eso es todo!** El script te guiará paso a paso.

---

## 📋 Requisitos Previos

### Sistemas Soportados
- ✅ **Linux** (Ubuntu, Debian, CentOS, etc.)
- ✅ **macOS** (Intel y Apple Silicon)
- ❌ Windows (usa WSL2 o Git Bash)

### Requisitos Obligatorios

1. **Java 21 o superior**
   - El script intenta instalarlo automáticamente si no lo tienes
   - Para verificar: `java -version`

2. **curl** (para descargas)
   - Generalmente ya está instalado
   - Si no: `sudo apt install curl` (Linux) o `brew install curl` (macOS)

3. **Conexión a Internet**
   - Para descargar el servidor de Minecraft

---

## 🚀 Dos Modos de Uso

### ⚡ Modo Rápido (Recomendado para Principiantes)

El script configura **todo automáticamente** con valores por defecto:
- Versión: **1.21.10** (última)
- Tipo: **Vanilla** (oficial de Minecraft)
- Modo: **Survival**
- RAM: **1GB mín - 4GB máx**
- Jugadores: **20 máximo**
- Puerto: **25565**

**Tiempo:** ~30 segundos

```
1️⃣ Selecciona: 1
2️⃣ ✓ Configura automáticamente
3️⃣ ¿Iniciar servidor? s
```

### 🔧 Modo Experto (Para Personalización Avanzada)

Personaliza todo aspecto del servidor:
- **Versión:** Elige entre 1.10 a 1.21
- **Tipo:** Vanilla / Paper (optimizado) / Forge (con mods)
- **RAM:** Configura consumo de memoria
- **25+ Parámetros:** Dificultad, gamemode, distancia de visión, etc.

**Tiempo:** ~2-5 minutos

```
1️⃣ Selecciona: 2
2️⃣ Elige versión y tipo
3️⃣ Configuración básica
4️⃣ ¿Configuración avanzada? s
5️⃣ Personaliza los 25+ parámetros
```

---

## 💡 Recomendación de RAM

El script incluye una **guía inteligente** de RAM según jugadores:

| Jugadores | RAM Mínima | RAM Máxima |
|-----------|-----------|-----------|
| 1-5 | 1 GB | 2-3 GB |
| 5-15 | 2 GB | 4-6 GB |
| 15-30 | 4 GB | 8 GB |
| 30+ | 6-8 GB | 12-16+ GB |

**Ver la tabla:** En Modo Experto, opción 13 "Ver recomendación RAM"

---

## 📡 Compartir el Servidor con Amigos

Después de configurar, el script muestra:

```
🎯 SERVIDOR LISTO - DATOS DE CONEXIÓN
╔════════════════════════════════════════╗
║  ✅ SERVIDOR CONFIGURADO Y LISTO      ║
╚════════════════════════════════════════╝

Dirección: 212.97.95.46:25565
```

**Comparte esta dirección con tus amigos.**

### ⚙️ Cómo Abrirlo en el Router

El script te mostrará una **guía paso a paso**, pero aquí está el resumen:

1. **Accede a tu router:**
   - Abre: `http://192.168.1.1` o `http://192.168.0.1`
   - Usuario/Contraseña: `admin/admin` (o consulta tu router)

2. **Busca "Port Forwarding" o "Reenvío de puertos"**

3. **Crea una regla:**
   - Puerto externo: `25565`
   - Puerto interno: `25565`
   - Protocolo: `TCP/UDP`
   - IP local: `192.168.x.x` (tu IP privada)

4. **Guarda y reinicia el router**

### 🎮 Cómo se Conectan tus Amigos

En **Minecraft Java Edition**:

1. Click en **"Multijugador"**
2. Click en **"Servidor directo"**
3. Pega la dirección: `212.97.95.46:25565`
4. ¡Conecta!

---

## 📁 Estructura de Carpetas

Después de ejecutar el script, se crea:

```
tu_carpeta/
├── minecraft-server-setup.sh (el script)
└── minecraft_server/
    ├── server.jar (servidor descargado)
    ├── server.properties (configuración)
    ├── eula.txt (aceptación de términos)
    ├── start.sh (script para iniciar)
    ├── world/ (tu mundo)
    ├── logs/
    └── plugins/ (si usas Paper)
```

---

## 🎮 Iniciar/Parar el Servidor

### Iniciar Automáticamente

El script te pregunta al final: **"¿Iniciar el servidor ahora?"**
- Si dices **SÍ**: Se inicia inmediatamente
- Si dices **NO**: Puedes iniciarlo después

### Iniciar Manualmente

```bash
cd minecraft_server
./start.sh
```

### Parar el Servidor

En la terminal donde corre el servidor:
```
Escribe: stop
Presiona: Enter
```

---

## ⚙️ Parámetros Avanzados (Modo Experto)

| Parámetro | Descripción | Valores |
|-----------|-------------|---------|
| MOTD | Descripción del servidor | Texto libre |
| Puerto | Puerto de conexión | 1-65535 |
| Gamemode | Modo de juego | survival / creative / adventure / spectator |
| Dificultad | Nivel de dificultad | peaceful / easy / normal / hard |
| Máx. Jugadores | Límite de conexiones | Número |
| Modo online | Verificación de licencia | true / false |
| PvP | Combate entre jugadores | true / false |
| Distancia visión | Chunks renderizados | 3-32 |
| Permitir Nether | Acceso al Nether | true / false |
| Permitir End | Acceso al End | true / false |
| Permitir vuelo | Flying mode | true / false |

---

## 🔧 Solución de Problemas

### ❌ "No se puede ejecutar el script"

**Solución:**
```bash
chmod +x minecraft-server-setup.sh
```

### ❌ "Java no está instalado"

**El script intenta instalarlo automáticamente.** Si falla:

**Linux (Ubuntu/Debian):**
```bash
sudo apt update && sudo apt install openjdk-21-jdk -y
```

**macOS:**
```bash
brew install openjdk@21
```

### ❌ "curl: command not found"

**Linux:**
```bash
sudo apt install curl -y
```

**macOS:**
```bash
brew install curl
```

### ❌ "El servidor se cierra al iniciar"

**Verifica:**
1. ¿Tienes Java 21+? → `java -version`
2. ¿Hay suficiente RAM en tu máquina?
3. Revisa el archivo: `minecraft_server/logs/latest.log`

### ❌ "No puedo conectarme desde internet"

**Pasos:**
1. ¿Abriste el puerto en el router? (Ver sección Port Forwarding)
2. ¿Esperaste 5 minutos después de configurar? (El router necesita tiempo)
3. ¿Estás usando la IP pública correcta? → `curl ifconfig.me`

### ❌ "El servidor va lento"

**Soluciones:**
1. Aumenta RAM: Opción 15 en Modo Experto
2. Reduce distancia de visión: Opción 16
3. Reduce número de jugadores: Opción 8

---

## 📊 Versiones de Minecraft Soportadas

El script soporta **todas las versiones desde 1.10 a 1.21**:

**Recomendadas:**
- 🟢 **1.21.10** (Última - Recomendada)
- 🟢 **1.20.4** (Estable)
- 🟢 **1.19.2** (Clásico)

**En Modo Experto** puedes seleccionar cualquier versión del histórico.

---

## 🖥️ Tipos de Servidor

### Vanilla (Oficial)
- 🎮 Experiencia oficial de Minecraft
- ✅ Sin mods ni plugins
- 💡 Perfecto para principiantes

### Paper (Optimizado)
- 🚀 Mejor rendimiento
- ✅ Soporta plugins
- 🔧 Ideal para servidores con muchos jugadores

### Forge (Con Mods)
- 🎨 Soporta modificaciones
- ⚠️ Requiere manual setup (ver: https://files.minecraftforge.net)

---

## 💾 Configuraciones Guardadas

El script guarda todas tus configuraciones en:
- **server.properties:** Configuración del servidor
- **start.sh:** Script personalizado para iniciar
- **setup_debug.log:** Registro de configuración

**Puedes editar estas archivos manualmente** si lo necesitas.

---

## 🆘 Obtener Ayuda

### Archivo de Log

Si hay un problema, revisa:
```bash
cat setup_debug.log
```

### Commandos Útiles

```bash
# Ver consola del servidor
tail -f minecraft_server/logs/latest.log

# Ver procesos de Java
ps aux | grep java

# Ver puertos abiertos
netstat -tlnp | grep java
```

---

## 📝 Comandos del Servidor (In-Game)

Una vez dentro del servidor, puedes usar:

```
/stop - Parar el servidor
/save-all - Guardar mundo
/say [mensaje] - Mensaje global
/difficulty [nivel] - Cambiar dificultad
/gamemode [modo] [jugador] - Cambiar gamemode
/whitelist add [jugador] - Agregar a whitelist
/op [jugador] - Dar permisos de admin
```

---

## 🔐 Seguridad

**Recomendaciones:**
- ✅ Usa contraseña fuerte en tu router
- ✅ Mantén Java actualizado
- ✅ Revisa regularmente el archivo de logs
- ✅ Solo comparte IP con gente de confianza
- ✅ Considera usar lista blanca (whitelist) si tienes servidor público

---

## 📜 Licencia

Este script es de código abierto. Úsalo libremente.

**Minecraft es propiedad de Mojang Studios.**

---

## 👨‍💻 Autor

**Nahuel Granollers**
- 🌐 Portfolio: https://nahuelgranollers.com
- 🐙 GitHub: https://github.com/NahuelGranollers
- 📧 Email: contacto@nahuelgranollers.com

**v3.10** - Noviembre 2025

---

## 🎉 ¡Ya está Listo!

**Próximos pasos:**

1. Descarga el script
2. Ejecuta: `./minecraft-server-setup.sh`
3. Elige Modo Rápido (opción 1) o Experto (opción 2)
4. Comparte la IP con tus amigos
5. ¡Que disfruten el servidor!

**Cualquier pregunta, revisa esta guía o el archivo `setup_debug.log`**

¡Bienvenido al mundo de los servidores Minecraft! 🎮✨
