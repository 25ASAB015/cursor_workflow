#!/usr/bin/env bash
set -Eeuo pipefail

# /clone — Clona un repositorio usando exclusivamente "try" en ~/src/tries
#
# Uso
#   ./.cursor/bin/clone.sh <repo_url> <name>
#   (Se invoca desde el slash command `/clone`)
#
# Parámetros
#   repo_url  URL del repo (HTTPS o SSH). Se acepta prefijo opcional '@'.
#   name      Nombre del directorio destino dentro de ~/src/tries
#
# Flujo
#   - Normaliza repo_url (quita '@' si existe).
#   - Define base_dir = "$HOME/src/tries" y lo crea si no existe.
#   - Si existe binario `try` en PATH: ejecuta TRY_PATH="$base_dir" try clone "repo_url" "name".
#   - Si no existe en PATH pero está ~/.local/try.rb: ejecuta
#       ruby ~/.local/try.rb --path "$base_dir" clone "repo_url" "name"
#     y evalúa su salida (que incluye git clone y cd).
#   - Si no hay `try` ni `~/.local/try.rb`: muestra instrucciones de instalación y aborta.
#   - Al finalizar, abre una nueva instancia de Cursor en el directorio clonado si el CLI `cursor` está disponible.
#
# Ejemplos
#   /clone https://github.com/user/repo.git my-repo     -> ~/src/tries/my-repo
#   /clone @https://github.com/tobi/try.git tryfork     -> ~/src/tries/tryfork
#   /clone git@github.com:user/repo.git demo            -> ~/src/tries/demo
#
# Salida esperada
#   ✓ Clonado exitoso: ~/src/tries/<name>
#   Abriendo Cursor: ~/src/tries/<name>
#   (o aviso si no hay CLI `cursor`)
#
# Notas
#   - No hay fallback a `git clone` directo aquí; siempre se usa `try`.
#   - Evita sudo. Muestra la salida y la ruta final creada.
#   - Referencia de la herramienta: https://github.com/tobi/try.git

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

usage() {
    echo "Uso: $0 <repo_url> <name>" >&2
    echo "Ejemplos:" >&2
    echo "  $0 https://github.com/user/repo.git my-repo" >&2
    echo "  $0 git@github.com:user/repo.git my-repo" >&2
    exit 2
}

help() {
    cat <<'EOF'
/clone — Clona un repositorio usando exclusivamente "try" en ~/src/tries

Uso:
  ./.cursor/bin/clone.sh <repo_url> <name>
  ./.cursor/bin/clone.sh -h|--help

Parámetros:
  repo_url  URL del repo (HTTPS o SSH). Se acepta prefijo opcional '@'.
  name      Nombre del directorio destino dentro de ~/src/tries

Flujo:
  - Normaliza repo_url (quita '@' si existe).
  - Define base_dir = "$HOME/src/tries" y lo crea si no existe.
  - Si existe binario `try` en PATH: ejecuta TRY_PATH="$HOME/src/tries" try clone "repo_url" "name".
  - Si no existe en PATH pero está ~/.local/try.rb: ejecuta
      ruby ~/.local/try.rb --path "$HOME/src/tries" clone "repo_url" "name"
    y evalúa su salida.
  - Si no hay `try` ni `~/.local/try.rb`: muestra instrucciones de instalación y aborta.
  - Al finalizar, abre una nueva instancia de Cursor en el directorio clonado si el CLI `cursor` está disponible.

Ejemplos:
  /clone https://github.com/user/repo.git my-repo     -> ~/src/tries/my-repo
  /clone @https://github.com/tobi/try.git tryfork     -> ~/src/tries/tryfork
  /clone git@github.com:user/repo.git demo            -> ~/src/tries/demo

Notas:
  - No hay fallback a `git clone`; siempre se usa `try`.
  - Referencia: https://github.com/tobi/try.git
EOF
}

case "${1-}" in
    -h|--help)
        help; exit 0 ;;
esac

repo_url=${1-}
dest_name=${2-}

[[ -n "$repo_url" && -n "$dest_name" ]] || usage

logo "clone"

# Normaliza el repo si viene con prefijo '@'
case "$repo_url" in
    @*) repo_url="${repo_url#@}" ;;
esac

base_dir="$HOME/src/tries"
mkdir -p "$base_dir"

if command -v try >/dev/null 2>&1; then
    echo "${CBL}Ejecutando:${CNC} TRY_PATH=\"$base_dir\" try clone \"$repo_url\" \"$dest_name\""
    TRY_PATH="$base_dir" try clone "$repo_url" "$dest_name"
elif [[ -f "$HOME/.local/try.rb" ]]; then
    echo "${CBL}Ejecutando (ruby):${CNC} ~/.local/try.rb --path \"$base_dir\" clone \"$repo_url\" \"$dest_name\""
    if ! cmd=$(ruby "$HOME/.local/try.rb" --path "$base_dir" clone "$repo_url" "$dest_name"); then
        echo "${CRE}Error:${CNC} fallo de 'try.rb'" >&2
        exit 1
    fi
    # El script 'try.rb' imprime un comando shell a ejecutar (p.ej., git clone && cd ...)
    if [[ "$cmd" == *" && "* ]]; then
        eval "$cmd"
    else
        eval "$cmd"
    fi
else
    echo "${CRE}Error:${CNC} no se encontró 'try' ni '~/.local/try.rb'. Instálalo:" >&2
    echo "  curl -sL https://raw.githubusercontent.com/tobi/try/refs/heads/main/try.rb > ~/.local/try.rb" >&2
    echo "  chmod +x ~/.local/try.rb" >&2
    echo "Repositorio: https://github.com/tobi/try.git" >&2
    exit 127
fi
final_dir="$base_dir/$dest_name"

if [[ -d "${final_dir}" ]]; then
    echo "${CGR}✓ Clonado exitoso${CNC}: ${final_dir}"
    if command -v cursor >/dev/null 2>&1; then
        echo "${CBL}Abriendo Cursor:${CNC} ${final_dir}"
        (cursor --new-window "${final_dir}" >/dev/null 2>&1 || cursor "${final_dir}" >/dev/null 2>&1) &
    else
        echo "${CYE}Aviso:${CNC} no se encontró el CLI 'cursor'. Abre manualmente: ${final_dir}"
    fi
else
    echo "${CYE}! Aviso:${CNC} no se pudo determinar la ruta final. Verifica la salida anterior."
fi

exit 0


