#!/usr/bin/env bash
# ==============================================================================
# Quick Start - Configuración rápida de cursor_workflow
# ==============================================================================
# Este script ayuda a configurar el entorno después de instalar cursor_workflow
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

log_header() { echo -e "${BOLD}${CYAN}━━━ $* ━━━${NC}"; }
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
log_error() { echo -e "${RED}✗${NC} $*" >&2; }
log_step() { echo -e "${BOLD}$*${NC}"; }

echo
log_header "Quick Start - Cursor Workflow"
echo

# Función para verificar comandos
check_command() {
    local cmd="$1"
    local required="$2"
    local url="$3"
    
    if command -v "$cmd" &>/dev/null; then
        local version=""
        case "$cmd" in
            gk) version=$(gk --version 2>/dev/null | head -n1 || echo "") ;;
            git) version=$(git --version 2>/dev/null || echo "") ;;
            jq) version=$(jq --version 2>/dev/null || echo "") ;;
            gh) version=$(gh --version 2>/dev/null | head -n1 || echo "") ;;
            gemini) version="instalado" ;;
        esac
        log_success "$cmd: ${version}"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            log_error "$cmd: NO INSTALADO (requerido)"
            echo "  → Instalar: $url"
        else
            log_warning "$cmd: no instalado (opcional)"
            echo "  → Instalar: $url"
        fi
        return 1
    fi
}

# Verificar dependencias
log_step "1. Verificando dependencias..."
echo

MISSING_REQUIRED=0

check_command "git" "true" "https://git-scm.com/" || MISSING_REQUIRED=$((MISSING_REQUIRED + 1))
check_command "gk" "true" "https://gitkraken.dev/cli" || MISSING_REQUIRED=$((MISSING_REQUIRED + 1))
check_command "jq" "true" "sudo apt install jq (Ubuntu) | sudo pacman -S jq (Arch)" || MISSING_REQUIRED=$((MISSING_REQUIRED + 1))

echo
log_info "Dependencias opcionales:"
check_command "gh" "false" "https://cli.github.com/" || true
check_command "gemini" "false" "https://ai.google.dev/" || true

echo

if [[ $MISSING_REQUIRED -gt 0 ]]; then
    log_error "Faltan $MISSING_REQUIRED dependencias requeridas"
    echo
    echo "Por favor, instala las dependencias faltantes antes de continuar."
    exit 1
fi

log_success "Todas las dependencias requeridas están instaladas"
echo

# Verificar autenticación de GitKraken
log_step "2. Verificando autenticación de GitKraken..."
echo

if gk config get user.email &>/dev/null; then
    GK_EMAIL=$(gk config get user.email 2>/dev/null || echo "")
    if [[ -n "$GK_EMAIL" ]]; then
        log_success "GitKraken CLI autenticado como: $GK_EMAIL"
    else
        log_warning "GitKraken CLI: no se pudo verificar el email"
    fi
else
    log_warning "GitKraken CLI podría no estar autenticado"
    echo
    read -p "¿Deseas autenticarte ahora? [s/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        gk auth login
        log_success "Autenticación completada"
    else
        log_info "Puedes autenticarte más tarde con: gk auth login"
    fi
fi

echo

# Verificar autenticación de GitHub CLI (opcional)
log_step "3. Verificando autenticación de GitHub CLI (opcional)..."
echo

if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null; then
        GH_USER=$(gh api user --jq .login 2>/dev/null || echo "")
        log_success "GitHub CLI autenticado como: $GH_USER"
    else
        log_warning "GitHub CLI no autenticado"
        echo
        read -p "¿Deseas autenticarte ahora? [s/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[SsYy]$ ]]; then
            gh auth login
            log_success "Autenticación completada"
        else
            log_info "Puedes autenticarte más tarde con: gh auth login"
        fi
    fi
else
    log_info "GitHub CLI no instalado (opcional, para abrir PRs automáticamente)"
fi

echo

# Verificar configuración de Gemini (opcional)
log_step "4. Verificando configuración de Gemini (opcional)..."
echo

GEMINI_CONFIGURED=false

if command -v gemini &>/dev/null; then
    log_success "Gemini CLI instalado"
    GEMINI_CONFIGURED=true
elif [[ -n "${GEMINI_API_KEY:-}" ]]; then
    log_success "GEMINI_API_KEY configurado"
    GEMINI_CONFIGURED=true
else
    log_info "Gemini no configurado (fallback para commits con IA)"
    echo
    read -p "¿Deseas configurar GEMINI_API_KEY ahora? [s/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        echo
        read -p "Ingresa tu GEMINI_API_KEY: " api_key
        if [[ -n "$api_key" ]]; then
            echo "export GEMINI_API_KEY=\"$api_key\"" >> ~/.bashrc
            echo "export GEMINI_API_KEY=\"$api_key\"" >> ~/.zshrc 2>/dev/null || true
            export GEMINI_API_KEY="$api_key"
            log_success "GEMINI_API_KEY configurado"
            log_info "Recarga tu shell o ejecuta: source ~/.bashrc"
            GEMINI_CONFIGURED=true
        fi
    fi
fi

echo

# Verificar instalación de .cursor
log_step "5. Verificando instalación de cursor_workflow..."
echo

if [[ -d ".cursor" ]]; then
    log_success "Carpeta .cursor encontrada"
    
    # Verificar scripts
    SCRIPTS=(start.sh commit.sh push.sh create-pull-request.sh clone.sh)
    ALL_FOUND=true
    
    for script in "${SCRIPTS[@]}"; do
        if [[ -x ".cursor/bin/$script" ]]; then
            log_success ".cursor/bin/$script (ejecutable)"
        else
            log_error ".cursor/bin/$script: no encontrado o no ejecutable"
            ALL_FOUND=false
        fi
    done
    
    if [[ "$ALL_FOUND" != "true" ]]; then
        echo
        log_warning "Algunos scripts no están instalados correctamente"
        log_info "Ejecuta: bash <(curl -fsSL URL_DEL_INSTALADOR) --force"
    fi
else
    log_error "Carpeta .cursor no encontrada"
    echo
    log_info "Para instalar, ejecuta:"
    echo "  bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh)"
    exit 1
fi

echo

# Resumen y próximos pasos
log_header "✨ Resumen de configuración"
echo

echo "Estado de las herramientas:"
echo "  • GitKraken CLI: $(command -v gk &>/dev/null && echo "✓ Instalado" || echo "✗ No instalado")"
echo "  • GitHub CLI: $(command -v gh &>/dev/null && echo "✓ Instalado" || echo "○ No instalado (opcional)")"
echo "  • Gemini: $([ "$GEMINI_CONFIGURED" = "true" ] && echo "✓ Configurado" || echo "○ No configurado (opcional)")"
echo "  • Scripts .cursor: $([ -d ".cursor/bin" ] && echo "✓ Instalados" || echo "✗ No instalados")"
echo

log_step "🚀 ¡Listo para comenzar!"
echo

log_header "Próximos pasos"
echo

echo "1. Iniciar un nuevo trabajo:"
echo "   ${CYAN}.cursor/bin/start.sh \"feat: tu funcionalidad\" -b feat/nombre${NC}"
echo

echo "2. Hacer cambios en el código y crear commit:"
echo "   ${CYAN}.cursor/bin/commit.sh -d${NC}"
echo

echo "3. Push y crear Pull Request:"
echo "   ${CYAN}.cursor/bin/push.sh --create-pr${NC}"
echo

echo "4. O crear PR manualmente:"
echo "   ${CYAN}.cursor/bin/create-pull-request.sh --open${NC}"
echo

log_header "Documentación"
echo

echo "• README principal: ${CYAN}cat README.md${NC}"
echo "• Documentación .cursor: ${CYAN}cat .cursor/README.md${NC}"
echo "• Comandos individuales: ${CYAN}ls .cursor/commands/${NC}"
echo

log_success "Configuración completada"
echo

