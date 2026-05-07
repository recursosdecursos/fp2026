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
Comprender -> Modelar -> Codificar -> Probar -> Explicar -> Mejorar
```

La arquitectura base de resolución de problemas será:

```text
Problema
   |
Entrada -> Proceso -> Salida
   |
Código
```

Los cinco pasos operativos que se repetirán en cada sesión son:

```text
1. Comprender el problema
2. Identificar entradas
3. Diseñar el proceso
4. Definir salidas y casos de prueba
5. Implementar, ejecutar y corregir
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

### Sesión 1: Pensamiento algorítmico: algoritmos, variables y tipos de datos

**Cuaderno de trabajo:** `S01_Algoritmos_Datos.ipynb`

#### Objetivo

Comprender qué es un algoritmo y representar información usando variables y tipos de datos básicos en un lenguaje de programación.

#### Secuencia didáctica sugerida

- Activación: distinguir una instrucción cotidiana de un algoritmo.
- Modelado: resolver un problema simple usando entrada, proceso y salida.
- Práctica guiada: usar `print()`, `input()`, `int()` y `float()`.
- Reto: construir una ficha básica de usuario o estudiante.
- Cierre: explicar qué diferencia existe entre dato, variable y tipo.

#### Contenidos

- Concepto de algoritmo.
- Arquitectura de resolución de problemas.
- Entorno de trabajo según el lenguaje y la herramienta seleccionada.
- Salidas con `print()`.
- Entradas con `input()`.
- Tipos de datos: `str`, `int`, `float`, `bool`.
- Variables y buenas prácticas de nombrado.

#### Producto esperado

Programa que capture y muestre datos básicos de forma estructurada.

---

### Sesión 2: Expresiones y secuencia en la solución de problemas

**Cuaderno de trabajo:** `S02_Operadores_Secuencia.ipynb`

#### Objetivo

Resolver problemas secuenciales utilizando operadores y conversiones de datos en un lenguaje de programación.

#### Secuencia didáctica sugerida

- Activación: predecir el resultado de expresiones simples.
- Modelado: construir un algoritmo que calcule un promedio o costo total.
- Práctica guiada: aplicar operadores aritméticos, relacionales y lógicos.
- Reto: resolver un problema de cálculo con varias entradas.
- Cierre: justificar por qué un programa secuencial no requiere decisiones.

#### Contenidos

- Operadores aritméticos.
- Operadores relacionales.
- Operadores lógicos.
- Conversión con `int()` y `float()`.
- Estructura secuencial.
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

#### Producto esperado

Programas que responden de manera diferente según las condiciones de entrada.

---

### Sesión 4: Decisiones múltiples y lógica anidada

**Cuaderno de trabajo:** `S04_Decisiones_Multiples.ipynb`

#### Objetivo

Resolver problemas con varios caminos lógicos usando estructuras `if-elif-else` y condicionales anidados.

#### Contenidos

- Condicionales anidados.
- Condicionales múltiples con `if-elif-else`.
- Priorización de condiciones.
- Clasificación de datos.
- Casos límite.

#### Producto esperado

Programas que clasifican y toman decisiones de acuerdo con varios criterios.

---

### Sesión 5: Aplicación integrada de estructuras básicas

**Cuaderno de trabajo:** `S05_Evaluacion_1.ipynb`

#### Objetivo

Integrar variables, operadores y estructuras condicionales en la resolución de problemas completos.

#### Contenidos

- Entrada, proceso y salida.
- Variables y conversiones.
- Operadores.
- Condicionales.
- Pruebas con casos normales y límite.

#### Producto esperado

Compendio parcial de ejercicios resueltos con procesamiento secuencial y decisiones básicas.

---

### Sesión 6: Evaluación de desempeño de la unidad 1

**Cuaderno de trabajo:** `S06_For.ipynb`

#### Evidencia

Programa individual que integre entrada de datos, procesamiento secuencial, validación y decisiones.

#### Criterios específicos

- Analiza bien el problema.
- Usa datos y operadores con corrección.
- Implementa decisiones apropiadas.
- Presenta resultados claros.
- Realiza pruebas básicas antes de entregar.

---

## Unidad 2: Estructuras repetitivas, datos y subprogramas

### Propósito de la unidad

Que el estudiante automatice tareas mediante bucles, procese datos en listas y cadenas, y estructure soluciones mediante funciones.

### Competencias de la unidad

- Usa estructuras repetitivas para automatizar procesos.
- Aplica contadores y acumuladores.
- Maneja listas, cadenas y estructuras simples de datos.
- Diseña funciones con parámetros y retorno.
- Aplica búsqueda secuencial y ordenación básica en problemas sencillos.
- Integra varias estructuras en un programa completo.

### Producto de unidad

Compendio de ejercicios resueltos sobre estructuras repetitivas, datos y subprogramas.

---

### Sesión 7: Repetición definida y procesamiento con listas

**Cuaderno de trabajo:** `S07_While.ipynb`

#### Objetivo

Resolver problemas repetitivos con `for`, listas, contadores, acumuladores y ordenación básica.

#### Contenidos

- Bucle `for`.
- Uso de `range()`.
- Recorrido de listas.
- Contadores.
- Acumuladores.
- Ordenación básica de datos en listas.
- Sumatorias y conteos condicionados.

#### Producto esperado

Programas que procesan, ordenan y resumen conjuntos básicos de datos.

---

### Sesión 8: Repetición condicionada y captura dinámica de datos

**Cuaderno de trabajo:** `S08_Listas_Cadenas.ipynb`

#### Objetivo

Usar `while` para controlar el ingreso de datos hasta cumplir una condición de parada y validar entradas en datos numéricos o textuales.

#### Contenidos

- Bucle `while`.
- Condición de parada.
- Centinelas.
- Validación repetida.
- Cadenas y operaciones básicas de procesamiento textual.
- Registro de datos en listas.

#### Producto esperado

Programa que permita ingresar una cantidad variable de datos, validarlos y procesarlos.

---

### Sesión 9: Estructuración básica de datos

**Cuaderno de trabajo:** `S09_Busqueda_Ordenacion.ipynb`

#### Objetivo

Organizar información utilizando listas y diccionarios simples según la estructura que requiera el problema.

#### Contenidos

- Listas e índices.
- Diccionarios simples.
- Selección de la estructura según el problema.
- Recorrido y consulta de datos.

#### Producto esperado

Programa que registre y consulte información organizada.

---

### Sesión 10: Modularización de soluciones con funciones

**Cuaderno de trabajo:** `S10_Matrices.ipynb`

#### Objetivo

Modularizar programas mediante funciones con parámetros y retorno.

#### Contenidos

- `def`.
- Parámetros.
- `return`.
- Reutilización de código.
- Diseño modular.

#### Producto esperado

Programa estructurado en funciones claras y reutilizables.

---

### Sesión 11: Integración de repetición, datos y funciones

**Cuaderno de trabajo:** `S11_Diccionarios.ipynb`

#### Objetivo

Integrar repetición, almacenamiento, búsqueda secuencial y modularización en una solución completa.

#### Contenidos

- Menús simples.
- Integración de bucles y listas.
- Búsqueda secuencial en colecciones de datos.
- Funciones para organizar el flujo.
- Pruebas de funcionamiento.

#### Producto esperado

Compendio parcial de ejercicios resueltos con repetición, organización de datos y funciones de apoyo.

---

### Sesión 12: Evaluación de desempeño de la unidad 2

**Cuaderno de trabajo:** `S12_Evaluacion_2.ipynb`

#### Evidencia

Programa aplicado que use datos de entrada, decisiones, bucles, listas y funciones.

#### Criterios específicos

- Integra correctamente las estructuras estudiadas.
- Organiza el código en bloques claros.
- Procesa múltiples datos sin errores graves.
- Presenta resultados comprensibles.
- Demuestra pruebas mínimas del funcionamiento.

---

## Unidad 3: Organización y persistencia de información

### Propósito de la unidad

Que el estudiante organice información de manera estructurada y use mecanismos básicos de persistencia para resolver problemas aplicados con mayor claridad, control y continuidad de los datos.

### Competencias de la unidad

- Organiza información para su registro, consulta y actualización según necesidades de persistencia.
- Lee, escribe y recupera información en mecanismos básicos de persistencia.
- Relaciona datos, operaciones y estructura del programa para resolver ejercicios de forma ordenada y consistente.

### Producto de la unidad

Compendio parcial de ejercicios resueltos sobre organización y persistencia básica de información.

### Sesión 13: Matrices y organización tabular de información

#### Objetivo

Organizar y procesar información en tablas o matrices para resolver problemas que requieren recorridos por filas, columnas y posiciones.

#### Contenidos

- Concepto de matriz o estructura bidimensional.
- Representación tabular de información.
- Recorrido por filas y columnas.
- Consulta, actualización y presentación de datos en tablas.
- Ejercicios de aplicación con matrices y organización tabular.

#### Producto esperado

Compendio parcial de ejercicios resueltos sobre matrices y organización tabular de información.

---

### Sesión 14: Persistencia básica de información

#### Objetivo

Resolver ejercicios de almacenamiento y recuperación de datos en archivos u otros mecanismos básicos de persistencia según el lenguaje o entorno utilizado.

#### Contenidos

- Concepto de persistencia.
- Archivos de texto y archivos estructurados simples.
- Opciones de almacenamiento según el lenguaje: archivos estructurados o bases ligeras.
- Registro, recuperación y consulta básica de información.
- Ejercicios de aplicación con persistencia básica.

#### Producto esperado

Compendio parcial de ejercicios resueltos sobre persistencia básica.

---

### Sesión 15: Integración de organización y persistencia de información

#### Objetivo

Integrar organización de datos, funciones y persistencia para resolver ejercicios completos de registro, consulta y actualización de información.

#### Contenidos

- Organización de información en registros, listas o estructuras equivalentes.
- Relación entre datos y operaciones asociadas.
- Registro, consulta y actualización de información.
- Validación de consistencia entre memoria y persistencia.
- Ejercicios integradores de organización y persistencia de información.

#### Producto esperado

Compendio parcial de ejercicios resueltos sobre organización y persistencia de información.

---

### Sesión 16: Evaluación final del curso

#### Evidencia

Entrega final del compendio de ejercicios resueltos y evaluación individual del dominio logrado en el curso.

#### Criterios específicos

- Presenta un compendio final consistente, ordenado y funcional.
- Corrige observaciones relevantes derivadas de las evaluaciones parciales.
- Demuestra comprensión integral de los fundamentos de programación.

---

## 7. Distribución resumida

```text
Nombre del curso: Fundamentos de Programación (FP)
Producto del curso: Compendio de resolución de ejercicios de programación
Duración: 3 unidades de 5 semanas y 1 sesión final de cierre

Unidad 1 - U1: Estructuras secuenciales y condicionales
Producto U1: Compendio parcial de ejercicios sobre estructuras secuenciales y condicionales
s1: Algoritmos, variables y tipos de datos (algoritmos, entrada-proceso-salida, variables, tipos de datos)
s2: Algoritmos secuenciales y operadores (algoritmo secuencial, operadores aritméticos, relacionales, lógicos)
s3: Decisiones simples y compuestas (decisiones simples, decisiones compuestas, validación básica)
s4: Decisiones múltiples y lógica anidada (decisiones anidadas, decisiones múltiples, clasificación de datos, casos límite)
s5: Aplicación integrada de estructuras básicas (integración de variables, operadores, condicionales, pruebas)
s6: Evaluación 1 (desempeño de la unidad 1)

Unidad 2 - U2: Estructuras repetitivas, datos y subprogramas
Producto U2: Compendio parcial de ejercicios sobre estructuras repetitivas, datos y subprogramas
s7: Repetición definida y listas (for, range, listas, contadores, acumuladores, ordenación básica)
s8: Repetición condicionada y captura de datos (while, condición de parada, centinelas, validación y cadenas)
s9: Estructuración básica de datos (listas, índices, diccionarios simples, recorrido y consulta de datos)
s10: Modularización con funciones (funciones, parámetros, retorno, reutilización de código)
s11: Integración de repetición, datos y funciones (integración de bucles, listas, búsqueda secuencial, funciones y menú simple)
s12: Evaluación 2 (desempeño de la unidad 2)

Unidad 3 - U3: Organización y persistencia de información
Producto U3: Compendio parcial de ejercicios sobre organización y persistencia básica de información
s13: Matrices y organización tabular de información (tablas, filas, columnas, consulta y actualización de datos)
s14: Persistencia básica de información (archivos, almacenamiento estructurado simple y recuperación de datos)
s15: Integración de organización y persistencia de información (registro, consulta, actualización y consistencia de datos)
s16: Evaluación final del curso (entrega final, mejoras y dominio logrado)
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