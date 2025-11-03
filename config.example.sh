#!/usr/bin/env bash
# ==============================================================================
# Configuración de cursor_workflow - Ejemplo
# ==============================================================================
# Copia este archivo a config.sh y personaliza según tus necesidades
# Luego ejecuta: source config.sh
# O agrégalo a tu ~/.bashrc o ~/.zshrc para hacerlo permanente
# ==============================================================================

# Repositorio de cursor_workflow en GitHub (formato: usuario/repo)
# Usado por los scripts de instalación y actualización
export CURSOR_WORKFLOW_REPO="25ASAB015/cursor_workflow"

# Rama a usar para instalaciones/actualizaciones
export CURSOR_WORKFLOW_BRANCH="master"

# API Key de Gemini (opcional, para fallback de commits con IA)
# Obtén tu API key en: https://ai.google.dev/
export GEMINI_API_KEY="tu_gemini_api_key_aqui"

# Configuración de GitKraken CLI (opcional)
# Estas variables son reconocidas por gk
# export GK_CLOUD_API_TOKEN="tu_token_aqui"

# Configuración de GitHub CLI (opcional)
# export GITHUB_TOKEN="tu_github_token_aqui"

# Configuración de git (opcional, si quieres sobrescribir)
# export GIT_AUTHOR_NAME="Tu Nombre"
# export GIT_AUTHOR_EMAIL="tu@email.com"
# export GIT_COMMITTER_NAME="Tu Nombre"
# export GIT_COMMITTER_EMAIL="tu@email.com"

# Editor por defecto para commits interactivos (opcional)
# export EDITOR="vim"
# export VISUAL="code --wait"

# Directorio base para clones de prueba (usado por clone.sh)
# Por defecto: ~/src/tries
# export TRIES_DIR="$HOME/src/tries"

# Configuración de idioma para mensajes
# export LANG="es_ES.UTF-8"
# export LC_ALL="es_ES.UTF-8"

# ==============================================================================
# Configuración avanzada
# ==============================================================================

# Deshabilitar uso de IA en commits (usar solo git commit estándar)
# export CURSOR_WORKFLOW_NO_AI=true

# Forzar uso de Gemini en lugar de GitKraken AI
# export CURSOR_WORKFLOW_FORCE_GEMINI=true

# Nivel de verbosidad (0=silencioso, 1=normal, 2=verbose)
# export CURSOR_WORKFLOW_VERBOSE=1

# Timeout para operaciones de red (en segundos)
# export CURSOR_WORKFLOW_TIMEOUT=30

# ==============================================================================
# Notas de uso
# ==============================================================================
# 
# Para aplicar esta configuración temporalmente (solo en la sesión actual):
#   source config.sh
#
# Para aplicar esta configuración permanentemente:
#   echo "source $(pwd)/config.sh" >> ~/.bashrc
#   echo "source $(pwd)/config.sh" >> ~/.zshrc
#
# O copiar las variables directamente a tu ~/.bashrc o ~/.zshrc
#
# Para verificar las variables actuales:
#   env | grep CURSOR_WORKFLOW
#   env | grep GEMINI_API_KEY
#   env | grep GK_
#

echo "Configuración de cursor_workflow cargada"
echo "Repositorio: ${CURSOR_WORKFLOW_REPO:-no configurado}"
echo "Rama: ${CURSOR_WORKFLOW_BRANCH:-master}"
echo "Gemini API: ${GEMINI_API_KEY:+configurado}"

