#!/usr/bin/env bash
set -Eeuo pipefail

# /create-pull-request — Crea un Pull Request con mensaje generado por AI usando GitKraken CLI
#
# Basado en: gk ai pr create
# Docs: https://gitkraken.github.io/gk-cli/docs/gk_ai_pr_create.html
#
# Uso
#   ./.cursor/bin/create-pull-request.sh [opciones]
#   ./.cursor/bin/create-pull-request.sh -h|--help
#
# Opciones (proxy a gk ai pr create)
#   -p, --path <dir>   Ruta del repositorio (opcional; por defecto cwd)
#   -y, --yes          Confirmación automática (no preguntar y/n) [por defecto]
#   --ask              Solicitar confirmación (desactiva el yes por defecto)
#   --open             Abrir PR en el navegador con GitHub CLI tras crear
#
# Ejemplos
#   /create-pull-request          # en el repo actual
#   /create-pull-request -p .     # explícito en cwd
#   /create-pull-request -p ~/r   # ruta concreta

CRE=$(tput setaf 1 || true)
CYE=$(tput setaf 3 || true)
CGR=$(tput setaf 2 || true)
CBL=$(tput setaf 4 || true)
BLD=$(tput bold || true)
CNC=$(tput sgr0 || true)

logo() {
	text="$1"
	printf "%b" "
   ▗▖                              ▗▖        
   ▐▌      ▐▌                      ▐▌        
 ▟█▟▌ ▟█▙ ▐███ ▐█▙█▖ ▟██▖ █▟█▌ ▟██▖▐▙██▖▝█ █▌
▐▛ ▜▌▐▛ ▜▌ ▐▌  ▐▌█▐▌ ▘▄▟▌ █▘  ▐▛  ▘▐▛ ▐▌ █▖█ 
▐▌ ▐▌▐▌ ▐▌ ▐▌  ▐▌█▐▌▗█▀▜▌ █   ▐▌   ▐▌ ▐▌ ▐█▛ 
▝█▄█▌▝█▄█▘ ▐▙▄ ▐▌█▐▌▐▙▄█▌ █   ▝█▄▄▌▐▌ ▐▌  █▌ 
 ▝▀▝▘ ▝▀▘   ▀▀ ▝▘▀▝▘ ▀▀▝▘ ▀    ▝▀▀ ▝▘ ▝▘  █  
                                         █▌  

   ${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

help() {
    sed -n '1,200p' "$0" | sed -n '/^# \/create-pull-request/,/^$/p' | sed 's/^# \{0,1\}//'
}

case "${1-}" in
    -h|--help)
        help; exit 0 ;;
esac

if ! command -v gk >/dev/null 2>&1; then
    echo "${CRE}Error:${CNC} no se encontró 'gk' (GitKraken CLI). Instala y autentica primero: https://gitkraken.github.io/gk-cli/" >&2
    exit 127
fi

repo_path=""
# Confirmación automática por defecto para evitar prompts en slash commands
auto_yes=1
open_after=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--path)
            repo_path=${2-}; shift 2 ;;
        -y|--yes)
            auto_yes=1; shift ;;
        --ask)
            auto_yes=0; shift ;;
        --open)
            open_after=1; shift ;;
        -h|--help)
            help; exit 0 ;;
        *)
            echo "${CYE}Aviso:${CNC} flag desconocida: $1 (se ignora)" >&2
            shift ;;
    esac
done

logo "ai pr create"

# Estrategia: capturar salida de gk ai pr create y parsear título/descripción
# Luego usar gh pr create con esos datos para evitar prompts interactivos

cmd=( gk ai pr create )
[[ -n "$repo_path" ]] && cmd+=( --path "$repo_path" )

echo "${CBL}Generando título y descripción con AI...${CNC}"

# Ejecutar gk ai pr create y capturar salida hasta el prompt
# Usamos timeout y capturamos stdout/stderr
temp_output=$(mktemp)
trap "rm -f '$temp_output'" EXIT

# Ejecutar con timeout de 30s y enviar 'n' para cancelar después de capturar
if timeout 30s bash -c "echo 'n' | ${cmd[*]}" > "$temp_output" 2>&1 || true; then
    # Parsear título y descripción de la salida
    pr_title=$(grep -A1 "^Title:" "$temp_output" | tail -1 | sed 's/^[[:space:]]*//')
    pr_description=$(sed -n '/^Description:/,/^Do you want to proceed/p' "$temp_output" | grep -v "^Description:" | grep -v "^Do you want to proceed" | sed 's/^[[:space:]]*//' | sed '/^$/d')
    
    if [[ -z "$pr_title" ]]; then
        echo "${CRE}Error:${CNC} no se pudo generar título con gk ai pr create" >&2
        echo "${CYE}Salida capturada:${CNC}" >&2
        cat "$temp_output" >&2
        exit 1
    fi
    
    echo "${CGR}Título generado:${CNC} $pr_title"
    echo "${CGR}Descripción generada:${CNC}"
    echo "$pr_description"
    echo ""
    
    # Crear PR con gh usando los datos generados
    if ! command -v gh >/dev/null 2>&1; then
        echo "${CRE}Error:${CNC} GitHub CLI 'gh' no está instalado. Instala 'gh' para crear PRs." >&2
        exit 127
    fi
    
    echo "${CBL}Creando PR con GitHub CLI...${CNC}"
    if [[ $auto_yes -eq 1 ]]; then
        # Crear PR directamente
        if gh pr create --title "$pr_title" --body "$pr_description"; then
            echo "${CGR}✓ Pull Request creado con AI${CNC}"
            if [[ $open_after -eq 1 ]]; then
                gh pr view --web >/dev/null 2>&1 || true
            fi
        else
            status=$?
            echo "${CRE}Error:${CNC} fallo 'gh pr create' (rc=$status)" >&2
            exit $status
        fi
    else
        # Modo interactivo: mostrar y pedir confirmación
        echo ""
        read -p "¿Crear PR con estos datos? [y/N]: " confirm
        if [[ "$confirm" =~ ^[yY]$ ]]; then
            if gh pr create --title "$pr_title" --body "$pr_description"; then
                echo "${CGR}✓ Pull Request creado con AI${CNC}"
                if [[ $open_after -eq 1 ]]; then
                    gh pr view --web >/dev/null 2>&1 || true
                fi
            else
                status=$?
                echo "${CRE}Error:${CNC} fallo 'gh pr create' (rc=$status)" >&2
                exit $status
            fi
        else
            echo "${CYE}Cancelado por el usuario${CNC}"
            exit 0
        fi
    fi
else
    echo "${CRE}Error:${CNC} timeout o fallo al ejecutar gk ai pr create" >&2
    exit 1
fi

exit 0


