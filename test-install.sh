#!/usr/bin/env bash
# ==============================================================================
# Script de prueba de instalación de cursor_workflow
# ==============================================================================
# Prueba la instalación de cursor_workflow en un entorno aislado
# ==============================================================================

set -euo pipefail

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

log_header() { echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; echo -e "${BOLD}${CYAN}  $*${NC}"; echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
log_error() { echo -e "${RED}✗${NC} $*" >&2; }
log_step() { echo -e "${BOLD}$*${NC}"; }

# Contadores
TESTS_PASSED=0
TESTS_FAILED=0

# Función para pruebas
test_assertion() {
    local description="$1"
    local command="$2"
    
    echo -n "  • $description... "
    
    if eval "$command" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC}"
        log_error "    Falló: $command"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Directorio de prueba
TEST_DIR="${TEST_DIR:-/tmp/cursor_workflow_test_$(date +%s)}"
REPO="${CURSOR_WORKFLOW_REPO:-}"
BRANCH="${CURSOR_WORKFLOW_BRANCH:-master}"

echo
log_header "Test de Instalación - Cursor Workflow"
echo

# Configuración
if [[ -z "$REPO" ]]; then
    log_warning "CURSOR_WORKFLOW_REPO no está configurado"
    log_info "Para probar instalación desde GitHub, configura:"
    echo "  export CURSOR_WORKFLOW_REPO='tu_usuario/cursor_workflow'"
    echo
    read -p "¿Deseas usar instalación local en su lugar? [S/n]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        LOCAL_INSTALL=true
        INSTALL_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install.sh"
        if [[ ! -f "$INSTALL_SCRIPT" ]]; then
            log_error "No se encontró install.sh en el directorio actual"
            exit 1
        fi
        log_info "Usando instalador local: $INSTALL_SCRIPT"
    else
        log_error "Configuración cancelada"
        exit 1
    fi
else
    LOCAL_INSTALL=false
    INSTALL_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh"
    log_info "Repositorio: $REPO"
    log_info "Rama: $BRANCH"
    log_info "URL: $INSTALL_URL"
fi

echo
log_step "1. Preparando entorno de prueba"
echo

log_info "Directorio de prueba: $TEST_DIR"

# Limpiar directorio previo si existe
if [[ -d "$TEST_DIR" ]]; then
    log_warning "Directorio de prueba existe, limpiando..."
    rm -rf "$TEST_DIR"
fi

# Crear directorio y configurar
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

log_info "Inicializando repositorio git..."
git init -q
git config user.email "test@example.com"
git config user.name "Test User"

log_success "Entorno preparado"
echo

# Ejecutar instalación
log_step "2. Ejecutando instalación"
echo

if [[ "$LOCAL_INSTALL" == "true" ]]; then
    log_info "Instalando desde script local..."
    if ! bash "$INSTALL_SCRIPT" --force; then
        log_error "Instalación falló"
        exit 1
    fi
else
    log_info "Instalando desde GitHub..."
    if ! bash <(curl -fsSL "$INSTALL_URL") --force --repo "$REPO" --branch "$BRANCH"; then
        log_error "Instalación falló"
        exit 1
    fi
fi

log_success "Instalación completada"
echo

# Verificar instalación
log_step "3. Verificando instalación"
echo

log_info "Estructura de directorios:"
test_assertion "Carpeta .cursor existe" "[[ -d '.cursor' ]]"
test_assertion "Carpeta .cursor/bin existe" "[[ -d '.cursor/bin' ]]"
test_assertion "Carpeta .cursor/commands existe" "[[ -d '.cursor/commands' ]]"
test_assertion "Carpeta .cursor/agents existe" "[[ -d '.cursor/agents' ]]"
test_assertion "Carpeta .cursor/rules existe" "[[ -d '.cursor/rules' ]]"

echo
log_info "Scripts ejecutables:"
test_assertion "start.sh existe y es ejecutable" "[[ -x '.cursor/bin/start.sh' ]]"
test_assertion "commit.sh existe y es ejecutable" "[[ -x '.cursor/bin/commit.sh' ]]"
test_assertion "push.sh existe y es ejecutable" "[[ -x '.cursor/bin/push.sh' ]]"
test_assertion "create-pull-request.sh existe y es ejecutable" "[[ -x '.cursor/bin/create-pull-request.sh' ]]"
test_assertion "clone.sh existe y es ejecutable" "[[ -x '.cursor/bin/clone.sh' ]]"
test_assertion "ai-commit-gemini.sh existe y es ejecutable" "[[ -x '.cursor/bin/ai-commit-gemini.sh' ]]"

echo
log_info "Documentación:"
test_assertion "README.md existe" "[[ -f '.cursor/README.md' ]]"
test_assertion "MANIFEST existe" "[[ -f '.cursor/MANIFEST' ]]"
test_assertion "start.md existe" "[[ -f '.cursor/commands/start.md' ]]"
test_assertion "commit.md existe" "[[ -f '.cursor/commands/commit.md' ]]"
test_assertion "push.md existe" "[[ -f '.cursor/commands/push.md' ]]"
test_assertion "create-pull-request.md existe" "[[ -f '.cursor/commands/create-pull-request.md' ]]"
test_assertion "clone.md existe" "[[ -f '.cursor/commands/clone.md' ]]"

echo

# Verificar contenido de scripts (no están vacíos)
log_step "4. Verificando integridad de archivos"
echo

log_info "Contenido de scripts:"
test_assertion "start.sh no está vacío" "[[ -s '.cursor/bin/start.sh' ]]"
test_assertion "commit.sh no está vacío" "[[ -s '.cursor/bin/commit.sh' ]]"
test_assertion "push.sh no está vacío" "[[ -s '.cursor/bin/push.sh' ]]"
test_assertion "start.sh tiene shebang" "grep -q '^#!/' '.cursor/bin/start.sh'"
test_assertion "commit.sh tiene shebang" "grep -q '^#!/' '.cursor/bin/commit.sh'"

echo

# Verificar que los scripts tienen ayuda
log_step "5. Verificando funcionalidad básica"
echo

log_info "Comandos de ayuda:"
test_assertion "start.sh --help funciona" ".cursor/bin/start.sh --help"
test_assertion "commit.sh --help funciona" ".cursor/bin/commit.sh --help"
test_assertion "push.sh --help funciona" ".cursor/bin/push.sh --help"

echo

# Resumen
log_header "Resumen de Pruebas"
echo

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))
PASS_RATE=$((TESTS_PASSED * 100 / TOTAL_TESTS))

echo "Total de pruebas: $TOTAL_TESTS"
echo -e "Pruebas exitosas: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Pruebas fallidas: ${RED}$TESTS_FAILED${NC}"
echo "Tasa de éxito: ${PASS_RATE}%"
echo

if [[ $TESTS_FAILED -eq 0 ]]; then
    log_success "¡Todas las pruebas pasaron!"
    echo
    log_info "Directorio de prueba: $TEST_DIR"
    log_info "Puedes explorar la instalación con: cd $TEST_DIR"
    echo
    read -p "¿Deseas limpiar el directorio de prueba? [s/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        rm -rf "$TEST_DIR"
        log_success "Directorio de prueba eliminado"
    else
        log_info "Directorio de prueba conservado: $TEST_DIR"
    fi
    exit 0
else
    log_error "Algunas pruebas fallaron"
    log_info "Revisa los errores arriba"
    log_info "Directorio de prueba: $TEST_DIR"
    exit 1
fi

