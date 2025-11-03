#!/usr/bin/env bash
# ==============================================================================
# Ejemplo de uso del instalador de cursor_workflow
# ==============================================================================
# Este script muestra diferentes formas de usar el instalador.
# Copia este archivo y adapta según tus necesidades.
# ==============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }

echo "=============================================="
echo "  Ejemplos de instalación de cursor_workflow"
echo "=============================================="
echo

# Ejemplo 1: Instalación básica desde GitHub
log_info "Ejemplo 1: Instalación básica desde GitHub"
echo "bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh)"
echo

# Ejemplo 2: Instalación desde rama específica
log_info "Ejemplo 2: Instalación desde rama específica (develop)"
echo "bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/develop/install.sh) --branch develop"
echo

# Ejemplo 3: Instalación forzada (sobrescribir existente)
log_info "Ejemplo 3: Instalación forzada"
echo "bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --force"
echo

# Ejemplo 4: Instalación especificando repositorio
log_info "Ejemplo 4: Especificando repositorio manualmente"
echo "bash install.sh --repo tu_usuario/cursor_workflow"
echo

# Ejemplo 5: Con variables de entorno
log_info "Ejemplo 5: Usando variables de entorno"
cat << 'EOF'
export CURSOR_WORKFLOW_REPO="tu_usuario/cursor_workflow"
export CURSOR_WORKFLOW_BRANCH="master"
bash <(curl -fsSL https://raw.githubusercontent.com/${CURSOR_WORKFLOW_REPO}/${CURSOR_WORKFLOW_BRANCH}/install.sh)
EOF
echo

# Ejemplo 6: Instalación local
log_info "Ejemplo 6: Instalación desde repositorio local"
echo "cd /ruta/a/tu/proyecto"
echo "/ruta/a/cursor_workflow/install.sh"
echo

# Ejemplo 7: Con wget en lugar de curl
log_info "Ejemplo 7: Usando wget en lugar de curl"
echo "wget -qO- https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh | bash"
echo

# Ejemplo 8: Descargar y revisar antes de ejecutar
log_info "Ejemplo 8: Descargar, revisar y ejecutar"
cat << 'EOF'
curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh -o install-cursor.sh
less install-cursor.sh  # Revisar el contenido
bash install-cursor.sh
rm install-cursor.sh
EOF
echo

echo "=============================================="
log_success "Copia y adapta estos ejemplos según tus necesidades"
echo "=============================================="

