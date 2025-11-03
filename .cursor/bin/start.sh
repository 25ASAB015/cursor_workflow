#!/usr/bin/env bash
set -Eeuo pipefail

# /start — Inicia un nuevo item de trabajo usando GitKraken CLI (gk work start)
#
# Uso
#   ./.cursor/bin/start.sh <name> [opciones]
#   ./.cursor/bin/start.sh -h|--help
#
# Parámetros
#   name                    Nombre del work item (usado por GK para preparar ramas)
#
# Opciones (proxy a gk work start)
#   --base-branch <str>     Rama base (por defecto: rama por defecto del repo)
#   -b, --branch <str>      Nombre de rama a usar en los repos de la workspace
#   --include-repos <csv>   Coma-separado de repos a incluir
#   --exclude-repos <csv>   Coma-separado de repos a excluir
#   -i, --issue <str>       Issue key (p. ej., ABC-123) para enlazar
#
# Ejemplos
#   /start "feat: onboarding"
#   /start "cool new work" -b feat/cool --base-branch master -i ABC-123
#   /start "fix: bug" --include-repos repo-1,repo-2 --exclude-repos legacy-repo
#
# Requisitos
#   - GitKraken CLI (`gk`) instalado y autenticado. Docs: https://gitkraken.github.io/gk-cli/

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
    sed -n '1,200p' "$0" | sed -n '/^# \/start/,/^$/p' | sed 's/^# \{0,1\}//'
}

case "${1-}" in
    -h|--help)
        help; exit 0 ;;
esac

name=${1-}
shift || true

if [[ -z "${name:-}" ]]; then
    echo "${CRE}Error:${CNC} falta <name>. Usa --help para ver ejemplos." >&2
    exit 2
fi

if ! command -v gk >/dev/null 2>&1; then
    echo "${CRE}Error:${CNC} no se encontró 'gk' (GitKraken CLI). Instala y autentica primero: https://gitkraken.github.io/gk-cli/" >&2
    exit 127
fi

# Parseo de flags que vamos a reenviar a 'gk work start'
base_branch=""
branch=""
include_repos=""
exclude_repos=""
issue=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --base-branch)
            base_branch=${2-}; shift 2 ;;
        -b|--branch)
            branch=${2-}; shift 2 ;;
        --include-repos)
            include_repos=${2-}; shift 2 ;;
        --exclude-repos)
            exclude_repos=${2-}; shift 2 ;;
        -i|--issue)
            issue=${2-}; shift 2 ;;
        -h|--help)
            help; exit 0 ;;
        *)
            echo "${CYE}Aviso:${CNC} flag desconocida: $1 (se ignora)" >&2
            shift ;;
    esac
done

logo "work start"

cmd=( gk work start "$name" )
[[ -n "$base_branch" ]] && cmd+=( --base-branch "$base_branch" )
[[ -n "$branch" ]] && cmd+=( --branch "$branch" )
[[ -n "$include_repos" ]] && cmd+=( --include-repos "$include_repos" )
[[ -n "$exclude_repos" ]] && cmd+=( --exclude-repos "$exclude_repos" )
[[ -n "$issue" ]] && cmd+=( --issue "$issue" )

echo "${CBL}Ejecutando:${CNC} ${cmd[*]}"
if "${cmd[@]}"; then
    echo "${CGR}✓ Work item iniciado${CNC}"
else
    rc=$?
    echo "${CRE}Error:${CNC} fallo 'gk work start' (rc=$rc)" >&2
    exit $rc
fi

exit 0


