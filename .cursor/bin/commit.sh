#!/usr/bin/env bash
set -Eeuo pipefail

# commit.sh — Crea un commit con IA
# 1) Intenta usar GitKraken CLI: gk ai commit (no interactivo)
# 2) Si falla o no existe, usa fallback Gemini API: ai-commit-gemini.sh
#
# Requisitos:
#   - Opción A (preferida): gk autenticado (gk ai commit)
#   - Opción B (fallback): GEMINI_API_KEY exportada para usar Gemini API
#   - git, jq (para fallback), curl (para fallback)
#
# Uso:
#   ./.cursor/bin/commit.sh [-p|--path <repo_dir>] [--all] [-d|--add-description] [-h|--help]
#

print_help() {
  cat <<'EOF'
Uso:
  ./.cursor/bin/commit.sh [-p|--path <repo_dir>] [--all] [-d|--add-description]

Descripción:
  Intenta crear un commit con `gk ai commit`. Si no está disponible o falla,
  usa el fallback `ai-commit-gemini.sh` (Gemini vía API Key).

Opciones:
  -p, --path <repo_dir>     Directorio del repo (por defecto: $PWD)
      --all                 Comitea todos los cambios tracked (equivalente a -a)
  -d, --add-description     (Compat) Genera cuerpo del commit (fallback ya lo hace)
  -h, --help                Muestra esta ayuda

Notas:
  - Para el fallback, exporta GEMINI_API_KEY y opcionalmente GEMINI_MODEL.
  - Este proyecto prioriza mensajes en español con Conventional Commits + emoji.
EOF
}

repo_path="${PWD}"
use_all=0
# Flag compat, no se usa explícitamente: el fallback ya genera body
add_description=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--path)
      repo_path=${2-}
      shift 2
      ;;
    --all)
      use_all=1
      shift
      ;;
    -d|--add-description)
      add_description=1
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      # Ignorar flags desconocidos para mantener compatibilidad futura
      shift
      ;;
  esac
done

cd "${repo_path}"

# Si se solicita --all, asegura stage antes del intento con gk
if [[ ${use_all} -eq 1 ]]; then
  git add -A || true
fi

run_gk() {
  # Ejecuta gk si está disponible. Intentos no interactivos.
  command -v gk >/dev/null 2>&1 || return 127
  # Intento no interactivo: responder afirmativamente al prompt
  if printf "y\n" | gk ai commit; then
    return 0
  fi
  # Intento simple (por si no requiere confirmación)
  gk ai commit && return 0
  return 1
}

if run_gk; then
  echo "✓ Commit creado con gk ai commit" >&2
  exit 0
fi

echo "Aviso: usando fallback Gemini (API)" >&2

fallback_script="$(dirname "$0")/ai-commit-gemini.sh"
[[ -x "${fallback_script}" ]] || { echo "No se encuentra ${fallback_script} ejecutable" >&2; exit 2; }

args=( )
args+=( --path "${repo_path}" )
if [[ ${use_all} -eq 1 ]]; then
  args+=( --all )
fi

"${fallback_script}" "${args[@]}"


