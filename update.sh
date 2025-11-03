#!/usr/bin/env bash
# ==============================================================================
# Script de actualización de cursor_workflow
# ==============================================================================
# Actualiza la instalación existente de cursor_workflow a la última versión
# ==============================================================================

set -euo pipefail

# Colores
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $*"; }

# Configuración por defecto
REPO="${CURSOR_WORKFLOW_REPO:-}"
BRANCH="${CURSOR_WORKFLOW_BRANCH:-master}"

echo
log_info "Actualizador de cursor_workflow"
echo

# Verificar si .cursor existe
if [[ ! -d ".cursor" ]]; then
    log_warning "No se encontró instalación de cursor_workflow en este directorio"
    echo
    read -p "¿Deseas instalarlo ahora? [s/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        if [[ -n "$REPO" ]]; then
            bash <(curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh")
        else
            log_warning "No se especificó CURSOR_WORKFLOW_REPO"
            echo "Configura la variable de entorno o proporciona el repositorio:"
            read -p "Repositorio (formato usuario/repo): " repo_input
            export CURSOR_WORKFLOW_REPO="$repo_input"
            bash <(curl -fsSL "https://raw.githubusercontent.com/${repo_input}/${BRANCH}/install.sh")
        fi
    fi
    exit 0
fi

log_info "Instalación actual encontrada"
echo

# Autodetectar repositorio si no está configurado
if [[ -z "$REPO" ]]; then
    if git remote get-url origin &>/dev/null; then
        ORIGIN=$(git remote get-url origin)
        if [[ "$ORIGIN" =~ github\.com[:/]([^/]+/[^/]+?)(\.git)?$ ]]; then
            REPO="${BASH_REMATCH[1]}"
        fi
    fi
    
    if [[ -z "$REPO" ]]; then
        log_warning "No se pudo autodetectar el repositorio"
        read -p "Repositorio (formato usuario/repo): " repo_input
        REPO="$repo_input"
    fi
fi

log_info "Repositorio: $REPO"
log_info "Rama: $BRANCH"
echo

# Preguntar antes de actualizar
read -p "¿Deseas actualizar cursor_workflow? [s/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
    log_info "Actualización cancelada"
    exit 0
fi

echo
log_info "Descargando e instalando actualización..."
echo

# Ejecutar instalador con --force
if command -v curl &>/dev/null; then
    bash <(curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh") --force --repo "$REPO" --branch "$BRANCH"
elif command -v wget &>/dev/null; then
    bash <(wget -qO- "https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh") --force --repo "$REPO" --branch "$BRANCH"
else
    log_error "Se necesita curl o wget para actualizar"
    exit 1
fi

echo
log_success "¡Actualización completada!"
echo
log_info "Revisa el changelog o README para ver las novedades"
echo

