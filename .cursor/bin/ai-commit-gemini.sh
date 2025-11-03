#!/usr/bin/env bash
set -Eeuo pipefail

# ai-commit-gemini — Genera un mensaje de commit con Gemini y aplica el commit (no interactivo)
#
# Requisitos:
#   - curl, jq, git
#   - GEMINI_API_KEY (exportada en el entorno)
#   - Opcional: GEMINI_MODEL (por defecto: gemini-2.5-pro)
#
# Uso:
#   ./.cursor/bin/ai-commit-gemini.sh [-p|--path <repo_dir>] [--all]
#   ./.cursor/bin/ai-commit-gemini.sh -h|--help
#
# Salida:
#   Crea un commit con formato Conventional Commits + emoji (estilo d-ocm-emoji)

help() {
    sed -n '1,200p' "$0" | sed -n '/^# ai-commit-gemini/,/^$/p' | sed 's/^# \{0,1\}//'
}

case "${1-}" in
    -h|--help)
        help; exit 0 ;;
esac

for dep in jq git; do
    command -v "$dep" >/dev/null 2>&1 || { echo "Falta dependencia: $dep" >&2; exit 127; }
done

repo_path="${PWD}"
commit_all=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--path) repo_path=${2-}; shift 2 ;;
        --all) commit_all=1; shift ;;
        -h|--help) help; exit 0 ;;
        *) shift ;;
    esac
done

cd "$repo_path"

# Solo proceder si hay cambios staged, salvo que --all esté activo
staged_names=$(git diff --name-only --staged || true)
if [[ -z "$staged_names" && $commit_all -eq 0 ]]; then
    echo "No hay cambios staged para comitear" >&2; exit 3
fi

# Construye contexto para el modelo
if [[ -n "$staged_names" ]]; then
    diff_text=$(git diff --staged || true)
else
    # --all: usa status como contexto
    diff_text=$(git status --porcelain || true)
fi

# Limita tamaño del prompt (aprox. 20k chars)
max_chars=6000
truncated="no"
if (( ${#diff_text} > max_chars )); then
    diff_text="${diff_text:0:max_chars}\n\n[... TRUNCADO ...]"
    truncated="yes"
fi

model="${GEMINI_MODEL:-gemini-2.5-pro}"

read -r -d '' prompt << 'EOF'
Eres un generador de mensajes de commit. Devuelve SOLO JSON con esta forma:
{
  "type": "feat|fix|docs|style|refactor|perf|test|chore",
  "scope": "string opcional, sin espacios, kebab-case",
  "subject": "línea corta imperativa (<= 72 chars)",
  "body": "texto opcional en español, bullets si aplica"
}

Reglas:
- Usa Conventional Commits (español). Imperativo, conciso.
- No incluyas código del diff en el subject.
- Si el cambio es mezcla, elige el tipo dominante.
- scope vacío si no aporta claridad.
EOF

use_cli=0
cli_cmd=""

# Permitir override explícito
if [[ -n "${GEMINI_CLI:-}" && -x "${GEMINI_CLI}" ]]; then
    cli_cmd="${GEMINI_CLI}"
    use_cli=1
fi

# Intentar detectar binarios comunes si no hay override
if [[ $use_cli -eq 0 ]]; then
    for name in gemini genai; do
        if command -v "$name" >/dev/null 2>&1; then
            cli_cmd="$name"
            use_cli=1
            break
        fi
    done
fi

# Buscar en rutas típicas si aún no aparece
if [[ $use_cli -eq 0 ]]; then
    for dir in "$HOME/.local/bin" "$HOME/bin" "/usr/local/bin" "/opt/homebrew/bin"; do
        if [[ -x "$dir/gemini" ]]; then
            cli_cmd="$dir/gemini"; use_cli=1; break
        fi
        if [[ -x "$dir/genai" ]]; then
            cli_cmd="$dir/genai"; use_cli=1; break
        fi
    done
fi

if [[ $use_cli -eq 1 ]]; then
    # Usar gemini CLI (autenticado con cuenta Google)
    content="$prompt\n\nDIFF:\n$diff_text"

    # Archivo temporal para evitar problemas de quoting/longitud en -p
    tmp_prompt=$(mktemp)
    trap 'rm -f "$tmp_prompt" 2>/dev/null || true' EXIT
    printf '%s' "$content" > "$tmp_prompt"

    try_cli() {
        # Preferir -p con salida de archivo
        "$cli_cmd" -m "$model" -p "$(cat "$tmp_prompt")" -o text 2>/dev/null && return 0
        # Stdin con -o text
        "$cli_cmd" -m "$model" -o text < "$tmp_prompt" 2>/dev/null && return 0
        # Sin -o text, con -p
        "$cli_cmd" -m "$model" -p "$(cat "$tmp_prompt")" 2>/dev/null && return 0
        # Stdin sin -o text
        "$cli_cmd" -m "$model" < "$tmp_prompt" 2>/dev/null && return 0
        # Posicional (último recurso)
        "$cli_cmd" -m "$model" "$(cat "$tmp_prompt")" 2>/dev/null && return 0
        return 1
    }

    if ! text=$(try_cli); then
        # Fallback: prompt reducido con solo nombres de archivos
        names=$(git diff --name-only --staged || true)
        [[ -z "$names" ]] && names=$(git status --porcelain | awk '{print $2}')
        short_content="$prompt\n\nARCHIVOS CAMBIADOS:\n$names"
        printf '%s' "$short_content" > "$tmp_prompt"
        # Reintentar con variantes sobre archivo
        if ! text=$( "$cli_cmd" -m "$model" -p "$(cat "$tmp_prompt")" -o text 2>/dev/null ); then
            if ! text=$( "$cli_cmd" -m "$model" -o text < "$tmp_prompt" 2>/dev/null ); then
                if ! text=$( "$cli_cmd" -m "$model" -p "$(cat "$tmp_prompt")" 2>/dev/null ); then
                    if ! text=$( "$cli_cmd" -m "$model" < "$tmp_prompt" 2>/dev/null ); then
                        if ! text=$( "$cli_cmd" -m "$model" "$(cat "$tmp_prompt")" 2>/dev/null ); then
                            echo "No se pudo obtener respuesta de Gemini CLI (intentos agotados)" >&2
                            exit 4
                        fi
                    fi
                fi
            fi
        fi
    fi
else
    # Usar API HTTP con API Key
    command -v curl >/dev/null 2>&1 || { echo "Falta dependencia: curl" >&2; exit 127; }
    [[ -n "${GEMINI_API_KEY:-}" ]] || { echo "Falta GEMINI_API_KEY o gemini CLI" >&2; exit 2; }
    payload=$(jq -n --arg p "$prompt" --arg d "$diff_text" '{
      contents: [ { role: "user", parts: [ { text: ($p + "\n\nDIFF:\n" + $d) } ] } ],
      generationConfig: { temperature: 0.3, topK: 40, topP: 0.95, maxOutputTokens: 512 }
    }')
    resp=$(curl -sS -H 'Content-Type: application/json' \
      -X POST "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${GEMINI_API_KEY}" \
      -d "$payload")
    text=$(echo "$resp" | jq -r '.candidates[0].content.parts[0].text // empty')
    [[ -z "$text" ]] && { echo "No se pudo obtener respuesta de Gemini API" >&2; echo "$resp" >&2; exit 4; }
fi

# Parsea ese texto como JSON del commit
type=$(printf '%s' "$text" | jq -r '.type // empty' 2>/dev/null || true)
scope=$(printf '%s' "$text" | jq -r '.scope // empty' 2>/dev/null || true)
subject=$(printf '%s' "$text" | jq -r '.subject // empty' 2>/dev/null || true)
body=$(printf '%s' "$text" | jq -r '.body // empty' 2>/dev/null || true)

if [[ -z "$type" || -z "$subject" ]]; then
    # Fallback: derivar Conventional Commit desde texto libre
    # Limpia posibles fences de markdown y espacios
    clean=$(printf '%s\n' "$text" | sed 's/^```.*$//g' | sed 's/```$//g' | sed 's/^[[:space:]]\+//; s/[[:space:]]\+$//' )
    # Primera línea no vacía como subject base
    subject_line=$(printf '%s\n' "$clean" | awk 'NF{print; exit}')
    # Si sigue vacío, usa mensaje genérico
    [[ -z "$subject_line" ]] && subject_line="actualiza cambios"
    # Limitar a 72 chars
    subject_line=$(printf '%.72s' "$subject_line")
    type="chore"
    subject="$subject_line"
    # body como resto del texto (truncado)
    body=$(printf '%s\n' "$clean" | tail -n +2)
    body=${body:0:2000}
fi

# Mapeo de emoji por tipo (estilo d-ocm-emoji)
emoji=""
case "$type" in
  feat) emoji="✨" ;;
  fix) emoji="🐛" ;;
  docs) emoji="📝" ;;
  style) emoji="🎨" ;;
  refactor) emoji="♻️" ;;
  perf) emoji="⚡" ;;
  test) emoji="✅" ;;
  chore) emoji="🔧" ;;
  *) emoji="🔧" ;;
esac

if [[ -n "$scope" ]]; then
    title="$emoji $type($scope): $subject"
else
    title="$emoji $type: $subject"
fi

echo "Título generado: $title" >&2

if [[ -n "$body" ]]; then
    if [[ $commit_all -eq 1 ]]; then
        git commit -a -m "$title" -m "$body"
    else
        git commit -m "$title" -m "$body"
    fi
else
    if [[ $commit_all -eq 1 ]]; then
        git commit -a -m "$title"
    else
        git commit -m "$title"
    fi
fi

echo "✓ Commit creado con Gemini" >&2
exit 0


