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

cmd=( gk ai pr create )
[[ -n "$repo_path" ]] && cmd+=( --path "$repo_path" )

echo "${CBL}Ejecutando:${CNC} ${cmd[*]}"
if [[ $auto_yes -eq 1 ]]; then
    # Intenta auto-confirmar: responde 'y' si GK pregunta
    if printf 'y\n' | "${cmd[@]}"; then
        status=0
    else
        status=$?
    fi
else
    if "${cmd[@]}"; then
        status=0
    else
        status=$?
    fi
fi

if [[ $status -eq 0 ]]; then
    echo "${CGR}✓ Pull Request creado con AI${CNC}"
    if [[ $open_after -eq 1 ]] && command -v gh >/dev/null 2>&1; then
        gh pr view --web >/dev/null 2>&1 || gh pr create --fill --web >/dev/null 2>&1 || true
    fi
else
    echo "${CRE}Error:${CNC} fallo 'gk ai pr create' (rc=$status)" >&2
    exit $status
fi

exit 0


