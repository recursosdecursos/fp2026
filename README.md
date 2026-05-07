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




FP + POO Articulados
La progresión correcta queda así:

FP: resolver problemas con corrección y estructura.
POO: modelar y diseñar mejor esas soluciones.
FP: 16 sesiones
Unidad 1: Problemas directos y control de casos
Evaluación en s5.

Pensamiento algorítmico, variables y tipos de datos
Operadores, expresiones y secuencia
Decisiones simples y compuestas
Decisiones múltiples, anidadas y validación
Evaluación integradora de la unidad 1

Unidad 2: Problemas iterativos y colecciones básicas
Evaluación en s10.

Repetición definida con for
Repetición condicionada con while
Listas y cadenas
Búsqueda secuencial y ordenación básica
Evaluación integradora de la unidad 2

Unidad 3: Problemas estructurados y persistencia básica
Evaluación en s16.

Matrices y organización tabular
Diccionarios y modelado simple de datos
Funciones y modularización
Integración de funciones, colecciones y menús
Persistencia básica de información
Evaluación integradora final


---- hasta aquí----




POO: 16 sesiones
Unidad 1: Modelado básico de objetos
Evaluación en s5.

Transición de programación estructurada a POO
Clases, objetos, atributos y métodos
Encapsulamiento y control del estado
Constructores y responsabilidad de clase
Evaluación integradora de la unidad 1



Unidad 2: Colecciones de objetos y extensión del comportamiento
Evaluación en s10.

Colecciones de objetos
Relaciones entre objetos
Herencia como reutilización
Polimorfismo y sustitución correcta
Evaluación integradora de la unidad 2


Unidad 3: Diseño aplicado y calidad
Evaluación en s16.

Interfaces o abstracción
Excepciones y robustez
Persistencia de objetos
Organización en módulos, capas o paquetes
Caso integrador con revisión de diseño
Evaluación integradora final