# 🚀 Guía de Despliegue - Cursor Workflow

Esta guía explica cómo publicar cursor_workflow en GitHub y configurar el instalador para que otros puedan usarlo.

## 📋 Prerequisitos

- Cuenta de GitHub
- Git configurado localmente
- GitHub CLI (opcional, pero recomendado)

## 🎯 Pasos para Desplegar

### 1. Crear Repositorio en GitHub

```bash
# Opción A: Con GitHub CLI (recomendado)
gh repo create cursor_workflow --public --source=. --description="Flujo de trabajo estandarizado para Cursor con GitKraken CLI"

# Opción B: Manual
# 1. Ve a https://github.com/new
# 2. Crea un repositorio llamado 'cursor_workflow'
# 3. Marca como público (o privado si prefieres)
# 4. NO inicialices con README (ya lo tienes)
```

### 2. Configurar Git y Subir el Código

```bash
# Si aún no has inicializado git en el proyecto
git init

# Agregar el remote
git remote add origin https://github.com/25ASAB015/cursor_workflow.git

# O con SSH
git remote add origin git@github.com:25ASAB015/cursor_workflow.git

# Agregar todos los archivos
git add .

# Hacer el primer commit
git commit -m "🎉 feat: initial commit - cursor workflow"

# Subir a GitHub
git push -u origin master

# Si tu rama principal se llama 'master', usa:
# git push -u origin master
```

### 3. Configurar el Instalador

Ahora que tu repositorio está en GitHub, necesitas actualizar las referencias en los archivos:

#### 3.1. Actualizar README.md

Busca y reemplaza `25ASAB015` con tu usuario de GitHub:

```bash
# Reemplazar en todos los archivos
find . -type f \( -name "*.md" -o -name "*.sh" \) -exec sed -i 's/25ASAB015/tu_usuario_real/g' {} +

# O manualmente edita estos archivos:
# - README.md
# - .cursor/README.md
# - install-example.sh
# - DEPLOYMENT.md (este archivo)
```

#### 3.2. Actualizar Configuración de Ejemplo

Edita `config.example.sh`:

```bash
export CURSOR_WORKFLOW_REPO="tu_usuario_real/cursor_workflow"
```

#### 3.3. Commit los Cambios

```bash
git add .
git commit -m "📝 docs: actualizar referencias de usuario en documentación"
git push
```

### 4. Verificar la Instalación

Prueba que el instalador funcione:

```bash
# En un directorio de prueba
cd /tmp/test-install
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --repo 25ASAB015/cursor_workflow
```

### 5. Crear Release (Opcional pero Recomendado)

```bash
# Con GitHub CLI
gh release create v1.0.0 \
  --title "v1.0.0 - Primera versión" \
  --notes "Primera versión estable de cursor_workflow" \
  --generate-notes

# O manualmente en https://github.com/25ASAB015/cursor_workflow/releases/new
```

## 📦 Estructura del Repositorio

Asegúrate de que tu repositorio tenga esta estructura:

```
cursor_workflow/
├── .cursor/                    # Carpeta principal que se instala
│   ├── bin/                    # Scripts ejecutables
│   ├── commands/               # Documentación
│   ├── agents/                 # Placeholder
│   ├── rules/                  # Placeholder
│   ├── MANIFEST                # Lista de archivos a instalar
│   └── README.md               # Documentación de .cursor
├── install.sh                  # Instalador principal ⭐
├── update.sh                   # Script de actualización
├── quickstart.sh               # Configuración rápida
├── install-example.sh          # Ejemplos de instalación
├── config.example.sh           # Configuración de ejemplo
├── README.md                   # Documentación principal ⭐
├── DEPLOYMENT.md               # Este archivo
├── .gitignore                  # Archivos ignorados
└── LICENSE                     # Licencia (si aplica)
```

## 🔧 Configuración Post-Despliegue

### Habilitar GitHub Pages (Opcional)

Si quieres tener documentación web:

1. Ve a Settings → Pages en tu repositorio
2. Selecciona la rama `master` y carpeta `/docs` o root
3. Guarda

### Configurar Branch Protection (Recomendado)

Para proteger la rama principal:

1. Ve a Settings → Branches
2. Agrega regla para `main`
3. Habilita:
   - Require pull request reviews
   - Require status checks to pass
   - Require conversation resolution

### Agregar Topics/Tags

Agrega tags relevantes a tu repositorio:

```bash
gh repo edit --add-topic cursor
gh repo edit --add-topic gitkraken
gh repo edit --add-topic workflow
gh repo edit --add-topic automation
gh repo edit --add-topic git-workflow
```

O manualmente en: Settings → Topics

## 📣 Compartir con Tu Equipo

### Instrucción Simple para el Equipo

Comparte esta instrucción de una línea:

```bash
# Instalar cursor_workflow
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --repo 25ASAB015/cursor_workflow
```

### Documentación para el Equipo

Crea un documento interno con:

1. Link al repositorio
2. Comando de instalación
3. Link a la documentación (README.md)
4. Requisitos previos (gk, jq, etc.)
5. Configuración de GEMINI_API_KEY

### Crear un Badge README

Agrega badges a tu README.md:

```markdown
![GitHub release](https://img.shields.io/github/v/release/25ASAB015/cursor_workflow)
![GitHub stars](https://img.shields.io/github/stars/25ASAB015/cursor_workflow)
![License](https://img.shields.io/github/license/25ASAB015/cursor_workflow)
```

## 🔄 Mantener el Proyecto

### Actualizar el MANIFEST

Cuando agregues nuevos archivos:

1. Edita `.cursor/MANIFEST`
2. Agrega la ruta del nuevo archivo
3. Commit y push

```bash
echo ".cursor/bin/nuevo-script.sh" >> .cursor/MANIFEST
git add .cursor/MANIFEST .cursor/bin/nuevo-script.sh
git commit -m "✨ feat: agregar nuevo-script.sh"
git push
```

### Crear una Nueva Versión

```bash
# 1. Actualiza el código
git add .
git commit -m "✨ feat: nueva funcionalidad"

# 2. Crea un tag
git tag -a v1.1.0 -m "Version 1.1.0 - Nuevas funcionalidades"
git push origin v1.1.0

# 3. Crea el release
gh release create v1.1.0 --generate-notes
```

### Testing de Instalación

Prueba regularmente el instalador:

```bash
# Script de prueba
cd /tmp
rm -rf test-cursor-workflow
mkdir test-cursor-workflow
cd test-cursor-workflow
git init
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --repo 25ASAB015/cursor_workflow
ls -la .cursor/
```

## 🐛 Troubleshooting

### El instalador no encuentra archivos

- Verifica que los archivos existan en GitHub
- Revisa que las rutas en MANIFEST sean correctas
- Espera unos minutos (caché de GitHub)

### Error 404 al instalar

- Verifica que el repositorio sea público
- Confirma que la rama sea `main` y no `master`
- Usa `--branch` si tu rama principal tiene otro nombre

### Los scripts no son ejecutables

Después de instalar, ejecuta:

```bash
chmod +x .cursor/bin/*.sh
```

O agrega en install.sh la línea:

```bash
chmod +x .cursor/bin/*.sh
```

## 📄 Licencia

Decide qué licencia usar:

- **MIT** - Muy permisiva, popular para herramientas
- **Apache 2.0** - Permisiva con protección de patentes
- **GPL v3** - Copyleft, requiere código abierto
- **Propietaria** - Si es interno de empresa

Agrega archivo LICENSE:

```bash
# Ejemplo con MIT
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 [Tu Nombre]

Permission is hereby granted...
EOF

git add LICENSE
git commit -m "📄 docs: agregar licencia MIT"
git push
```

## ✅ Checklist Final

Antes de considerar el despliegue completo:

- [ ] Repositorio creado en GitHub
- [ ] Código subido (main/master)
- [ ] Referencias a 25ASAB015 reemplazadas
- [ ] MANIFEST actualizado
- [ ] Instalador probado desde URL de GitHub
- [ ] README.md actualizado con instrucciones correctas
- [ ] .gitignore configurado apropiadamente
- [ ] LICENSE agregado (si aplica)
- [ ] Release v1.0.0 creado
- [ ] Documentación revisada
- [ ] Equipo notificado

## 🎉 ¡Listo!

Tu cursor_workflow está ahora desplegado y listo para usar.

Instalación de una línea:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) --repo 25ASAB015/cursor_workflow
```

---

**¿Problemas?** Abre un issue en el repositorio.

