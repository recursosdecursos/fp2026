$ErrorActionPreference = 'Stop'

$root = 'c:\recursosdecursos\fp2026\docs'
$repoBase = 'https://colab.research.google.com/github/recursosdecursos/fp2026/blob/main/docs'

function Split-Source {
    param([string]$Text)
    if ($null -eq $Text) { return @() }
    $lines = $Text -split "`n"
    return @($lines | ForEach-Object { "$_`n" })
}

function New-MarkdownCell {
    param([string]$Text)
    return [ordered]@{
        cell_type = 'markdown'
        id = ((New-Guid).Guid.Replace('-', '')).Substring(0, 8)
        metadata = @{ language = 'markdown' }
        source = Split-Source $Text
    }
}

function New-CodeCell {
    param([string]$Text)
    return [ordered]@{
        cell_type = 'code'
        id = ((New-Guid).Guid.Replace('-', '')).Substring(0, 8)
        metadata = @{}
        execution_count = $null
        outputs = @()
        source = Split-Source $Text
    }
}

function New-Notebook {
    param([array]$Cells)
    return [ordered]@{
        cells = $Cells
        metadata = [ordered]@{
            kernelspec = [ordered]@{
                display_name = 'Python 3'
                language = 'python'
                name = 'python3'
            }
            language_info = [ordered]@{
                name = 'python'
                version = '3.12'
            }
        }
        nbformat = 4
        nbformat_minor = 5
    }
}

function Write-NotebookFile {
    param(
        [string]$Path,
        [hashtable]$Notebook
    )
    $json = $Notebook | ConvertTo-Json -Depth 50
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $json, $utf8NoBom)
}

function New-ColabCell {
    param([string]$Filename)
    return New-MarkdownCell ('<a href="{0}/{1}" target="_blank" rel="noopener">Abrir en Google Colab</a>' -f $repoBase, $Filename)
}

function New-SessionNotebook {
    param(
        [string]$Filename,
        [string]$Title,
        [string]$Objective,
        [string]$Result,
        [string[]]$Contents,
        [string]$GuidedTitle,
        [string]$GuidedText,
        [string]$GuidedCode,
        [string]$ChallengeTitle,
        [string]$ChallengeText,
        [string]$StarterCode,
        [string[]]$Checklist
    )

    $sessionNumber = [int](([regex]::Match($Filename, 'Sesion_(\d+)_')).Groups[1].Value)
    if ($sessionNumber -le 4) {
        $difficulty = 'Básico'
        $practiceText = 'Resuelve una variante cercana del ejemplo guiado, cambiando los datos de entrada y verificando que la lógica siga siendo correcta.'
        $practiceCode = "# Escribe aquí una variante intermedia del ejemplo guiado`n# Cambia entradas o condiciones y comprueba el resultado"
    }
    elseif ($sessionNumber -le 9) {
        $difficulty = 'Básico - intermedio'
        $practiceText = 'Resuelve un caso con más datos o más validaciones que el ejemplo guiado, manteniendo la misma técnica principal.'
        $practiceCode = "# Resuelve aquí una práctica intermedia`n# Agrega más datos o más validaciones al problema"
    }
    else {
        $difficulty = 'Intermedio'
        $practiceText = 'Integra la técnica principal de la sesión con una estructura de datos o una regla adicional para acercarte a un problema más completo.'
        $practiceCode = "# Resuelve aquí una práctica intermedia`n# Integra la técnica principal con una condición o estructura adicional"
    }

    $contentsMd = ($Contents | ForEach-Object { "- $_" }) -join "`n"
    $checklistMd = ($Checklist | ForEach-Object { "- $_" }) -join "`n"

    $cells = @(
        (New-ColabCell $Filename),
        (New-MarkdownCell "# $Title

## Objetivo
$Objective

## Resultado esperado
$Result

## Dificultad sugerida
$difficulty

## Contenidos
$contentsMd"),
        (New-MarkdownCell "## Ruta de trabajo

1. Comprender el problema.
2. Identificar entradas, proceso y salidas.
3. Diseñar una solución breve antes de programar.
4. Probar con casos normales y casos límite.
5. Corregir y explicar la lógica aplicada."),
        (New-MarkdownCell "## $GuidedTitle

$GuidedText"),
        (New-CodeCell $GuidedCode),
        (New-MarkdownCell "## Práctica intermedia

$practiceText"),
        (New-CodeCell $practiceCode),
        (New-MarkdownCell "## $ChallengeTitle

$ChallengeText"),
        (New-CodeCell $StarterCode),
        (New-MarkdownCell "## Checklist de cierre

$checklistMd")
    )

    return New-Notebook $cells
}

function New-EvaluationNotebook {
    param(
        [string]$Filename,
        [string]$Title,
        [string]$Purpose,
        [string[]]$Criteria,
        [array]$Problems
    )

    $criteriaMd = ($Criteria | ForEach-Object { "- $_" }) -join "`n"
    $cells = @(
        (New-ColabCell $Filename),
        (New-MarkdownCell "# $Title

## Propósito
$Purpose

## Criterios de evaluación
$criteriaMd"),
        (New-MarkdownCell "## Indicaciones

- Lee cada problema completo antes de escribir código.
- Diseña al menos un caso de prueba por problema.
- Mantén nombres de variables claros.
- Verifica el resultado antes de entregar.")
    )

    foreach ($problem in $Problems) {
        $cells += New-MarkdownCell "## $($problem.Title)

$($problem.Statement)

**Entradas esperadas:** $($problem.Inputs)

**Salida esperada:** $($problem.Output)"
        $cells += New-CodeCell $problem.Starter
    }

    $cells += New-MarkdownCell "## Cierre

Antes de entregar, revisa que tu solución funcione con varios casos de prueba y que el código sea legible."

    return New-Notebook $cells
}

Get-ChildItem -Path $root -Filter 'Sesion_*.ipynb' | Remove-Item -Force

$guide = New-Notebook @(
    (New-ColabCell 'Guia_algoritmo_a_codigo.ipynb'),
    (New-MarkdownCell "# Guía de apoyo: de algoritmo a código

## Propósito
Esta guía acompaña el curso de Fundamentos de Programación y resume una ruta práctica para pasar del enunciado al programa."),
    (New-MarkdownCell "## Ruta base de resolución

1. Comprender qué pide el problema.
2. Identificar entradas, proceso y salidas.
3. Elegir la estructura de control o de datos adecuada.
4. Escribir una primera solución simple.
5. Probar con casos normales y casos límite.
6. Mejorar la claridad del código."),
    (New-MarkdownCell "## Tipos de problemas del curso

- Problemas secuenciales y condicionales.
- Problemas iterativos con conteos y acumulación.
- Problemas con listas, cadenas, matrices y diccionarios.
- Problemas estructurados con funciones y menús.
- Problemas con persistencia básica."),
    (New-MarkdownCell "## Escalera de dificultad sugerida

- Básico: aplica una técnica principal con pocas entradas y salidas claras.
- Básico - intermedio: resuelve el mismo tipo de problema, pero con más datos, validaciones o comparaciones.
- Intermedio: integra varias decisiones, estructuras o etapas en una sola solución.

La secuencia de cada cuaderno está organizada como ejemplo guiado, práctica intermedia y desafío de transferencia."),
    (New-MarkdownCell "## Plantilla mínima para resolver un problema

- ¿Qué datos necesito leer?
- ¿Qué operaciones o decisiones debo realizar?
- ¿Qué estructura de datos usaré?
- ¿Qué debe mostrar o guardar el programa?
- ¿Cómo probaré si funciona?"),
    (New-CodeCell "# Plantilla base
# 1. Leer entradas
# 2. Procesar los datos
# 3. Mostrar o guardar resultados"),
    (New-MarkdownCell "## Recomendación final

Empieza con una versión pequeña que funcione. Luego mejora nombres, organiza el código y añade pruebas. En programación inicial, una solución clara y correcta vale más que una solución compleja y confusa.")
)
Write-NotebookFile -Path (Join-Path $root 'Guia_algoritmo_a_codigo.ipynb') -Notebook $guide

$sessionSpecs = @(
    @{ Filename='Sesion_01_Pensamiento_Algoritmico_Variables_Tipos_Datos.ipynb'; Title='Sesión 1: Pensamiento algorítmico, variables y tipos de datos'; Objective='Comprender la lógica de entrada, proceso y salida, y representar información con variables y tipos de datos básicos.'; Result='Programa que capture datos de una persona y los muestre de manera clara y ordenada.'; Contents=@('algoritmos','entrada, proceso y salida','variables','tipos de datos','salida formateada'); GuidedTitle='Ejemplo guiado'; GuidedText='Construiremos un programa que solicite nombre, edad y carrera de un estudiante y luego muestre una ficha resumida.'; GuidedCode="nombre = input('Nombre: ')
edad = int(input('Edad: '))
carrera = input('Carrera: ')

print('--- Ficha del estudiante ---')
print('Nombre:', nombre)
print('Edad:', edad)
print('Carrera:', carrera)
print('¿Es mayor de edad?:', edad >= 18)"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita el nombre de un producto, su precio y la cantidad comprada. Luego muestra un resumen con el costo total.'; StarterCode="producto = input('Producto: ')
precio = float(input('Precio: '))
cantidad = int(input('Cantidad: '))

# Calcula y muestra el resumen de compra"; Checklist=@('Identifiqué las entradas antes de programar.','Usé variables con nombres claros.','Elegí tipos de datos adecuados.','Probé al menos dos entradas diferentes.') },
    @{ Filename='Sesion_02_Operadores_Expresiones_Secuencia.ipynb'; Title='Sesión 2: Operadores, expresiones y secuencia de instrucciones'; Objective='Resolver problemas secuenciales usando operadores aritméticos, relacionales y lógicos.'; Result='Programa secuencial que realice cálculos y muestre resultados correctamente.'; Contents=@('operadores aritméticos','operadores relacionales','operadores lógicos','expresiones','secuencia de instrucciones'); GuidedTitle='Ejemplo guiado'; GuidedText='Calcularemos el promedio de tres notas y determinaremos si el estudiante aprueba con una condición simple.'; GuidedCode="nota1 = float(input('Nota 1: '))
nota2 = float(input('Nota 2: '))
nota3 = float(input('Nota 3: '))

promedio = (nota1 + nota2 + nota3) / 3
print('Promedio:', round(promedio, 2))
print('Aprueba:', promedio >= 11)"; ChallengeTitle='Reto aplicado'; ChallengeText='Pide el sueldo base y el porcentaje de bonificación. Luego calcula el sueldo final y muestra si supera un monto de referencia.'; StarterCode="sueldo_base = float(input('Sueldo base: '))
porcentaje_bono = float(input('Porcentaje de bonificación: '))

# Calcula el sueldo final y muestra una comparación con un umbral"; Checklist=@('Separé claramente el cálculo principal.','Usé operadores adecuados para cada expresión.','Comprobé el resultado con datos simples.','Entiendo por qué la solución no requiere decisiones múltiples.') },
    @{ Filename='Sesion_03_Decisiones_Simples_Compuestas.ipynb'; Title='Sesión 3: Decisiones simples y compuestas'; Objective='Resolver problemas que requieren evaluar condiciones simples y compuestas.'; Result='Programa que tome decisiones correctas según los datos de entrada.'; Contents=@('if','if-else','condiciones compuestas','validación básica','casos de prueba'); GuidedTitle='Ejemplo guiado'; GuidedText='Determinaremos si una persona accede a un descuento según su edad y si cuenta con carné estudiantil.'; GuidedCode="edad = int(input('Edad: '))
tiene_carne = input('¿Tiene carné estudiantil? (si/no): ').strip().lower()

if edad < 18 or tiene_carne == 'si':
    print('Aplica a descuento.')
else:
    print('No aplica a descuento.')"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita una temperatura y determina si el clima se considera frío, templado o cálido usando decisiones simples y compuestas.'; StarterCode="temperatura = float(input('Temperatura: '))

# Evalúa la temperatura y muestra el tipo de clima"; Checklist=@('Escribí condiciones legibles.','Probé al menos un caso verdadero y uno falso.','Usé operadores lógicos cuando era necesario.','La salida explica claramente la decisión tomada.') },
    @{ Filename='Sesion_04_Decisiones_Multiples_Casos_Limite.ipynb'; Title='Sesión 4: Decisiones múltiples, anidadas y casos límite'; Objective='Resolver problemas con varios caminos lógicos y considerar casos límite en la solución.'; Result='Programa que clasifique correctamente situaciones usando decisiones múltiples.'; Contents=@('if-elif-else','decisiones anidadas','clasificación','prioridad de reglas','casos límite'); GuidedTitle='Ejemplo guiado'; GuidedText='Clasificaremos una nota final en niveles de desempeño y controlaremos el caso de entradas fuera de rango.'; GuidedCode="nota = float(input('Nota final: '))

if nota < 0 or nota > 20:
    print('Nota fuera de rango.')
elif nota >= 17:
    print('Desempeño destacado')
elif nota >= 14:
    print('Desempeño esperado')
elif nota >= 11:
    print('En proceso')
else:
    print('Requiere refuerzo')"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita el monto de una compra y clasifica el descuento aplicable según rangos definidos por el docente.'; StarterCode="monto = float(input('Monto de compra: '))

# Clasifica el descuento según rangos y muestra el resultado"; Checklist=@('Ordené correctamente las condiciones.','Consideré datos fuera de rango o extremos.','La clasificación no deja casos sin cubrir.','Probé varios escenarios antes de cerrar.') },
    @{ Filename='Sesion_06_Repeticion_Definida_For.ipynb'; Title='Sesión 6: Repetición definida con for'; Objective='Resolver problemas que requieren repetir una acción un número conocido de veces.'; Result='Programa que use for, contadores y acumuladores para procesar varios datos.'; Contents=@('for','range','contadores','acumuladores','sumatorias'); GuidedTitle='Ejemplo guiado'; GuidedText='Contaremos cuántos estudiantes aprueban dentro de un grupo de cinco registros ingresados por teclado.'; GuidedCode="aprobados = 0
for i in range(5):
    nota = float(input(f'Nota {i + 1}: '))
    if nota >= 11:
        aprobados += 1

print('Total de aprobados:', aprobados)"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita 6 números y muestra la suma total y cuántos son pares.'; StarterCode="suma = 0
pares = 0

for i in range(6):
    numero = int(input(f'Número {i + 1}: '))
    # Completa el procesamiento

print('Suma:', suma)
print('Pares:', pares)"; Checklist=@('Usé un contador cuando necesitaba contar casos.','Usé un acumulador cuando necesitaba sumar valores.','El ciclo repite exactamente el número esperado de veces.','Probé la solución con datos pequeños.') },
    @{ Filename='Sesion_07_Repeticion_Condicionada_While.ipynb'; Title='Sesión 7: Repetición condicionada con while'; Objective='Resolver problemas en los que la repetición depende de una condición de parada.'; Result='Programa que use while, centinelas y validación iterativa de datos.'; Contents=@('while','condición de parada','centinelas','validación iterativa','control de ingreso'); GuidedTitle='Ejemplo guiado'; GuidedText='Registraremos ventas hasta que el usuario ingrese 0 como señal de cierre.'; GuidedCode="total = 0
venta = float(input('Venta (0 para terminar): '))

while venta != 0:
    total += venta
    venta = float(input('Venta (0 para terminar): '))

print('Total vendido:', total)"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita contraseñas hasta que el usuario ingrese una que cumpla longitud mínima y contenga un número.'; StarterCode="contrasena = input('Ingrese contraseña: ')

while True:
    # Valida la contraseña y decide si sales del ciclo
    break"; Checklist=@('Definí claramente la condición de parada.','Evité ciclos infinitos.','Validé los datos dentro del proceso iterativo.','La salida refleja correctamente el estado final del ciclo.') },
    @{ Filename='Sesion_08_Listas_Cadenas_Procesamiento_Colecciones.ipynb'; Title='Sesión 8: Listas, cadenas y procesamiento de colecciones'; Objective='Procesar conjuntos de datos usando listas y cadenas en problemas de recorrido y análisis simple.'; Result='Programa que recorra una colección, cuente elementos y transforme información textual.'; Contents=@('listas','cadenas','recorrido de colecciones','conteos','transformación básica de texto'); GuidedTitle='Ejemplo guiado'; GuidedText='Analizaremos una lista de nombres para contar cuántos empiezan con una vocal.'; GuidedCode="nombres = ['Ana', 'Luis', 'Elena', 'Oscar', 'Marta']
vocales = 'aeiou'
contador = 0

for nombre in nombres:
    if nombre[0].lower() in vocales:
        contador += 1

print('Nombres que empiezan con vocal:', contador)"; ChallengeTitle='Reto aplicado'; ChallengeText='Dada una lista de palabras, muestra cuántas tienen más de 5 letras y construye una nueva lista en mayúsculas.'; StarterCode="palabras = ['programacion', 'datos', 'bucle', 'sistema', 'python']
mayusculas = []
contador = 0

# Recorre la lista y procesa las palabras"; Checklist=@('Recorrí correctamente la colección completa.','Usé condiciones para contar casos específicos.','Transformé texto sin perder la información original.','Probé con palabras de distinto tamaño.') },
    @{ Filename='Sesion_09_Busqueda_Secuencial_Ordenacion_Basica.ipynb'; Title='Sesión 9: Búsqueda secuencial y ordenación básica'; Objective='Resolver problemas de localización y ordenamiento de datos usando técnicas básicas.'; Result='Programa que encuentre elementos y ordene listas con una estrategia elemental.'; Contents=@('búsqueda secuencial','comparación de elementos','ordenación básica','intercambio de valores','análisis del proceso'); GuidedTitle='Ejemplo guiado'; GuidedText='Buscaremos un valor en una lista y luego aplicaremos una ordenación simple por intercambio.'; GuidedCode="datos = [8, 3, 6, 1, 9]
buscado = 6

indice = -1
for i in range(len(datos)):
    if datos[i] == buscado:
        indice = i
        break

print('Índice encontrado:', indice)

for i in range(len(datos)):
    for j in range(i + 1, len(datos)):
        if datos[j] < datos[i]:
            datos[i], datos[j] = datos[j], datos[i]

print('Lista ordenada:', datos)"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita una lista de 5 enteros, encuentra el mayor y luego ordénala de menor a mayor sin usar sort().' ; StarterCode="numeros = []
for i in range(5):
    numeros.append(int(input(f'Número {i + 1}: ')))

# Busca el mayor y ordena la lista sin usar sort()"; Checklist=@('Distinguí entre buscar y ordenar.','Usé ciclos correctamente para comparar elementos.','No utilicé funciones automáticas de ordenación.','Probé con listas ya ordenadas y desordenadas.') },
    @{ Filename='Sesion_10_Matrices_Organizacion_Tabular.ipynb'; Title='Sesión 10: Matrices y organización tabular de información'; Objective='Representar y procesar datos organizados en filas y columnas.'; Result='Programa que recorra una matriz y obtenga resúmenes por filas o columnas.'; Contents=@('matrices','filas','columnas','recorrido bidimensional','consulta y actualización'); GuidedTitle='Ejemplo guiado'; GuidedText='Calcularemos el total de asistencia por estudiante usando una matriz simple de 0 y 1.'; GuidedCode="asistencia = [
    [1, 1, 0],
    [1, 0, 1],
    [1, 1, 1]
]

for fila in range(len(asistencia)):
    total = 0
    for columna in range(len(asistencia[fila])):
        total += asistencia[fila][columna]
    print('Estudiante', fila + 1, ':', total, 'asistencias')"; ChallengeTitle='Reto aplicado'; ChallengeText='Dada una tabla de ventas por día y producto, calcula el total por fila y el total general.'; StarterCode="ventas = [
    [12, 15, 10],
    [8, 11, 9],
    [14, 7, 13]
]

# Calcula totales por fila y total general"; Checklist=@('Identifiqué filas y columnas correctamente.','Usé ciclos anidados cuando fue necesario.','La consulta de posiciones fue clara y precisa.','Probé con matrices pequeñas antes de cerrar.') },
    @{ Filename='Sesion_11_Diccionarios_Consulta_Datos.ipynb'; Title='Sesión 11: Diccionarios, organización clave-valor y consulta de datos'; Objective='Modelar información mediante pares clave-valor para registrar y consultar datos de forma directa.'; Result='Programa que use diccionarios para guardar, consultar y actualizar información.'; Contents=@('diccionarios','claves y valores','registro de datos','consulta','actualización'); GuidedTitle='Ejemplo guiado'; GuidedText='Registraremos notas por estudiante usando un diccionario y consultaremos una clave específica.'; GuidedCode="notas = {
    'Ana': 18,
    'Luis': 14,
    'Marta': 16
}

print('Nota de Luis:', notas['Luis'])
notas['Luis'] = 15
print('Diccionario actualizado:', notas)"; ChallengeTitle='Reto aplicado'; ChallengeText='Construye un diccionario con productos y precios. Luego consulta un producto y actualiza su valor si existe.'; StarterCode="productos = {
    'cuaderno': 5.5,
    'lapiz': 1.2,
    'mochila': 45.0
}

# Consulta y actualiza un producto del diccionario"; Checklist=@('Usé claves adecuadas para identificar cada dato.','Consulté información sin recorrer toda la estructura cuando no era necesario.','Actualicé valores sin perder el resto de los datos.','Probé claves existentes y no existentes.') },
    @{ Filename='Sesion_13_Funciones_Parametros_Retorno_Modularizacion.ipynb'; Title='Sesión 13: Funciones, parámetros, retorno y modularización'; Objective='Dividir un problema en partes reutilizables mediante funciones con parámetros y retorno.'; Result='Programa organizado en funciones claras que resuelvan subproblemas concretos.'; Contents=@('funciones','parámetros','return','modularización','reutilización'); GuidedTitle='Ejemplo guiado'; GuidedText='Crearemos una función para calcular el promedio y otra para decidir el resultado final del estudiante.'; GuidedCode="def calcular_promedio(n1, n2, n3):
    return (n1 + n2 + n3) / 3

def obtener_resultado(promedio):
    if promedio >= 11:
        return 'Aprobado'
    return 'Desaprobado'

promedio = calcular_promedio(15, 12, 14)
print('Promedio:', promedio)
print('Resultado:', obtener_resultado(promedio))"; ChallengeTitle='Reto aplicado'; ChallengeText='Escribe una función que reciba una lista de números y retorne el mayor valor. Luego úsala en un programa principal.'; StarterCode="def mayor_lista(numeros):
    # Retorna el mayor valor de la lista
    pass

datos = [7, 12, 5, 18, 9]
print(mayor_lista(datos))"; Checklist=@('Cada función resuelve una tarea específica.','Usé parámetros para evitar repetir código.','El valor de retorno fue aprovechado en el programa principal.','Probé la función con más de un caso.') },
    @{ Filename='Sesion_14_Integracion_Funciones_Colecciones_Menus.ipynb'; Title='Sesión 14: Integración de funciones, colecciones y menús'; Objective='Construir un programa que integre funciones, estructuras de datos y un menú sencillo de opciones.'; Result='Programa modular con menú, registro y consulta de información en memoria.'; Contents=@('menús','integración de funciones','listas o diccionarios','flujo del programa','organización de opciones'); GuidedTitle='Ejemplo guiado'; GuidedText='Construiremos un menú básico para registrar y mostrar nombres en una lista.'; GuidedCode="def mostrar_menu():
    print('1. Agregar nombre')
    print('2. Mostrar nombres')
    print('3. Salir')

nombres = []
opcion = ''

while opcion != '3':
    mostrar_menu()
    opcion = input('Opción: ')
    if opcion == '1':
        nombres.append(input('Nombre: '))
    elif opcion == '2':
        print(nombres)"; ChallengeTitle='Reto aplicado'; ChallengeText='Crea un menú para registrar productos y consultar su precio usando un diccionario.'; StarterCode="def mostrar_menu():
    print('1. Registrar producto')
    print('2. Consultar producto')
    print('3. Salir')

productos = {}
# Completa el programa con un menú funcional"; Checklist=@('El menú organiza claramente las opciones del programa.','Separé tareas del flujo principal en funciones.','La estructura de datos elegida responde al problema.','El programa puede ejecutarse varias veces sin romperse.') },
    @{ Filename='Sesion_15_Persistencia_Basica_Archivos.ipynb'; Title='Sesión 15: Persistencia básica de información'; Objective='Registrar y recuperar información simple usando archivos de texto.'; Result='Programa que escriba datos en un archivo y luego los lea para mostrarlos o procesarlos.'; Contents=@('persistencia','archivos de texto','escritura','lectura','registro y recuperación'); GuidedTitle='Ejemplo guiado'; GuidedText='Guardaremos nombres en un archivo de texto y luego los recuperaremos para mostrarlos en pantalla.'; GuidedCode="with open('nombres.txt', 'w', encoding='utf-8') as archivo:
    archivo.write('Ana\n')
    archivo.write('Luis\n')

with open('nombres.txt', 'r', encoding='utf-8') as archivo:
    for linea in archivo:
        print(linea.strip())"; ChallengeTitle='Reto aplicado'; ChallengeText='Guarda tres productos con su precio en un archivo y luego léelos para mostrarlos en formato de lista.'; StarterCode="# Registra productos en un archivo de texto
# Luego léelos y muéstralos en pantalla"; Checklist=@('Distinguí claramente escritura y lectura de archivos.','Usé rutas y nombres de archivo consistentes.','Verifiqué que la información guardada pueda recuperarse.','El archivo contiene datos legibles y ordenados.') }
)

foreach ($spec in $sessionSpecs) {
    $nb = New-SessionNotebook -Filename $spec.Filename -Title $spec.Title -Objective $spec.Objective -Result $spec.Result -Contents $spec.Contents -GuidedTitle $spec.GuidedTitle -GuidedText $spec.GuidedText -GuidedCode $spec.GuidedCode -ChallengeTitle $spec.ChallengeTitle -ChallengeText $spec.ChallengeText -StarterCode $spec.StarterCode -Checklist $spec.Checklist
    Write-NotebookFile -Path (Join-Path $root $spec.Filename) -Notebook $nb
}

$eval1 = New-EvaluationNotebook -Filename 'Sesion_05_Evaluacion_1.ipynb' -Title 'Sesión 5: Evaluación 1' -Purpose 'Evaluar la resolución de problemas secuenciales y condicionales con validación básica.' -Criteria @('Identifica correctamente entradas, proceso y salida.','Usa operadores y decisiones de manera coherente.','Presenta salidas claras y comprobables.','Prueba la solución con casos distintos.') -Problems @(
    @{ Title='Problema 1: Control de consumo eléctrico'; Statement='Lee el consumo mensual en kWh y calcula el pago aplicando una tarifa base y un recargo si supera un umbral definido.'; Inputs='consumo mensual y tarifa base'; Output='monto total a pagar y mensaje de observación'; Starter="consumo = float(input('Consumo kWh: '))
tarifa = float(input('Tarifa base: '))

# Desarrolla aquí la solución" },
    @{ Title='Problema 2: Clasificación de postulantes'; Statement='Solicita la edad y el puntaje de un postulante. Clasifica si pasa directo, pasa con observación o no pasa según reglas establecidas.'; Inputs='edad y puntaje'; Output='clasificación final del postulante'; Starter="edad = int(input('Edad: '))
puntaje = float(input('Puntaje: '))

# Desarrolla aquí la solución" }
)
Write-NotebookFile -Path (Join-Path $root 'Sesion_05_Evaluacion_1.ipynb') -Notebook $eval1

$eval2 = New-EvaluationNotebook -Filename 'Sesion_12_Evaluacion_2.ipynb' -Title 'Sesión 12: Evaluación 2' -Purpose 'Evaluar la resolución de problemas iterativos y de procesamiento de datos con listas, matrices y diccionarios.' -Criteria @('Selecciona la estructura de datos adecuada.','Aplica correctamente ciclos y condiciones.','Utiliza búsqueda u ordenación cuando el problema lo requiere.','Comprueba la solución con varios casos.') -Problems @(
    @{ Title='Problema 1: Control de ventas semanales'; Statement='Registra 5 montos de ventas, calcula el total, el promedio y luego ordena los montos de menor a mayor.'; Inputs='cinco montos numéricos'; Output='total, promedio y lista ordenada'; Starter="ventas = []
for i in range(5):
    ventas.append(float(input(f'Venta {i + 1}: ')))

# Desarrolla aquí la solución" },
    @{ Title='Problema 2: Consulta de inventario'; Statement='Usa un diccionario para almacenar productos y cantidades. Consulta un producto y muestra si está disponible o agotado.'; Inputs='nombre de producto'; Output='estado del producto consultado'; Starter="inventario = {'teclado': 4, 'mouse': 0, 'monitor': 3}
producto = input('Producto a consultar: ')

# Desarrolla aquí la solución" }
)
Write-NotebookFile -Path (Join-Path $root 'Sesion_12_Evaluacion_2.ipynb') -Notebook $eval2

$evalFinal = New-EvaluationNotebook -Filename 'Sesion_16_Evaluacion_Final.ipynb' -Title 'Sesión 16: Evaluación final' -Purpose 'Evaluar la resolución integrada de problemas con funciones, estructuras de datos y persistencia básica.' -Criteria @('Descompone el problema en funciones o etapas claras.','Selecciona correctamente estructuras de datos y persistencia básica.','Entrega una solución funcional y legible.','Comprueba el programa con casos representativos.') -Problems @(
    @{ Title='Problema 1: Registro académico básico'; Statement='Construye un programa con menú que permita registrar estudiantes, guardar la información en archivo y consultar los registros almacenados.'; Inputs='opciones de menú, nombre del estudiante y nota'; Output='registro actualizado y consulta de datos almacenados'; Starter="def mostrar_menu():
    print('1. Registrar estudiante')
    print('2. Mostrar registros')
    print('3. Salir')

# Desarrolla aquí la solución completa" },
    @{ Title='Problema 2: Inventario básico persistente'; Statement='Desarrolla una solución que permita registrar productos en memoria, guardarlos en archivo y luego recuperar la información para mostrarla ordenada.'; Inputs='nombre de producto y precio'; Output='listado de productos guardados y recuperados'; Starter="productos = []

# Desarrolla aquí la solución completa" }
)
Write-NotebookFile -Path (Join-Path $root 'Sesion_16_Evaluacion_Final.ipynb') -Notebook $evalFinal

Write-Host ('Notebook files generated: ' + ((Get-ChildItem -Path $root -Filter '*.ipynb').Count))


