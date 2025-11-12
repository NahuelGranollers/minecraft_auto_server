#!/bin/bash

#############################################################################
# Script de Configuración Automatizada de Servidor Minecraft (v3.1)
# Descarga, configura e inicia un servidor Minecraft Java Edition
# Compatible con: Vanilla, Paper, Forge
#
# CON: Configuración Avanzada + Inicio Automático + Control Total
# NUEVO: Todas las versiones de Minecraft + Submenu inteligente
#
# © Copyright 2025 - Nahuel Granollers
# Desarrollado como herramienta de automatización para servidores Minecraft
#############################################################################

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$SCRIPT_DIR"
SERVER_FOLDER_NAME="minecraft_server"
JAVA_VERSION="21"
PUBLIC_IP=""
PRIVATE_IP=""
USER_AGENT="MinecraftServerSetup/3.1 (+https://github.com/NahuelGranollers/minecraft_auto_server)"
ICON_URL="https://raw.githubusercontent.com/NahuelGranollers/minecraft_auto_server/refs/heads/main/icon.png"

# Arrays de versiones disponibles
declare -a VERSIONS_LATEST=("1.21.10" "1.21.8" "1.21.6" "1.21.4" "1.20.1")
declare -a VERSIONS_1_20=("1.20.4" "1.20.3" "1.20.2" "1.20.1")
declare -a VERSIONS_1_19=("1.19.2" "1.19.1" "1.19")
declare -a VERSIONS_1_18=("1.18.2" "1.18.1" "1.18")
declare -a VERSIONS_1_17=("1.17.1" "1.17")
declare -a VERSIONS_1_16=("1.16.5" "1.16.4" "1.16.3" "1.16.2" "1.16.1")
declare -a VERSIONS_1_15=("1.15.2" "1.15.1" "1.15")
declare -a VERSIONS_1_14=("1.14.4" "1.14.3" "1.14.2" "1.14.1" "1.14")
declare -a VERSIONS_1_12=("1.12.2" "1.12.1" "1.12")
declare -a VERSIONS_1_11=("1.11.2" "1.11.1" "1.11")
declare -a VERSIONS_1_10=("1.10.2" "1.10.1" "1.10")

# Variables de configuración (valores por defecto)
MOTD="Un Servidor de Minecraft"
SERVER_PORT="25565"
GAMEMODE="survival"
DIFFICULTY="easy"
MAX_PLAYERS="20"
ONLINE_MODE="true"
PVP="true"
SPAWN_PROTECTION="16"
WHITE_LIST="false"
ENABLE_COMMAND_BLOCK="false"
LEVEL_NAME="world"
LEVEL_SEED=""
VIEW_DISTANCE="10"
ENABLE_RCON="false"
RCON_PASSWORD="minecraft"
RCON_PORT="25575"
ENABLE_QUERY="false"
QUERY_PORT="25565"
ALLOW_FLIGHT="false"
MAX_BUILD_HEIGHT="320"
MAX_WORLD_SIZE="59999968"
HARDCORE="false"
MIN_RAM="1"
MAX_RAM="4"

#############################################################################
# FUNCIONES AUXILIARES
#############################################################################

print_header() {
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}\n"
}

print_subheader() {
    echo -e "\n${CYAN}━━━━ $1 ━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_option() {
    echo -e "${CYAN}  $1${NC}"
}

pause_script() {
    echo -e "${YELLOW}Presiona Enter para continuar...${NC}"
    read -r
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "$1 no está instalado"
        return 1
    fi
    return 0
}

# Validar puerto
validate_port() {
    local port=$1
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        print_error "Puerto inválido. Debe estar entre 1 y 65535"
        return 1
    fi
    return 0
}

# Validar RAM
validate_ram() {
    local ram=$1
    if ! [[ "$ram" =~ ^[0-9]+$ ]] || [ "$ram" -lt 1 ]; then
        print_error "RAM inválida. Debe ser un número positivo"
        return 1
    fi
    return 0
}

# Validar nombre de carpeta
validate_folder_name() {
    local name=$1
    if [[ "$name" =~ [^a-zA-Z0-9_-] ]]; then
        print_error "El nombre de carpeta solo puede contener letras, números, guiones y guiones bajos"
        return 1
    fi
    return 0
}

#############################################################################
# VERIFICACIÓN DE JAVA
#############################################################################

check_java() {
    print_header "Verificando Instalación de Java"
    
    if command -v java &> /dev/null; then
        JAVA_VERSION_INSTALLED=$(java -version 2>&1 | grep -oP '(?<=\")[0-9]+' | head -1 || echo "desconocida")
        print_success "Java $JAVA_VERSION_INSTALLED encontrado"
        
        if [[ $JAVA_VERSION_INSTALLED -ge 21 ]]; then
            print_success "Java version es compatible (≥ 21)"
            return 0
        else
            print_warning "Java $JAVA_VERSION_INSTALLED es inferior a 21, se recomienda actualizar"
            return 1
        fi
    else
        print_error "Java no está instalado"
        return 1
    fi
}

install_java() {
    print_header "Instalando Java 21"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            print_info "Detectado sistema Debian/Ubuntu"
            sudo apt update
            sudo apt install -y openjdk-21-jdk
            print_success "Java 21 instalado correctamente"
        elif command -v yum &> /dev/null; then
            print_info "Detectado sistema RedHat/CentOS"
            sudo yum install -y java-21-openjdk java-21-openjdk-devel
            print_success "Java 21 instalado correctamente"
        else
            print_error "Gestor de paquetes no reconocido. Instala Java 21 manualmente"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Detectado macOS"
        if command -v brew &> /dev/null; then
            brew install openjdk@21
            print_success "Java 21 instalado correctamente"
        else
            print_error "Homebrew no encontrado. Instala Homebrew primero: https://brew.sh"
            exit 1
        fi
    else
        print_error "Sistema operativo no soportado automáticamente"
        exit 1
    fi
}

#############################################################################
# OBTENCIÓN DE IP
#############################################################################

get_network_info() {
    print_header "Obteniendo Información de Red"
    
    # IP Privada
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PRIVATE_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
    else
        PRIVATE_IP=$(hostname -I | awk '{print $1}')
    fi
    print_success "IP Privada Local: $PRIVATE_IP"
    
    # IP Pública con reintentos
    print_info "Obteniendo IP Pública (esto puede tardar unos segundos)..."
    
    PUBLIC_IP=""
    
    # Intento 1: ipify
    if [[ -z "$PUBLIC_IP" ]]; then
        if check_command curl; then
            PUBLIC_IP=$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null || echo "")
        elif check_command wget; then
            PUBLIC_IP=$(wget -qO- --timeout=5 https://api.ipify.org 2>/dev/null || echo "")
        fi
    fi
    
    # Intento 2: icanhazip
    if [[ -z "$PUBLIC_IP" ]]; then
        if check_command curl; then
            PUBLIC_IP=$(curl -s --max-time 5 http://icanhazip.com 2>/dev/null || echo "")
        elif check_command wget; then
            PUBLIC_IP=$(wget -qO- --timeout=5 http://icanhazip.com 2>/dev/null || echo "")
        fi
    fi
    
    if [[ -n "$PUBLIC_IP" ]]; then
        print_success "IP Pública: $PUBLIC_IP"
    else
        print_warning "No se pudo obtener IP pública automáticamente"
        read -p "Ingresa tu IP pública manualmente (o presiona Enter para omitir): " PUBLIC_IP
        if [[ -z "$PUBLIC_IP" ]]; then
            PUBLIC_IP="[NO CONFIGURADA]"
        fi
    fi
}

#############################################################################
# SELECCIÓN DE VERSIÓN CON SUBMENU
#############################################################################

select_version() {
    print_header "Selecciona la Versión de Minecraft"
    
    echo "Versiones disponibles:"
    echo "  1) 1.21.10 (Última - Recomendado)"
    echo "  2) 1.21.8"
    echo "  3) 1.21.6"
    echo "  4) 1.21.4"
    echo "  5) 📂 Más versiones..."
    
    read -p "Selecciona una opción (1-5): " version_choice
    
    case $version_choice in
        1) MINECRAFT_VERSION="1.21.10" ;;
        2) MINECRAFT_VERSION="1.21.8" ;;
        3) MINECRAFT_VERSION="1.21.6" ;;
        4) MINECRAFT_VERSION="1.21.4" ;;
        5) select_version_submenu ;;
        *) 
            print_error "Opción inválida"
            select_version
            return
            ;;
    esac
    
    print_success "Versión seleccionada: $MINECRAFT_VERSION"
}

select_version_submenu() {
    print_header "📂 MÁS VERSIONES DE MINECRAFT"
    
    while true; do
        echo "Selecciona una categoría:"
        echo "  1) Versión 1.20.x"
        echo "  2) Versión 1.19.x"
        echo "  3) Versión 1.18.x"
        echo "  4) Versión 1.17.x"
        echo "  5) Versión 1.16.x"
        echo "  6) Versión 1.15.x"
        echo "  7) Versión 1.14.x"
        echo "  8) Versión 1.12.x"
        echo "  9) Versión 1.11.x"
        echo "  10) Versión 1.10.x"
        echo "  0) Volver atrás"
        
        read -p "Selecciona categoría (0-10): " category_choice
        
        case $category_choice in
            1) select_version_category "VERSIONS_1_20[@]" "1.20.x" ;;
            2) select_version_category "VERSIONS_1_19[@]" "1.19.x" ;;
            3) select_version_category "VERSIONS_1_18[@]" "1.18.x" ;;
            4) select_version_category "VERSIONS_1_17[@]" "1.17.x" ;;
            5) select_version_category "VERSIONS_1_16[@]" "1.16.x" ;;
            6) select_version_category "VERSIONS_1_15[@]" "1.15.x" ;;
            7) select_version_category "VERSIONS_1_14[@]" "1.14.x" ;;
            8) select_version_category "VERSIONS_1_12[@]" "1.12.x" ;;
            9) select_version_category "VERSIONS_1_11[@]" "1.11.x" ;;
            10) select_version_category "VERSIONS_1_10[@]" "1.10.x" ;;
            0) return ;;
            *) print_error "Opción inválida" ;;
        esac
        
        if [[ -n "$MINECRAFT_VERSION" ]]; then
            print_success "Versión seleccionada: $MINECRAFT_VERSION"
            return
        fi
    done
}

select_version_category() {
    local array_ref=$1
    local category=$2
    
    print_header "Selecciona versión de $category"
    
    # Obtener el array dinámicamente
    local array_name="${array_ref%[@]*}"
    local versions=("${!array_name}")
    
    echo "Versiones disponibles:"
    for i in "${!versions[@]}"; do
        echo "  $((i+1))) ${versions[$i]}"
    done
    echo "  0) Volver"
    
    read -p "Selecciona una versión: " version_choice
    
    if [[ $version_choice -eq 0 ]]; then
        return
    elif [[ $version_choice -ge 1 && $version_choice -le ${#versions[@]} ]]; then
        MINECRAFT_VERSION="${versions[$((version_choice-1))]}"
    else
        print_error "Opción inválida"
        select_version_category "$array_ref" "$category"
    fi
}

#############################################################################
# SELECCIÓN DE TIPO DE SERVIDOR
#############################################################################

select_server_type() {
    print_header "Selecciona el Tipo de Servidor"
    
    echo "Opciones disponibles:"
    echo "  1) Vanilla (Servidor Oficial)"
    echo "  2) Paper (Optimizado, soporta plugins)"
    echo "  3) Forge (Soporta mods)"
    
    read -p "Selecciona una opción (1-3): " server_choice
    
    case $server_choice in
        1)
            SERVER_TYPE="vanilla"
            print_success "Servidor Vanilla seleccionado"
            ;;
        2)
            SERVER_TYPE="paper"
            print_success "Servidor Paper seleccionado"
            ;;
        3)
            SERVER_TYPE="forge"
            print_success "Servidor Forge seleccionado"
            ;;
        *)
            print_error "Opción inválida"
            select_server_type
            ;;
    esac
}

#############################################################################
# CONFIGURACIÓN RÁPIDA
#############################################################################

select_basic_config() {
    print_header "Configuración Rápida"
    
    # Validar nombre de carpeta
    while true; do
        read -p "Nombre de la carpeta contenedora [default: 'minecraft_server']: " input
        input="${input:-minecraft_server}"
        if validate_folder_name "$input"; then
            SERVER_FOLDER_NAME="$input"
            SERVER_DIR="$SCRIPT_DIR/$SERVER_FOLDER_NAME"
            break
        fi
    done
    
    read -p "MOTD (Descripción del servidor) [default: '$MOTD']: " input
    [[ -n "$input" ]] && MOTD="$input"
    
    read -p "Número máximo de jugadores [default: $MAX_PLAYERS]: " input
    if [[ -n "$input" ]]; then
        if [[ "$input" =~ ^[0-9]+$ ]]; then
            MAX_PLAYERS="$input"
        else
            print_warning "Valor inválido, usando default: $MAX_PLAYERS"
        fi
    fi
    
    # Validar puerto
    while true; do
        read -p "Puerto del servidor [default: $SERVER_PORT]: " input
        input="${input:-$SERVER_PORT}"
        if validate_port "$input"; then
            SERVER_PORT="$input"
            break
        fi
    done
    
    read -p "Modo de juego (survival/creative/adventure) [default: $GAMEMODE]: " input
    [[ -n "$input" ]] && GAMEMODE="$input"
    
    read -p "Dificultad (peaceful/easy/normal/hard) [default: $DIFFICULTY]: " input
    [[ -n "$input" ]] && DIFFICULTY="$input"
    
    read -p "¿Modo online (s/n)? [default: s]: " online_choice
    [[ "$online_choice" == "n" || "$online_choice" == "N" ]] && ONLINE_MODE="false" || ONLINE_MODE="true"
    
    print_success "Configuración rápida completada"
}

#############################################################################
# CONFIGURACIÓN AVANZADA (TRUNCADA - Same as before)
#############################################################################

show_advanced_menu() {
    print_header "⚙️  CONFIGURACIÓN AVANZADA"
    
    while true; do
        echo ""
        echo "Selecciona un parámetro para editar:"
        echo ""
        echo "  1)  Nombre de carpeta contenedora   (Actual: $SERVER_FOLDER_NAME)"
        echo "  2)  MOTD (Descripción servidor)     (Actual: $MOTD)"
        echo "  3)  Nombre del mundo (nivel)        (Actual: $LEVEL_NAME)"
        echo "  4)  Puerto                          (Actual: $SERVER_PORT)"
        echo "  5)  Modo de juego                   (Actual: $GAMEMODE)"
        echo "  6)  Dificultad                      (Actual: $DIFFICULTY)"
        echo "  7)  Máximo de jugadores             (Actual: $MAX_PLAYERS)"
        echo "  8)  Modo online                     (Actual: $ONLINE_MODE)"
        echo "  9)  PvP habilitado                  (Actual: $PVP)"
        echo "  10) Protección de spawn             (Actual: $SPAWN_PROTECTION)"
        echo "  11) Lista blanca                    (Actual: $WHITE_LIST)"
        echo "  12) Bloques de comandos             (Actual: $ENABLE_COMMAND_BLOCK)"
        echo "  13) Semilla del mundo               (Actual: ${LEVEL_SEED:-[Aleatoria]})"
        echo "  14) Distancia de visión             (Actual: $VIEW_DISTANCE)"
        echo "  15) RCON habilitado                 (Actual: $ENABLE_RCON)"
        echo "  16) Puerto RCON                     (Actual: $RCON_PORT)"
        echo "  17) Contraseña RCON                 (Actual: ••••••••)"
        echo "  18) Permitir vuelo                  (Actual: $ALLOW_FLIGHT)"
        echo "  19) Altura máxima de construcción   (Actual: $MAX_BUILD_HEIGHT)"
        echo "  20) RAM mínima del servidor         (Actual: ${MIN_RAM}GB)"
        echo "  21) RAM máxima del servidor         (Actual: ${MAX_RAM}GB)"
        echo "  22) Ver resumen actual"
        echo "  23) Volver al menú principal"
        echo ""
        
        read -p "Selecciona una opción (1-23): " adv_choice
        
        case $adv_choice in
            1) edit_folder_name ;;
            2) edit_motd ;;
            3) edit_level_name ;;
            4) edit_port ;;
            5) edit_gamemode ;;
            6) edit_difficulty ;;
            7) edit_max_players ;;
            8) edit_online_mode ;;
            9) edit_pvp ;;
            10) edit_spawn_protection ;;
            11) edit_whitelist ;;
            12) edit_command_blocks ;;
            13) edit_level_seed ;;
            14) edit_view_distance ;;
            15) edit_rcon_enabled ;;
            16) edit_rcon_port ;;
            17) edit_rcon_password ;;
            18) edit_allow_flight ;;
            19) edit_max_build_height ;;
            20) edit_min_ram ;;
            21) edit_max_ram ;;
            22) show_current_config ;;
            23) return ;;
            *) print_error "Opción inválida" ;;
        esac
    done
}

# (Todos los edit_* functions del script anterior - omitidos por espacio)

edit_folder_name() {
    print_subheader "Editar Nombre de Carpeta Contenedora"
    print_info "Actual: $SERVER_FOLDER_NAME"
    print_info "Esta es la carpeta principal que contiene todo el servidor"
    while true; do
        read -p "Nuevo nombre: " new_value
        if [[ -n "$new_value" ]]; then
            if validate_folder_name "$new_value"; then
                SERVER_FOLDER_NAME="$new_value"
                SERVER_DIR="$SCRIPT_DIR/$SERVER_FOLDER_NAME"
                print_success "Nombre de carpeta actualizado a: $SERVER_FOLDER_NAME"
                break
            fi
        fi
    done
}

edit_motd() {
    print_subheader "Editar MOTD (Message Of The Day)"
    print_info "Actual: $MOTD"
    print_info "Este es el mensaje que ven los jugadores en la lista de servidores"
    read -p "Nuevo MOTD: " new_value
    [[ -n "$new_value" ]] && MOTD="$new_value" && print_success "MOTD actualizado"
}

edit_level_name() {
    print_subheader "Editar Nombre del Mundo (Nivel)"
    print_info "Actual: $LEVEL_NAME"
    print_info "Este es el nombre de la carpeta donde se guardan los datos del mundo"
    read -p "Nuevo nombre: " new_value
    [[ -n "$new_value" ]] && LEVEL_NAME="$new_value" && print_success "Nombre del mundo actualizado"
}

edit_port() {
    print_subheader "Editar Puerto"
    print_info "Actual: $SERVER_PORT"
    print_info "Puerto por defecto: 25565 (recuerda abrir en router)"
    while true; do
        read -p "Nuevo puerto: " new_value
        if validate_port "$new_value"; then
            SERVER_PORT="$new_value"
            print_success "Puerto actualizado a: $SERVER_PORT"
            break
        fi
    done
}

edit_gamemode() {
    print_subheader "Editar Modo de Juego"
    print_info "Actual: $GAMEMODE"
    echo "  1) survival   - Modo clásico con hambre y daño"
    echo "  2) creative   - Modo creativo sin límites"
    echo "  3) adventure  - Modo aventura (solo lectura)"
    echo "  4) spectator  - Modo espectador"
    read -p "Selecciona modo (1-4): " gm_choice
    case $gm_choice in
        1) GAMEMODE="survival" ;;
        2) GAMEMODE="creative" ;;
        3) GAMEMODE="adventure" ;;
        4) GAMEMODE="spectator" ;;
        *) print_error "Opción inválida" ;;
    esac
    print_success "Modo de juego: $GAMEMODE"
}

edit_difficulty() {
    print_subheader "Editar Dificultad"
    print_info "Actual: $DIFFICULTY"
    echo "  1) peaceful  - Sin monstruos, regeneración automática"
    echo "  2) easy      - Monstruos débiles, poco daño"
    echo "  3) normal    - Experiencia Minecraft estándar"
    echo "  4) hard      - Monstruos fuertes, hambre importante"
    read -p "Selecciona dificultad (1-4): " diff_choice
    case $diff_choice in
        1) DIFFICULTY="peaceful" ;;
        2) DIFFICULTY="easy" ;;
        3) DIFFICULTY="normal" ;;
        4) DIFFICULTY="hard" ;;
        *) print_error "Opción inválida" ;;
    esac
    print_success "Dificultad: $DIFFICULTY"
}

edit_max_players() {
    print_subheader "Editar Máximo de Jugadores"
    print_info "Actual: $MAX_PLAYERS"
    print_info "Recomendación: 1-5 jugadores por GB de RAM"
    read -p "Nuevo máximo: " new_value
    if [[ -n "$new_value" ]] && [[ "$new_value" =~ ^[0-9]+$ ]]; then
        MAX_PLAYERS="$new_value"
        print_success "Actualizado"
    fi
}

edit_online_mode() {
    print_subheader "Editar Modo Online"
    print_info "Actual: $ONLINE_MODE"
    echo "  true  - Verifica licencias de Minecraft (recomendado)"
    echo "  false - Cualquiera puede conectarse sin verificación"
    read -p "¿Activar verificación? (s/n): " online_choice
    [[ "$online_choice" == "s" || "$online_choice" == "S" ]] && ONLINE_MODE="true" || ONLINE_MODE="false"
    print_success "Modo online: $ONLINE_MODE"
}

edit_pvp() {
    print_subheader "Editar PvP (Jugador vs Jugador)"
    print_info "Actual: $PVP"
    echo "  true  - Jugadores pueden atacarse entre sí"
    echo "  false - No hay combate entre jugadores"
    read -p "¿Activar PvP? (s/n): " pvp_choice
    [[ "$pvp_choice" == "s" || "$pvp_choice" == "S" ]] && PVP="true" || PVP="false"
    print_success "PvP: $PVP"
}

edit_spawn_protection() {
    print_subheader "Editar Protección de Spawn"
    print_info "Actual: $SPAWN_PROTECTION bloques"
    print_info "Distancia en bloques alrededor del spawn (0 = desactivado)"
    read -p "Nuevo valor: " new_value
    if [[ -n "$new_value" ]] && [[ "$new_value" =~ ^[0-9]+$ ]]; then
        SPAWN_PROTECTION="$new_value"
        print_success "Actualizado"
    fi
}

edit_whitelist() {
    print_subheader "Editar Lista Blanca"
    print_info "Actual: $WHITE_LIST"
    echo "  true  - Solo jugadores en lista blanca pueden conectarse"
    echo "  false - Cualquiera puede conectarse"
    read -p "¿Activar lista blanca? (s/n): " wl_choice
    [[ "$wl_choice" == "s" || "$wl_choice" == "S" ]] && WHITE_LIST="true" || WHITE_LIST="false"
    print_success "Lista blanca: $WHITE_LIST"
}

edit_command_blocks() {
    print_subheader "Editar Bloques de Comandos"
    print_info "Actual: $ENABLE_COMMAND_BLOCK"
    echo "  true  - Bloques de comandos funcionan"
    echo "  false - Bloques de comandos desactivados"
    read -p "¿Activar bloques de comandos? (s/n): " cb_choice
    [[ "$cb_choice" == "s" || "$cb_choice" == "S" ]] && ENABLE_COMMAND_BLOCK="true" || ENABLE_COMMAND_BLOCK="false"
    print_success "Bloques de comandos: $ENABLE_COMMAND_BLOCK"
}

edit_level_seed() {
    print_subheader "Editar Semilla del Mundo"
    print_info "Actual: ${LEVEL_SEED:-[Aleatoria]}"
    print_info "Deja vacío para una semilla aleatoria"
    read -p "Nueva semilla: " new_value
    LEVEL_SEED="$new_value"
    [[ -z "$LEVEL_SEED" ]] && print_success "Semilla aleatoria" || print_success "Semilla establecida"
}

edit_view_distance() {
    print_subheader "Editar Distancia de Visión"
    print_info "Actual: $VIEW_DISTANCE chunks"
    print_info "Mayor = mejor visual pero menos rendimiento (10 es estándar, 5-8 para rendimiento)"
    read -p "Nuevo valor (3-32): " new_value
    if [[ -n "$new_value" ]] && [[ "$new_value" =~ ^[0-9]+$ ]]; then
        VIEW_DISTANCE="$new_value"
        print_success "Actualizado"
    fi
}

edit_rcon_enabled() {
    print_subheader "Editar RCON (Remote Console)"
    print_info "Actual: $ENABLE_RCON"
    echo "  true  - Permite control remoto del servidor"
    echo "  false - RCON desactivado"
    read -p "¿Activar RCON? (s/n): " rcon_choice
    [[ "$rcon_choice" == "s" || "$rcon_choice" == "S" ]] && ENABLE_RCON="true" || ENABLE_RCON="false"
    print_success "RCON: $ENABLE_RCON"
}

edit_rcon_port() {
    print_subheader "Editar Puerto RCON"
    print_info "Actual: $RCON_PORT"
    while true; do
        read -p "Nuevo puerto: " new_value
        if validate_port "$new_value"; then
            RCON_PORT="$new_value"
            print_success "Puerto RCON actualizado"
            break
        fi
    done
}

edit_rcon_password() {
    print_subheader "Editar Contraseña RCON"
    print_info "Actual: ••••••••"
    read -p "Nueva contraseña: " new_value
    [[ -n "$new_value" ]] && RCON_PASSWORD="$new_value" && print_success "Contraseña actualizada"
}

edit_allow_flight() {
    print_subheader "Editar Vuelo Permitido"
    print_info "Actual: $ALLOW_FLIGHT"
    echo "  true  - Los jugadores pueden volar (creativo/adventure)"
    echo "  false - Vuelo solo en modo creativo"
    read -p "¿Permitir vuelo? (s/n): " flight_choice
    [[ "$flight_choice" == "s" || "$flight_choice" == "S" ]] && ALLOW_FLIGHT="true" || ALLOW_FLIGHT="false"
    print_success "Vuelo: $ALLOW_FLIGHT"
}

edit_max_build_height() {
    print_subheader "Editar Altura Máxima de Construcción"
    print_info "Actual: $MAX_BUILD_HEIGHT bloques"
    print_info "Por defecto en 1.21: 320"
    read -p "Nueva altura: " new_value
    if [[ -n "$new_value" ]] && [[ "$new_value" =~ ^[0-9]+$ ]]; then
        MAX_BUILD_HEIGHT="$new_value"
        print_success "Actualizado"
    fi
}

edit_min_ram() {
    print_subheader "Editar RAM Mínima del Servidor"
    print_info "Actual: ${MIN_RAM}GB"
    print_info "RAM mínima que el servidor usará"
    echo "  Recomendaciones:"
    echo "  - Servidor pequeño (1-5 jugadores): 1-2 GB"
    echo "  - Servidor mediano (5-15 jugadores): 2-4 GB"
    echo "  - Servidor grande (15+ jugadores): 4+ GB"
    while true; do
        read -p "Nueva RAM mínima (en GB): " new_value
        if validate_ram "$new_value"; then
            MIN_RAM="$new_value"
            print_success "RAM mínima establecida a: ${MIN_RAM}GB"
            break
        fi
    done
}

edit_max_ram() {
    print_subheader "Editar RAM Máxima del Servidor"
    print_info "Actual: ${MAX_RAM}GB"
    print_info "RAM máxima que el servidor puede usar"
    echo "  Recomendaciones:"
    echo "  - Servidor pequeño (1-5 jugadores): 2-4 GB"
    echo "  - Servidor mediano (5-15 jugadores): 4-8 GB"
    echo "  - Servidor grande (15+ jugadores): 8-16 GB"
    while true; do
        read -p "Nueva RAM máxima (en GB): " new_value
        if validate_ram "$new_value"; then
            MAX_RAM="$new_value"
            print_success "RAM máxima establecida a: ${MAX_RAM}GB"
            break
        fi
    done
}

show_current_config() {
    print_header "📋 RESUMEN DE CONFIGURACIÓN ACTUAL"
    
    echo -e "${CYAN}Estructura de Carpetas:${NC}"
    echo "  Carpeta contenedora         : $SERVER_FOLDER_NAME"
    echo "  Ruta completa              : $SERVER_DIR"
    echo "  Carpeta del mundo           : $LEVEL_NAME"
    
    echo -e "\n${CYAN}Información Básica:${NC}"
    echo "  MOTD (Descripción)         : $MOTD"
    echo "  Puerto                     : $SERVER_PORT"
    echo "  Versión Minecraft          : $MINECRAFT_VERSION"
    echo "  Tipo de servidor           : $SERVER_TYPE"
    
    echo -e "\n${CYAN}Gameplay:${NC}"
    echo "  Modo de juego              : $GAMEMODE"
    echo "  Dificultad                 : $DIFFICULTY"
    echo "  PvP habilitado             : $PVP"
    echo "  Vuelo permitido            : $ALLOW_FLIGHT"
    echo "  Altura máxima de construcción : $MAX_BUILD_HEIGHT"
    
    echo -e "\n${CYAN}Jugadores:${NC}"
    echo "  Máximo de jugadores        : $MAX_PLAYERS"
    echo "  Modo online                : $ONLINE_MODE"
    echo "  Lista blanca               : $WHITE_LIST"
    echo "  Protección de spawn        : $SPAWN_PROTECTION"
    
    echo -e "\n${CYAN}Mundo:${NC}"
    echo "  Semilla                    : ${LEVEL_SEED:-[Aleatoria]}"
    echo "  Distancia de visión        : $VIEW_DISTANCE chunks"
    
    echo -e "\n${CYAN}Control Remoto (RCON):${NC}"
    echo "  RCON habilitado            : $ENABLE_RCON"
    echo "  Puerto RCON                : $RCON_PORT"
    
    echo -e "\n${CYAN}Características:${NC}"
    echo "  Bloques de comandos        : $ENABLE_COMMAND_BLOCK"
    
    echo -e "\n${CYAN}Memoria (RAM):${NC}"
    echo "  RAM mínima                 : ${MIN_RAM}GB"
    echo "  RAM máxima                 : ${MAX_RAM}GB"
    
    echo ""
    pause_script
}

#############################################################################
# DESCARGA DE SERVIDOR
#############################################################################

download_vanilla_server() {
    print_header "Descargando Servidor Vanilla ($MINECRAFT_VERSION)"
    
    declare -A VANILLA_URLS=(
        ["1.21.10"]="https://piston-data.mojang.com/v1/objects/95495a7f485eedd84ce928cef5e223b757d2f764/server.jar"
        ["1.21.8"]="https://piston-data.mojang.com/v1/objects/6bce4ef400e4efaa63a13d5e6f6b500be969ef81/server.jar"
        ["1.21.6"]="https://piston-data.mojang.com/v1/objects/1ab5390fd6d5da60f08d13ea3f35db89aab1e6ac/server.jar"
        ["1.21.4"]="https://piston-data.mojang.com/v1/objects/d5f32fc73e8f7417f32ddae2706ac0bf0a0c5cfb/server.jar"
        ["1.20.4"]="https://piston-data.mojang.com/v1/objects/3437e7f1868b80f73967b96ce225219b5f15e28e/server.jar"
        ["1.20.3"]="https://piston-data.mojang.com/v1/objects/e2004aff91aec0163e8f59ab4c2e3e4c80c98e16/server.jar"
        ["1.20.2"]="https://piston-data.mojang.com/v1/objects/c9064d0894d03479d63684f6840d5371b6b8ee1e/server.jar"
        ["1.20.1"]="https://piston-data.mojang.com/v1/objects/84b2e061efccf23eee218f16367e61491c5c8d82/server.jar"
        ["1.19.2"]="https://piston-data.mojang.com/v1/objects/f00c3471e548ab20d7f72b426f61b3bcc2591302/server.jar"
        ["1.19.1"]="https://piston-data.mojang.com/v1/objects/d2216616697cf14d92e480864e03c37ab92b0d72/server.jar"
        ["1.19"]="https://piston-data.mojang.com/v1/objects/7e4c3d22d62c25e8ffc0843e9ce8a2e0d2a00ae5/server.jar"
        ["1.18.2"]="https://piston-data.mojang.com/v1/objects/c8f83c5655308435b3dcf03f06144bb0d287d1c91/server.jar"
        ["1.18.1"]="https://piston-data.mojang.com/v1/objects/3cf24a8694281d40dd1873d7b57ce089328deca9/server.jar"
        ["1.18"]="https://piston-data.mojang.com/v1/objects/3dc3d84a581f14691b13b6b91ff53522ba9e5a33/server.jar"
        ["1.17.1"]="https://piston-data.mojang.com/v1/objects/a16d67e5807f57fc4e550c051b920dda67045b76/server.jar"
        ["1.17"]="https://piston-data.mojang.com/v1/objects/0c2569fcf3ffc4211df34a2ae29693ee2709b5ff/server.jar"
        ["1.16.5"]="https://piston-data.mojang.com/v1/objects/1b557e7b033b583d006f4b7573965bb82823c3dd/server.jar"
        ["1.16.4"]="https://piston-data.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar"
        ["1.16.3"]="https://piston-data.mojang.com/v1/objects/f02f4473dbf152c23d7d484952121db0569d4909/server.jar"
        ["1.16.2"]="https://piston-data.mojang.com/v1/objects/c5f6fb23c3876461d46ec380421e42b289789530/server.jar"
        ["1.16.1"]="https://piston-data.mojang.com/v1/objects/a412fd69db1f81db3f511c1791d6e6698666e909/server.jar"
        ["1.15.2"]="https://piston-data.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149b5c1112fce67720d/server.jar"
        ["1.15.1"]="https://piston-data.mojang.com/v1/objects/4d60468b3bcc0b18550环境d64cb6e8e25bef4d53/server.jar"
        ["1.15"]="https://piston-data.mojang.com/v1/objects/ed76ed597ea6635bcc899d6af6f55f3547314볼/server.jar"
        ["1.14.4"]="https://piston-data.mojang.com/v1/objects/e0604713079862373eff479535ab624fdde8043f/server.jar"
        ["1.14.3"]="https://piston-data.mojang.com/v1/objects/d0d0fe2b6932e3e07d12d653d7572ba7cb7dc2e9/server.jar"
        ["1.14.2"]="https://piston-data.mojang.com/v1/objects/808be3869e2ca6b62378f1bd418c4d69c7681only/server.jar"
        ["1.14.1"]="https://piston-data.mojang.com/v1/objects/2ecc8ef3fb56e213dcc4b31043dae2588b fd/server.jar"
        ["1.14"]="https://piston-data.mojang.com/v1/objects/f1a0073671057f01aa7d01b0571a0791562af8fb/server.jar"
        ["1.12.2"]="https://piston-data.mojang.com/v1/objects/88887b7937495e422b2913a8628aa24bd8de0b07/server.jar"
        ["1.12.1"]="https://piston-data.mojang.com/v1/objects/6820b4dada4467b10158e43ce3f51cdc326b38df/server.jar"
        ["1.12"]="https://piston-data.mojang.com/v1/objects/8494e92e9fcc6e879c4eb1580f9f00496c0ebe7f/server.jar"
        ["1.11.2"]="https://piston-data.mojang.com/v1/objects/f00c3471e548ab20d7f72b426f61b3bcc2591302/server.jar"
        ["1.11.1"]="https://piston-data.mojang.com/v1/objects/03d8371cd36e4704b57b7bff374de5934c4be251/server.jar"
        ["1.11"]="https://piston-data.mojang.com/v1/objects/3737db93722190ce681435c41c487039b59f1d99/server.jar"
        ["1.10.2"]="https://piston-data.mojang.com/v1/objects/846e1503127d737fb579bb9baa36fb9d0d732e42/server.jar"
        ["1.10.1"]="https://piston-data.mojang.com/v1/objects/b58b2cea346ce0862bc1c6bf75f5201796b7221b/server.jar"
        ["1.10"]="https://piston-data.mojang.com/v1/objects/9eef99421540686d17ad0e318265afcc1244e38d9/server.jar"
    )
    
    if [[ -z "${VANILLA_URLS[$MINECRAFT_VERSION]}" ]]; then
        print_error "Versión $MINECRAFT_VERSION no soportada o no disponible"
        exit 1
    fi
    
    DOWNLOAD_URL="${VANILLA_URLS[$MINECRAFT_VERSION]}"
    print_info "Descargando desde: $DOWNLOAD_URL"
    
    mkdir -p "$SERVER_DIR"
    
    local max_attempts=3
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        print_info "Intento $attempt de $max_attempts..."
        
        if check_command curl; then
            if curl -f -L --max-time 300 -o "$SERVER_DIR/server.jar" "$DOWNLOAD_URL" 2>/dev/null; then
                print_success "Servidor descargado correctamente"
                return 0
            fi
        elif check_command wget; then
            if wget -q --timeout=300 -O "$SERVER_DIR/server.jar" "$DOWNLOAD_URL" 2>/dev/null; then
                print_success "Servidor descargado correctamente"
                return 0
            fi
        else
            print_error "curl o wget no están disponibles"
            exit 1
        fi
        
        attempt=$((attempt + 1))
        if [[ $attempt -le $max_attempts ]]; then
            print_warning "Reintentando en 5 segundos..."
            sleep 5
        fi
    done
    
    print_error "Error al descargar el servidor después de $max_attempts intentos"
    exit 1
}

download_paper_server() {
    print_header "Descargando Servidor Paper ($MINECRAFT_VERSION)"
    
    mkdir -p "$SERVER_DIR"
    print_info "Consultando API de PaperMC..."
    
    if ! check_command curl && ! check_command wget; then
        print_error "Se requiere curl o wget para descargar Paper"
        exit 1
    fi
    
    local api_url="https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION"
    
    if check_command curl; then
        BUILDS=$(curl -s -A "$USER_AGENT" "$api_url" | grep -o '"builds":\[[0-9,]*\]' | grep -o '[0-9]*' | tail -1 2>/dev/null || echo "")
    elif check_command wget; then
        BUILDS=$(wget -qO- --user-agent="$USER_AGENT" "$api_url" | grep -o '"builds":\[[0-9,]*\]' | grep -o '[0-9]*' | tail -1 2>/dev/null || echo "")
    fi
    
    if [[ -z "$BUILDS" ]]; then
        print_error "No se pudo obtener el build más reciente de Paper para la versión $MINECRAFT_VERSION"
        exit 1
    fi
    
    LATEST_BUILD="$BUILDS"
    print_success "Build más reciente de Paper: $LATEST_BUILD"
    
    DOWNLOAD_URL="https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$LATEST_BUILD/downloads/paper-$MINECRAFT_VERSION-$LATEST_BUILD.jar"
    
    print_info "Descargando Paper build $LATEST_BUILD..."
    
    local max_attempts=3
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        print_info "Intento $attempt de $max_attempts..."
        
        if check_command curl; then
            if curl -f -L --max-time 300 -A "$USER_AGENT" -o "$SERVER_DIR/server.jar" "$DOWNLOAD_URL" 2>/dev/null; then
                print_success "Servidor Paper descargado correctamente"
                return 0
            fi
        elif check_command wget; then
            if wget -q --timeout=300 --user-agent="$USER_AGENT" -O "$SERVER_DIR/server.jar" "$DOWNLOAD_URL" 2>/dev/null; then
                print_success "Servidor Paper descargado correctamente"
                return 0
            fi
        fi
        
        attempt=$((attempt + 1))
        if [[ $attempt -le $max_attempts ]]; then
            print_warning "Reintentando en 5 segundos..."
            sleep 5
        fi
    done
    
    print_error "Error al descargar Paper después de $max_attempts intentos"
    exit 1
}

download_forge_server() {
    print_header "Descargando Servidor Forge ($MINECRAFT_VERSION)"
    
    print_warning "La descarga de Forge es más compleja y requiere configuración adicional"
    print_info "Por favor, descarga manualmente Forge desde: https://files.minecraftforge.net"
    print_info "Pasos:"
    print_info "1. Visita https://files.minecraftforge.net"
    print_info "2. Selecciona Minecraft versión $MINECRAFT_VERSION"
    print_info "3. Descarga el archivo 'Installer' (no MDK o Source)"
    print_info "4. Ejecuta: java -jar forge-installer-*.jar --installServer"
    
    exit 1
}

download_server() {
    case $SERVER_TYPE in
        vanilla)
            download_vanilla_server
            ;;
        paper)
            download_paper_server
            ;;
        forge)
            download_forge_server
            ;;
    esac
}

#############################################################################
# DESCARGA DE ICONO
#############################################################################

download_server_icon() {
    print_info "Descargando icono del servidor..."
    
    if check_command curl; then
        if curl -f -L --max-time 60 -o "$SERVER_DIR/server-icon.png" "$ICON_URL" 2>/dev/null; then
            print_success "Icono del servidor descargado correctamente"
            return 0
        fi
    elif check_command wget; then
        if wget -q --timeout=60 -O "$SERVER_DIR/server-icon.png" "$ICON_URL" 2>/dev/null; then
            print_success "Icono del servidor descargado correctamente"
            return 0
        fi
    fi
    
    print_warning "No se pudo descargar el icono predeterminado. Puedes añadirlo manualmente después."
    return 0
}

#############################################################################
# CONFIGURACIÓN DEL SERVIDOR
#############################################################################

configure_server() {
    print_header "Configurando el Servidor"
    
    mkdir -p "$SERVER_DIR"
    
    if [[ "$SERVER_TYPE" == "paper" ]]; then
        mkdir -p "$SERVER_DIR/plugins"
        print_success "Carpeta de plugins creada"
    fi
    
    print_info "Aceptando EULA..."
    echo "eula=true" > "$SERVER_DIR/eula.txt"
    print_success "EULA aceptado"
    
    # Descargar icono
    download_server_icon
}

configure_properties() {
    print_header "Configurando server.properties"
    
    cat > "$SERVER_DIR/server.properties" << EOF
#Minecraft server properties
#Configurado automáticamente - $(date)
#© Copyright 2025 - Nahuel Granollers
motd=$MOTD
server-port=$SERVER_PORT
gamemode=$GAMEMODE
difficulty=$DIFFICULTY
max-players=$MAX_PLAYERS
online-mode=$ONLINE_MODE
pvp=$PVP
spawn-protection=$SPAWN_PROTECTION
white-list=$WHITE_LIST
enable-command-block=$ENABLE_COMMAND_BLOCK
level-name=$LEVEL_NAME
level-seed=$LEVEL_SEED
view-distance=$VIEW_DISTANCE
enable-rcon=$ENABLE_RCON
rcon.password=$RCON_PASSWORD
rcon.port=$RCON_PORT
enable-query=$ENABLE_QUERY
query.port=$QUERY_PORT
allow-flight=$ALLOW_FLIGHT
max-build-height=$MAX_BUILD_HEIGHT
hardcore=$HARDCORE
EOF
    
    print_success "server.properties configurado"
}

#############################################################################
# CREACIÓN DE SCRIPTS DE INICIO
#############################################################################

create_start_script() {
    print_header "Creando Scripts de Inicio"
    
    cat > "$SERVER_DIR/start.sh" << EOF
#!/bin/bash
# Script de inicio del servidor Minecraft
# © Copyright 2025 - Nahuel Granollers
# Configurado con RAM personalizada

echo "════════════════════════════════════════"
echo "Servidor Minecraft - Iniciando"
echo "════════════════════════════════════════"
echo ""

ASSIGNED_MIN_RAM="${MIN_RAM}G"
ASSIGNED_MAX_RAM="${MAX_RAM}G"

echo "RAM mínima asignada: \$ASSIGNED_MIN_RAM"
echo "RAM máxima asignada: \$ASSIGNED_MAX_RAM"
echo ""

java -Xms\$ASSIGNED_MIN_RAM -Xmx\$ASSIGNED_MAX_RAM -jar server.jar nogui
EOF
    
    chmod +x "$SERVER_DIR/start.sh"
    print_success "Script start.sh creado con RAM personalizada"
}

#############################################################################
# INFORMACIÓN FINAL Y COMPARTIR SERVIDOR
#############################################################################

print_final_info() {
    print_header "¡Configuración Completada!"
    
    echo -e "📁 ${BLUE}Estructura de Carpetas:${NC}"
    echo "   Carpeta contenedora: $SERVER_FOLDER_NAME"
    echo "   Ruta completa      : $SERVER_DIR"
    echo "   Mundo (nivel)      : $SERVER_DIR/$LEVEL_NAME"
    
    echo -e "\n🎮 ${BLUE}Configuración del servidor:${NC}"
    echo "   Tipo: $SERVER_TYPE"
    echo "   Versión: $MINECRAFT_VERSION"
    echo "   MOTD (Descripción): $MOTD"
    echo "   Modo: $GAMEMODE"
    echo "   Dificultad: $DIFFICULTY"
    echo "   Jugadores máximo: $MAX_PLAYERS"
    echo "   Puerto: $SERVER_PORT"
    echo "   Modo online: $ONLINE_MODE"
    
    echo -e "\n💾 ${BLUE}Configuración de Memoria:${NC}"
    echo "   RAM mínima: ${MIN_RAM}GB"
    echo "   RAM máxima: ${MAX_RAM}GB"
    
    if [[ "$SERVER_TYPE" == "paper" ]]; then
        echo -e "\n📦 ${BLUE}Para instalar plugins:${NC}"
        echo "   1. Descarga archivos .jar de plugins"
        echo "   2. Cópialos a la carpeta: $SERVER_DIR/plugins"
        echo "   3. Reinicia el servidor con: /stop + ./start.sh"
    fi
    
    echo -e "\n${YELLOW}⚠️  Importante para conexiones remotas:${NC}"
    echo "   • Abre el puerto $SERVER_PORT en tu router (Port Forwarding)"
    echo "   • Comparte tu IP pública: $PUBLIC_IP"
    echo "   • Configura un firewall permitiendo el puerto"

    echo -e "\n🌐 ${BLUE}Información de Red:${NC}"
    echo "   IP Privada (localhost): $PRIVATE_IP:$SERVER_PORT"
    echo "   IP Pública (amigos): $PUBLIC_IP:$SERVER_PORT"
 
    echo ""
}

print_share_server_info() {
    print_header "🎯 DATOS PARA COMPARTIR CON TUS AMIGOS"
    
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║              ✅ SERVIDOR CONFIGURADO Y LISTO                  ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${CYAN}┌─ DATOS DE CONEXIÓN ─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}│  ${GREEN}🌐 IP Pública${NC}      : ${YELLOW}$PUBLIC_IP${NC}"
    echo -e "${CYAN}│  ${GREEN}🔌 Puerto${NC}          : ${YELLOW}$SERVER_PORT${NC}"
    echo -e "${CYAN}│  ${GREEN}👥 Máx Jugadores${NC}   : ${YELLOW}$MAX_PLAYERS${NC}"
    echo -e "${CYAN}│  ${GREEN}🎮 Modo${NC}            : ${YELLOW}$GAMEMODE${NC}"
    echo -e "${CYAN}│  ${GREEN}⚒️  Versión${NC}        : ${YELLOW}$MINECRAFT_VERSION${NC}"
    echo -e "${CYAN}│  ${GREEN}📝 MOTD${NC}            : ${YELLOW}$MOTD${NC}"
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}│  ${MAGENTA}✂️  COPIAR Y PEGAR A TUS AMIGOS:${NC}"
    echo -e "${CYAN}│  ┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  │ ${GREEN}$PUBLIC_IP:$SERVER_PORT${NC}"
    echo -e "${CYAN}│  └─────────────────────────────────────────────────────────┘${NC}"
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}│  ${YELLOW}📌 INSTRUCCIONES PARA TUS AMIGOS:${NC}"
    echo -e "${CYAN}│     1. Abre Minecraft Java Edition${NC}"
    echo -e "${CYAN}│     2. Click en 'Multijugador'${NC}"
    echo -e "${CYAN}│     3. Click en 'Servidor directo'${NC}"
    echo -e "${CYAN}│     4. Pega: ${GREEN}$PUBLIC_IP:$SERVER_PORT${NC}"
    echo -e "${CYAN}│     5. ¡Conecta!${NC}"
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"
    
    echo -e "\n${CYAN}📝 RECORDATORIOS:${NC}"
    echo -e "   • El servidor está ejecutándose en: ${YELLOW}$SERVER_DIR${NC}"
    echo -e "   • Para detenerlo: Presiona ${YELLOW}Ctrl+C${NC} en esta terminal"
    echo -e "   • Para reiniciarlo: ${YELLOW}cd $SERVER_DIR && ./start.sh${NC}"
    echo -e "   • El mundo se guardó en: ${YELLOW}$SERVER_DIR/$LEVEL_NAME${NC}"
    
    echo -e "\n${YELLOW}⚠️  PUERTO EN ROUTER:${NC}"
    echo -e "   • Asegúrate de abrir el puerto ${YELLOW}$SERVER_PORT${NC} en tu router"
    echo -e "   • Sin esto, solo conexiones locales funcionarán"
    
    echo -e "\n${GREEN}© Copyright 2025 - Nahuel Granollers${NC}"
    echo -e "${BLUE}https://github.com/NahuelGranollers/minecraft_auto_server${NC}"
    
    echo ""
}

start_server_now() {
    print_header "🚀 INICIAR SERVIDOR AUTOMÁTICAMENTE"
    
    echo -e "${CYAN}El servidor está configurado y listo para iniciar.${NC}"
    echo ""
    echo "En la primera ejecución:"
    echo "  ✓ Se generará el mundo"
    echo "  ✓ Se crearán carpetas adicionales"
    echo "  ✓ Se prepararán todos los archivos necesarios"
    echo ""
    echo "Cuando veas el mensaje 'Done!' el servidor estará completamente operativo."
    echo ""
    
    read -p "¿Deseas iniciar el servidor ahora? (s/n): " start_choice
    
    if [[ "$start_choice" == "s" || "$start_choice" == "S" ]]; then
        print_header "🎮 INICIANDO SERVIDOR"
        echo -e "${GREEN}El servidor se está iniciando...${NC}"
        echo ""
        echo "Presiona Ctrl+C para detener el servidor en cualquier momento"
        echo "Cuando veas 'Done!' el servidor estará listo para usar"
        echo ""
        pause_script
        
        cd "$SERVER_DIR"
        bash start.sh
        
        # Después de cerrar el servidor, mostrar info de compartir
        print_share_server_info
    else
        print_info "Para iniciar el servidor manualmente, ejecuta:"
        echo ""
        echo "  cd $SERVER_DIR"
        echo "  ./start.sh"
        echo ""
        print_share_server_info
    fi
}

#############################################################################
# MAIN - FLUJO PRINCIPAL
#############################################################################

main() {
    clear
    
    print_header "Configurador Automatizado de Servidor Minecraft v3.1"
    echo -e "${MAGENTA}Todas las versiones disponibles${NC}"
    echo -e "${MAGENTA}© Copyright 2025 - Nahuel Granollers${NC}"
    echo "Configuración Avanzada + Inicio Automático + Icono + Compartir"
    echo ""
    
    # Verificar Java
    if ! check_java; then
        read -p "¿Deseas instalar Java 21? (s/n): " install_choice
        if [[ "$install_choice" == "s" || "$install_choice" == "S" ]]; then
            install_java
        else
            print_error "Java es requerido para ejecutar el servidor"
            exit 1
        fi
    fi
    
    # Obtener información de red
    get_network_info
    pause_script
    
    # Seleccionar versión y tipo
    select_version
    select_server_type
    
    # Configuración
    select_basic_config
    
    # Ofrecer configuración avanzada
    print_header "¿Deseas Configuración Avanzada?"
    echo "Puedes personalizar todos los parámetros del servidor"
    echo "como MOTD, distancia de visión, RCON, RAM asignada, etc."
    echo ""
    read -p "¿Acceder a configuración avanzada? (s/n): " adv_choice
    if [[ "$adv_choice" == "s" || "$adv_choice" == "S" ]]; then
        show_advanced_menu
    fi
    
    # Descargar y configurar
    download_server
    configure_server
    configure_properties
    create_start_script
    
    # Información final
    print_final_info
    
    # Inicio automático
    start_server_now
}

# Ejecutar main
main "$@"
