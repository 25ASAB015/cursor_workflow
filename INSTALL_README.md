# 📦 Sistema de Instalación - Cursor Workflow

## ✅ Archivos Creados

Se han creado los siguientes archivos para facilitar la instalación y distribución de cursor_workflow:

### 🔧 Scripts de Instalación

1. **`install.sh`** ⭐
   - Script principal de instalación
   - Puede ejecutarse desde GitHub con curl/wget
   - Descarga automáticamente todos los archivos necesarios
   - Verifica dependencias
   - Crea backup de instalaciones previas
   - Lee el MANIFEST para saber qué archivos descargar
   - Fallback a lista predefinida si MANIFEST no está disponible

2. **`update.sh`**
   - Actualiza una instalación existente
   - Autodetecta el repositorio desde git remote
   - Ejecuta el instalador con --force

3. **`test-install.sh`**
   - Suite de pruebas automatizada
   - Verifica la instalación en entorno aislado
   - Valida estructura de archivos y permisos
   - Prueba funcionalidad básica de scripts

4. **`quickstart.sh`**
   - Configuración interactiva post-instalación
   - Verifica todas las dependencias
   - Guía de autenticación para gk/gh/gemini
   - Muestra estado del sistema
   - Próximos pasos personalizados

### 📚 Documentación

5. **`README.md`**
   - Documentación principal del proyecto
   - Instrucciones de instalación
   - Guía de uso completa
   - Convenciones y mejores prácticas
   - Solución de problemas

6. **`.cursor/README.md`**
   - Documentación específica de la carpeta .cursor
   - Detalles de cada script
   - Flujo de trabajo recomendado

7. **`DEPLOYMENT.md`** ⭐
   - Guía completa de despliegue en GitHub
   - Pasos para publicar el proyecto
   - Configuración post-despliegue
   - Checklist de validación
   - Mejores prácticas de mantenimiento

8. **`install-example.sh`**
   - Ejemplos de diferentes formas de instalación
   - Casos de uso comunes
   - Referencia rápida

### ⚙️ Configuración

9. **`config.example.sh`**
   - Plantilla de configuración
   - Variables de entorno documentadas
   - Ejemplos de valores
   - Instrucciones de uso

10. **`.cursor/MANIFEST`**
    - Lista de archivos a instalar
    - Usado por install.sh para saber qué descargar
    - Facilita el mantenimiento
    - Formato simple (un archivo por línea)

11. **`.gitignore`**
    - Actualizado con archivos sensibles
    - Excluye config.sh, .env, backups
    - Protege credenciales

## 🚀 Cómo Usar

### Instalación desde GitHub (cuando esté publicado)

```bash
# Reemplaza 25ASAB015 con tu usuario de GitHub
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/install.sh) \
  --repo 25ASAB015/cursor_workflow
```

### Instalación Local (para desarrollo/testing)

```bash
# Desde el directorio de tu proyecto
cd /ruta/a/tu/proyecto
/ruta/a/cursor_workflow/install.sh
```

### Configuración Post-Instalación

```bash
# Ejecutar quickstart para configuración guiada
./quickstart.sh
```

### Actualización

```bash
# Desde un proyecto con cursor_workflow instalado
bash <(curl -fsSL https://raw.githubusercontent.com/25ASAB015/cursor_workflow/master/update.sh)
```

### Testing

```bash
# Probar instalación en entorno limpio
./test-install.sh

# O especificar directorio de prueba
TEST_DIR=/tmp/mi_test ./test-install.sh
```

## 📋 Flujo de Despliegue Recomendado

### 1. Preparación Local

```bash
# Verificar que todo esté en orden
ls -la install.sh update.sh quickstart.sh test-install.sh
ls -la .cursor/MANIFEST
```

### 2. Publicar en GitHub

```bash
# Crear repositorio y subir código
gh repo create cursor_workflow --public --source=.
git add .
git commit -m "🎉 feat: initial commit"
git push -u origin master
```

### 3. Actualizar Referencias

```bash
# Reemplazar 25ASAB015 con tu usuario real
find . -type f \( -name "*.md" -o -name "*.sh" \) \
  -exec sed -i 's/25ASAB015/tu_usuario_real/g' {} +

git add .
git commit -m "📝 docs: actualizar referencias de usuario"
git push
```

### 4. Probar Instalación

```bash
# En un directorio de prueba
cd /tmp/test-install
bash <(curl -fsSL https://raw.githubusercontent.com/tu_usuario/cursor_workflow/master/install.sh) \
  --repo tu_usuario/cursor_workflow
```

### 5. Crear Release

```bash
gh release create v1.0.0 \
  --title "v1.0.0 - Primera versión" \
  --generate-notes
```

## 🎯 Características del Sistema de Instalación

### ✨ Ventajas

1. **Instalación con una línea**: Curl directo desde GitHub
2. **Autodetección**: Detecta repositorio desde git remote
3. **MANIFEST dinámico**: Fácil agregar nuevos archivos
4. **Fallback robusto**: Lista predefinida si MANIFEST falla
5. **Verificación de dependencias**: Informa qué hace falta
6. **Backup automático**: No sobreescribe sin preguntar
7. **Permisos correctos**: Configura ejecutables automáticamente
8. **Testing automatizado**: Suite de pruebas completa
9. **Configuración guiada**: Quickstart interactivo
10. **Actualización fácil**: Script de update dedicado

### 🔒 Seguridad

- No ejecuta código arbitrario sin revisar
- Verifica URLs antes de descargar
- Permite revisar script antes de ejecutar
- Backup de instalaciones previas
- No requiere sudo (instalación local)

### 🛠️ Mantenimiento

- **Agregar archivo nuevo**: Solo editar MANIFEST
- **Cambiar estructura**: Actualizar install.sh
- **Nueva versión**: Git tag + release
- **Testing**: Script automatizado test-install.sh

## 📊 Estructura de Archivos del Sistema

```
cursor_workflow/
├── install.sh              # Instalador principal ⭐
├── update.sh               # Actualizador
├── test-install.sh         # Suite de pruebas
├── quickstart.sh           # Configuración guiada
├── install-example.sh      # Ejemplos
├── config.example.sh       # Plantilla de config
├── README.md               # Doc principal
├── DEPLOYMENT.md           # Guía de despliegue ⭐
├── INSTALL_README.md       # Este archivo
├── .gitignore              # Git ignore actualizado
└── .cursor/
    ├── MANIFEST            # Lista de archivos ⭐
    ├── README.md           # Doc de .cursor
    ├── bin/                # Scripts (instalables)
    ├── commands/           # Documentación (instalable)
    ├── agents/             # Placeholder
    └── rules/              # Placeholder
```

## 🎓 Mejores Prácticas

### Para Mantenedores

1. **Actualizar MANIFEST** cuando agregues archivos
2. **Probar con test-install.sh** antes de push
3. **Versionar con tags** semánticos (v1.0.0)
4. **Documentar cambios** en releases
5. **Mantener README** actualizado

### Para Usuarios

1. **Revisar script** antes de ejecutar desde Internet
2. **Usar --force** solo cuando sea necesario
3. **Ejecutar quickstart.sh** después de instalar
4. **Configurar variables** en config.sh
5. **Actualizar regularmente** con update.sh

## 🔍 Verificación de Instalación

Después de instalar, verifica que todo esté en orden:

```bash
# Verificar estructura
ls -la .cursor/
ls -la .cursor/bin/
ls -la .cursor/commands/

# Verificar permisos
file .cursor/bin/*.sh

# Probar ayuda
.cursor/bin/start.sh --help
.cursor/bin/commit.sh --help

# Ejecutar quickstart
./quickstart.sh
```

## 🐛 Solución de Problemas

### Install.sh falla con 404

- **Causa**: Repositorio no publicado o URL incorrecta
- **Solución**: Verifica que el repo esté público y la URL sea correcta

### Scripts no ejecutables

- **Causa**: Permisos no configurados
- **Solución**: `chmod +x .cursor/bin/*.sh`

### MANIFEST no encontrado

- **Causa**: Normal si es primera instalación
- **Solución**: El instalador usa lista predefinida (fallback)

### Dependencias faltantes

- **Causa**: gk, jq, etc. no instalados
- **Solución**: Instala según mensajes de quickstart.sh

## 📝 Próximos Pasos

1. **Publicar en GitHub**: Seguir guía en DEPLOYMENT.md
2. **Compartir con equipo**: Documentación + comando de instalación
3. **Configurar CI/CD**: Tests automáticos en PRs
4. **Crear changelog**: Documentar cambios entre versiones
5. **Community feedback**: Issues y PRs

## ✅ Checklist de Publicación

Antes de publicar:

- [ ] Todos los scripts son ejecutables
- [ ] MANIFEST está actualizado
- [ ] 25ASAB015 reemplazado en todos los archivos
- [ ] Test-install.sh pasa localmente
- [ ] README.md completo y correcto
- [ ] DEPLOYMENT.md revisado
- [ ] .gitignore apropiado
- [ ] config.example.sh con valores de ejemplo
- [ ] LICENSE agregado (opcional)

## 🎉 Resultado Final

Después de seguir esta guía, tendrás:

✅ Sistema de instalación robusto y fácil de usar  
✅ Instalación con una línea desde GitHub  
✅ Documentación completa para usuarios y mantenedores  
✅ Suite de pruebas automatizada  
✅ Configuración guiada post-instalación  
✅ Sistema de actualización simple  
✅ Mantenimiento facilitado con MANIFEST  

---

**Para más detalles:**
- Instalación: `README.md`
- Despliegue: `DEPLOYMENT.md`
- Configuración: `config.example.sh`
- Scripts: `.cursor/README.md`

