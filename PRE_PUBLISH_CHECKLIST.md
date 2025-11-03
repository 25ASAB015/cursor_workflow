# ✅ Checklist de Pre-Publicación

Usa esta lista de verificación antes de publicar cursor_workflow en GitHub.

## 🔍 Verificación de Archivos

### Scripts Principales
- [ ] `install.sh` existe y es ejecutable
- [ ] `update.sh` existe y es ejecutable
- [ ] `quickstart.sh` existe y es ejecutable
- [ ] `test-install.sh` existe y es ejecutable
- [ ] `show-install-system.sh` existe y es ejecutable

### Documentación
- [ ] `README.md` completo y actualizado
- [ ] `DEPLOYMENT.md` con instrucciones claras
- [ ] `INSTALL_README.md` documenta el sistema
- [ ] `.cursor/README.md` documenta los scripts
- [ ] `PRE_PUBLISH_CHECKLIST.md` (este archivo)

### Carpeta .cursor
- [ ] `.cursor/MANIFEST` lista todos los archivos
- [ ] `.cursor/bin/` contiene todos los scripts
- [ ] `.cursor/commands/` contiene toda la documentación
- [ ] Todos los scripts en `.cursor/bin/` son ejecutables

### Configuración
- [ ] `.gitignore` configurado apropiadamente
- [ ] `config.example.sh` con valores de ejemplo
- [ ] No hay archivos sensibles (tokens, keys) en el repo

## 📝 Actualizar Referencias

### Reemplazar 25ASAB015

Ejecuta este comando (reemplaza `tu_usuario_real` con tu usuario de GitHub):

```bash
find . -type f \( -name "*.md" -o -name "*.sh" \) \
  -exec sed -i 's/25ASAB015/tu_usuario_real/g' {} +
```

Verifica manualmente estos archivos críticos:

- [ ] `README.md` - URL de instalación actualizada
- [ ] `DEPLOYMENT.md` - Referencias correctas
- [ ] `INSTALL_README.md` - Ejemplos con usuario correcto
- [ ] `.cursor/README.md` - URLs correctas
- [ ] `install-example.sh` - Comandos actualizados
- [ ] `show-install-system.sh` - Referencias correctas

### Variables de Entorno

- [ ] `config.example.sh` tiene `CURSOR_WORKFLOW_REPO` con valor de ejemplo correcto
- [ ] Documentación menciona cómo configurar estas variables

## 🧪 Testing

### Pruebas Locales

```bash
# 1. Ver resumen del sistema
./show-install-system.sh

# 2. Verificar que todos los scripts son ejecutables
find . -name "*.sh" -type f ! -executable

# 3. Probar instalación local
./test-install.sh
```

- [ ] `show-install-system.sh` muestra todo correcto
- [ ] No hay scripts sin permisos de ejecución
- [ ] `test-install.sh` pasa todas las pruebas

### Pruebas de Scripts

```bash
# Probar ayuda de cada script
.cursor/bin/start.sh --help
.cursor/bin/commit.sh --help
.cursor/bin/push.sh --help
.cursor/bin/create-pull-request.sh --help
.cursor/bin/clone.sh --help
```

- [ ] Todos los scripts muestran ayuda correctamente
- [ ] No hay errores de sintaxis

## 📦 Git y GitHub

### Repositorio Local

- [ ] Git inicializado (`git status` funciona)
- [ ] Usuario de git configurado
  ```bash
  git config user.name
  git config user.email
  ```
- [ ] Rama principal es `master` o `master`
- [ ] Todos los cambios están commiteados
- [ ] No hay archivos sin trackear que deberían estar incluidos

### Verificación de Commits

```bash
# Ver commits
git log --oneline

# Ver archivos staged
git status
```

- [ ] Commits tienen mensajes descriptivos
- [ ] No hay archivos sensibles en el historial
- [ ] `.gitignore` está funcionando correctamente

## 🚀 GitHub

### Crear Repositorio

Opción A - Con GitHub CLI:
```bash
gh repo create cursor_workflow --public --source=. \
  --description="Flujo de trabajo estandarizado para Cursor con GitKraken CLI"
```

Opción B - Manual:
1. Ve a https://github.com/new
2. Nombre: `cursor_workflow`
3. Descripción: "Flujo de trabajo estandarizado para Cursor con GitKraken CLI"
4. Público
5. NO inicializar con README

- [ ] Repositorio creado en GitHub
- [ ] Es público (o privado si prefieres)
- [ ] Descripción agregada

### Subir Código

```bash
# Agregar remote
git remote add origin https://github.com/25ASAB015/cursor_workflow.git

# O con SSH
git remote add origin git@github.com:25ASAB015/cursor_workflow.git

# Push
git push -u origin master  # o master
```

- [ ] Remote configurado
- [ ] Código subido a GitHub
- [ ] Rama principal sincronizada

### Configuración del Repositorio

En GitHub (Settings):

- [ ] Descripción y topics agregados
  - Topics sugeridos: `cursor`, `gitkraken`, `workflow`, `automation`, `git-workflow`
- [ ] README.md se muestra correctamente en la página principal
- [ ] Branch protection configurado (opcional)
  - Require pull request reviews
  - Require status checks to pass

## 🧪 Prueba de Instalación desde GitHub

### Primera Prueba Real

En un directorio temporal:

```bash
cd /tmp
mkdir test-cursor-install
cd test-cursor-install
git init

# Probar instalación desde GitHub
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) \
  --repo 25ASAB015/cursor_workflow
```

- [ ] El instalador se descarga correctamente
- [ ] MANIFEST se descarga desde GitHub
- [ ] Todos los archivos se descargan
- [ ] Estructura `.cursor/` se crea correctamente
- [ ] Scripts tienen permisos de ejecución
- [ ] No hay errores 404

### Verificar Instalación

```bash
# Desde el directorio donde instalaste
ls -la .cursor/
.cursor/bin/start.sh --help
```

- [ ] Carpeta `.cursor/` existe
- [ ] Scripts son ejecutables
- [ ] Ayuda funciona correctamente

## 📋 Documentación Final

### READMEs

- [ ] README.md tiene badge de GitHub (opcional)
  ```markdown
  ![GitHub release](https://img.shields.io/github/v/release/25ASAB015/cursor_workflow)
  ![GitHub stars](https://img.shields.io/github/stars/25ASAB015/cursor_workflow)
  ```
- [ ] Comando de instalación de una línea es correcto y funciona
- [ ] Links a documentación funcionan
- [ ] Ejemplos de código son válidos

### Guías

- [ ] DEPLOYMENT.md tiene instrucciones claras
- [ ] INSTALL_README.md explica el sistema
- [ ] No hay referencias a rutas locales de tu máquina
- [ ] No hay información sensible

## 📢 Comunicación

### Preparar Anuncio para el Equipo

Prepara un mensaje con:

```markdown
# Cursor Workflow - Ya disponible! 🚀

Instalación con una línea:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) \
  --repo 25ASAB015/cursor_workflow
```

**Características:**
- Commits con IA (Conventional Commits en español)
- PRs automáticos con GitKraken CLI
- Scripts reutilizables
- Configuración guiada

**Documentación:** https://github.com/25ASAB015/cursor_workflow

**Requisitos:**
- GitKraken CLI (gk)
- git, jq
```

- [ ] Mensaje preparado
- [ ] Link al repositorio correcto
- [ ] Comando de instalación probado

## 🎉 Release

### Crear Primera Release

```bash
# Crear tag
git tag -a v1.0.0 -m "Version 1.0.0 - Primera versión estable"
git push origin v1.0.0

# Crear release
gh release create v1.0.0 \
  --title "v1.0.0 - Primera versión estable" \
  --notes "Primera versión estable de cursor_workflow con sistema de instalación completo." \
  --generate-notes
```

- [ ] Tag v1.0.0 creado
- [ ] Tag subido a GitHub
- [ ] Release publicado
- [ ] Release notes generadas

### Verificar Release

- [ ] Release aparece en GitHub
- [ ] Assets adjuntos (si aplica)
- [ ] Notas de release son claras
- [ ] Link de descarga funciona

## 📊 Post-Publicación

### Verificaciones Finales

- [ ] Instalación desde GitHub funciona en máquina limpia
- [ ] Documentación accesible desde GitHub
- [ ] Issues habilitados en el repo
- [ ] README se muestra correctamente en la página principal

### Monitoreo

- [ ] Configurar notificaciones de GitHub (issues, PRs)
- [ ] Revisar primeros issues/feedback
- [ ] Preparar respuestas a preguntas frecuentes

### Siguientes Pasos

- [ ] Compartir con el equipo
- [ ] Documentar feedback
- [ ] Planear próximas funcionalidades
- [ ] Mantener documentación actualizada

## ✅ Checklist Rápida

**Pre-Publicación:**
```bash
# 1. Verificar sistema
./show-install-system.sh

# 2. Reemplazar 25ASAB015
find . -type f \( -name "*.md" -o -name "*.sh" \) \
  -exec sed -i 's/25ASAB015/tu_usuario_real/g' {} +

# 3. Commit cambios
git add .
git commit -m "📝 docs: actualizar referencias de usuario"

# 4. Crear y subir
gh repo create cursor_workflow --public --source=.
git push -u origin master

# 5. Probar instalación
cd /tmp/test && \
bash <(curl -fsSL https://raw.githubusercontent.com/tu_usuario/cursor_workflow/master/install.sh) \
  --repo tu_usuario/cursor_workflow

# 6. Crear release
gh release create v1.0.0 --generate-notes

# 7. Compartir con equipo
echo "¡Listo! 🎉"
```

## 🆘 Si Algo Sale Mal

### Instalador no funciona

1. Verifica que el repo sea público
2. Comprueba que la rama sea `main` (no `master`)
3. Verifica URLs en raw.githubusercontent.com manualmente
4. Revisa que MANIFEST esté en `.cursor/MANIFEST`

### Error 404 al descargar

1. Espera 1-2 minutos (caché de GitHub)
2. Verifica que los archivos existan en el repo
3. Usa `--branch` si tu rama principal tiene otro nombre

### Scripts no ejecutables

```bash
# Después de instalar, ejecuta:
chmod +x .cursor/bin/*.sh
```

---

**¿Todo listo?** ¡Adelante con la publicación! 🚀

Para más ayuda, consulta `DEPLOYMENT.md` con instrucciones paso a paso.

