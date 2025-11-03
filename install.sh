#!/usr/bin/env bash
# ==============================================================================
# Script de instalación de cursor_workflow
# ==============================================================================
# Instala la carpeta .cursor con todos los scripts y configuraciones necesarias
# para el flujo de trabajo estandarizado de Cursor + GitKraken CLI.
#
# Uso:
#   bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh)
#   O bien:
#   wget -qO- https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh | bash
#
# Opciones:
#   -h, --help          Muestra esta ayuda
#   -b, --branch RAMA   Instala desde una rama específica (default: master)
#   -f, --force         Fuerza la instalación incluso si .cursor ya existe
#   --repo REPO         Repositorio GitHub (formato: usuario/repo, default: autodetectado)
# ==============================================================================

set -euo pipefail

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Configuración por defecto
BRANCH="${CURSOR_WORKFLOW_BRANCH:-master}"
FORCE=false
REPO="${CURSOR_WORKFLOW_REPO:-}"

# Función para mostrar mensajes
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
log_error() { echo -e "${RED}✗${NC} $*" >&2; }

# Función para mostrar ayuda
show_help() {
    grep '^#' "$0" | grep -v '#!/usr/bin/env' | sed 's/^# //; s/^#//'
    exit 0
}

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        --repo)
            REPO="$2"
            shift 2
            ;;
        *)
            log_error "Argumento desconocido: $1"
            echo "Usa --help para ver las opciones disponibles"
            exit 1
            ;;
    esac
done

# Autodetectar repositorio si no está configurado
if [[ -z "$REPO" ]]; then
    # Intentar detectar desde git remote si estamos en un repo
    if git remote get-url origin &>/dev/null; then
        ORIGIN=$(git remote get-url origin)
        # Extraer usuario/repo de la URL
        if [[ "$ORIGIN" =~ github\.com[:/]([^/]+/[^/]+?)(\.git)?$ ]]; then
            REPO="${BASH_REMATCH[1]}"
        fi
    fi
    
    # Si aún no tenemos repo, usar un valor por defecto
    if [[ -z "$REPO" ]]; then
        log_warning "No se pudo autodetectar el repositorio"
        log_info "Por favor, especifica el repositorio con --repo usuario/repo"
        log_info "O configura la variable de entorno CURSOR_WORKFLOW_REPO"
        exit 1
    fi
fi

log_info "Instalando cursor_workflow desde: ${REPO} (rama: ${BRANCH})"

# Verificar si .cursor ya existe
if [[ -d ".cursor" ]] && [[ "$FORCE" != "true" ]]; then
    log_warning "La carpeta .cursor ya existe en este directorio"
    read -p "¿Deseas sobrescribirla? [s/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        log_info "Instalación cancelada"
        exit 0
    fi
    FORCE=true
fi

# Crear backup si existe
if [[ -d ".cursor" ]] && [[ "$FORCE" == "true" ]]; then
    BACKUP_DIR=".cursor.backup.$(date +%Y%m%d_%H%M%S)"
    log_warning "Creando backup en: $BACKUP_DIR"
    mv .cursor "$BACKUP_DIR"
fi

# URL base de raw.githubusercontent.com
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

# Función para descargar un archivo
download_file() {
    local remote_path="$1"
    local local_path="$2"
    local url="${BASE_URL}/${remote_path}"
    
    log_info "Descargando: $remote_path"
    
    # Crear directorio si no existe
    mkdir -p "$(dirname "$local_path")"
    
    # Intentar descargar con curl, luego con wget
    if command -v curl &>/dev/null; then
        if ! curl -fsSL "$url" -o "$local_path"; then
            log_error "Error descargando: $remote_path"
            return 1
        fi
    elif command -v wget &>/dev/null; then
        if ! wget -q "$url" -O "$local_path"; then
            log_error "Error descargando: $remote_path"
            return 1
        fi
    else
        log_error "Se necesita curl o wget para la instalación"
        exit 1
    fi
    
    return 0
}

# Crear estructura de directorios
log_info "Creando estructura de directorios..."
mkdir -p .cursor/{bin,commands,agents,rules}

# Descargar el MANIFEST primero
log_info "Descargando MANIFEST..."
MANIFEST_URL="${BASE_URL}/.cursor/MANIFEST"
MANIFEST_FILE=".cursor/MANIFEST"

if ! download_file ".cursor/MANIFEST" "$MANIFEST_FILE"; then
    log_warning "No se pudo descargar MANIFEST, usando lista predefinida de archivos"
    # Lista de archivos por defecto (fallback)
    declare -a FILES=(
        ".cursor/bin/ai-commit-gemini.sh"
        ".cursor/bin/clone.sh"
        ".cursor/bin/commit.sh"
        ".cursor/bin/create-pull-request.sh"
        ".cursor/bin/fzf"
        ".cursor/bin/push.sh"
        ".cursor/bin/start.sh"
        ".cursor/commands/clone.md"
        ".cursor/commands/commit.md"
        ".cursor/commands/create-pull-request.md"
        ".cursor/commands/push.md"
        ".cursor/commands/start.md"
        ".cursor/README.md"
    )
else
    log_success "MANIFEST descargado"
    # Leer archivos desde MANIFEST (ignorar comentarios y líneas vacías)
    mapfile -t FILES < <(grep -v '^#' "$MANIFEST_FILE" | grep -v '^[[:space:]]*$')
    log_info "Encontrados ${#FILES[@]} archivos en MANIFEST"
fi

# Descargar todos los archivos
log_info "Descargando archivos..."
FAILED=0
for file in "${FILES[@]}"; do
    # Saltar el MANIFEST ya que ya lo descargamos
    if [[ "$file" == ".cursor/MANIFEST" ]]; then
        continue
    fi
    if ! download_file "$file" "$file"; then
        FAILED=$((FAILED + 1))
    fi
done

if [[ $FAILED -gt 0 ]]; then
    log_error "Algunos archivos no se pudieron descargar ($FAILED errores)"
    log_warning "La instalación puede estar incompleta"
fi

# Hacer ejecutables los scripts
log_info "Configurando permisos..."
chmod +x .cursor/bin/*.sh 2>/dev/null || true
chmod +x .cursor/bin/fzf 2>/dev/null || true

# Verificar dependencias
log_info "Verificando dependencias..."

check_command() {
    if command -v "$1" &>/dev/null; then
        log_success "$1 instalado"
        return 0
    else
        log_warning "$1 no encontrado"
        return 1
    fi
}

MISSING_DEPS=0
for cmd in git gk jq; do
    check_command "$cmd" || MISSING_DEPS=$((MISSING_DEPS + 1))
done

# Dependencias opcionales
log_info "Dependencias opcionales:"
for cmd in gh gemini; do
    check_command "$cmd" || true
done

# Mensaje final
echo
log_success "¡Instalación completada!"
echo
log_info "Estructura instalada:"
echo "  .cursor/"
echo "    ├── bin/         (scripts ejecutables)"
echo "    ├── commands/    (documentación de comandos slash)"
echo "    ├── agents/      (roles de agente, placeholder)"
echo "    └── rules/       (reglas adicionales, placeholder)"
echo

if [[ $MISSING_DEPS -gt 0 ]]; then
    log_warning "Algunas dependencias no están instaladas"
    echo
    echo "Dependencias requeridas:"
    echo "  - gk (GitKraken CLI): https://gitkraken.dev/cli"
    echo "  - git: gestor de versiones"
    echo "  - jq: procesamiento JSON"
    echo
    echo "Dependencias opcionales:"
    echo "  - gh (GitHub CLI): para abrir PRs automáticamente"
    echo "  - gemini: CLI de Gemini (fallback de commits IA)"
    echo
fi

log_info "Próximos pasos:"
echo "  1. Asegúrate de tener GitKraken CLI autenticado: gk auth login"
echo "  2. Configura las reglas del proyecto en Cursor"
echo "  3. Comienza un nuevo trabajo: .cursor/bin/start.sh \"feat: tu funcionalidad\""
echo
log_info "Para más información, consulta la documentación en .cursor/commands/"
echo

