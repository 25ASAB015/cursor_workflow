# /commit

Propósito: Crear un commit con mensaje generado por IA siguiendo Conventional Commits en español + emoji.

Flujo:
- Primero intenta `gk ai commit` (GitKraken CLI).
- Si no está disponible o falla, hace fallback automático a Gemini vía API Key usando `./.cursor/bin/ai-commit-gemini.sh`.

Requisitos:
- git y jq instalados. curl para el fallback.
- Opción A (preferida): `gk` autenticado.
- Opción B (fallback): exportar `GEMINI_API_KEY` (este proyecto usa Gemini con API Key por defecto como respaldo). Opcional `GEMINI_MODEL` (por defecto `gemini-2.5-pro`).

Uso básico:
```bash
./.cursor/bin/commit.sh [--all] [-p|--path <dir>]
```

Opciones:
- `-p, --path <dir>`: Directorio del repo (por defecto, el actual).
- `--all`: Comitea todos los cambios tracked (equivalente a `-a`).
- `-d, --add-description`: Compatibilidad (el fallback ya genera cuerpo del commit).
- `-h, --help`: Ayuda.

Autenticación Gemini (fallback con API Key):
```bash
export GEMINI_API_KEY="tu_api_key"
# Opcional: export GEMINI_MODEL="gemini-2.5-pro"
```

Ejemplos:
```bash
# Con cambios staged
./.cursor/bin/commit.sh

# Comitear todo lo modificado (tracked)
./.cursor/bin/commit.sh --all

# Ejecutar sobre otro repo
./.cursor/bin/commit.sh --path /ruta/al/repo --all
```

Notas:
- Este proyecto prioriza mensajes en español con Conventional Commits + emoji.
- El fallback limita el diff enviado al modelo para evitar prompts muy grandes; aun así genera mensajes útiles.
- Asegúrate de que los scripts sean ejecutables:
```bash
chmod +x ./.cursor/bin/commit.sh ./.cursor/bin/ai-commit-gemini.sh
```

