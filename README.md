# fp2026

Libro digital de Programación construido con MkDocs a partir de cuadernos Jupyter.

## Poner en marcha el libro en local

### Opción recomendada: con Docker

Requisitos:

- Tener Docker Desktop instalado y en ejecución.

Desde la raíz del proyecto, ejecuta:

```powershell
docker compose up
```

Luego abre en tu navegador:

```text
http://127.0.0.1:8000/
```

Para detener el servidor, presiona `Ctrl+C` en la terminal.

### Opción alternativa: con Python local

Requisitos:

- Tener Python instalado.
- Tener `pip` disponible.

Instala las dependencias:

```powershell
python -m pip install mkdocs mkdocs-material mkdocs-jupyter pymdown-extensions
```

Luego inicia el servidor local:

```powershell
mkdocs serve
```

Después abre:

```text
http://127.0.0.1:8000/
```

### Generar el sitio estático

Si quieres construir el libro sin levantar el servidor:

Con Docker:

```powershell
docker compose run --rm mkdocs mkdocs build
```

Con Python local:

```powershell
mkdocs build
```

El resultado se genera en la carpeta `site/`.

## Publicación en GitHub Pages

El repositorio está configurado para desplegar el sitio al hacer `push` a la rama `main`.

El flujo de despliegue:

1. Instala MkDocs, Material y `mkdocs-jupyter`.
2. Convierte los cuadernos `.ipynb` en páginas estáticas del sitio.
3. Publica el contenido generado en GitHub Pages mediante `mkdocs gh-deploy --force`.

## Vista local

Puedes probar el libro localmente con cualquiera de estas opciones:

- `mkdocs serve`
- `docker compose up`

## Contenido del libro

- Portada del curso.
- Sílabo.
- Guía de apoyo.
- Sesiones 1 a 12 en formato de libro digital no ejecutable.
