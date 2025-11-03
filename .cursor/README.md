# Cursor Workflow

Flujo de trabajo estandarizado para Cursor con GitKraken CLI, commits/PRs con IA y utilidades locales.

## 🚀 Instalación

### Instalación rápida desde GitHub

Ejecuta uno de estos comandos en el directorio raíz de tu proyecto:

```bash
# Con curl
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh)

# O con wget
wget -qO- https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh | bash
```

### Instalación desde repositorio local

Si ya tienes el repositorio clonado:

```bash
cd /ruta/a/tu/proyecto
/ruta/a/cursor_workflow/install.sh
```

### Opciones de instalación

```bash
# Instalar desde una rama específica
bash install.sh --branch develop

# Forzar instalación (sobrescribir si existe)
bash install.sh --force

# Especificar repositorio manualmente
bash install.sh --repo usuario/repo
```

## 📋 Requisitos

### Requeridos
- **gk** (GitKraken CLI) - [Instalar](https://gitkraken.dev/cli)
- **git** - Sistema de control de versiones
- **jq** - Procesador JSON para línea de comandos

### Opcionales
- **gh** (GitHub CLI) - Para abrir PRs automáticamente
- **gemini** (Gemini CLI) - Fallback para commits con IA
- **GEMINI_API_KEY** - Variable de entorno alternativa a Gemini CLI

### Configuración inicial

1. **Autenticar GitKraken CLI:**
   ```bash
   gk auth login
   ```

2. **Configurar Gemini (opcional):**
   ```bash
   # Con CLI
   gemini auth login
   
   # O con variable de entorno
   export GEMINI_API_KEY="tu_api_key"
   ```

3. **Autenticar GitHub CLI (opcional):**
   ```bash
   gh auth login
   ```

## 📁 Estructura instalada

```
.cursor/
├── bin/                          # Scripts ejecutables
│   ├── start.sh                  # Iniciar nuevo trabajo
│   ├── commit.sh                 # Crear commit con IA
│   ├── push.sh                   # Push con GitKraken
│   ├── create-pull-request.sh    # Crear PR con IA
│   ├── clone.sh                  # Clonar repo en ~/src/tries
│   ├── ai-commit-gemini.sh       # Fallback Gemini para commits
│   └── fzf                       # Utilidad de selección
├── commands/                     # Documentación comandos slash
│   ├── start.md
│   ├── commit.md
│   ├── push.md
│   ├── create-pull-request.md
│   └── clone.md
├── agents/                       # Roles de agente (placeholder)
└── rules/                        # Reglas adicionales (placeholder)
```

## 🔧 Uso

### Scripts disponibles

#### 1. Iniciar nuevo trabajo
```bash
.cursor/bin/start.sh "feat: nueva funcionalidad" [-b rama] [-i ISSUE-123]
```

#### 2. Crear commit con IA
```bash
.cursor/bin/commit.sh [-d] [--no-force] [-p directorio]
```

#### 3. Push cambios
```bash
.cursor/bin/push.sh [--create-pr] [-f]
```

#### 4. Crear Pull Request
```bash
.cursor/bin/create-pull-request.sh [-p directorio] [-y] [--open]
```

#### 5. Clonar repositorio para pruebas
```bash
.cursor/bin/clone.sh <repo_url> <nombre>
```

### Flujo de trabajo recomendado

1. **Iniciar trabajo:**
   ```bash
   .cursor/bin/start.sh "feat: implementar autenticación" -b feat/auth
   ```

2. **Implementar cambios** (código, tests, linting)

3. **Crear commit con IA:**
   ```bash
   .cursor/bin/commit.sh -d
   ```

4. **Push y crear PR:**
   ```bash
   .cursor/bin/push.sh --create-pr
   ```

5. **Revisar y hacer merge en GitHub**

## 📝 Convenciones

### Mensajes de commit
- Seguimos **Conventional Commits** en español
- Incluimos emoji según el tipo de cambio
- Ejemplos:
  - `✨ feat: agregar autenticación OAuth`
  - `🐛 fix: corregir error en validación`
  - `📚 docs: actualizar README`
  - `♻️ refactor: simplificar lógica de usuario`

### Branching
- `feature/*` - Nuevas funcionalidades
- `bugfix/*` - Corrección de bugs
- `hotfix/*` - Correcciones urgentes
- `refactor/*` - Refactorización de código

### Pull Requests
- Descripción generada automáticamente por IA
- Revisión de código antes de merge
- Tests pasando en CI/CD

## 🔄 Actualización

Para actualizar a la última versión:

```bash
# Desde el directorio de tu proyecto
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --force
```

## 🤝 Comandos Slash (Cursor)

*Nota: Estos comandos están planificados pero aún no implementados. Por ahora, usa los scripts directamente.*

- `/start` - Iniciar nuevo trabajo
- `/commit` - Crear commit con IA
- `/push` - Push cambios
- `/create-pull-request` - Crear PR
- `/clone` - Clonar repositorio

## 📖 Documentación adicional

Consulta los archivos en `.cursor/commands/` para documentación detallada de cada comando.

## 🐛 Solución de problemas

### Error: "gk not found"
```bash
# Instalar GitKraken CLI
curl -fsSL https://gitkraken.dev/install.sh | bash
gk auth login
```

### Error: "jq not found"
```bash
# Ubuntu/Debian
sudo apt install jq

# Arch Linux
sudo pacman -S jq

# macOS
brew install jq
```

### Error en commits con IA
```bash
# Configurar Gemini como fallback
export GEMINI_API_KEY="tu_api_key"

# O instalar Gemini CLI
# (consulta documentación de Gemini)
```

## 📄 Licencia

Este proyecto es de uso interno. Consulta el archivo LICENSE en el repositorio principal.

## 🙋 Soporte

Para reportar issues o sugerencias, abre un issue en el repositorio principal.

