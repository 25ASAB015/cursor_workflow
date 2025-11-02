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

- **`cursor_workflow.code-workspace`**: Archivo de workspace de VS Code/Cursor
  - Configuración básica del workspace para el proyecto

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
