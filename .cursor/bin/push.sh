#!/usr/bin/env bash
set -Eeuo pipefail

# /push — Empuja cambios del work item activo con GitKraken CLI (gk work push)
#
# Basado en: gk work push
# Docs: https://gitkraken.github.io/gk-cli/docs/gk_work_push.html
#
# Uso
#   ./.cursor/bin/push.sh [opciones]
#   ./.cursor/bin/push.sh -h|--help
#
# Opciones (proxy a gk work push)
#   --create-pr | --pr    Crear PR después del push (aplica defaults) y abrirlo con GitHub CLI
#   -f, --force           Force push a upstream
#
# Ejemplos
#   /push                 # push del work item actual
#   /push --create-pr     # push y crea PR con defaults
#   /push -f              # force push

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
    sed -n '1,200p' "$0" | sed -n '/^# \/push/,/^$/p' | sed 's/^# \{0,1\}//'
}

case "${1-}" in
    -h|--help)
        help; exit 0 ;;
esac

if ! command -v gk >/dev/null 2>&1; then
    echo "${CRE}Error:${CNC} no se encontró 'gk' (GitKraken CLI). Instala y autentica primero: https://gitkraken.github.io/gk-cli/" >&2
    exit 127
fi

create_pr=0
force=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --create-pr|--pr)
            create_pr=1; shift ;;
        -f|--force)
            force=1; shift ;;
        -h|--help)
            help; exit 0 ;;
        *)
            echo "${CYE}Aviso:${CNC} flag desconocida: $1 (se ignora)" >&2
            shift ;;
    esac
done

logo "work push"

cmd=( gk work push )
[[ $create_pr -eq 1 ]] && cmd+=( --create-pr )
[[ $force -eq 1 ]] && cmd+=( --force )

echo "${CBL}Ejecutando:${CNC} ${cmd[*]}"
if "${cmd[@]}"; then
    echo "${CGR}✓ Push completado${CNC}"
    if [[ $create_pr -eq 1 ]]; then
        # Intentar abrir o crear PR con GitHub CLI
        if command -v gh >/dev/null 2>&1; then
            # Primero intentar abrir PR existente, si falla intentar crearlo con defaults
            if gh pr view --web >/dev/null 2>&1; then
                :
            else
                echo "${CBL}Creando PR con defaults (gh pr create)${CNC}"
                if gh pr create --fill --web >/dev/null 2>&1; then
                    :
                else
                    # fallback: abrir página de creación en web
                    gh repo view --web >/dev/null 2>&1 || true
                fi
            fi
        else
            echo "${CYE}Aviso:${CNC} GitHub CLI 'gh' no está instalado. Instala 'gh' para abrir PR automáticamente."
        fi
    fi
else
    rc=$?
    echo "${CRE}Error:${CNC} fallo 'gk work push' (rc=$rc)" >&2
    exit $rc
fi

exit 0


