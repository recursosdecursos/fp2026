# Sílabo de Programación para Futuros Desarrolladores

## 1. Datos generales

**Área:** Educación para el Trabajo / Computación e Informática  
**Grado:** 5to de secundaria  
**Duración:** 2 unidades  
**Sesiones:** 12 sesiones de 4 horas pedagógicas  
**Modalidad:** Teórico-práctica con cuadernos Jupyter  
**Lenguaje:** Python  
**Entorno sugerido:** Jupyter Notebook o Google Colab

---

## 2. Propósito del curso

El curso busca que el estudiante aprenda a resolver problemas mediante algoritmos y programas en Python, desarrollando pensamiento lógico, autonomía, precisión y capacidad para probar sus soluciones.

Al finalizar, el estudiante podrá analizar un problema, identificar entradas, procesos y salidas, escribir código funcional, verificar resultados y organizar programas usando condicionales, bucles, arreglos/listas, estructuras de datos simples y funciones.

---

## 3. Enfoque metodológico

La metodología del curso será práctica, progresiva y orientada a resultados. Cada sesión debe permitir que el estudiante avance con la guía incluso sin depender totalmente del docente.

La secuencia de aprendizaje será:

```text
Ver -> Cambiar -> Probar -> Crear -> Evaluar
```

Cada sesión incluye:

- Explicación teórica breve y directa.
- Guía práctica en cuaderno Jupyter.
- Ejercicios resueltos para observar patrones.
- Tareas tipo competencia para resolver de forma autónoma.
- Pruebas con casos normales y casos límite.
- Evaluación rápida de lo aprendido.
- Retroalimentación del docente.

El método base para resolver problemas tendrá 5 pasos:

```text
1. Comprender el problema
2. Identificar entradas
3. Diseñar el proceso
4. Definir salidas y pruebas
5. Escribir, ejecutar y corregir el código
```

La arquitectura que acompaña esos pasos será:

```text
Problema
   |
Entrada -> Proceso -> Salida
   |
Código en Python
```

---

## 4. Evaluación del aprendizaje

La evaluación será principalmente práctica. Se valorará que el estudiante no solo escriba código, sino que entienda el problema, pruebe su solución y explique sus decisiones.

### Criterios generales

- Identifica correctamente el problema, las entradas, el proceso y las salidas.
- Usa variables, tipos de datos y conversiones de forma adecuada.
- Aplica operadores, condicionales, bucles, listas y funciones según corresponda.
- Escribe código claro, ordenado y funcional.
- Prueba sus programas con diferentes casos.
- Corrige errores básicos de sintaxis y lógica.
- Explica cómo funciona su solución.

### Evidencias

- Cuadernos Jupyter desarrollados.
- Ejercicios resueltos en clase.
- Tareas tipo competencia.
- Evaluaciones prácticas por unidad.
- Programa integrador final de cada unidad.

---

# Unidad 1: Fundamentos para Pensar y Programar

## Propósito de la unidad

Que el estudiante comprenda cómo se resuelve un problema mediante algoritmos, use datos y variables, aplique operadores, construya programas secuenciales y tome decisiones con condicionales.

## Competencias principales

- Comprende la arquitectura para resolver ejercicios: problema, entrada, proceso, salida y código.
- Reconoce tipos de datos y usa variables.
- Aplica operadores aritméticos, relacionales y lógicos.
- Construye algoritmos secuenciales.
- Usa condicionales simples, compuestos, anidados y múltiples.
- Prueba sus programas con diferentes casos.

## Producto de unidad

Programas básicos en Python que resuelven problemas escolares y cotidianos:

- Ficha interactiva.
- Calculadoras secuenciales.
- Comparadores lógicos.
- Programas con decisiones.
- Asistente básico de notas.

---

## Sesión 1: Algoritmos, tipos de datos y variables

**Cuaderno de trabajo:** `Sesion_01_Algoritmos_Tipos_Datos_Variables.ipynb`

### Objetivo

Comprender qué es un algoritmo, aplicar la arquitectura para resolver ejercicios y usar variables con distintos tipos de datos.

### Contenidos

- Concepto de algoritmo.
- Arquitectura: problema, entrada, proceso, salida y código.
- Entorno de trabajo: Jupyter Notebook o Google Colab.
- Salidas con `print()`.
- Entradas con `input()`.
- Tipos de datos: texto, entero, decimal y lógico.
- Variables y nombres claros.

### Producto esperado

Ficha interactiva que pide datos de un estudiante y los muestra de forma ordenada.

### Ejercicios propuestos tipo competencia

- Eco de datos: leer un dato y mostrarlo con una etiqueta.
- Ficha escolar: leer nombre, grado y sección.
- Salida exacta: reproducir una salida con formato fijo.

---

## Sesión 2: Operadores y algoritmos secuenciales

**Cuaderno de trabajo:** `Sesion_02_Operadores_Algoritmos_Secuenciales.ipynb`

### Objetivo

Resolver algoritmos secuenciales usando variables y operadores aritméticos, relacionales y lógicos.

### Contenidos

- Operadores aritméticos: `+`, `-`, `*`, `/`, `//`, `%`, `**`.
- Operadores relacionales: `>`, `<`, `>=`, `<=`, `==`, `!=`.
- Operadores lógicos: `and`, `or`, `not`.
- Conversión de datos con `int()` y `float()`.
- Estructura secuencial de un programa.
- Prueba de resultados.

### Producto esperado

Programas secuenciales que calculan, comparan y muestran resultados.

### Ejercicios propuestos tipo competencia

- Calculadora básica.
- Promedio de tres notas.
- Área y perímetro.
- Reparto exacto con división entera y residuo.
- Comparador lógico.

---

## Sesión 3: Decisiones inteligentes simples

**Cuaderno de trabajo:** `Sesion_03_Decisiones_Inteligentes_Simples.ipynb`

### Objetivo

Crear programas que toman decisiones usando condicionales simples y compuestos.

### Contenidos

- Condiciones que producen `True` o `False`.
- Condicional simple: `if`.
- Condicional compuesto: `if-else`.
- Comparaciones.
- Condiciones compuestas con `and` y `or`.
- Validación básica de datos.

### Producto esperado

Programas que responden de forma diferente según los datos ingresados.

### Ejercicios propuestos tipo competencia

- Aprobó o desaprobó.
- Mayor de dos números.
- Mayor de tres números.
- Par o impar.
- Validar una nota.

---

## Sesión 4: Decisiones inteligentes anidadas y múltiples

**Cuaderno de trabajo:** `Sesion_04_Decisiones_Anidadas_Multiples.ipynb`

### Objetivo

Resolver problemas con varios caminos usando condicionales anidados y múltiples.

### Contenidos

- Condicionales anidados.
- Condicionales múltiples con `if-elif-else`.
- Decisiones múltiples tipo `switch` con `match-case`.
- Menús simples con opciones.
- Clasificación de datos.
- Priorización de condiciones.
- Casos límite.

### Producto esperado

Programas que clasifican datos y resuelven situaciones con más de dos caminos.

### Ejercicios propuestos tipo competencia

- Clasificar una nota.
- Semáforo.
- Descuento por monto de compra.
- Menú simple con `match-case`.
- Recomendador de actividad.
- Acceso con usuario y clave.

---

## Sesión 5: Integración de fundamentos

**Cuaderno de trabajo:** `Sesion_05_Integracion_Fundamentos.ipynb`

### Objetivo

Integrar arquitectura, entradas, salidas, variables, operadores y decisiones en problemas completos.

### Contenidos

- Repaso aplicado de algoritmos.
- Entrada, proceso y salida.
- Variables y operadores.
- Condicionales simples, anidados y múltiples.
- Validación de datos.
- Pruebas con casos normales y casos límite.

### Producto esperado

Programa integrador que combine cálculos y decisiones.

### Ejercicios propuestos tipo competencia

- Promedio con clasificación.
- Boleta con descuento.
- Acceso escolar.
- Asistente de notas.
- Temperatura: frío, templado o calor.

---

## Sesión 6: Evaluación de Unidad 1

**Cuaderno de trabajo:** `Sesion_06_Evaluacion_Unidad_1.ipynb`

### Tipo de evaluación

Evaluación práctica individual.

### Producto evaluado

Programa en Python que combine entrada de datos, variables, operadores, cálculos, condiciones y salida clara.

### Propuesta evaluativa

Crear un programa llamado "Asistente de notas" que:

- Pida el nombre del estudiante.
- Pida tres notas.
- Valide que las notas estén entre 0 y 20.
- Calcule el promedio.
- Indique si aprobó o desaprobó.
- Clasifique el resultado.

---

# Unidad 2: Automatizar y Organizar Programas

## Propósito de la unidad

Que el estudiante automatice tareas con bucles, use acumuladores y contadores, organice datos con arreglos y estructuras simples, reutilice código con funciones e integre lo aprendido en programas más completos.

## Competencias principales

- Usa estructuras repetitivas.
- Aplica acumuladores y contadores.
- Maneja arreglos/listas y estructuras de datos simples.
- Crea funciones con parámetros y retorno.
- Comprende la idea básica de recursividad como extensión.
- Integra bucles, listas y funciones en un programa.

## Producto de unidad

Programas en Python que automaticen procesos y organicen datos:

- Contadores y sumatorias.
- Registro de notas.
- Quiz con puntaje.
- Lista de compras.
- Calculadora modular.
- Menú interactivo.

---

## Sesión 7: `for`, arreglos, acumuladores y contadores

**Cuaderno de trabajo:** `Sesion_07_For_Arreglos_Acumuladores_Contadores.ipynb`

### Objetivo

Usar `for` para repetir instrucciones una cantidad conocida de veces, recorrer arreglos/listas y resolver problemas con contadores y acumuladores.

### Contenidos

- Concepto de repetición.
- Bucle `for`.
- Uso de `range()`.
- Arreglos/listas como conjunto de datos.
- Recorrido de listas con `for`.
- Contadores.
- Acumuladores.
- Sumatorias.
- Conteos con condición.

### Producto esperado

Programas que recorren varios datos, cuentan casos y acumulan resultados.

### Ejercicios propuestos tipo competencia

- Contar del 1 a N.
- Sumar números hasta N.
- Tabla de multiplicar.
- Contar pares entre 1 y N.
- Calcular el promedio de N notas.
- Promedio de una lista de notas.
- Mayor y menor de una lista.

---

## Sesión 8: `while` con listas en ejercicios de aplicación

**Cuaderno de trabajo:** `Sesion_08_While_con_Listas_Aplicacion.ipynb`

### Objetivo

Usar `while` para ingresar datos hasta cumplir una condición y guardarlos en listas.

### Contenidos

- Bucle `while`.
- Condición de parada.
- Variables centinela.
- Validación repetida.
- Listas con `append()`.
- Ingreso de datos hasta escribir una señal de salida.
- Recorrido posterior con `for`.

### Producto esperado

Programa que registra una cantidad variable de datos y luego muestra resultados.

### Ejercicios propuestos tipo competencia

- Ingresar notas hasta escribir `-1`.
- Registrar compras hasta escribir `0`.
- Pedir clave hasta que sea correcta.
- Sumar números hasta escribir `0`.
- Menú simple para registrar y mostrar datos.

---

## Sesión 9: Introducción a estructuras de datos

**Cuaderno de trabajo:** `Sesion_09_Introduccion_Estructuras_Datos.ipynb`

### Objetivo

Organizar datos de forma más clara usando listas, listas de listas y diccionarios simples.

### Contenidos

- Repaso de listas.
- Índices y posiciones.
- Listas de listas para tablas sencillas.
- Diccionarios simples: clave y valor.
- Cuándo usar una lista y cuándo usar un diccionario.
- Recorrido de estructuras con `for`.

### Producto esperado

Programa que organiza información de estudiantes, productos o puntajes usando estructuras simples.

### Ejercicios propuestos tipo competencia

- Agenda simple con nombre y teléfono.
- Registro de estudiante con nombre, grado y nota.
- Tabla de notas por estudiante.
- Conteo de productos por categoría.
- Buscar información por clave.

---

## Sesión 10: Funciones en acción

**Cuaderno de trabajo:** `Sesion_10_Funciones_en_Accion.ipynb`

### Objetivo

Organizar código usando funciones con parámetros y retorno.

### Contenidos

- Funciones con `def`.
- Parámetros.
- Retorno con `return`.
- Reutilización de código.
- Funciones que llaman a otras funciones.
- Recursividad como ampliación guiada.

### Producto esperado

Programa modular dividido en funciones.

### Ejercicios propuestos tipo competencia

- Función para sumar.
- Función para calcular promedio.
- Función para validar nota.
- Función para clasificar promedio.
- Factorial con recursividad guiada como ejercicio de ampliación.

---

## Sesión 11: Integración de bucles, listas y funciones

**Cuaderno de trabajo:** `Sesion_11_Integracion_Bucles_Listas_Funciones.ipynb`

### Objetivo

Integrar estructuras repetitivas, listas y funciones en un programa completo.

### Contenidos

- Menú interactivo.
- Bucles con opciones.
- Listas como almacenamiento temporal.
- Funciones para organizar el programa.
- Pruebas de funcionamiento.

### Producto esperado

Programa con menú interactivo que permita registrar, consultar y procesar datos.

### Ejercicios propuestos tipo competencia

- Registro de notas.
- Lista de compras con total.
- Ranking de puntajes.
- Quiz con funciones.
- Calculadora escolar modular.

---

## Sesión 12: Evaluación de Unidad 2

**Cuaderno de trabajo:** `Sesion_12_Evaluacion_Unidad_2.ipynb`

### Tipo de evaluación

Evaluación práctica individual.

### Producto evaluado

Programa integrador en Python.

### Requisitos mínimos

El programa debe incluir:

- Entrada de datos.
- Condiciones.
- Bucles.
- Listas.
- Funciones.
- Resultados claros.

### Propuesta evaluativa

Crear un programa llamado "Registro de notas" que:

- Permita ingresar varias notas.
- Guarde las notas en una lista.
- Calcule el promedio.
- Muestre la nota mayor y menor.
- Clasifique el promedio.
- Use funciones para organizar el código.

---

## 5. Distribución resumida

```text
Unidad 1: Fundamentos para Pensar y Programar
Sesión 1   Algoritmos, tipos de datos y variables
Sesión 2   Operadores y algoritmos secuenciales
Sesión 3   Decisiones inteligentes simples
Sesión 4   Decisiones inteligentes anidadas y múltiples
Sesión 5   Integración de fundamentos
Sesión 6   Evaluación de Unidad 1

Unidad 2: Automatizar y Organizar Programas
Sesión 7   For, arreglos, acumuladores y contadores
Sesión 8   While con listas en ejercicios de aplicación
Sesión 9   Introducción a estructuras de datos
Sesión 10  Funciones en acción
Sesión 11  Integración de bucles, listas y funciones
Sesión 12  Evaluación de Unidad 2
```

---

## 6. Recursos

- Computadora o laptop.
- Internet para usar Google Colab, si no se trabaja con Jupyter local.
- Cuadernos Jupyter por sesión.
- Python.
- Proyector o pantalla para demostraciones breves.
- Rúbrica de evaluación práctica.
