# Sílabo del curso: Fundamentos de Programación

## 1. Datos generales

**Curso:** Fundamentos de Programación  
**Abreviación:** FP  
**Carrera profesional:** Ingeniería de Sistemas  
**Institución:** UPeU  
**Ciclo:** I  
**Duración:** 3 unidades de 5 semanas y 1 sesión final de cierre  
**Sesiones:** 16 sesiones teórico-prácticas  
**Lenguaje de trabajo:** Según la planificación docente  
**Entorno sugerido:** Entorno de programación o IDE según el lenguaje seleccionado

---

## 2. Descripción del curso

Fundamentos de Programación es un curso de inicio de carrera orientado al desarrollo del pensamiento algorítmico y la resolución estructurada de problemas. El estudiante aprende a analizar situaciones, identificar datos de entrada, diseñar procesos, producir salidas verificables y traducir esa lógica a programas funcionales en un lenguaje de programación definido por el docente.

Por tratarse de estudiantes de primer ciclo, el curso prioriza comprensión, práctica guiada y construcción progresiva de autonomía. El énfasis no está en memorizar sintaxis, sino en aprender a pensar como programador: descomponer problemas, probar soluciones, detectar errores y mejorar el código con criterio.

---

## 3. Propósito formativo

Al finalizar el curso, el estudiante será capaz de diseñar algoritmos y desarrollar programas básicos en un lenguaje de programación empleando variables, operadores, estructuras condicionales, estructuras repetitivas, listas y funciones, validando sus resultados mediante pruebas simples y explicando la lógica de su solución.

### Producto del curso

Compendio de resolución de ejercicios de programación: conjunto organizado de ejercicios resueltos, probados y explicados, que evidencian el dominio progresivo de estructuras secuenciales, condicionales, repetitivas, estructuras básicas de datos y subprogramas.

---

## 4. Enfoque pedagógico

El curso adopta un enfoque activo, progresivo y aplicado. En un curso de primer ciclo, una sesión de programación no debe consistir en exposición larga y copia de código. Debe combinar explicación breve, modelado del docente, práctica guiada, resolución de retos y cierre con verificación.

La lógica metodológica del curso será:

```text
Comprender -> Diseñar -> Codificar -> Probar -> Explicar -> Mejorar
```

La arquitectura base de resolución de problemas será:

```text
Problema
   |
Entrada -> Proceso -> Salida
   |
Código
```

Los 6 pasos operativos que se repetirán en cada sesión son:

```text
1. Comprender el problema
2. Identificar entradas
3. Diseñar el proceso
4. Definir salidas
5. Casos de prueba
6. Implementar, ejecutar y corregir
```

---

## 5. Cómo debería ser una sesión de clase de programación

En Fundamentos de Programación, una sesión eficaz debe tener ritmo, práctica y retroalimentación. Para estudiantes de primer ciclo, la secuencia sugerida es la siguiente:

### 5.1 Inicio de la sesión

- Recuperar saberes previos con una pregunta o ejercicio corto.
- Presentar la meta de la sesión en lenguaje claro.
- Mostrar para qué sirve el tema en problemas reales de ingeniería o gestión de datos.

### 5.2 Construcción guiada

- Explicar el concepto central con ejemplos pequeños.
- Resolver un problema modelo paso a paso antes de escribir el código.
- Pensar en voz alta: qué entra, qué se procesa, qué sale y cómo se prueba.

### 5.3 Práctica acompañada

- El estudiante modifica ejemplos ya resueltos.
- El docente supervisa errores frecuentes de sintaxis, tipos de datos y lógica.
- Se promueve que el estudiante anticipe el resultado antes de ejecutar.

### 5.4 Reto aplicado

- El estudiante resuelve un ejercicio nuevo con menor apoyo.
- El reto debe exigir transferencia, no copia literal del ejemplo.
- Se evalúa tanto el resultado como el proceso de solución.

### 5.5 Cierre y metacognición

- Se revisan errores comunes y formas de corregirlos.
- El estudiante explica qué aprendió y qué parte aún le cuesta.
- Se deja una tarea breve o práctica de consolidación.

### 5.6 Estructura sugerida de tiempo

Para una sesión de 4 horas pedagógicas, una distribución razonable sería:

```text
Activación y propósito                 15 min
Explicación y modelado del docente     35 min
Práctica guiada                        50 min
Pausa breve                            10 min
Reto aplicado individual o en pares    45 min
Socialización y retroalimentación      25 min
Síntesis, autoevaluación y cierre      20 min
```

Esta estructura evita dos errores comunes en cursos iniciales: saturar de teoría y dejar al estudiante solo demasiado pronto.

---

## 6. Evaluación del aprendizaje

La evaluación será continua, práctica y formativa. En programación inicial, no basta verificar si el código "corre"; también importa si el estudiante comprende el problema, selecciona correctamente las estructuras y prueba su solución.

### Criterios generales

- Analiza correctamente el problema y distingue entrada, proceso y salida.
- Usa variables y tipos de datos de forma coherente.
- Emplea operadores y estructuras de control según el problema.
- Escribe código legible, ordenado y funcional.
- Realiza pruebas con datos normales y casos límite básicos.
- Detecta y corrige errores de sintaxis o lógica simple.
- Explica verbalmente o por escrito la lógica de su programa.

### Evidencias

- Guías o cuadernos desarrollados por sesión.
- Ejercicios resueltos en clase.
- Retos prácticos individuales o colaborativos.
- Evaluaciones prácticas por unidad.
- Compendio de ejercicios resueltos por unidad.


---

## Unidad 1: Estructuras secuenciales y condicionales

### Propósito de la unidad

Que el estudiante comprenda la lógica de resolución de problemas computacionales y desarrolle programas básicos usando datos, operadores y estructuras condicionales.

### Competencias de la unidad

- Representa un problema mediante entrada, proceso y salida.
- Usa variables y tipos de datos para modelar información.
- Aplica operadores aritméticos, relacionales y lógicos.
- Construye algoritmos secuenciales.
- Resuelve problemas con decisiones simples, compuestas y múltiples.
- Verifica resultados mediante pruebas básicas.

### Producto de unidad

Compendio de ejercicios resueltos sobre estructuras secuenciales y condicionales.

---

### Sesión 1: Pensamiento algorítmico, datos y variables

**Cuaderno de trabajo:** `S01_Algoritmos_Datos.ipynb`

#### Objetivo

Comprender qué es un algoritmo, organizar una solución mediante entrada, proceso y salida, e identificar datos para almacenarlos en variables según su tipo.

#### Secuencia didáctica sugerida

- Activación: distinguir una instrucción cotidiana de un algoritmo.
- Modelado: resolver un problema simple usando entrada, proceso y salida.
- Práctica guiada: usar `print()`, `input()`, `int()` y `float()`.
- Reto: construir una ficha básica de usuario o estudiante.
- Cierre: explicar qué diferencia existe entre dato, variable y tipo.

#### Contenidos

- Concepto de algoritmo.
- Estructura entrada, proceso y salida.
- Representación de algoritmos en lenguaje natural, pseudocódigo y diagrama de flujo.
- Entorno de trabajo según el lenguaje y la herramienta seleccionada.
- Salidas con `print()`.
- Entradas con `input()`.
- Tipos de datos: `str`, `int`, `float`, `bool`.
- Variables y buenas prácticas de nombrado.
- Constantes.
- Metodología para resolver problemas y casos de prueba.

#### Producto esperado

Programa que capture y muestre datos básicos de forma estructurada.

---

### Sesión 2: Expresiones y secuencia en la solución de problemas

**Cuaderno de trabajo:** `S02_Operadores_Algoritmos_Secuenciales.ipynb`

#### Objetivo

Resolver problemas secuenciales utilizando operadores y conversiones de datos en un lenguaje de programación.

#### Secuencia didáctica sugerida

- Activación: predecir el resultado de expresiones simples.
- Modelado: construir un algoritmo que calcule un promedio o costo total.
- Práctica guiada: aplicar operadores aritméticos, relacionales y lógicos.
- Reto: resolver un problema de cálculo con varias entradas.
- Cierre: justificar por qué un programa secuencial no requiere decisiones.

#### Contenidos

- Operadores de asignación.
- Operadores aritméticos.
- Operadores relacionales.
- Operadores lógicos.
- Expresiones y precedencia de operadores.
- Conversión con `int()` y `float()`.
- Estructura secuencial.
- Organización en entrada, proceso y salida.
- Verificación de resultados.

#### Producto esperado

Programas que leen datos, realizan cálculos y muestran resultados correctamente formateados.

---

### Sesión 3: Decisiones simples en la lógica del programa

**Cuaderno de trabajo:** `S03_Decisiones.ipynb`

#### Objetivo

Construir programas que tomen decisiones usando estructuras `if` y `if-else`.

#### Contenidos

- Expresiones condicionales.
- `if`.
- `if-else`.
- Condiciones compuestas con `and` y `or`.
- Validación básica de datos.
- Casos de prueba.

#### Producto esperado

Programas que responden de manera diferente según las condiciones de entrada.

---

### Sesión 4: Decisiones múltiples y lógica anidada

**Cuaderno de trabajo:** `S04_Decisiones_Multiples.ipynb`

#### Objetivo

Resolver problemas con varios caminos lógicos usando estructuras `if-elif-else`, `match-case` y condicionales anidados.

#### Contenidos

- Condicionales anidados.
- Condicionales múltiples con `if-elif-else`.
- Selección de casos con `match-case`.
- Priorización de condiciones.
- Clasificación de datos.
- Casos límite.

#### Producto esperado

Programas que clasifican y toman decisiones de acuerdo con varios criterios usando decisiones múltiples, `match-case` o lógica anidada.

---

### Sesión 5: Evaluación de desempeño de la unidad 1

**Cuaderno de trabajo:** `S05_Evaluacion_1.ipynb`

#### Evidencia

Programa individual que integre variables, operadores, decisiones simples, múltiples o anidadas y selección con `match-case`, organizando la solución en entrada, proceso y salida.

#### Criterios específicos

- Analiza bien el problema.
- Usa datos y operadores con corrección.
- Implementa decisiones simples, múltiples, anidadas o `match-case` según el problema.
- Presenta resultados claros.
- Realiza pruebas con casos normales y límite antes de entregar.

---

## Unidad 2: Estructuras repetitivas y procesamiento de datos

### Propósito de la unidad

Que el estudiante automatice tareas mediante bucles y procese colecciones de datos usando listas, cadenas, búsqueda, ordenación, matrices y diccionarios simples.

### Competencias de la unidad

- Usa estructuras repetitivas para automatizar procesos.
- Aplica contadores y acumuladores.
- Maneja listas, cadenas, matrices y diccionarios simples.
- Aplica búsqueda secuencial y ordenación básica en problemas sencillos.
- Procesa datos organizados en filas, columnas y pares clave-valor.
- Integra varias estructuras en programas de complejidad progresiva.

### Producto de unidad

Compendio de ejercicios resueltos sobre estructuras repetitivas y procesamiento de datos.

---

### Sesión 6: Repetición definida con `for`

**Cuaderno de trabajo:** `S06_For.ipynb`

#### Objetivo

Resolver problemas que requieren repetir una acción un número conocido de veces.

#### Contenidos

- Bucle `for`.
- Uso de `range()`.
- Contadores.
- Acumuladores.
- Sumatorias.

#### Producto esperado

Programas que usan `for`, contadores y acumuladores para procesar varios datos.

---

### Sesión 7: Repetición condicionada con `while`

**Cuaderno de trabajo:** `S07_While.ipynb`

#### Objetivo

Resolver problemas en los que la repetición depende de una condición de parada.

#### Contenidos

- Bucle `while`.
- Condición de parada.
- Centinelas.
- Validación iterativa.
- Control de ingreso de datos.

#### Producto esperado

Programa que use `while`, centinelas y validación iterativa de datos.

---

### Sesión 8: Listas, cadenas y procesamiento de colecciones

**Cuaderno de trabajo:** `S08_Listas_Cadenas.ipynb`

#### Objetivo

Procesar conjuntos de datos usando listas y cadenas en problemas de recorrido y análisis simple.

#### Contenidos

- Listas.
- Cadenas.
- Recorrido de colecciones.
- Conteos condicionados.
- Transformación básica de texto.

#### Producto esperado

Programa que recorra una colección, cuente elementos y transforme información textual.

---

### Sesión 9: Búsqueda secuencial y ordenación básica

**Cuaderno de trabajo:** `S09_Busqueda_Ordenacion.ipynb`

#### Objetivo

Resolver problemas de localización y ordenamiento de datos usando técnicas básicas.

#### Contenidos

- Búsqueda secuencial.
- Comparación entre elementos.
- Intercambio de valores.
- Ordenación básica por intercambio.
- Análisis del proceso de búsqueda u ordenación.

#### Producto esperado

Programa que encuentre elementos y ordene listas con una estrategia elemental.

---

### Sesión 10: Matrices y organización tabular de información

**Cuaderno de trabajo:** `S10_Matrices.ipynb`

#### Objetivo

Representar y procesar datos organizados en filas y columnas, incluyendo operaciones matemáticas básicas con matrices.

#### Contenidos

- Concepto de matriz o estructura bidimensional.
- Recorrido por filas.
- Recorrido por columnas.
- Promedios y totales por fila.
- Totales por columna.
- Organización tabular de información.
- Consulta y actualización de datos.
- Transpuesta.
- Producto por escalar.
- Producto de matrices.
- Inversa 2x2.

#### Producto esperado

Programa que recorra una matriz y obtenga resúmenes por filas o columnas, o que aplique operaciones matriciales básicas.

---

### Sesión 11: Diccionarios, organización clave-valor y consulta de datos

**Cuaderno de trabajo:** `S11_Diccionarios.ipynb`

#### Objetivo

Modelar información mediante pares clave-valor para registrar y consultar datos de forma directa.

#### Contenidos

- Diccionarios.
- Claves y valores.
- Registro de datos.
- Consulta y actualización de datos.

#### Producto esperado

Programa que use diccionarios para guardar, consultar y actualizar información.

---

### Sesión 12: Evaluación de desempeño de la unidad 2

**Cuaderno de trabajo:** `S12_Evaluacion_2.ipynb`

#### Evidencia

Programa aplicado que use ciclos y estructuras de datos de la unidad 2, integrando `for`, `while`, listas, cadenas, búsqueda, ordenación, matrices y diccionarios según el problema.

#### Criterios específicos

- Integra correctamente las estructuras estudiadas.
- Organiza el código en bloques claros.
- Procesa múltiples datos sin errores graves.
- Resuelve correctamente recorridos, búsquedas, ordenación u operaciones con matrices cuando corresponda.
- Presenta resultados comprensibles.
- Demuestra pruebas con casos normales y límite.

---

## Unidad 3: Problemas estructurados y persistencia básica

### Propósito de la unidad

Que el estudiante organice programas mediante funciones, integre colecciones con menús y use archivos de texto para resolver problemas aplicados con mayor claridad, control y continuidad de los datos.

### Competencias de la unidad

- Diseña funciones con parámetros y retorno.
- Integra funciones, colecciones y menús simples.
- Lee, escribe y recupera información en archivos de texto.
- Relaciona datos, operaciones y estructura del programa para resolver ejercicios completos.

### Producto de la unidad

Compendio parcial de ejercicios resueltos sobre modularización, integración y persistencia básica.

### Sesión 13: Funciones, parámetros, retorno y modularización

**Cuaderno de trabajo:** `S13_Funciones.ipynb`

#### Objetivo

Dividir un problema en partes reutilizables mediante funciones con parámetros y retorno.

#### Contenidos

- `def`.
- Parámetros.
- `return`.
- Modularización.
- Reutilización de código.

#### Producto esperado

Programa organizado en funciones claras que resuelvan subproblemas concretos y presenten resultados verificables.

---

### Sesión 14: Integración de funciones, colecciones y menús

**Cuaderno de trabajo:** `S14_Integracion_Menus.ipynb`

#### Objetivo

Construir un programa que integre funciones, estructuras de datos y un menú sencillo de opciones.

#### Contenidos

- Menús para organizar opciones del programa.
- Integración de funciones con listas o diccionarios.
- Registro, consulta, actualización y salida.
- Coordinación del flujo del programa.
- Pruebas de funcionamiento.

#### Producto esperado

Programa modular con menú que registre, consulte o actualice información en memoria.

---

### Sesión 15: Persistencia básica de información

**Cuaderno de trabajo:** `S15_Archivos.ipynb`

#### Objetivo

Registrar y recuperar información simple usando archivos de texto.

#### Contenidos

- Concepto de persistencia.
- Archivos de texto.
- Escritura.
- Lectura.
- Registro y recuperación de datos.
- Procesamiento básico de información guardada.

#### Producto esperado

Programa que escriba datos en un archivo y luego los lea para mostrarlos o procesarlos.

---

### Sesión 16: Evaluación final del curso

**Cuaderno de trabajo:** `S16_Evaluacion_Final.ipynb`

#### Evidencia

Evaluación práctica integradora con problemas que combinen funciones, menús, colecciones y persistencia básica, organizada en entrada, proceso y salida y acompañada por el compendio trabajado en el curso.

#### Criterios específicos

- Integra funciones, menús, colecciones y archivos según el problema.
- Organiza la solución en bloques claros y verificables.
- Presenta resultados correctos, ordenados y comprensibles.
- Demuestra comprensión integral de los fundamentos de programación mediante pruebas básicas.

---

## 7. Distribución resumida

```text
Nombre del curso: Fundamentos de Programación (FP)
Producto del curso: Compendio de resolución de ejercicios de programación
Duración: 16 sesiones teórico-prácticas

Unidad 1 - U1: Estructuras secuenciales y condicionales
Producto U1: Compendio parcial de ejercicios sobre estructuras secuenciales y condicionales
s1: Pensamiento algorítmico, datos y variables (algoritmos, representación, entrada-proceso-salida, variables, tipos de datos y constantes)
s2: Algoritmos secuenciales y operadores (asignación, operadores aritméticos, relacionales y lógicos, expresiones y conversión)
s3: Decisiones simples y compuestas (if, if-else, condiciones compuestas, validación y casos de prueba)
s4: Decisiones múltiples y lógica anidada (if-elif-else, match-case, decisiones anidadas, clasificación y casos límite)
s5: Evaluación 1 (variables, operadores, decisiones y match-case)

Unidad 2 - U2: Estructuras repetitivas y procesamiento de datos
Producto U2: Compendio parcial de ejercicios sobre estructuras repetitivas y procesamiento de datos
s6: Repetición definida con for (for, range, contadores, acumuladores y sumatorias)
s7: Repetición condicionada con while (while, condición de parada, centinelas, validación y control de ingreso)
s8: Listas y cadenas (listas, cadenas, recorridos, conteos y transformación de texto)
s9: Búsqueda secuencial y ordenación básica (búsqueda, comparación, intercambio y análisis del proceso)
s10: Matrices y organización tabular (filas, columnas, recorridos y operaciones matriciales básicas)
s11: Diccionarios y organización clave-valor (claves, valores, registro, consulta y actualización)
s12: Evaluación 2 (ciclos, listas, cadenas, búsqueda, ordenación, matrices y diccionarios)

Unidad 3 - U3: Problemas estructurados y persistencia básica
Producto U3: Compendio parcial de ejercicios sobre modularización, integración y persistencia básica
s13: Funciones y modularización (funciones, parámetros, return, modularización y reutilización)
s14: Integración de funciones, colecciones y menús (menús, listas o diccionarios, flujo y opciones del programa)
s15: Persistencia básica de información (archivos de texto, escritura, lectura, registro y recuperación)
s16: Evaluación final del curso (integración de funciones, menús, colecciones y persistencia)
```

---

## 8. Recursos

- Computadora o laptop.
- Acceso a un entorno de programación o IDE según el lenguaje seleccionado.
- Guías o cuadernos de práctica por sesión.
- Lenguaje de programación definido para el curso.
- Proyector o pantalla para modelado en vivo.
- Rúbrica de evaluación práctica.

---

## 9. Recomendación pedagógica final

Si el curso está dirigido a estudiantes de primer ciclo de Ingeniería de Sistemas, cada sesión debe priorizar menos contenido y más práctica significativa. Es preferible que el estudiante resuelva 2 o 3 problemas bien guiados y explique su lógica, antes que exponer muchas estructuras en una sola clase sin tiempo de aplicación.

En este nivel, una buena sesión de programación se reconoce porque el estudiante:

- entiende qué problema está resolviendo,
- puede anticipar qué debería ocurrir al ejecutar,
- prueba su programa con distintos datos,
- y explica por qué su solución funciona.
