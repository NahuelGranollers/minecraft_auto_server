#!/bin/bash

#############################################################################
# Script de Configuración Automatizada de Servidor Minecraft (v3.12)
# Descarga, configura e inicia un servidor Minecraft Java Edition
# Compatible con: Vanilla, Paper, Forge
#
# MODO RÁPIDO: 100% automático, sin pausas
# MODO EXPERTO: Personalización completa con consejos inteligentes
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
WHITE='\033[1;37m'
NC='\033[0m'

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$SCRIPT_DIR"
SERVER_FOLDER_NAME="minecraft_server"
JAVA_VERSION="21"
PUBLIC_IP=""
PRIVATE_IP=""
USER_AGENT="MinecraftServerSetup/3.12 (+https://github.com/NahuelGranollers/minecraft_auto_server)"
ICON_URL="https://raw.githubusercontent.com/NahuelGranollers/minecraft_auto_server/refs/heads/main/server_icon/icon.png"
OPERATION_MODE="expert"
LOG_FILE="$SCRIPT_DIR/setup_debug.log"

# Arrays de versiones
declare -a VERSIONS_1_21=("1.21.10" "1.21.8" "1.21.6" "1.21.4")
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

# Configuración por defecto
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
ANNOUNCE_PLAYER_ACHIEVEMENTS="true"
ALLOW_NETHER="true"
ALLOW_END="true"
FORCE_GAMEMODE="false"
NETWORK_COMPRESSION_THRESHOLD="256"
MAX_TICK_TIME="60000"
MAX_CHUNK_SIZE="500"

#############################################################################
# FUNCIONES DE LOGGING
#############################################################################

debug_log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

#############################################################################
# FUNCIONES AUXILIARES
#############################################################################

print_header() {
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
    debug_log "SUCCESS: $1"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    debug_log "ERROR: $1"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    debug_log "WARNING: $1"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
    debug_log "INFO: $1"
}

print_tip() {
    echo -e "${CYAN}💡 $1${NC}"
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

validate_port() {
    local port=$1
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        print_error "Puerto inválido. Debe estar entre 1 y 65535"
        return 1
    fi
    return 0
}

validate_ram() {
    local ram=$1
    if ! [[ "$ram" =~ ^[0-9]+$ ]] || [ "$ram" -lt 1 ]; then
        print_error "RAM inválida. Debe ser un número positivo"
        return 1
    fi
    return 0
}

validate_folder_name() {
    local name=$1
    if [[ "$name" =~ [^a-zA-Z0-9_-] ]]; then
        print_error "El nombre de carpeta solo puede contener letras, números, guiones y guiones bajos"
        return 1
    fi
    return 0
}

#############################################################################
# CONSEJOS INTELIGENTES DE RAM
#############################################################################

show_ram_recommendation_dialog() {
    clear
    print_header "💾 RECOMENDACIÓN DE RAM ÓPTIMA"
    echo -e "${CYAN}Basada en el número de jugadores:${NC}"
    echo ""
    echo -e "  ${GREEN}1-5 Jugadores${NC}"
    echo -e "    RAM mínima: 1 GB"
    echo -e "    RAM máxima: 2-3 GB"
    echo ""
    echo -e "  ${GREEN}5-15 Jugadores${NC}"
    echo -e "    RAM mínima: 2 GB"
    echo -e "    RAM máxima: 4-6 GB"
    echo ""
    echo -e "  ${GREEN}15-30 Jugadores${NC}"
    echo -e "    RAM mínima: 4 GB"
    echo -e "    RAM máxima: 8 GB"
    echo ""
    echo -e "  ${GREEN}30+ Jugadores${NC}"
    echo -e "    RAM mínima: 6-8 GB"
    echo -e "    RAM máxima: 12-16+ GB"
    echo ""
    pause_script
}

recommend_ram_by_value() {
    local ram=$1
    if [[ $ram -le 2 ]]; then
        print_tip "Con ${ram}GB puedes jugar 1-5 jugadores sin problemas"
    elif [[ $ram -le 4 ]]; then
        print_tip "Con ${ram}GB es ideal para 5-15 jugadores"
    elif [[ $ram -le 8 ]]; then
        print_tip "Con ${ram}GB soportarás 15-30 jugadores sin lag"
    else
        print_tip "Con ${ram}GB puedes jugar con 30+ jugadores sin problemas"
    fi
}

#############################################################################
# VERIFICACIÓN DE JAVA
#############################################################################

check_java() {
    if command -v java &> /dev/null; then
        JAVA_VERSION_INSTALLED=$(java -version 2>&1 | grep -oE '[0-9]{1,2}' | head -1 || echo "0")
        print_success "Java $JAVA_VERSION_INSTALLED encontrado"
        debug_log "Java version detected: $JAVA_VERSION_INSTALLED"
        if [[ $JAVA_VERSION_INSTALLED -ge 21 ]]; then
            print_success "Java version es compatible (≥ 21)"
            return 0
        else
            print_warning "Java $JAVA_VERSION_INSTALLED es inferior a 21"
            return 1
        fi
    else
        print_error "Java no está instalado"
        return 1
    fi
}

#############################################################################
# OBTENCIÓN DE IP
#############################################################################

get_network_info() {
    print_header "Obteniendo Información de Red"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PRIVATE_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
    else
        PRIVATE_IP=$(hostname -I | awk '{print $1}')
    fi
    print_success "IP Privada Local: $PRIVATE_IP"
    debug_log "Private IP: $PRIVATE_IP"
    print_info "Obteniendo IP Pública..."
    PUBLIC_IP=""
    if check_command curl; then
        PUBLIC_IP=$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null || echo "")
    fi
    if [[ -n "$PUBLIC_IP" ]]; then
        print_success "IP Pública: $PUBLIC_IP"
        debug_log "Public IP: $PUBLIC_IP"
    else
        print_warning "No se pudo obtener IP pública automáticamente"
        read -p "Ingresa tu IP pública manualmente (o presiona Enter para omitir): " PUBLIC_IP
        if [[ -z "$PUBLIC_IP" ]]; then
            PUBLIC_IP="[NO CONFIGURADA]"
        fi
        debug_log "Public IP (manual): $PUBLIC_IP"
    fi
}

#############################################################################
# SELECCIÓN DE MODO
#############################################################################

select_operation_mode() {
    print_header "🎮 MINECRAFT AUTO SERVER SETUP v3.12"
    echo "Elige cómo configurar tu servidor:"
    echo "  1) ⚡ Modo Rápido (30 segundos)"
    echo "  2) 🔧 Modo Experto (personalización completa)"
    read -p "Selecciona modo (1 o 2): " mode_choice
    case $mode_choice in
        1)
            OPERATION_MODE="rapido"
            print_success "Modo Rápido seleccionado"
            debug_log "Operation mode: rapido"
            ;;
        2)
            OPERATION_MODE="expert"
            print_success "Modo Experto seleccionado"
            debug_log "Operation mode: expert"
            ;;
        *)
            print_error "Opción inválida"
            select_operation_mode
            ;;
    esac
}

#############################################################################
# SELECCIÓN DE VERSIÓN
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
    debug_log "Minecraft version selected: $MINECRAFT_VERSION"
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
            1) select_version_from_array "VERSIONS_1_20" "1.20.x" ;;
            2) select_version_from_array "VERSIONS_1_19" "1.19.x" ;;
            3) select_version_from_array "VERSIONS_1_18" "1.18.x" ;;
            4) select_version_from_array "VERSIONS_1_17" "1.17.x" ;;
            5) select_version_from_array "VERSIONS_1_16" "1.16.x" ;;
            6) select_version_from_array "VERSIONS_1_15" "1.15.x" ;;
            7) select_version_from_array "VERSIONS_1_14" "1.14.x" ;;
            8) select_version_from_array "VERSIONS_1_12" "1.12.x" ;;
            9) select_version_from_array "VERSIONS_1_11" "1.11.x" ;;
            10) select_version_from_array "VERSIONS_1_10" "1.10.x" ;;
            0) return ;;
            *) print_error "Opción inválida" ;;
        esac
        if [[ -n "$MINECRAFT_VERSION" ]]; then
            print_success "Versión seleccionada: $MINECRAFT_VERSION"
            debug_log "Minecraft version selected: $MINECRAFT_VERSION"
            return
        fi
    done
}

select_version_from_array() {
    local array_name=$1
    local category=$2
    print_header "Selecciona versión de $category"
    local -n versions=$array_name
    echo "Versiones disponibles:"
    for i in "${!versions[@]}"; do
        echo "  $((i+1))) ${versions[$i]}"
    done
    echo "  0) Volver"
    read -p "Selecciona una versión: " version_choice
    if [[ $version_choice -eq 0 ]]; then
        MINECRAFT_VERSION=""
        return
    elif [[ $version_choice -ge 1 && $version_choice -le ${#versions[@]} ]]; then
        MINECRAFT_VERSION="${versions[$((version_choice-1))]}"
    else
        print_error "Opción inválida"
        MINECRAFT_VERSION=""
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
            debug_log "Server type: vanilla"
            ;;
        2)
            SERVER_TYPE="paper"
            print_success "Servidor Paper seleccionado"
            debug_log "Server type: paper"
            ;;
        3)
            SERVER_TYPE="forge"
            print_success "Servidor Forge seleccionado"
            debug_log "Server type: forge"
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
    if [[ -n "$input" ]] && [[ "$input" =~ ^[0-9]+$ ]]; then
        MAX_PLAYERS="$input"
    fi
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
    debug_log "Basic config completed"
}

#############################################################################
# CONFIGURACIÓN AVANZADA
#############################################################################

show_advanced_menu() {
    print_header "⚙️  CONFIGURACIÓN AVANZADA (20+ PARÁMETROS)"
    while true; do
        echo "Selecciona un parámetro para editar:"
        echo "  1)  Nombre de carpeta contenedora   (Actual: $SERVER_FOLDER_NAME)"
        echo "  2)  Nombre del mundo (nivel)        (Actual: $LEVEL_NAME)"
        echo "  3)  Semilla del mundo               (Actual: ${LEVEL_SEED:-[Aleatoria]})"
        echo "  4)  MOTD (Descripción)              (Actual: $MOTD)"
        echo "  5)  Puerto                          (Actual: $SERVER_PORT)"
        echo "  6)  Modo de juego                   (Actual: $GAMEMODE)"
        echo "  7)  Dificultad                      (Actual: $DIFFICULTY)"
        echo "  8)  Máximo de jugadores             (Actual: $MAX_PLAYERS)"
        echo "  9)  Modo online (verificación)      (Actual: $ONLINE_MODE)"
        echo "  10) Lista blanca                    (Actual: $WHITE_LIST)"
        echo "  11) PvP habilitado                  (Actual: $PVP)"
        echo "  12) Protección de spawn             (Actual: $SPAWN_PROTECTION)"
        echo "  13) ⭐ Ver recomendación RAM        (Mostrar tabla de recomendaciones)"
        echo "  14) RAM mínima del servidor         (Actual: ${MIN_RAM}GB)"
        echo "  15) RAM máxima del servidor         (Actual: ${MAX_RAM}GB)"
        echo "  16) Distancia de visión             (Actual: $VIEW_DISTANCE)"
        echo "  17) Altura máxima construcción      (Actual: $MAX_BUILD_HEIGHT)"
        echo "  18) Bloques de comandos             (Actual: $ENABLE_COMMAND_BLOCK)"
        echo "  19) Permitir Nether                 (Actual: $ALLOW_NETHER)"
        echo "  20) Permitir End                    (Actual: $ALLOW_END)"
        echo "  21) Permitir vuelo                  (Actual: $ALLOW_FLIGHT)"
        echo "  22) Anunciar logros                 (Actual: $ANNOUNCE_PLAYER_ACHIEVEMENTS)"
        echo "  23) Forzar modo de juego            (Actual: $FORCE_GAMEMODE)"
        echo "  24) RCON habilitado                 (Actual: $ENABLE_RCON)"
        echo "  25) Puerto RCON                     (Actual: $RCON_PORT)"
        echo "  26) Contraseña RCON                 (Actual: ••••••••)"
        echo "  27) Ver resumen actual"
        echo "  28) 💾 GUARDAR CAMBIOS Y SEGUIR"
        read -p "Selecciona una opción (1-28): " adv_choice
        case $adv_choice in
            1) read -p "Nuevo nombre: " SERVER_FOLDER_NAME; SERVER_DIR="$SCRIPT_DIR/$SERVER_FOLDER_NAME"; print_success "Actualizado" ;;
            2) read -p "Nuevo nombre: " LEVEL_NAME; print_success "Actualizado" ;;
            3) read -p "Nueva semilla: " LEVEL_SEED; print_success "Actualizado" ;;
            4) read -p "Nuevo MOTD: " MOTD; print_success "Actualizado" ;;
            5) while true; do read -p "Nuevo puerto: " input; if validate_port "$input"; then SERVER_PORT="$input"; print_success "Actualizado"; break; fi; done ;;
            6) echo "1) survival 2) creative 3) adventure 4) spectator"; read -p "Selecciona: " gm; [[ $gm -eq 1 ]] && GAMEMODE="survival" || [[ $gm -eq 2 ]] && GAMEMODE="creative" || [[ $gm -eq 3 ]] && GAMEMODE="adventure" || [[ $gm -eq 4 ]] && GAMEMODE="spectator"; print_success "Actualizado" ;;
            7) echo "1) peaceful 2) easy 3) normal 4) hard"; read -p "Selecciona: " df; [[ $df -eq 1 ]] && DIFFICULTY="peaceful" || [[ $df -eq 2 ]] && DIFFICULTY="easy" || [[ $df -eq 3 ]] && DIFFICULTY="normal" || [[ $df -eq 4 ]] && DIFFICULTY="hard"; print_success "Actualizado" ;;
            8) read -p "Nuevo máximo: " MAX_PLAYERS; print_success "Actualizado" ;;
            9) read -p "¿Online? (s/n): " ol; [[ "$ol" == "s" ]] && ONLINE_MODE="true" || ONLINE_MODE="false"; print_success "Actualizado" ;;
            10) read -p "¿Lista blanca? (s/n): " wl; [[ "$wl" == "s" ]] && WHITE_LIST="true" || WHITE_LIST="false"; print_success "Actualizado" ;;
            11) read -p "¿PvP? (s/n): " pv; [[ "$pv" == "s" ]] && PVP="true" || PVP="false"; print_success "Actualizado" ;;
            12) read -p "Nuevo valor: " SPAWN_PROTECTION; print_success "Actualizado" ;;
            13) show_ram_recommendation_dialog ;;
            14) while true; do read -p "Nueva RAM mín: " input; if validate_ram "$input"; then MIN_RAM="$input"; print_success "Actualizado"; recommend_ram_by_value "$MIN_RAM"; break; fi; done ;;
            15) while true; do read -p "Nueva RAM máx: " input; if validate_ram "$input"; then MAX_RAM="$input"; print_success "Actualizado"; recommend_ram_by_value "$MAX_RAM"; break; fi; done ;;
            16) read -p "Nuevo valor (3-32): " VIEW_DISTANCE; print_success "Actualizado" ;;
            17) read -p "Nuevo valor: " MAX_BUILD_HEIGHT; print_success "Actualizado" ;;
            18) read -p "¿Comandos? (s/n): " cb; [[ "$cb" == "s" ]] && ENABLE_COMMAND_BLOCK="true" || ENABLE_COMMAND_BLOCK="false"; print_success "Actualizado" ;;
            19) read -p "¿Nether? (s/n): " nether; [[ "$nether" == "s" ]] && ALLOW_NETHER="true" || ALLOW_NETHER="false"; print_success "Actualizado" ;;
            20) read -p "¿End? (s/n): " end; [[ "$end" == "s" ]] && ALLOW_END="true" || ALLOW_END="false"; print_success "Actualizado" ;;
            21) read -p "¿Vuelo? (s/n): " fl; [[ "$fl" == "s" ]] && ALLOW_FLIGHT="true" || ALLOW_FLIGHT="false"; print_success "Actualizado" ;;
            22) read -p "¿Anunciar logros? (s/n): " achv; [[ "$achv" == "s" ]] && ANNOUNCE_PLAYER_ACHIEVEMENTS="true" || ANNOUNCE_PLAYER_ACHIEVEMENTS="false"; print_success "Actualizado" ;;
            23) read -p "¿Forzar modo? (s/n): " force; [[ "$force" == "s" ]] && FORCE_GAMEMODE="true" || FORCE_GAMEMODE="false"; print_success "Actualizado" ;;
            24) read -p "¿RCON? (s/n): " rc; [[ "$rc" == "s" ]] && ENABLE_RCON="true" || ENABLE_RCON="false"; print_success "Actualizado" ;;
            25) while true; do read -p "Nuevo puerto RCON: " input; if validate_port "$input"; then RCON_PORT="$input"; print_success "Actualizado"; break; fi; done ;;
            26) read -p "Nueva contraseña RCON: " RCON_PASSWORD; print_success "Actualizado" ;;
            27) show_current_config ;;
            28) print_success "✅ CAMBIOS GUARDADOS - Continuando..."; return ;;
            *) print_error "Opción inválida" ;;
        esac
    done
}

show_current_config() {
    print_header "📋 RESUMEN DE CONFIGURACIÓN ACTUAL"
    echo -e "${CYAN}Carpeta:${NC} $SERVER_FOLDER_NAME"
    echo -e "${CYAN}Versión:${NC} $MINECRAFT_VERSION | ${CYAN}Tipo:${NC} $SERVER_TYPE"
    echo -e "${CYAN}Puerto:${NC} $SERVER_PORT | ${CYAN}Modo:${NC} $GAMEMODE | ${CYAN}Dificultad:${NC} $DIFFICULTY"
    echo -e "${CYAN}Jugadores:${NC} $MAX_PLAYERS | ${CYAN}RAM:${NC} ${MIN_RAM}GB - ${MAX_RAM}GB"
    echo -e "${CYAN}Mundo:${NC} $LEVEL_NAME | ${CYAN}Distancia:${NC} $VIEW_DISTANCE"
    pause_script
}

#############################################################################
# DESCARGA DE SERVIDOR
#############################################################################

download_vanilla_server() {
    print_header "Descargando Servidor Vanilla ($MINECRAFT_VERSION)"
    debug_log "Starting Vanilla download for version $MINECRAFT_VERSION"
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
        ["1.15.1"]="https://piston-data.mojang.com/v1/objects/4d60468b3bcc0b18550bf39a67035205eac68c006/server.jar"
        ["1.15"]="https://piston-data.mojang.com/v1/objects/ed76ed597ea6635bcc899d6af6f55f3547314547/server.jar"
        ["1.14.4"]="https://piston-data.mojang.com/v1/objects/e0604713079862373eff479535ab624fdde8043f/server.jar"
        ["1.14.3"]="https://piston-data.mojang.com/v1/objects/d0d0fe2b6932e3e07d12d653d7572ba7cb7dc2e9/server.jar"
        ["1.14.2"]="https://piston-data.mojang.com/v1/objects/808be3869e2ca6b62378f1bd418c4d69c7681871/server.jar"
        ["1.14.1"]="https://piston-data.mojang.com/v1/objects/2ecc8ef3fb56e213dcc4b31043dae2588b5d68d37/server.jar"
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
        print_error "Versión $MINECRAFT_VERSION no soportada"
        debug_log "ERROR: Version $MINECRAFT_VERSION not found"
        exit 1
    fi
    
    DOWNLOAD_URL="${VANILLA_URLS[$MINECRAFT_VERSION]}"
    debug_log "Download URL: $DOWNLOAD_URL"
    print_info "Descargando versión $MINECRAFT_VERSION..."
    mkdir -p "$SERVER_DIR"
    
    local max_attempts=3
    local attempt=1
    while [[ $attempt -le $max_attempts ]]; do
        print_info "Intento $attempt de $max_attempts..."
        debug_log "Download attempt $attempt"
        if check_command curl; then
            if curl -f -L --max-time 300 -o "$SERVER_DIR/server.jar" "$DOWNLOAD_URL" 2>/dev/null; then
                if [[ -f "$SERVER_DIR/server.jar" ]] && [[ -s "$SERVER_DIR/server.jar" ]]; then
                    local filesize=$(du -h "$SERVER_DIR/server.jar" | cut -f1)
                    print_success "Servidor descargado correctamente ($filesize)"
                    debug_log "Download successful - Size: $filesize"
                    return 0
                fi
            fi
        fi
        attempt=$((attempt + 1))
        if [[ $attempt -le $max_attempts ]]; then
            print_warning "Reintentando en 5 segundos..."
            debug_log "Retrying download"
            sleep 5
        fi
    done
    print_error "Error al descargar el servidor después de $max_attempts intentos"
    debug_log "ERROR: Download failed after $max_attempts attempts"
    exit 1
}

download_paper_server() {
    print_header "Descargando Servidor Paper ($MINECRAFT_VERSION)"
    debug_log "Starting Paper download for version $MINECRAFT_VERSION"
    mkdir -p "$SERVER_DIR"
    print_info "Consultando API de PaperMC..."
    if ! check_command curl; then
        print_error "Se requiere curl para descargar Paper"
        exit 1
    fi
    local api_url="https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION"
    debug_log "Paper API URL: $api_url"
    BUILDS=$(curl -s -A "$USER_AGENT" "$api_url" 2>&1 | grep -o '"builds":\[[0-9,]*\]' | grep -o '[0-9]*' | tail -1 2>/dev/null || echo "")
    if [[ -z "$BUILDS" ]]; then
        print_error "No se pudo obtener Paper para versión $MINECRAFT_VERSION"
        debug_log "ERROR: Could not fetch Paper builds"
        exit 1
    fi
    LATEST_BUILD="$BUILDS"
    print_success "Build más reciente de Paper: $LATEST_BUILD"
    debug_log "Latest Paper build: $LATEST_BUILD"
    DOWNLOAD_URL="https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$LATEST_BUILD/downloads/paper-$MINECRAFT_VERSION-$LATEST_BUILD.jar"
    local max_attempts=3
    local attempt=1
    while [[ $attempt -le $max_attempts ]]; do
        print_info "Intento $attempt de $max_attempts..."
        if curl -f -L --max-time 300 -A "$USER_AGENT" -o "$SERVER_DIR/server.jar" "$DOWNLOAD_URL" 2>/dev/null; then
            if [[ -f "$SERVER_DIR/server.jar" ]] && [[ -s "$SERVER_DIR/server.jar" ]]; then
                print_success "Servidor Paper descargado correctamente"
                debug_log "Paper download successful"
                return 0
            fi
        fi
        attempt=$((attempt + 1))
        if [[ $attempt -le $max_attempts ]]; then
            print_warning "Reintentando..."
            sleep 5
        fi
    done
    print_error "Error al descargar Paper"
    debug_log "ERROR: Paper download failed"
    exit 1
}

download_forge_server() {
    print_header "Descargando Servidor Forge ($MINECRAFT_VERSION)"
    print_warning "Descarga manual: https://files.minecraftforge.net"
    exit 1
}

download_server() {
    debug_log "Starting server download (type: $SERVER_TYPE)"
    case $SERVER_TYPE in
        vanilla) download_vanilla_server ;;
        paper) download_paper_server ;;
        forge) download_forge_server ;;
    esac
}

#############################################################################
# DESCARGA DE ICONO
#############################################################################

download_server_icon() {
    print_info "Descargando icono del servidor..."
    debug_log "Downloading icon from: $ICON_URL"
    if check_command curl; then
        if curl -f -L --max-time 60 -o "$SERVER_DIR/server-icon.png" "$ICON_URL" 2>/dev/null; then
            if [[ -f "$SERVER_DIR/server-icon.png" ]] && [[ -s "$SERVER_DIR/server-icon.png" ]]; then
                print_success "Icono descargado correctamente"
                debug_log "Icon download successful"
                return 0
            fi
        fi
    fi
    print_warning "No se pudo descargar el icono. Puedes añadirlo manualmente."
    debug_log "WARNING: Icon download failed"
    return 0
}

#############################################################################
# CONFIGURACIÓN DEL SERVIDOR
#############################################################################

configure_server() {
    print_header "Configurando el Servidor"
    debug_log "Starting server configuration"
    mkdir -p "$SERVER_DIR"
    if [[ "$SERVER_TYPE" == "paper" ]]; then
        mkdir -p "$SERVER_DIR/plugins"
        print_success "Carpeta de plugins creada"
    fi
    echo "eula=true" > "$SERVER_DIR/eula.txt"
    print_success "EULA aceptado"
    debug_log "EULA accepted"
    download_server_icon
}

configure_properties() {
    print_header "Configurando server.properties"
    debug_log "Configuring server.properties"
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
allow-flight=$ALLOW_FLIGHT
max-build-height=$MAX_BUILD_HEIGHT
allow-nether=$ALLOW_NETHER
allow-end=$ALLOW_END
announce-player-achievements=$ANNOUNCE_PLAYER_ACHIEVEMENTS
force-gamemode=$FORCE_GAMEMODE
max-tick-time=$MAX_TICK_TIME
network-compression-threshold=$NETWORK_COMPRESSION_THRESHOLD
EOF
    print_success "server.properties configurado"
    debug_log "server.properties configuration complete"
}

create_start_script() {
    print_header "Creando Scripts de Inicio"
    debug_log "Creating start script"
    cat > "$SERVER_DIR/start.sh" << EOF
#!/bin/bash
echo "════════════════════════════════════════"
echo "Servidor Minecraft - Iniciando"
echo "════════════════════════════════════════"
ASSIGNED_MIN_RAM="${MIN_RAM}G"
ASSIGNED_MAX_RAM="${MAX_RAM}G"
echo "RAM mínima asignada: \$ASSIGNED_MIN_RAM"
echo "RAM máxima asignada: \$ASSIGNED_MAX_RAM"
java -Xms\$ASSIGNED_MIN_RAM -Xmx\$ASSIGNED_MAX_RAM -jar server.jar nogui
EOF
    chmod +x "$SERVER_DIR/start.sh"
    print_success "Script start.sh creado"
    debug_log "Start script created successfully"
}

#############################################################################
# INFORMACIÓN FINAL
#############################################################################

print_final_info() {
    print_header "¡Configuración Completada!"
    echo -e "📁 ${BLUE}Carpeta:${NC} $SERVER_FOLDER_NAME"
    echo -e "🎮 ${BLUE}Versión:${NC} $MINECRAFT_VERSION | ${BLUE}Tipo:${NC} $SERVER_TYPE"
    echo -e "🔌 ${BLUE}Puerto:${NC} $SERVER_PORT | ${BLUE}RAM:${NC} ${MIN_RAM}GB - ${MAX_RAM}GB"
    echo -e "👥 ${BLUE}Jugadores:${NC} $MAX_PLAYERS | ${BLUE}Modo:${NC} $GAMEMODE"
    debug_log "Server configuration final"
}

print_share_server_info() {
    print_header "🎯 SERVIDOR LISTO - DATOS DE CONEXIÓN"
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║  ✅ SERVIDOR CONFIGURADO Y LISTO      ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    echo -e "${WHITE}┌─ DIRECCIÓN PARA COMPARTIR CON TUS AMIGOS ─┐${NC}"
    echo -e "${WHITE}│  ${CYAN}Dirección:${NC} ${GREEN}${PUBLIC_IP}:${SERVER_PORT}${NC}"
    echo -e "${WHITE}└────────────────────────────────────────────┘${NC}"
    echo -e "${BLUE}Ubicación del servidor:${NC} $SERVER_DIR"
    echo -e "${GREEN}© Copyright 2025 - Nahuel Granollers${NC}"
    echo -e "${BLUE}https://github.com/NahuelGranollers/minecraft_auto_server${NC}"
}

show_router_guide() {
    print_header "📡 GUÍA: CÓMO COMPARTIR TU SERVIDOR"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  PARA QUE TUS AMIGOS PUEDAN CONECTARSE DESDE INTERNET${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}1️⃣  DIRECCIÓN A COMPARTIR:${NC}"
    echo -e "    ${GREEN}${PUBLIC_IP}:${SERVER_PORT}${NC}"
    echo -e "${CYAN}2️⃣  PASOS PARA ABRIR EL PUERTO EN EL ROUTER:${NC}"
    echo -e "    ${WHITE}a) Accede a tu router:${NC}"
    echo -e "       • Abre: http://192.168.1.1 (o 192.168.0.1) en el navegador"
    echo -e "       • Usuario/Contraseña: admin/admin (o consulta tu router)"
    echo -e "    ${WHITE}b) Busca 'Port Forwarding' o 'Reenvío de puertos'${NC}"
    echo -e "    ${WHITE}c) Crea una nueva regla con estos datos:${NC}"
    echo -e "       • Puerto externo: ${GREEN}${SERVER_PORT}${NC}"
    echo -e "       • Puerto interno: ${GREEN}${SERVER_PORT}${NC}"
    echo -e "       • Protocolo: TCP/UDP"
    echo -e "       • IP local: ${GREEN}${PRIVATE_IP}${NC} (o busca tu IP con 'ifconfig')"
    echo -e "    ${WHITE}d) Guarda y reinicia el router${NC}"
    echo -e "${CYAN}3️⃣  CÓMO SE CONECTAN TUS AMIGOS EN MINECRAFT:${NC}"
    echo -e "    a) Minecraft Java Edition → Multijugador"
    echo -e "    b) Click en 'Servidor directo'"
    echo -e "    c) Pega la dirección:"
    echo -e "       ${GREEN}${PUBLIC_IP}:${SERVER_PORT}${NC}"
    echo -e "    d) ¡Conecta!"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    pause_script
}

start_server_now() {
    print_header "🚀 INICIAR SERVIDOR"
    read -p "¿Iniciar el servidor ahora? (s/n): " start_choice
    if [[ "$start_choice" == "s" || "$start_choice" == "S" ]]; then
        debug_log "Starting server"
        cd "$SERVER_DIR" || exit 1
        print_share_server_info
        show_router_guide
        bash start.sh
    else
        print_info "Para iniciar manualmente más tarde:"
        echo -e "    ${CYAN}cd $SERVER_DIR && ./start.sh${NC}"
        print_share_server_info
        show_router_guide
    fi
}

setup_rapido_mode() {
    MINECRAFT_VERSION="1.21.10"
    SERVER_TYPE="vanilla"
    SERVER_FOLDER_NAME="minecraft_server"
    SERVER_DIR="$SCRIPT_DIR/$SERVER_FOLDER_NAME"
    MOTD="Servidor automático"
    GAMEMODE="survival"
    DIFFICULTY="easy"
    MAX_PLAYERS="20"
    ONLINE_MODE="true"
    PVP="true"
    MIN_RAM="1"
    MAX_RAM="4"
    SERVER_PORT="25565"
    LEVEL_NAME="world"
    LEVEL_SEED=""
    VIEW_DISTANCE="10"
    WHITE_LIST="false"
    ENABLE_COMMAND_BLOCK="false"
    SPAWN_PROTECTION="16"
    ENABLE_RCON="false"
    RCON_PASSWORD="minecraft"
    RCON_PORT="25575"
    ALLOW_FLIGHT="false"
    MAX_BUILD_HEIGHT="320"
    MAX_WORLD_SIZE="59999968"
    HARDCORE="false"
    ALLOW_NETHER="true"
    ALLOW_END="true"
    ANNOUNCE_PLAYER_ACHIEVEMENTS="true"
    FORCE_GAMEMODE="false"
    mkdir -p "$SERVER_DIR"
    print_success "Configuración automática aplicada"
    debug_log "Modo rápido autopilot, todo por defecto"
}

#############################################################################
# MAIN
#############################################################################

main() {
    > "$LOG_FILE"
    debug_log "Script started - Version 3.12"
    clear
    print_header "Configurador Auto Minecraft v3.12"
    echo -e "${MAGENTA}© 2025 - Nahuel Granollers${NC}"
    select_operation_mode
    if ! check_java; then
        print_error "Java 21+ es requerido."
        print_warning "Descarga Java desde: https://adoptium.net/es/temurin/releases/?version=21"
        exit 1
    fi
    get_network_info
    if [[ "$OPERATION_MODE" == "rapido" ]]; then
        setup_rapido_mode
        download_server
        configure_server
        configure_properties
        create_start_script
        print_final_info
        read -p "¿Iniciar el servidor ahora? (s/n): " start_choice
        if [[ "$start_choice" == "s" || "$start_choice" == "S" ]]; then
            debug_log "Starting server in rapid mode"
            cd "$SERVER_DIR" || exit 1
            print_share_server_info
            show_router_guide
            bash start.sh
        else
            print_info "Para iniciar manualmente más tarde:"
            echo -e "    ${CYAN}cd $SERVER_DIR && ./start.sh${NC}"
            print_share_server_info
            show_router_guide
        fi
    else
        pause_script
        select_version
        select_server_type
        select_basic_config
        read -p "¿Configuración avanzada? (s/n): " adv_choice
        if [[ "$adv_choice" == "s" || "$adv_choice" == "S" ]]; then
            show_advanced_menu
        fi
        download_server
        configure_server
        configure_properties
        create_start_script
        print_final_info
        start_server_now
        debug_log "Script completed successfully"
    fi
}

main "$@"
