# 🚀 Cursor Workflow

Flujo de trabajo estandarizado para Cursor con GitKraken CLI (gk), commits/PRs con IA y utilidades locales.

## ✨ Características

- 🤖 **Commits con IA**: Genera mensajes de commit siguiendo Conventional Commits
- 🔄 **Pull Requests automáticos**: Crea PRs con descripción generada por IA
- 🎯 **GitKraken CLI integrado**: Workflow completo con `gk`
- 📝 **Convenciones estandarizadas**: Conventional Commits en español + emojis
- 🛠️ **Scripts reutilizables**: Instala en cualquier repositorio
- 🧪 **Repositorios de prueba**: Clone en `~/src/tries` para experimentar

## 📦 Instalación Rápida

### 🚀 Instalación con una línea

Ejecuta este comando en el directorio raíz de tu proyecto:

```bash
# Reemplaza 25ASAB015/cursor_workflow con la ubicación de tu repo
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) \
  --repo 25ASAB015/cursor_workflow
```

### 📖 Sistema de instalación completo

Este proyecto incluye un **sistema de instalación profesional** que permite:

- ✅ Instalación con una línea desde GitHub
- ✅ Descarga automática de todos los archivos necesarios
- ✅ Verificación de dependencias
- ✅ Backup automático de instalaciones previas
- ✅ Configuración guiada post-instalación
- ✅ Sistema de actualización integrado
- ✅ Suite de pruebas automatizada

**Archivos del sistema de instalación:**
- `install.sh` - Instalador principal
- `update.sh` - Actualizador
- `quickstart.sh` - Configuración guiada
- `test-install.sh` - Suite de pruebas
- `.cursor/MANIFEST` - Lista de archivos a instalar

📚 **Ver guía completa**: [`INSTALL_README.md`](INSTALL_README.md)

### ⚙️ Opciones de instalación

```bash
# Instalar desde rama específica
bash install.sh --repo 25ASAB015/cursor_workflow --branch develop

# Forzar instalación (sobrescribir)
bash install.sh --repo 25ASAB015/cursor_workflow --force

# Con variables de entorno
export CURSOR_WORKFLOW_REPO="25ASAB015/cursor_workflow"
export CURSOR_WORKFLOW_BRANCH="master"
bash <(curl -fsSL https://raw.githubusercontent.com/${CURSOR_WORKFLOW_REPO}/${CURSOR_WORKFLOW_BRANCH}/install.sh)
```

### 💻 Instalación local (desarrollo)

```bash
# Clonar este repositorio
git clone https://github.com/25ASAB015/cursor_workflow.git
cd tu_proyecto
/ruta/a/cursor_workflow/install.sh
```

### 🔧 Post-instalación

Después de instalar, ejecuta la configuración guiada:

```bash
# Desde el directorio raíz de tu proyecto donde instalaste cursor_workflow
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/quickstart.sh)

# O si descargaste el repo
./quickstart.sh
```

Esto verificará dependencias, configurará autenticación y te guiará en los próximos pasos.

## 📋 Requisitos

### Obligatorios
- [GitKraken CLI (gk)](https://gitkraken.dev/cli)
- git
- jq

### Opcionales
- [GitHub CLI (gh)](https://cli.github.com/) - Para abrir PRs automáticamente
- Gemini CLI o `GEMINI_API_KEY` - Fallback para commits con IA

### Instalación de dependencias

```bash
# GitKraken CLI
curl -fsSL https://gitkraken.dev/install.sh | bash
gk auth login

# GitHub CLI (opcional)
# Ubuntu/Debian
sudo apt install gh
# Arch Linux
sudo pacman -S github-cli
# macOS
brew install gh

gh auth login

# jq
# Ubuntu/Debian
sudo apt install jq
# Arch Linux  
sudo pacman -S jq
# macOS
brew install jq
```

## 🎯 Uso

### Flujo de trabajo completo

```bash
# 1. Iniciar nuevo trabajo
.cursor/bin/start.sh "feat: implementar login" -b feat/login

# 2. Hacer cambios en el código...

# 3. Crear commit con IA
.cursor/bin/commit.sh -d

# 4. Push y crear PR
.cursor/bin/push.sh --create-pr

# 5. Revisar y hacer merge en GitHub
```

### Scripts disponibles

#### `start.sh` - Iniciar nuevo trabajo
```bash
.cursor/bin/start.sh "feat: descripción" [opciones]

# Opciones:
#   --base-branch <rama>   Rama base (default: master)
#   -b, --branch <rama>    Nombre de la rama
#   -i, --issue <KEY>      Vincular con issue
```

#### `commit.sh` - Crear commit con IA
```bash
.cursor/bin/commit.sh [opciones]

# Opciones:
#   -d, --add-description  Agregar descripción detallada
#   --no-force            No forzar si falla
#   -p, --path <dir>      Ruta específica
```

#### `push.sh` - Push cambios
```bash
.cursor/bin/push.sh [opciones]

# Opciones:
#   --create-pr, --pr     Crear PR después del push
#   -f, --force          Forzar push
```

#### `create-pull-request.sh` - Crear PR con IA
```bash
.cursor/bin/create-pull-request.sh [opciones]

# Opciones:
#   -p, --path <dir>     Ruta específica
#   -y, --yes, --ask     No pedir confirmación
#   --open              Abrir PR en navegador
```

#### `clone.sh` - Clonar para pruebas
```bash
.cursor/bin/clone.sh <repo_url> <nombre>

# Clona en ~/src/tries/<nombre> y abre Cursor
```

## 📝 Convenciones

### Conventional Commits + Emojis

Tipo | Emoji | Descripción
-----|-------|------------
`feat` | ✨ | Nueva funcionalidad
`fix` | 🐛 | Corrección de bug
`docs` | 📚 | Documentación
`style` | 💄 | Formato, sin cambios de código
`refactor` | ♻️ | Refactorización
`perf` | ⚡ | Mejora de rendimiento
`test` | ✅ | Agregar/modificar tests
`build` | 📦 | Sistema de build
`ci` | 👷 | CI/CD
`chore` | 🔧 | Tareas de mantenimiento

### Branching

- `feature/*` o `feat/*` - Nuevas funcionalidades
- `bugfix/*` o `fix/*` - Corrección de bugs
- `hotfix/*` - Correcciones urgentes en producción
- `refactor/*` - Refactorización de código
- `docs/*` - Cambios en documentación

### Pull Requests

- Título claro y descriptivo
- Descripción generada automáticamente por IA (`gk ai pr create`)
- Vincular issues relacionados
- Tests pasando
- Revisión de código antes de merge

## 🔧 Configuración

### Reglas de Cursor

El instalador crea la carpeta `.cursor/` con la siguiente estructura:

```
.cursor/
├── bin/                      # Scripts ejecutables
├── commands/                 # Documentación de comandos slash
├── agents/                   # Roles de agente (futuro)
└── rules/                    # Reglas personalizadas (futuro)
```

Estas reglas se pueden agregar al archivo `.cursorrules` de tu proyecto para que Cursor las aplique automáticamente.

### Personalización

Puedes personalizar los scripts editando los archivos en `.cursor/bin/`. Los cambios serán específicos de tu proyecto.

## 🎮 Comandos Slash (Cursor)

*Nota: Planificados, aún no implementados. Por ahora usa los scripts directamente.*

- `/start "{nombre}"` - Inicia trabajo con `gk work start`
- `/commit` - Crea commit con IA
- `/push [--create-pr]` - Push y opcionalmente crea PR  
- `/create-pull-request` - Crea PR con IA
- `/clone <url> <name>` - Clona en ~/src/tries

## 📖 Documentación

Para más detalles, consulta:

- [`.cursor/README.md`](.cursor/README.md) - Documentación completa de la carpeta .cursor
- [`.cursor/commands/`](.cursor/commands/) - Documentación individual de cada comando
- [`install.sh`](install.sh) - Script de instalación con opciones

## 🔄 Actualización

Para actualizar a la última versión en un proyecto existente:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --force
```

## 🐛 Solución de problemas

### GitKraken AI falla

Los scripts incluyen fallback a Gemini cuando `gk ai` no está disponible:

```bash
# Configurar Gemini API Key
export GEMINI_API_KEY="tu_api_key_aqui"

# O usar Gemini CLI
gemini auth login
```

### Permisos de ejecución

Si los scripts no son ejecutables:

```bash
chmod +x .cursor/bin/*.sh
```

### Dependencias faltantes

El instalador verifica las dependencias. Si algo falta:

```bash
# Verificar manualmente
which gk git jq gh

# Instalar lo que falte (ver sección Requisitos)
```

## 🤝 Contribuir

1. Fork el repositorio
2. Crea una rama: `git checkout -b feat/mejora`
3. Commit: `.cursor/bin/commit.sh -d`
4. Push: `.cursor/bin/push.sh --create-pr`
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es de uso interno. Consulta el archivo LICENSE si existe.

## 👤 Autor

Proyecto estandarizado desde `25ASAB015_cursor_workflow`.

## 🙏 Agradecimientos

- [GitKraken](https://gitkraken.dev/) por el excelente CLI
- [Conventional Commits](https://www.conventionalcommits.org/)
- Comunidad de Cursor

---

**¿Preguntas o sugerencias?** Abre un issue en el repositorio.

