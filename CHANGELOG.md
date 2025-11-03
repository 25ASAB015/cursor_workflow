# Changelog

Todas las notable changes de este proyecto se documentan aquí.

## 0.1.0 - 2025-11-03

- feat(commit): agrega wrapper `./.cursor/bin/commit.sh` que usa `gk ai commit --force` y fallback automático a Gemini vía API Key (`./.cursor/bin/ai-commit-gemini.sh`).
- docs(commit): actualiza `./.cursor/commands/commit.md` con uso, requisitos y configuración de `GEMINI_API_KEY`.
- feat(commit): soporte `--all` y nuevo flag `--push` para empujar la rama tras crear el commit.
- chore: marca scripts como ejecutables.
- fix(commit): elimina flags no soportados en `gk ai commit` y evita confirmaciones interactivas.
- docs(start): referencia de uso en `./.cursor/commands/start.md`.
- feat(push): agrega `./.cursor/bin/push.sh` basado en `gk work push` con soporte `--create-pr|--pr` y `-f|--force`; intenta abrir/crear PR con `gh` si está disponible.
- docs(push): añade `./.cursor/commands/push.md` con uso básico y ayuda.
- feat(pr): agrega `./.cursor/bin/create-pull-request.sh` basado en `gk ai pr create` y opción `--open` para abrir el PR con `gh`.
- docs(pr): añade `./.cursor/commands/create-pull-request.md` con uso básico y ayuda.
- fix(pr): reescribe `create-pull-request.sh` para capturar salida de `gk ai pr create` y usar `gh pr create` sin prompts interactivos; soluciona bloqueo por confirmación manual.

# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Added - Rama `cursorrules`

#### Configuración del proyecto

- **`.cursorrules`**: Archivo de configuración principal de Cursor que define:
  - Objetivo del proyecto: estandarizar el flujo de trabajo en Cursor con GitKraken CLI (gk)
  - Requisitos locales (gk, gh, git, jq, Gemini CLI)
  - Convenciones de commits (Conventional Commits en español + emoji)
  - Convenciones de branching (feature/bugfix)
  - Comandos slash planificados (/start, /commit, /push, /create-pull-request, /clone)
  - Flujo de trabajo recomendado
  - Directrices para el asistente de Cursor

- **`.gitignore`**: Configuración para ignorar archivos binarios en `bin/*`
  - Evita que se trackeen scripts ejecutables temporales o generados


#### Estructura de directorios

- **`.cursor/`**: Directorio raíz para configuración y scripts de Cursor
  - **`.cursor/bin/`**: Directorio para scripts shell que implementarán los comandos slash
    - Planeado para: `start.sh`, `commit.sh`, `push.sh`, `create-pull-request.sh`, `clone.sh`
  - **`.cursor/commands/`**: Directorio para documentación de comandos slash
    - Planeado para documentar cada comando y su uso
  - **`.cursor/agents/`**: Directorio para roles/agentes (placeholder)
    - Planeado para definir roles específicos del asistente
  - **`.cursor/rules/`**: Directorio para reglas adicionales
    - Planeado para reglas específicas por contexto o módulo

#### Documentación

- **`CHANGELOG.md`**: Este archivo, limpio y listo para documentar cambios futuros
  - Formato basado en Keep a Changelog
  - Versión en español siguiendo las convenciones del proyecto

#### Licencia

- **`LICENSE`**: Licencia MIT del proyecto
  - Nota: Actualmente contiene copyright de otro proyecto (Kevin Zhuang), debe actualizarse

### Notas

- Esta rama establece la estructura base del proyecto y las convenciones de trabajo
- Los comandos slash mencionados en `.cursorrules` están planificados pero aún no implementados
- La estructura de directorios `.cursor/*` está creada pero los archivos específicos están pendientes de desarrollo
