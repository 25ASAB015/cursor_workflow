#!/usr/bin/env bash
# ==============================================================================
# Visualizador del sistema de instalación de cursor_workflow
# ==============================================================================
# Muestra un resumen visual de todos los componentes del sistema de instalación
# ==============================================================================

set -euo pipefail

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

# Emojis
readonly CHECK="✅"
readonly CROSS="❌"
readonly INFO="ℹ️"
readonly ROCKET="🚀"
readonly FOLDER="📁"
readonly FILE="📄"
readonly SCRIPT="🔧"
readonly DOC="📚"

log_header() { echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"; echo -e "${BOLD}${CYAN}║  $*${NC}"; echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"; }
log_section() { echo -e "\n${BOLD}${MAGENTA}▶ $*${NC}"; }
log_item() { echo -e "  ${GREEN}•${NC} $*"; }
log_file() { 
    local emoji="$1"
    local name="$2"
    local desc="$3"
    local path="$4"
    
    if [[ -f "$path" ]]; then
        local size=$(du -h "$path" 2>/dev/null | cut -f1)
        local lines=$(wc -l < "$path" 2>/dev/null || echo "?")
        echo -e "  ${emoji} ${BOLD}${name}${NC} - ${desc}"
        echo -e "     ${DIM}└─ $path (${size}, ${lines} líneas)${NC}"
    else
        echo -e "  ${CROSS} ${BOLD}${name}${NC} - ${RED}NO ENCONTRADO${NC}"
        echo -e "     ${DIM}└─ $path${NC}"
    fi
}

echo
log_header "Sistema de Instalación - Cursor Workflow"
echo

# Información general
log_section "Información General"
echo

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo -e "  ${INFO} ${BOLD}Ubicación:${NC} $PROJECT_ROOT"

if git rev-parse --is-inside-work-tree &>/dev/null; then
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "desconocida")
    COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "?")
    LAST_COMMIT=$(git log -1 --format="%h - %s" 2>/dev/null || echo "ninguno")
    echo -e "  ${INFO} ${BOLD}Rama:${NC} $CURRENT_BRANCH"
    echo -e "  ${INFO} ${BOLD}Commits:${NC} $COMMITS"
    echo -e "  ${INFO} ${BOLD}Último commit:${NC} $LAST_COMMIT"
fi

# Scripts de instalación
log_section "Scripts de Instalación ${SCRIPT}"
echo

log_file "🚀" "install.sh" "Instalador principal" "$PROJECT_ROOT/install.sh"
log_file "🔄" "update.sh" "Actualizador de instalaciones" "$PROJECT_ROOT/update.sh"
log_file "⚡" "quickstart.sh" "Configuración guiada" "$PROJECT_ROOT/quickstart.sh"
log_file "🧪" "test-install.sh" "Suite de pruebas" "$PROJECT_ROOT/test-install.sh"
log_file "📋" "install-example.sh" "Ejemplos de uso" "$PROJECT_ROOT/install-example.sh"
log_file "⚙️" "config.example.sh" "Plantilla de configuración" "$PROJECT_ROOT/config.example.sh"

# Documentación
log_section "Documentación ${DOC}"
echo

log_file "📖" "README.md" "Documentación principal" "$PROJECT_ROOT/README.md"
log_file "🚀" "DEPLOYMENT.md" "Guía de despliegue" "$PROJECT_ROOT/DEPLOYMENT.md"
log_file "📦" "INSTALL_README.md" "Doc del sistema de instalación" "$PROJECT_ROOT/INSTALL_README.md"
log_file "📚" ".cursor/README.md" "Doc de carpeta .cursor" "$PROJECT_ROOT/.cursor/README.md"

# Sistema de archivos
log_section "Sistema de Archivos ${FOLDER}"
echo

log_file "📋" ".cursor/MANIFEST" "Lista de archivos a instalar" "$PROJECT_ROOT/.cursor/MANIFEST"
log_file "🚫" ".gitignore" "Archivos ignorados por git" "$PROJECT_ROOT/.gitignore"

# Scripts instalables
log_section "Scripts Instalables (en .cursor/bin/)"
echo

CURSOR_SCRIPTS=(
    "start.sh:Iniciar nuevo trabajo"
    "commit.sh:Crear commit con IA"
    "push.sh:Push cambios"
    "create-pull-request.sh:Crear PR con IA"
    "clone.sh:Clonar repo para pruebas"
    "ai-commit-gemini.sh:Fallback Gemini"
    "fzf:Utilidad de selección"
)

for item in "${CURSOR_SCRIPTS[@]}"; do
    IFS=: read -r script desc <<< "$item"
    log_file "⚙️" "$script" "$desc" "$PROJECT_ROOT/.cursor/bin/$script"
done

# Documentación de comandos
log_section "Documentación de Comandos (en .cursor/commands/)"
echo

COMMAND_DOCS=(
    "start.md:Comando /start"
    "commit.md:Comando /commit"
    "push.md:Comando /push"
    "create-pull-request.md:Comando /create-pull-request"
    "clone.md:Comando /clone"
)

for item in "${COMMAND_DOCS[@]}"; do
    IFS=: read -r doc desc <<< "$item"
    log_file "📄" "$doc" "$desc" "$PROJECT_ROOT/.cursor/commands/$doc"
done

# Estadísticas
log_section "Estadísticas"
echo

TOTAL_SCRIPTS=$(find "$PROJECT_ROOT" -maxdepth 1 -name "*.sh" -type f 2>/dev/null | wc -l)
TOTAL_DOCS=$(find "$PROJECT_ROOT" -name "*.md" -type f 2>/dev/null | wc -l)
TOTAL_CURSOR_SCRIPTS=$(find "$PROJECT_ROOT/.cursor/bin" -type f 2>/dev/null | wc -l)
TOTAL_CURSOR_DOCS=$(find "$PROJECT_ROOT/.cursor/commands" -name "*.md" -type f 2>/dev/null | wc -l)
TOTAL_LINES=0

# Contar líneas de código
for file in "$PROJECT_ROOT"/*.sh "$PROJECT_ROOT/.cursor/bin"/* "$PROJECT_ROOT"/*.md "$PROJECT_ROOT/.cursor"/*.md "$PROJECT_ROOT/.cursor/commands"/*.md; do
    if [[ -f "$file" ]]; then
        TOTAL_LINES=$((TOTAL_LINES + $(wc -l < "$file" 2>/dev/null || echo 0)))
    fi
done

echo -e "  ${CHECK} Scripts del sistema: ${BOLD}$TOTAL_SCRIPTS${NC}"
echo -e "  ${CHECK} Scripts en .cursor/bin: ${BOLD}$TOTAL_CURSOR_SCRIPTS${NC}"
echo -e "  ${CHECK} Documentos markdown: ${BOLD}$TOTAL_DOCS${NC}"
echo -e "  ${CHECK} Documentos de comandos: ${BOLD}$TOTAL_CURSOR_DOCS${NC}"
echo -e "  ${CHECK} Total de líneas: ${BOLD}$TOTAL_LINES${NC}"

# Verificación de permisos
log_section "Verificación de Permisos"
echo

check_executable() {
    local file="$1"
    if [[ -f "$file" ]]; then
        if [[ -x "$file" ]]; then
            echo -e "  ${CHECK} $(basename "$file") ${DIM}(ejecutable)${NC}"
        else
            echo -e "  ${CROSS} $(basename "$file") ${YELLOW}(no ejecutable - ejecuta: chmod +x $file)${NC}"
        fi
    fi
}

for script in "$PROJECT_ROOT"/*.sh "$PROJECT_ROOT/.cursor/bin"/*.sh; do
    [[ -f "$script" ]] && check_executable "$script"
done

# Comandos de uso rápido
log_section "Comandos de Uso Rápido"
echo

echo -e "${BOLD}Instalación local:${NC}"
echo -e "  ${DIM}cd /tu/proyecto && $PROJECT_ROOT/install.sh${NC}"
echo

echo -e "${BOLD}Probar instalación:${NC}"
echo -e "  ${DIM}$PROJECT_ROOT/test-install.sh${NC}"
echo

echo -e "${BOLD}Configuración guiada:${NC}"
echo -e "  ${DIM}$PROJECT_ROOT/quickstart.sh${NC}"
echo

echo -e "${BOLD}Ver ejemplos:${NC}"
echo -e "  ${DIM}$PROJECT_ROOT/install-example.sh${NC}"
echo

echo -e "${BOLD}Desde GitHub (cuando esté publicado):${NC}"
echo -e "  ${DIM}bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --repo 25ASAB015/cursor_workflow${NC}"
echo

# Próximos pasos
log_section "Próximos Pasos"
echo

echo -e "  ${ROCKET} ${BOLD}1. Publicar en GitHub${NC}"
echo -e "     ${DIM}Ver instrucciones en: DEPLOYMENT.md${NC}"
echo

echo -e "  ${ROCKET} ${BOLD}2. Reemplazar 25ASAB015${NC}"
echo -e "     ${DIM}find . -type f \\( -name \"*.md\" -o -name \"*.sh\" \\) -exec sed -i 's/25ASAB015/tu_usuario/g' {} +${NC}"
echo

echo -e "  ${ROCKET} ${BOLD}3. Probar instalación${NC}"
echo -e "     ${DIM}./test-install.sh${NC}"
echo

echo -e "  ${ROCKET} ${BOLD}4. Crear primer release${NC}"
echo -e "     ${DIM}gh release create v1.0.0 --generate-notes${NC}"
echo

echo -e "  ${ROCKET} ${BOLD}5. Compartir con el equipo${NC}"
echo -e "     ${DIM}Enviar comando de instalación de una línea${NC}"
echo

# Recursos adicionales
log_section "Recursos Adicionales"
echo

echo -e "  ${DOC} ${BOLD}Documentación completa:${NC} README.md"
echo -e "  ${DOC} ${BOLD}Guía de despliegue:${NC} DEPLOYMENT.md"
echo -e "  ${DOC} ${BOLD}Doc del instalador:${NC} INSTALL_README.md"
echo -e "  ${DOC} ${BOLD}Scripts de .cursor:${NC} .cursor/README.md"
echo -e "  ${DOC} ${BOLD}Configuración:${NC} config.example.sh"
echo

log_header "Sistema Listo para Desplegar! ${ROCKET}"
echo

