param(
    [switch]$SkipGuide
)

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
    $normalizedText = (($Text -split "`n") | ForEach-Object { $_.TrimStart() }) -join "`n"
    return [ordered]@{
        cell_type = 'markdown'
        id = ((New-Guid).Guid.Replace('-', '')).Substring(0, 8)
        metadata = @{ language = 'markdown' }
        source = Split-Source $normalizedText
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

function Get-PlainGuidanceText {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return ''
    }

    return (($Text -replace '^-\s*', '').Trim()).TrimEnd('.')
}

function Join-ResolutionSteps {
    param([string[]]$Steps)

    $normalized = @(
        $Steps | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { Get-PlainGuidanceText $_ }
    )

    return $normalized -join "`n"
}

function Get-ResolutionBlock {
    param(
        [string]$Understanding,
        [string]$Entries,
        [string]$Processes,
        [string]$Outputs,
        [string]$Tests,
        [string]$CodeInstruction = ''
    )

    $resolutionLines = @(
        '#### Resolución guiada aplicada',
        '',
        "1. Comprender: $Understanding",
        "2. Entradas: $Entries"
    )

    $processLines = @($Processes -split "`n")
    if ($processLines.Count -gt 1) {
        $resolutionLines += '3. Procesos:'
        $resolutionLines += ($processLines | ForEach-Object { "- $_" })
    }
    else {
        $resolutionLines += "3. Procesos: $Processes"
    }

    $resolutionLines += "4. Salidas: $Outputs"

    $testLines = @($Tests -split "`n")
    if ($testLines.Count -gt 1) {
        $resolutionLines += '5. Pruebas:'
        $resolutionLines += ($testLines | ForEach-Object { "- $_" })
    }
    else {
        $resolutionLines += "5. Pruebas: $Tests"
    }

    if ([string]::IsNullOrWhiteSpace($CodeInstruction)) {
        $resolutionLines += '6. Código:'
    }
    else {
        $resolutionLines += "6. Código: $CodeInstruction"
    }

    return $resolutionLines
}

function Convert-PracticeGuidanceToResolutionBlock {
    param(
        [string]$Problem,
        [string[]]$Guidance
    )

    $entries = if ($Guidance.Count -ge 2) { Get-PlainGuidanceText $Guidance[1] } else { 'identifica los datos que deben ingresar y su tipo.' }
    $processes = if ($Guidance.Count -ge 3) { Get-PlainGuidanceText $Guidance[2] } else { 'define la operación, condición o estructura principal que resolverá el problema.' }
    $outputs = 'muestra el resultado solicitado por el enunciado con mensajes claros y ordenados.'
    $tests = Join-ResolutionSteps @(
        'caso normal: usa datos habituales para comprobar que el resultado principal sea correcto.'
        'caso límite: prueba el valor exacto donde cambia la regla, condición o cálculo principal.'
        'caso excepcional: revisa qué ocurre con una entrada vacía, inválida o fuera de rango.'
    )

    if ($Guidance.Count -ge 4) {
        $thirdHint = Get-PlainGuidanceText $Guidance[3]

        if ($thirdHint -match 'prueba|caso|verifica|verificar|comprueba') {
            $tests = Join-ResolutionSteps @(
                $thirdHint
                'caso límite: prueba el valor exacto donde cambia la regla, condición o cálculo principal.'
                'caso excepcional: revisa qué ocurre con una entrada vacía, inválida o fuera de rango.'
            )
        }
        elseif ($thirdHint -match 'muestra|salida|resumen|ficha|presenta|mensaje|mensajes') {
            $outputs = $thirdHint
        }
        else {
            $processes = "$processes. $thirdHint"
        }
    }

    $processes = Join-ResolutionSteps @(
        $processes
        'ordena las operaciones o decisiones antes de escribir el código.'
        'prepara el resultado final que mostrarás al usuario.'
    )

    return Get-ResolutionBlock `
        -Understanding ("el programa debe resolver este problema: {0}" -f $Problem.TrimEnd('.')) `
        -Entries $entries `
        -Processes $processes `
        -Outputs $outputs `
        -Tests $tests
}

function Get-MiniLab {
    param(
        [int]$SessionNumber,
        [string]$Objective
    )

    switch ($SessionNumber) {
        1 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Explora variables, tipos básicos y salida en pantalla antes de resolver problemas completos.'
                Code = "nombre = 'Ana'`nedad = 18`npromedio = 16.5`nactivo = True`n`nprint(nombre, edad, promedio, activo)`nprint(type(nombre))`nprint(type(edad))"
            }
        }
        2 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Prueba operadores aritméticos, relacionales y lógicos con valores pequeños para verificar qué resultado produce cada expresión.'
                Code = "a = 12`nb = 5`n`nprint('Suma:', a + b)`nprint('Mayor que:', a > b)`nprint('Ambas condiciones:', a > b and b > 0)"
            }
        }
        3 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Experimenta con decisiones simples y compuestas cambiando los datos de entrada para observar cómo cambia la salida.'
                Code = "edad = 17`ntiene_carne = 'si'`n`nif edad < 18 or tiene_carne == 'si':`n    print('Aplica')`nelse:`n    print('No aplica')"
            }
        }
        4 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Revisa cómo cambia una clasificación cuando el dato cae en distintos rangos, incluyendo valores fuera de rango.'
                Code = "nota = 14`n`nif nota < 0 or nota > 20:`n    print('Fuera de rango')`nelif nota >= 17:`n    print('Destacado')`nelif nota >= 14:`n    print('Esperado')`nelse:`n    print('Otro nivel')"
            }
        }
        6 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Usa un ciclo corto con contador y acumulador para observar qué cambia en cada repetición.'
                Code = "suma = 0`nfor i in range(3):`n    suma += i`n    print('Iteración', i, '-> suma', suma)"
            }
        }
        7 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Explora un ciclo condicionado por una variable de control para reconocer cómo se actualiza hasta detenerse.'
                Code = "numero = 3`nwhile numero > 0:`n    print('Cuenta:', numero)`n    numero -= 1"
            }
        }
        8 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Recorre una lista y una cadena para observar cómo se procesan colecciones elemento por elemento.'
                Code = "palabras = ['sol', 'luna', 'mar']`nfor palabra in palabras:`n    print(palabra.upper(), len(palabra))"
            }
        }
        9 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Prueba una búsqueda sencilla y una comparación entre elementos para anticipar la lógica de ordenación.'
                Code = "datos = [7, 2, 9]`nbuscado = 2`nfor i in range(len(datos)):`n    if datos[i] == buscado:`n        print('Encontrado en', i)"
            }
        }
        10 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Observa cómo acceder a filas y columnas en una tabla pequeña antes de resolver un problema más completo.'
                Code = "matriz = [[1, 2], [3, 4]]`nfor fila in matriz:`n    print('Fila:', fila, 'Suma:', sum(fila))"
            }
        }
        11 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Explora cómo registrar, consultar y actualizar valores en una estructura clave-valor.'
                Code = "producto = {'nombre': 'cuaderno', 'precio': 5.5}`nprint(producto['nombre'])`nproducto['precio'] = 6.0`nprint(producto)"
            }
        }
        13 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Prueba una función pequeña con parámetro y retorno para observar cómo encapsula una tarea.'
                Code = "def doble(valor):`n    return valor * 2`n`nprint(doble(4))"
            }
        }
        14 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Separa una tarea breve en función y flujo principal para reconocer cómo se integra un programa modular.'
                Code = "def mostrar_menu():`n    print('1. Continuar')`n    print('2. Salir')`n`nmostrar_menu()"
            }
        }
        15 {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Escribe y lee una línea en un archivo de texto para observar la idea básica de persistencia.'
                Code = "with open('demo.txt', 'w', encoding='utf-8') as archivo:`n    archivo.write('hola mundo')`n`nwith open('demo.txt', 'r', encoding='utf-8') as archivo:`n    print(archivo.read())"
            }
        }
        default {
            return @{
                Title = 'Mini laboratorio'
                Text = 'Explora una versión mínima de la técnica central de la sesión antes de resolver el problema principal.'
                Code = "# Prueba aquí una versión mínima de la técnica principal de la sesión"
            }
        }
    }
}

function Get-ConceptDefinition {
    param([string]$Concept)

    switch ($Concept.ToLowerInvariant()) {
        'algoritmos' { return 'un algoritmo es una secuencia finita y ordenada de pasos que permite resolver un problema o realizar una tarea. Su valor está en que describe con claridad qué hacer, en qué orden hacerlo y cuándo termina el proceso.' }
        'entrada, proceso y salida' { return 'permite distinguir qué datos ingresan, qué transformación ocurre y qué resultado se obtiene.' }
        'variables' { return 'una variable es un nombre asociado a un espacio de memoria donde se guarda un dato que puede usarse y cambiar durante la ejecución del programa. Sirve para representar información del problema de manera comprensible y manipulable.' }
        'tipos de datos' { return 'los tipos de datos indican la clase de valor que una variable puede almacenar y la forma en que ese valor será tratado por el programa. Gracias a ellos se distingue si un dato representa texto, números o valores lógicos.' }
        'salida formateada' { return 'ayuda a presentar la información de forma legible para que el resultado tenga sentido para el usuario.' }
        'operadores aritméticos' { return 'permiten realizar cálculos como suma, resta, multiplicación, división y residuos.' }
        'operadores relacionales' { return 'comparan valores y producen resultados lógicos como verdadero o falso.' }
        'operadores lógicos' { return 'combinan condiciones para construir decisiones más completas.' }
        'expresiones' { return 'integran datos, operadores y variables para producir un resultado nuevo.' }
        'secuencia de instrucciones' { return 'organiza el programa en un orden de ejecución donde cada paso depende del anterior.' }
        'if' { return 'permite ejecutar una acción solo cuando una condición se cumple.' }
        'if-else' { return 'define dos caminos posibles según el resultado de una condición.' }
        'condiciones compuestas' { return 'usan operadores lógicos para evaluar más de una regla al mismo tiempo.' }
        'validación básica' { return 'sirve para comprobar si los datos ingresados tienen sentido antes de continuar.' }
        'casos de prueba' { return 'permiten verificar si la solución funciona en situaciones normales, límite y excepcionales.' }
        'if-elif-else' { return 'organiza varias alternativas cuando el problema tiene más de dos posibles respuestas.' }
        'decisiones anidadas' { return 'aparecen cuando una decisión depende del resultado de otra decisión previa.' }
        'clasificación' { return 'consiste en ubicar un dato dentro de una categoría según reglas definidas.' }
        'prioridad de reglas' { return 'obliga a ordenar las condiciones para que cada caso caiga en la opción correcta.' }
        'casos límite' { return 'son valores cercanos al cambio de regla y ayudan a descubrir errores lógicos.' }
        'for' { return 'repite una acción un número conocido de veces.' }
        'range' { return 'genera una secuencia de valores útil para controlar repeticiones con for.' }
        'contadores' { return 'registran cuántas veces ocurre una condición o evento.' }
        'acumuladores' { return 'guardan una suma u otro resultado que crece durante el ciclo.' }
        'sumatorias' { return 'expresan la acumulación progresiva de valores dentro de un proceso repetitivo.' }
        'while' { return 'repite acciones mientras una condición siga siendo verdadera.' }
        'condición de parada' { return 'define cuándo debe detenerse el ciclo para evitar repeticiones infinitas.' }
        'centinelas' { return 'son valores especiales usados para indicar el fin de un proceso de ingreso o repetición.' }
        'validación iterativa' { return 'permite revisar datos dentro de un ciclo hasta que cumplan lo solicitado.' }
        'control de ingreso' { return 'ayuda a mantener la calidad de los datos leídos durante la ejecución.' }
        'listas' { return 'almacenan varios valores en una misma estructura y permiten recorrerlos o modificarlos.' }
        'cadenas' { return 'representan texto y pueden analizarse carácter por carácter o como una unidad.' }
        'recorrido de colecciones' { return 'implica visitar cada elemento de una estructura para procesarlo.' }
        'conteos' { return 'permiten medir cuántos elementos cumplen una condición.' }
        'transformación básica de texto' { return 'modifica cadenas para adaptarlas a una necesidad del problema.' }
        'búsqueda secuencial' { return 'revisa los elementos uno por uno hasta encontrar el valor buscado o terminar la lista.' }
        'comparación de elementos' { return 'permite decidir cuál valor es mayor, menor o igual en un conjunto de datos.' }
        'ordenación básica' { return 'reorganiza los datos siguiendo un criterio, por ejemplo de menor a mayor.' }
        'intercambio de valores' { return 'sirve para cambiar posiciones cuando un elemento debe ir antes o después de otro.' }
        'análisis del proceso' { return 'permite entender por qué una técnica encuentra o reordena datos correctamente.' }
        'matrices' { return 'organizan datos en filas y columnas para representar información tabular.' }
        'filas' { return 'una fila es un conjunto horizontal de datos relacionados dentro de una matriz o tabla. Suele representar un registro completo, como un estudiante, un producto o un día.' }
        'columnas' { return 'una columna es un conjunto vertical de datos del mismo tipo o significado dentro de una tabla. Permite analizar una característica común en varios registros.' }
        'recorrido bidimensional' { return 'es el proceso de visitar los elementos de una matriz usando dos niveles de recorrido: uno para las filas y otro para las columnas.' }
        'consulta y actualización' { return 'consiste en acceder a una posición o clave para leer su contenido y, cuando el problema lo exige, modificar el dato almacenado.' }
        'organización tabular' { return 'permite consultar y procesar datos según su posición en una tabla.' }
        'diccionarios' { return 'guardan información en pares clave-valor para acceder a ella de forma directa.' }
        'claves y valores' { return 'una clave identifica un dato y el valor contiene la información asociada. Esta relación permite recuperar información sin buscar posición por posición.' }
        'registro de datos' { return 'es la acción de almacenar información nueva en una estructura, cuidando que cada dato quede asociado a un identificador o posición clara.' }
        'consulta' { return 'es la recuperación de un dato almacenado para mostrarlo, compararlo, actualizarlo o usarlo en un cálculo posterior.' }
        'actualización' { return 'es la modificación controlada de un dato ya registrado sin perder el resto de la información almacenada.' }
        'organización clave-valor' { return 'relaciona un identificador con un dato asociado para simplificar consultas.' }
        'consulta de datos' { return 'consiste en recuperar información específica desde una estructura ya organizada.' }
        'funciones' { return 'agrupan instrucciones con una tarea clara para reutilizar y ordenar la solución.' }
        'parámetros' { return 'permiten que una función reciba datos desde el exterior para trabajar con ellos.' }
        'return' { return 'es la instrucción que entrega al programa principal el resultado producido por una función.' }
        'retorno' { return 'devuelve un resultado desde la función hacia la parte principal del programa.' }
        'modularización' { return 'divide el problema en partes pequeñas para mejorar claridad y mantenimiento.' }
        'reutilización' { return 'consiste en diseñar una solución para usarla más de una vez con distintos datos, evitando repetir código.' }
        'menús' { return 'presentan opciones al usuario y permiten dirigir el flujo del programa hacia diferentes operaciones.' }
        'integración de funciones' { return 'une funciones pequeñas dentro de una solución mayor, donde cada función aporta una parte del proceso.' }
        'listas o diccionarios' { return 'son estructuras de datos básicas que permiten organizar varios valores; la lista conserva orden por posición y el diccionario organiza por clave.' }
        'flujo del programa' { return 'es el orden general en que se ejecutan las instrucciones, se toman decisiones, se llaman funciones y se muestran resultados.' }
        'organización de opciones' { return 'consiste en ordenar las alternativas de un programa para que cada acción sea comprensible y tenga una respuesta definida.' }
        'persistencia' { return 'es la capacidad de conservar datos más allá de la ejecución del programa mediante almacenamiento externo.' }
        'archivos de texto' { return 'son documentos simples que guardan información legible como líneas de caracteres.' }
        'escritura' { return 'es el proceso de enviar datos desde el programa hacia un archivo para conservarlos.' }
        'lectura' { return 'es el proceso de recuperar datos desde un archivo para mostrarlos o procesarlos dentro del programa.' }
        'registro y recuperación' { return 'agrupa las operaciones de guardar datos y volver a leerlos posteriormente de forma coherente.' }
        'persistencia básica' { return 'permite conservar información fuera de la memoria del programa mientras se usa un archivo.' }
        default { return 'es un concepto clave que debe entenderse antes de aplicar la solución práctica.' }
    }
}

function Get-ConceptTaxonomy {
    param([string]$Concept)

    switch ($Concept.ToLowerInvariant()) {
        'algoritmos' { return 'pueden ser secuenciales cuando siguen pasos lineales, condicionales cuando toman decisiones y repetitivos cuando ejecutan acciones varias veces hasta cumplir una condición o un número de repeticiones.' }
        'entrada, proceso y salida' { return 'entrada de datos, transformación de datos y presentación de resultados.' }
        'variables' { return 'según el dato que guardan, suelen trabajar con valores numéricos, textos y valores lógicos. También pueden distinguirse por su función dentro del algoritmo, por ejemplo variables de entrada, de proceso o de salida.' }
        'tipos de datos' { return 'en programación inicial se trabaja sobre todo con enteros, decimales, cadenas de texto y booleanos. Cada tipo define operaciones válidas y una forma distinta de representar la información.' }
        'salida formateada' { return 'salida con texto fijo, salida con etiquetas y salida combinada con variables.' }
        'operadores aritméticos' { return 'suma, resta, multiplicación, división, división entera, potencia y módulo.' }
        'operadores relacionales' { return 'igualdad, diferencia, mayor que, menor que, mayor o igual y menor o igual.' }
        'operadores lógicos' { return 'conjunción, disyunción y negación.' }
        'expresiones' { return 'aritméticas, relacionales y lógicas.' }
        'secuencia de instrucciones' { return 'lectura, cálculo y salida en orden lineal.' }
        'if' { return 'decisión simple con una sola condición y una sola acción principal.' }
        'if-else' { return 'decisión binaria con camino verdadero y camino falso.' }
        'condiciones compuestas' { return 'condiciones unidas por and, or y not.' }
        'validación básica' { return 'validación de rango, formato y consistencia.' }
        'casos de prueba' { return 'casos normales, límite y excepcionales.' }
        'if-elif-else' { return 'decisión múltiple con varias ramas ordenadas por prioridad.' }
        'decisiones anidadas' { return 'una decisión interna dentro de una decisión externa.' }
        'clasificación' { return 'por rangos, categorías o cumplimiento de reglas.' }
        'prioridad de reglas' { return 'reglas más restrictivas primero y reglas generales después.' }
        'casos límite' { return 'valores mínimos, máximos y de frontera entre categorías.' }
        'for' { return 'recorrido por contador, por rango y por colección.' }
        'range' { return 'inicio-fin, inicio-fin-paso y rango simple desde cero.' }
        'contadores' { return 'conteo simple, conteo por condición y conteo acumulado por iteración.' }
        'acumuladores' { return 'sumatorias, productos y agregaciones progresivas.' }
        'sumatorias' { return 'sumatoria total, parcial y condicionada.' }
        'while' { return 'ciclo por condición, ciclo con centinela y ciclo de validación.' }
        'condición de parada' { return 'parada por valor objetivo, por centinela o por validación satisfactoria.' }
        'centinelas' { return 'valores de cierre como 0, fin, salir u otra marca especial.' }
        'validación iterativa' { return 'repetición hasta que el dato cumpla una regla.' }
        'control de ingreso' { return 'lectura controlada, repetición de ingreso y verificación de regla.' }
        'listas' { return 'listas de números, textos o estructuras compuestas.' }
        'cadenas' { return 'texto completo, caracteres individuales y fragmentos.' }
        'recorrido de colecciones' { return 'recorrido total, búsqueda parcial y filtrado por condición.' }
        'conteos' { return 'conteo general y conteo condicionado.' }
        'transformación básica de texto' { return 'conversión de mayúsculas, minúsculas, limpieza y concatenación.' }
        'búsqueda secuencial' { return 'búsqueda con éxito, búsqueda sin éxito y búsqueda con corte anticipado.' }
        'comparación de elementos' { return 'comparación par a par y comparación contra un valor de referencia.' }
        'ordenación básica' { return 'orden ascendente y descendente mediante comparaciones sucesivas.' }
        'intercambio de valores' { return 'intercambio simple entre dos posiciones durante una ordenación.' }
        'análisis del proceso' { return 'seguimiento paso a paso, comparación de estados y verificación del resultado.' }
        'matrices' { return 'filas, columnas y posiciones por índice.' }
        'filas' { return 'filas de datos numéricos, textuales o mixtos, cada una asociada a un registro.' }
        'columnas' { return 'columnas de atributos, columnas de totales y columnas de consulta.' }
        'recorrido bidimensional' { return 'recorrido por filas, recorrido por columnas y recorrido por celda.' }
        'consulta y actualización' { return 'consulta por posición, actualización de celda y verificación de límites.' }
        'organización tabular' { return 'datos por fila, por columna y por celda.' }
        'diccionarios' { return 'claves únicas con valores asociados.' }
        'claves y valores' { return 'claves textuales, numéricas o códigos; valores simples o compuestos.' }
        'registro de datos' { return 'registro nuevo, reemplazo de registro y registro validado.' }
        'consulta' { return 'consulta directa, consulta condicionada y consulta no encontrada.' }
        'actualización' { return 'actualización de valor, incremento de cantidad y reemplazo de información.' }
        'organización clave-valor' { return 'registro por identificador y consulta directa por clave.' }
        'consulta de datos' { return 'consulta existente, consulta no encontrada y actualización de datos.' }
        'funciones' { return 'funciones sin retorno, con retorno y con parámetros.' }
        'parámetros' { return 'parámetros de entrada simples o múltiples.' }
        'return' { return 'retorno de un valor calculado, retorno de texto y retorno lógico.' }
        'retorno' { return 'retorno único y retorno calculado a partir de parámetros.' }
        'modularización' { return 'división en funciones pequeñas con responsabilidades claras.' }
        'reutilización' { return 'uso repetido de una función con distintos argumentos.' }
        'menús' { return 'menú de registro, consulta, actualización y salida.' }
        'integración de funciones' { return 'funciones de entrada, proceso, salida y control.' }
        'listas o diccionarios' { return 'listas para datos ordenados y diccionarios para datos identificados por clave.' }
        'flujo del programa' { return 'inicio, repetición de menú, ejecución de opción y cierre.' }
        'organización de opciones' { return 'opciones numeradas, validación de opción y operación asociada.' }
        'persistencia' { return 'persistencia en archivos de texto y recuperación en memoria.' }
        'archivos de texto' { return 'archivos línea por línea, registros separados por comas y texto plano.' }
        'escritura' { return 'escritura nueva y escritura agregada al final.' }
        'lectura' { return 'lectura completa, lectura línea por línea y separación de campos.' }
        'registro y recuperación' { return 'guardar registros, leer registros y reconstruir datos.' }
        'persistencia básica' { return 'escritura, lectura y recuperación simple desde archivos.' }
        default { return 'categorías básicas, variantes de uso y casos comunes en la sesión.' }
    }
}

function Get-ConceptExample {
    param([string]$Concept)

    switch ($Concept.ToLowerInvariant()) {
        'algoritmos' { return 'un algoritmo para calcular el área de un rectángulo puede seguir estos pasos: leer base, leer altura, multiplicar ambos valores y mostrar el resultado.' }
        'entrada, proceso y salida' { return 'leer edad, evaluar si es mayor de edad y mostrar el mensaje final.' }
        'variables' { return 'nombre = "Ana", edad = 18 y promedio = 16.5 muestran cómo una variable puede representar distintos datos del mismo problema.' }
        'tipos de datos' { return 'en Python, "Lima" es una cadena, 25 es un entero, 16.5 es un decimal y True es un booleano.' }
        'salida formateada' { return 'print("Nombre:", nombre).' }
        'operadores aritméticos' { return 'promedio = (n1 + n2 + n3) / 3.' }
        'operadores relacionales' { return 'promedio >= 11.' }
        'operadores lógicos' { return 'edad < 18 or tiene_carne == "si".' }
        'expresiones' { return 'total = precio * cantidad.' }
        'secuencia de instrucciones' { return 'leer datos, calcular y luego mostrar.' }
        'if' { return 'if nota >= 11: print("Aprueba").' }
        'if-else' { return 'if edad >= 18: print("Mayor") else: print("Menor").' }
        'condiciones compuestas' { return 'if edad >= 18 and promedio >= 14: print("Beca").' }
        'validación básica' { return 'if nota < 0 or nota > 20: print("Fuera de rango").' }
        'casos de prueba' { return 'probar con 10.9, 11 y 20 para observar cambios de resultado.' }
        'if-elif-else' { return 'clasificar una nota en destacado, esperado o refuerzo.' }
        'decisiones anidadas' { return 'primero validar rango y luego clasificar el valor.' }
        'clasificación' { return 'ubicar una temperatura en frío, templado o cálido.' }
        'prioridad de reglas' { return 'evaluar primero monto >= 500 y luego monto >= 200.' }
        'casos límite' { return 'probar exactamente 18 años o una nota igual a 14.' }
        'for' { return 'for i in range(5): leer una nota.' }
        'range' { return 'range(1, 6) genera cinco valores consecutivos.' }
        'contadores' { return 'aprobados += 1 cuando la nota cumple la condición.' }
        'acumuladores' { return 'suma += numero en cada repetición.' }
        'sumatorias' { return 'sumar seis números ingresados por el usuario.' }
        'while' { return 'while venta != 0: total += venta.' }
        'condición de parada' { return 'terminar cuando el usuario ingresa 0.' }
        'centinelas' { return 'usar 0 como marca de cierre del ingreso.' }
        'validación iterativa' { return 'repetir el ingreso de contraseña hasta que cumpla la regla.' }
        'control de ingreso' { return 'seguir pidiendo dato mientras sea inválido.' }
        'listas' { return 'nombres = ["Ana", "Luis", "Elena"].' }
        'cadenas' { return 'palabra.upper() convierte el texto a mayúsculas.' }
        'recorrido de colecciones' { return 'for palabra in palabras: procesar cada elemento.' }
        'conteos' { return 'contar cuántas palabras tienen más de cinco letras.' }
        'transformación básica de texto' { return 'crear una nueva lista con cada palabra en mayúsculas.' }
        'búsqueda secuencial' { return 'recorrer la lista hasta encontrar el valor buscado.' }
        'comparación de elementos' { return 'comparar datos[j] < datos[i] antes de intercambiar.' }
        'ordenación básica' { return 'reordenar una lista de menor a mayor con ciclos.' }
        'intercambio de valores' { return 'datos[i], datos[j] = datos[j], datos[i].' }
        'análisis del proceso' { return 'seguir el estado de la lista después de cada intercambio.' }
        'matrices' { return 'matriz[1][0] accede a la fila 2, columna 1.' }
        'filas' { return 'sumar todos los valores de una fila para obtener el total de un estudiante.' }
        'columnas' { return 'sumar una columna para conocer el total de ventas de un producto.' }
        'recorrido bidimensional' { return 'usar un ciclo para filas y otro para columnas al procesar una tabla.' }
        'consulta y actualización' { return 'matriz[0][1] = 15 modifica el dato de la primera fila y segunda columna.' }
        'organización tabular' { return 'sumar cada fila de una tabla de ventas.' }
        'diccionarios' { return 'producto = {"nombre": "cuaderno", "precio": 5.5}.' }
        'claves y valores' { return 'productos["cuaderno"] = 5.5 asocia una clave con su precio.' }
        'registro de datos' { return 'guardar productos[nombre] = precio después de leer ambos datos.' }
        'consulta' { return 'if nombre in productos: print(productos[nombre]).' }
        'actualización' { return 'productos["lapiz"] = 1.5 cambia el precio registrado.' }
        'organización clave-valor' { return 'consultar producto["precio"] usando la clave.' }
        'consulta de datos' { return 'mostrar el precio si la clave existe o avisar si no existe.' }
        'funciones' { return 'def doble(x): return x * 2.' }
        'parámetros' { return 'def saludar(nombre): print(nombre).' }
        'return' { return 'def sumar(a, b): return a + b.' }
        'retorno' { return 'return suma dentro de una función.' }
        'modularización' { return 'crear una función para registrar y otra para consultar.' }
        'reutilización' { return 'usar calcular_promedio() para varios estudiantes sin repetir la fórmula.' }
        'menús' { return 'mostrar 1. Registrar, 2. Consultar y 3. Salir.' }
        'integración de funciones' { return 'mostrar_menu(), registrar() y consultar() trabajan juntas en el programa principal.' }
        'listas o diccionarios' { return 'usar una lista para nombres y un diccionario para productos con precio.' }
        'flujo del programa' { return 'leer opción, ejecutar la acción elegida y volver al menú hasta salir.' }
        'organización de opciones' { return 'if opcion == "1": registrar; elif opcion == "2": consultar.' }
        'persistencia' { return 'guardar notas en un archivo para revisarlas después de cerrar el programa.' }
        'archivos de texto' { return 'productos.txt puede contener una línea por producto.' }
        'escritura' { return 'archivo.write("Ana,18\n") guarda un registro.' }
        'lectura' { return 'for linea in archivo: print(linea.strip()).' }
        'registro y recuperación' { return 'guardar "cuaderno,5.5" y luego separar la línea con split(",").' }
        'persistencia básica' { return 'guardar productos en un archivo y luego leerlos.' }
        default { return 'usar el concepto dentro de un ejercicio corto de la sesión.' }
    }
}

function Get-ConceptUseRule {
    param([string]$Concept)

    switch ($Concept.ToLowerInvariant()) {
        'algoritmos' { return 'Antes de programar conviene escribir la solución como pasos claros: identificar entradas, ordenar el proceso, prever decisiones o repeticiones y definir la salida esperada.' }
        'entrada, proceso y salida' { return 'Todo problema inicial debe analizarse con la pregunta clásica: qué datos ingresan, qué se hace con ellos y qué resultado debe entregarse al usuario.' }
        'variables' { return 'El nombre de una variable debe representar su propósito dentro del problema. Debe evitarse usar nombres ambiguos, espacios, símbolos especiales o identificadores que empiecen con números.' }
        'tipos de datos' { return 'El tipo se elige según la naturaleza del dato y las operaciones necesarias: números para calcular, cadenas para texto y booleanos para decisiones.' }
        'salida formateada' { return 'Una salida correcta no solo muestra valores; también incluye etiquetas, orden y formato para que el usuario entienda el resultado sin revisar el código.' }
        'operadores aritméticos' { return 'Se usan cuando el proceso requiere transformar datos numéricos. Es importante cuidar la precedencia y usar paréntesis cuando la expresión pueda ser ambigua.' }
        'operadores relacionales' { return 'Se emplean para formular preguntas sobre los datos. El resultado de una comparación alimenta decisiones, validaciones y filtros.' }
        'operadores lógicos' { return 'Permiten unir condiciones simples. Deben usarse con cuidado porque cambian el significado de la decisión: and exige que todo se cumpla, or acepta alternativas y not invierte la condición.' }
        'expresiones' { return 'Una expresión debe ser legible y verificable. Si combina varios cálculos, puede dividirse en variables intermedias para mejorar claridad.' }
        'secuencia de instrucciones' { return 'En una estructura secuencial, el orden importa: primero se leen o definen datos, luego se calculan resultados y finalmente se muestran las salidas.' }
        'if' { return 'Se usa cuando una acción depende de una condición. Si la condición es falsa y no existe otra rama, el programa continúa con la siguiente instrucción.' }
        'if-else' { return 'Se usa cuando el problema exige escoger entre dos caminos excluyentes. Cada camino debe producir un resultado coherente para el usuario.' }
        'condiciones compuestas' { return 'Conviene construirlas a partir de condiciones simples ya entendidas. Si una condición se vuelve extensa, debe separarse en variables lógicas con nombres claros.' }
        'validación básica' { return 'La validación protege al algoritmo de datos imposibles o incoherentes antes de realizar cálculos, clasificaciones o salidas finales.' }
        'casos de prueba' { return 'Una solución debe probarse con datos normales, valores de frontera y entradas inválidas o poco frecuentes.' }
        'if-elif-else' { return 'Se usa cuando hay varias categorías posibles. El orden de las condiciones debe ir de lo más específico a lo más general.' }
        'decisiones anidadas' { return 'Son útiles cuando una pregunta depende de otra, pero deben mantenerse simples para no dificultar la lectura del algoritmo.' }
        'clasificación' { return 'Clasificar exige definir rangos o reglas sin contradicciones, sin vacíos y con límites claramente tratados.' }
        'prioridad de reglas' { return 'Cuando varias reglas podrían cumplirse, debe decidirse cuál tiene preferencia y ubicarla primero en el algoritmo.' }
        'casos límite' { return 'Sirven para comprobar si los operadores relacionales elegidos incluyen o excluyen correctamente los extremos de cada rango.' }
        'for' { return 'Se usa cuando se conoce de antemano cuántas veces se repetirá una acción o cuando se recorrerá una colección completa.' }
        'range' { return 'Ayuda a controlar repeticiones mediante una secuencia numérica. Debe revisarse siempre el inicio, el fin no incluido y el paso.' }
        'contadores' { return 'Un contador se inicializa antes del ciclo y aumenta cuando ocurre el evento que se desea contar.' }
        'acumuladores' { return 'Un acumulador se inicializa con un valor neutro y se actualiza en cada repetición con el dato procesado.' }
        'sumatorias' { return 'Una sumatoria requiere definir qué valores participan, cuándo se suman y qué variable conservará el total.' }
        'while' { return 'Se usa cuando la repetición depende de una condición que puede cambiar durante la ejecución. Siempre debe existir una actualización que acerque el ciclo a su fin.' }
        'condición de parada' { return 'Debe ser clara, alcanzable y comprobable. Una condición mal definida puede provocar ciclos infinitos o terminar antes de tiempo.' }
        'centinelas' { return 'El centinela debe ser un valor fácil de reconocer y que no se confunda con datos válidos del problema.' }
        'validación iterativa' { return 'Se aplica cuando el programa debe insistir hasta recibir un dato aceptable, evitando continuar con información incorrecta.' }
        'control de ingreso' { return 'Ordena la lectura de datos para que el programa trabaje con valores consistentes durante todo el proceso.' }
        'listas' { return 'Se usan cuando varios datos del mismo problema deben almacenarse juntos, conservar su orden o procesarse mediante recorridos.' }
        'cadenas' { return 'Se tratan como datos textuales y también como colecciones de caracteres, por eso permiten búsqueda, conteo, transformación y validación.' }
        'recorrido de colecciones' { return 'Debe quedar claro qué se hace con cada elemento: mostrarlo, contarlo, transformarlo, compararlo o seleccionarlo.' }
        'conteos' { return 'Requieren una regla de conteo precisa y una variable que aumente solo cuando el elemento cumple la condición.' }
        'transformación básica de texto' { return 'Antes de comparar texto conviene normalizarlo, por ejemplo usando minúsculas, mayúsculas o eliminación de espacios innecesarios.' }
        'búsqueda secuencial' { return 'Es adecuada para colecciones pequeñas o no ordenadas. El algoritmo debe indicar qué ocurre si el dato se encuentra y qué ocurre si no aparece.' }
        'comparación de elementos' { return 'Comparar elementos permite encontrar mayores, menores, coincidencias o posiciones que deben cambiarse.' }
        'ordenación básica' { return 'Se aplica para reorganizar datos según un criterio. En programación inicial interesa comprender el proceso más que usar funciones automáticas.' }
        'intercambio de valores' { return 'El intercambio debe conservar ambos datos; por eso se realiza con una variable auxiliar o con asignación múltiple cuando el lenguaje lo permite.' }
        'análisis del proceso' { return 'Consiste en seguir los cambios del algoritmo paso a paso para explicar por qué llega al resultado correcto.' }
        'matrices' { return 'Se usan cuando la información tiene dos dimensiones naturales, como filas y columnas, estudiantes y notas, días y productos.' }
        'filas' { return 'Una fila agrupa datos de un mismo registro o unidad de análisis; recorrer filas permite obtener resúmenes por registro.' }
        'columnas' { return 'Una columna agrupa el mismo atributo en varios registros; recorrer columnas permite comparar o totalizar una característica común.' }
        'recorrido bidimensional' { return 'Requiere normalmente dos ciclos: uno para filas y otro para columnas. El orden del recorrido debe coincidir con el análisis solicitado.' }
        'consulta y actualización' { return 'Consultar recupera un valor existente y actualizar modifica una posición específica sin alterar el resto de la estructura.' }
        'organización tabular' { return 'Antes de calcular, debe definirse qué representa cada fila, cada columna y cada celda.' }
        'diccionarios' { return 'Se usan cuando cada dato puede identificarse mediante una clave única, como código, nombre o identificador.' }
        'claves y valores' { return 'La clave identifica y el valor contiene la información asociada. La clave debe ser estable para que la consulta sea confiable.' }
        'registro de datos' { return 'Registrar datos implica decidir qué clave se usará, qué valor se guardará y cómo se tratarán claves repetidas.' }
        'consulta' { return 'Antes de consultar una clave conviene verificar si existe para evitar errores y ofrecer una respuesta clara.' }
        'actualización' { return 'Actualizar significa cambiar un valor asociado a una clave ya existente o crear una nueva entrada cuando el problema lo permite.' }
        'organización clave-valor' { return 'Es útil cuando interesa acceder directamente a un dato sin recorrer toda la colección.' }
        'consulta de datos' { return 'Debe contemplar dos escenarios: dato encontrado y dato no encontrado.' }
        'funciones' { return 'Se usan para dividir un problema en subproblemas. Una buena función tiene nombre claro, responsabilidad única y entradas definidas.' }
        'parámetros' { return 'Permiten que la función trabaje con datos variables sin depender de valores escritos directamente dentro de ella.' }
        'return' { return 'Devuelve el resultado calculado por una función para que pueda usarse en otra parte del programa.' }
        'retorno' { return 'Debe usarse cuando la función produce un valor que será almacenado, mostrado, comparado o enviado a otra función.' }
        'modularización' { return 'Ayuda a construir programas más claros: cada módulo resuelve una parte y el programa principal coordina el flujo general.' }
        'reutilización' { return 'Una solución reutilizable evita repetir instrucciones y permite aplicar la misma función con datos diferentes.' }
        'menús' { return 'Un menú organiza las opciones disponibles y normalmente se combina con un ciclo para permitir varias operaciones en una misma ejecución.' }
        'integración de funciones' { return 'Integrar funciones exige definir qué función resuelve cada tarea y cómo se comunican mediante parámetros y retornos.' }
        'listas o diccionarios' { return 'La estructura se elige según la forma de acceso: listas para recorridos ordenados y diccionarios para consultas directas por clave.' }
        'flujo del programa' { return 'El flujo principal debe coordinar lectura, decisión, llamada a funciones, actualización de datos y salida.' }
        'organización de opciones' { return 'Las opciones deben ser claras, mutuamente distinguibles y tener una respuesta prevista cuando el usuario ingresa una alternativa inválida.' }
        'persistencia básica' { return 'Se aplica cuando los datos deben conservarse después de terminar el programa. El archivo actúa como almacenamiento externo simple.' }
        'persistencia' { return 'Permite separar la memoria temporal del programa de la información que necesita guardarse para usos posteriores.' }
        'archivos de texto' { return 'Son adecuados para guardar datos simples y legibles. Cada línea puede representar un registro.' }
        'escritura' { return 'La escritura crea o actualiza el contenido de un archivo. Debe cuidarse si se reemplaza todo el archivo o se agrega información al final.' }
        'lectura' { return 'La lectura recupera datos desde un archivo y suele requerir limpieza o separación de campos antes de procesarlos.' }
        'registro y recuperación' { return 'Registrar y recuperar exige mantener un formato consistente para que lo guardado pueda interpretarse correctamente después.' }
        default { return 'Debe relacionarse con el esquema general de solución: problema, datos de entrada, proceso, salida y prueba.' }
    }
}

function Convert-InitialToUpper {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return $Text
    }

    return $Text.Substring(0, 1).ToUpperInvariant() + $Text.Substring(1)
}

function Get-SessionOneTheoryMarkdown {
    return @(
        '## Base conceptual de la sesión',
        '',
        'La programación inicia con la capacidad de resolver problemas de manera ordenada. Antes de escribir código, se debe comprender el problema, identificar los datos necesarios, diseñar un algoritmo y representar la solución de una forma clara.',
        '',
        '### 1. Algoritmos',
        '#### Concepto',
        'Un algoritmo es un conjunto ordenado, lógico y finito de pasos que permite resolver un problema o realizar una tarea específica.',
        '',
        '#### Características',
        '- **Preciso:** cada instrucción debe ser clara y específica.',
        '- **Definido:** con los mismos datos de entrada produce el mismo resultado.',
        '- **Finito:** debe terminar después de ejecutar una cantidad limitada de pasos.',
        '- **Ordenado:** sigue una secuencia lógica.',
        '- **Eficiente:** busca resolver el problema correctamente usando los recursos necesarios.',
        '',
        '#### Ejemplo de aplicación',
        'Para calcular el promedio de tres notas: leer las tres notas, sumarlas, dividir el resultado entre tres y mostrar el promedio.',
        '',
        '### 2. Estructura básica de un algoritmo',
        '#### Concepto',
        'La estructura básica de un algoritmo organiza la solución en tres partes: entrada, proceso y salida. Esta estructura ayuda a comprender qué datos se necesitan, qué operaciones se realizarán y qué resultado debe obtenerse.',
        '',
        '#### Elementos',
        '- **Entrada:** datos que recibe el algoritmo.',
        '- **Proceso:** operaciones, cálculos, decisiones o transformaciones realizadas con los datos.',
        '- **Salida:** resultado obtenido después del procesamiento.',
        '',
        '#### Ejemplo de aplicación',
        'En el cálculo de un promedio, las entradas son las notas, el proceso es la suma y división, y la salida es el promedio final.',
        '',
        '### 3. Representación de algoritmos',
        '#### Concepto',
        'Representar un algoritmo permite expresar la solución antes de programarla. Esto reduce errores porque obliga a ordenar las ideas y revisar la lógica.',
        '',
        '#### Formas principales',
        '- **Lenguaje natural:** describe los pasos usando palabras comunes.',
        '- **Pseudocódigo:** usa una escritura cercana a un lenguaje de programación, pero sin depender de una sintaxis específica.',
        '- **Diagrama de flujo:** representa gráficamente los pasos mediante símbolos.',
        '',
        '#### Ejemplo en lenguaje natural',
        '1. Leer dos números.',
        '2. Sumar los números.',
        '3. Mostrar el resultado.',
        '',
        '#### Ejemplo en pseudocódigo',
        '```text',
        'Inicio',
        '   Leer numero1',
        '   Leer numero2',
        '   suma <- numero1 + numero2',
        '   Escribir suma',
        'Fin',
        '```',
        '',
        '#### Ejemplo correcto de diagrama de flujo',
        '**Representación gráfica**',
        '',
        '```mermaid',
        'flowchart TD',
        '    inicio([Inicio])',
        '    entrada[/Leer datos/]',
        '    proceso[Procesar datos]',
        '    decision{¿Cumple condición?}',
        '    salida_si[/Mostrar resultado válido/]',
        '    salida_no[/Mostrar mensaje de error/]',
        '    fin([Fin])',
        '    inicio --> entrada --> proceso --> decision',
        '    decision -->|Sí| salida_si --> fin',
        '    decision -->|No| salida_no --> fin',
        '```',
        '',
        '<br>',
        '',
        '**Representación en texto**',
        '',
        '```text',
        'Inicio',
        '  |',
        'Leer datos',
        '  |',
        'Procesar datos',
        '  |',
        '¿Cumple condición?',
        '  |-- Sí --> Mostrar resultado válido --> Fin',
        '  |-- No --> Mostrar mensaje de error --> Fin',
        '```',
        '',
        'En un flujo real, el rombo representa una decisión y debe mostrar sus caminos posibles, normalmente `Sí` y `No`.',
        '',
        '### 4. Datos y tipos de datos',
        '#### Concepto',
        'Un dato es una representación de información que puede ser almacenada y procesada por una computadora. El tipo de dato indica qué clase de valor se guarda y qué operaciones pueden realizarse con él.',
        '',
        '#### Datos simples',
        '- **Entero:** número sin decimales. Ejemplos: `5`, `-10`, `200`.',
        '- **Real:** número con decimales. Ejemplos: `3.14`, `25.8`, `-7.5`.',
        '- **Carácter:** un solo símbolo o letra. Ejemplos: `"A"`, `"7"`, `"#"`.',
        '- **Cadena:** conjunto de caracteres. Ejemplos: `"Carlos"`, `"Lima"`.',
        '- **Lógico o booleano:** valor de verdad. Ejemplos: `Verdadero`, `Falso`.',
        '',
        '#### Datos estructurados',
        'Permiten almacenar varios datos relacionados. Algunos ejemplos son arreglos, matrices, registros, listas y diccionarios.',
        '',
        '#### Criterio de uso',
        'El tipo de dato debe elegirse según la naturaleza de la información: números para calcular, cadenas para texto y valores lógicos para representar condiciones.',
        '',
        '### 5. Variables',
        '#### Concepto',
        'Una variable es un espacio de memoria identificado por un nombre, donde se almacena un dato cuyo valor puede cambiar durante la ejecución del programa.',
        '',
        '#### Componentes',
        '| Elemento | Descripción |',
        '|---|---|',
        '| Nombre | Identificador de la variable |',
        '| Tipo | Clase de dato almacenado |',
        '| Valor | Información guardada |',
        '',
        '#### Reglas para nombrar variables',
        'Son adecuados nombres como `edad`, `promedio`, `total_ventas` y `nota_final`, porque describen el dato almacenado. No son adecuados `1edad`, `total ventas` o `@numero`, porque incumplen reglas de identificación.',
        '',
        '#### Declaración y asignación',
        'En pseudocódigo se puede declarar una variable indicando su nombre y tipo:',
        '',
        '```text',
        'Definir edad Como Entero',
        'Definir sueldo Como Real',
        'Definir nombre Como Cadena',
        '```',
        '',
        'Asignar un valor significa almacenar información en la variable:',
        '',
        '```text',
        'edad <- 20',
        'sueldo <- 1500.50',
        'nombre <- "Carlos"',
        '```',
        '',
        '### 6. Constantes',
        '#### Concepto',
        'Una constante es un valor que no cambia durante la ejecución del programa. Se usa cuando un dato debe permanecer fijo en todo el algoritmo.',
        '',
        '#### Ejemplo de aplicación',
        '```text',
        'PI <- 3.1416',
        '```',
        '',
        '### Relación entre algoritmo, datos y variables',
        '```text',
        'Problema',
        '   |',
        'Algoritmo',
        '   |',
        'Variables + Datos',
        '   |',
        'Procesamiento',
        '   |',
        'Resultado',
        '```',
        '',
        '### Ejemplo completo',
        '#### Problema',
        'Calcular el promedio de tres notas.',
        '',
        '#### Pseudocódigo',
        '```text',
        'Inicio',
        '   Definir n1, n2, n3, promedio Como Real',
        '',
        '   Leer n1',
        '   Leer n2',
        '   Leer n3',
        '',
        '   promedio <- (n1 + n2 + n3) / 3',
        '',
        '   Escribir promedio',
        'Fin',
        '```'
    ) -join "`n"
}

function Get-SessionTheoryMarkdown {
    param(
        [string]$Objective,
        [string[]]$Contents
    )

    $theoryLines = @(
        '## Base conceptual de la sesión'
    )

    for ($i = 0; $i -lt $Contents.Count; $i++) {
        $concept = $Contents[$i]
        $theoryLines += @(
            '',
            ('### {0}. {1}' -f ($i + 1), (Get-Culture).TextInfo.ToTitleCase($concept)),
            ('#### Concepto'),
            (Convert-InitialToUpper (Get-ConceptDefinition -Concept $concept)),
            '',
            ('#### Elementos o clasificación'),
            (Convert-InitialToUpper (Get-ConceptTaxonomy -Concept $concept)),
            '',
            ('#### Criterio de uso'),
            (Get-ConceptUseRule -Concept $concept),
            '',
            ('#### Ejemplo de aplicación'),
            (Convert-InitialToUpper (Get-ConceptExample -Concept $concept))
        )
    }

    $theoryLines += @(
        '',
        '### Síntesis de la sesión',
        'Para resolver ejercicios, no basta con escribir instrucciones en Python. Es necesario reconocer los datos, nombrarlos correctamente, elegir operaciones o estructuras de control apropiadas y comprobar el resultado con casos de prueba.',
        '',
        '| Aspecto | Pregunta guía |',
        '|---|---|',
        '| Entrada | ¿Qué datos necesita recibir el programa? |',
        '| Proceso | ¿Qué cálculos, decisiones o repeticiones transforman los datos? |',
        '| Salida | ¿Qué resultado debe mostrarse y con qué formato? |',
        '| Prueba | ¿Con qué casos se demuestra que la solución funciona? |'
    )

    return $theoryLines -join "`n"
}

function Get-PracticeActivities {
    param([int]$SessionNumber)

    switch ($SessionNumber) {
        1 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Solicita nombre, ciclo y promedio de un estudiante. Luego muestra un resumen e indica si su promedio está por encima de 14.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica las tres entradas y el tipo de dato adecuado',
                        '- define cómo calcularás o evaluarás el promedio ingresado',
                        '- describe qué mensajes debe mostrar el resumen final'
                    )
                    Code = "nombre = input('Nombre: ')`nciclo = input('Ciclo: ')`npromedio = float(input('Promedio: '))`n`nprint('--- Resumen del estudiante ---')`nprint('Nombre:', nombre)`nprint('Ciclo:', ciclo)`nprint('Promedio:', promedio)`nprint('¿Supera 14?:', promedio > 14)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Lee el nombre de una mascota, su edad y su peso. Luego muestra una ficha ordenada con esos datos.'
                    Guidance = @(
                        'Antes de programar:',
                        '- escribe las entradas y su tipo de dato',
                        '- organiza el orden en que presentarás la ficha',
                        '- prueba con una mascota pequeña y otra de mayor edad'
                    )
                    Code = "mascota = input('Mascota: ')`nedad = int(input('Edad: '))`npeso = float(input('Peso: '))`n`nprint('--- Ficha de la mascota ---')`nprint('Nombre:', mascota)`nprint('Edad:', edad)`nprint('Peso:', peso)"
                }
            )
        }
        2 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Solicita cuatro notas, calcula el promedio y muestra también la nota mayor ingresada.'
                    Guidance = @(
                        'Antes de programar:',
                        '- anota las cuatro entradas numéricas',
                        '- define la fórmula del promedio',
                        '- decide cómo compararás las notas para hallar la mayor'
                    )
                    Code = "n1 = float(input('Nota 1: '))`nn2 = float(input('Nota 2: '))`nn3 = float(input('Nota 3: '))`nn4 = float(input('Nota 4: '))`n`npromedio = (n1 + n2 + n3 + n4) / 4`nmayor = max(n1, n2, n3, n4)`n`nprint('Promedio:', round(promedio, 2))`nprint('Nota mayor:', mayor)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Pide el precio de un producto y el porcentaje de descuento. Luego calcula el precio final y muestra cuánto se ahorró el cliente.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define las entradas numéricas',
                        '- escribe la operación para hallar descuento y precio final',
                        '- comprueba con un caso de descuento 0 y otro mayor'
                    )
                    Code = "precio = float(input('Precio: '))`ndescuento = float(input('Descuento %: '))`n`nahorro = precio * descuento / 100`nprecio_final = precio - ahorro`n`nprint('Ahorro:', round(ahorro, 2))`nprint('Precio final:', round(precio_final, 2))"
                }
            )
        }
        3 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Solicita la edad y la estatura de una persona. Indica si puede ingresar a un juego que exige ser mayor o medir más de 1.60 m.'
                    Guidance = @(
                        'Antes de programar:',
                        '- escribe las dos entradas requeridas',
                        '- formula la condición compuesta de ingreso',
                        '- prueba un caso que cumpla y otro que no cumpla'
                    )
                    Code = "edad = int(input('Edad: '))`nestatura = float(input('Estatura: '))`npuede_ingresar = edad >= 18 or estatura > 1.60`n`nprint('¿Puede ingresar?:', puede_ingresar)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Pide el promedio final y la asistencia de un estudiante. Determina si aprueba solo si el promedio es al menos 11 y la asistencia supera 70%.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica las entradas y sus tipos',
                        '- expresa la condición con operador lógico and',
                        '- verifica con un caso que falle por promedio y otro por asistencia'
                    )
                    Code = "promedio = float(input('Promedio: '))`nasistencia = float(input('Asistencia %: '))`naprueba = promedio >= 11 and asistencia > 70`n`nprint('¿Aprueba?:', aprueba)"
                }
            )
        }
        4 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Solicita la edad de una persona y clasifícala como niño, adolescente, adulto o adulto mayor.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define los rangos de edades sin dejar vacíos',
                        '- ordena las condiciones de mayor a menor o de menor a mayor',
                        '- prueba un valor límite en cada cambio de categoría'
                    )
                    Code = "edad = int(input('Edad: '))`n`nif edad < 12:`n    etapa = 'Niño'`nelif edad < 18:`n    etapa = 'Adolescente'`nelif edad < 60:`n    etapa = 'Adulto'`nelse:`n    etapa = 'Adulto mayor'`n`nprint('Etapa:', etapa)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Lee tres números y muestra cuál es el mayor. Si alguno es igual a otro, indícalo claramente.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica las tres entradas',
                        '- decide el orden de comparación',
                        '- considera casos con igualdad entre valores'
                    )
                    Code = "a = float(input('Número 1: '))`nb = float(input('Número 2: '))`nc = float(input('Número 3: '))`n`nif a == b == c:`n    print('Los tres números son iguales')`nelif a >= b and a >= c:`n    print('El mayor es:', a)`n    if a == b or a == c:`n        print('Existe empate en el valor mayor')`nelif b >= a and b >= c:`n    print('El mayor es:', b)`n    if b == a or b == c:`n        print('Existe empate en el valor mayor')`nelse:`n    print('El mayor es:', c)`n    if c == a or c == b:`n        print('Existe empate en el valor mayor')"
                }
            )
        }
        6 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Solicita 5 edades y muestra cuántas corresponden a personas mayores de edad.'
                    Guidance = @(
                        'Antes de programar:',
                        '- determina cuántas repeticiones tendrá el ciclo',
                        '- define cuándo aumenta el contador',
                        '- prueba con edades mezcladas'
                    )
                    Code = "mayores = 0`nfor i in range(5):`n    edad = int(input(f'Edad {i + 1}: '))`n    if edad >= 18:`n        mayores += 1`n`nprint('Mayores de edad:', mayores)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Solicita 4 precios y calcula el total acumulado y el promedio de compra.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define el acumulador principal',
                        '- repite la lectura exactamente 4 veces',
                        '- calcula el promedio al final'
                    )
                    Code = "total = 0`nfor i in range(4):`n    precio = float(input(f'Precio {i + 1}: '))`n    total += precio`n`npromedio = total / 4`nprint('Total:', round(total, 2))`nprint('Promedio:', round(promedio, 2))"
                }
            )
        }
        7 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Solicita números hasta que el usuario ingrese -1. Luego muestra la suma total de los valores ingresados.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define el valor centinela',
                        '- explica cuándo se acumula y cuándo se detiene el ciclo',
                        '- prueba con una secuencia corta y con salida inmediata'
                    )
                    Code = "total = 0`nnumero = int(input('Número (-1 para salir): '))`n`nwhile numero != -1:`n    total += numero`n    numero = int(input('Número (-1 para salir): '))`n`nprint('Total:', total)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Pide una contraseña hasta que tenga al menos 8 caracteres. Luego muestra un mensaje de acceso permitido.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define la condición de repetición',
                        '- explica qué dato se vuelve a solicitar',
                        '- prueba con contraseñas cortas y una válida'
                    )
                    Code = "contrasena = input('Contraseña: ')`n`nwhile len(contrasena) < 8:`n    contrasena = input('Contraseña: ')`n`nprint('Acceso permitido')"
                }
            )
        }
        8 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Dada una lista de cursos, cuenta cuántos tienen más de 6 letras y muéstralos en mayúscula.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica la colección inicial',
                        '- define la condición de conteo',
                        '- decide cómo transformar cada texto'
                    )
                    Code = "cursos = ['calculo', 'fisica', 'programacion', 'redes']`ncontador = 0`n`nfor curso in cursos:`n    if len(curso) > 6:`n        contador += 1`n        print(curso.upper())`n`nprint('Cantidad de cursos con más de 6 letras:', contador)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Recorre una cadena ingresada por teclado y cuenta cuántas vocales contiene.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define la entrada principal',
                        '- establece la lista o cadena de vocales de referencia',
                        '- prueba con texto en mayúsculas y minúsculas'
                    )
                    Code = "texto = input('Texto: ')`nvocales = 'aeiou'`ncontador = 0`n`nfor letra in texto.lower():`n    if letra in vocales:`n        contador += 1`n`nprint('Vocales:', contador)"
                }
            )
        }
        9 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Dada una lista de enteros, busca un valor ingresado por el usuario y muestra si fue encontrado.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define la lista y el valor buscado',
                        '- explica cuándo termina la búsqueda',
                        '- prueba con un valor presente y otro ausente'
                    )
                    Code = "datos = [4, 9, 2, 7, 5]`nbuscado = int(input('Valor a buscar: '))`nencontrado = False`n`nfor numero in datos:`n    if numero == buscado:`n        encontrado = True`n        break`n`nprint('Encontrado:', encontrado)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Ordena una lista de 4 números de menor a mayor sin usar sort().' 
                    Guidance = @(
                        'Antes de programar:',
                        '- escribe la lista inicial',
                        '- decide cómo compararás cada par de elementos',
                        '- comprueba con una lista ya ordenada y otra invertida'
                    )
                    Code = "datos = [8, 1, 6, 3]`n`nfor i in range(len(datos)):`n    for j in range(i + 1, len(datos)):`n        if datos[j] < datos[i]:`n            datos[i], datos[j] = datos[j], datos[i]`n`nprint(datos)"
                }
            )
        }
        10 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Calcula la suma de cada fila de una matriz de 3x3 y muestra el resultado por fila.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica filas y columnas',
                        '- define dónde reinicias el total de cada fila',
                        '- prueba con una matriz de números pequeños'
                    )
                    Code = "matriz = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]`n`nfor fila in range(len(matriz)):`n    total = 0`n    for columna in range(len(matriz[fila])):`n        total += matriz[fila][columna]`n    print('Fila', fila + 1, total)"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Dada una tabla de notas, calcula el promedio de cada estudiante.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica qué representa cada fila',
                        '- calcula suma y promedio por estudiante',
                        '- valida con notas fáciles de dividir'
                    )
                    Code = "notas = [[15, 14, 16], [11, 13, 12], [18, 17, 19]]`n`nfor fila in range(len(notas)):`n    total = 0`n    for columna in range(len(notas[fila])):`n        total += notas[fila][columna]`n    promedio = total / len(notas[fila])`n    print('Estudiante', fila + 1, 'promedio:', round(promedio, 2))"
                }
            )
        }
        11 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Crea un diccionario con tres estudiantes y sus promedios. Luego consulta uno por nombre.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define las claves y valores',
                        '- decide cómo leerás el nombre a consultar',
                        '- prueba con una clave existente y otra inexistente'
                    )
                    Code = "promedios = {'Ana': 16, 'Luis': 14, 'Marta': 18}`nnombre = input('Nombre a consultar: ')`n`nif nombre in promedios:`n    print('Promedio:', promedios[nombre])`nelse:`n    print('Estudiante no encontrado')"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Construye un diccionario de productos y actualiza el precio de uno de ellos.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define los productos iniciales',
                        '- identifica la clave que se modificará',
                        '- muestra el diccionario antes y después del cambio'
                    )
                    Code = "productos = {'cuaderno': 5.5, 'lapiz': 1.2, 'mochila': 45.0}`nprint('Antes:', productos)`nproductos['lapiz'] = 1.5`nprint('Después:', productos)"
                }
            )
        }
        13 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Escribe una función que reciba la base y la altura de un triángulo y retorne su área.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define los parámetros de la función',
                        '- escribe la fórmula del área',
                        '- prueba la función con más de un par de valores'
                    )
                    Code = "def area_triangulo(base, altura):`n    return (base * altura) / 2`n`nprint(area_triangulo(10, 4))"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Escribe una función que reciba un número y retorne True si es par o False si es impar.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define el parámetro de entrada',
                        '- identifica la condición para saber si es par',
                        '- prueba con números pares e impares'
                    )
                    Code = "def es_par(numero):`n    return numero % 2 == 0`n`nprint(es_par(8))`nprint(es_par(7))"
                }
            )
        }
        14 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Amplía el menú para permitir eliminar un nombre registrado de la lista.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define la nueva opción del menú',
                        '- decide qué sucede si el nombre no existe',
                        '- prueba el flujo completo con agregar, mostrar y eliminar'
                    )
                    Code = "def mostrar_menu():`n    print('1. Agregar nombre')`n    print('2. Mostrar nombres')`n    print('3. Eliminar nombre')`n    print('4. Salir')`n`nnombres = []`nopcion = ''`n`nwhile opcion != '4':`n    mostrar_menu()`n    opcion = input('Opción: ')`n    if opcion == '1':`n        nombres.append(input('Nombre: '))`n    elif opcion == '2':`n        print(nombres)`n    elif opcion == '3':`n        nombre = input('Nombre a eliminar: ')`n        if nombre in nombres:`n            nombres.remove(nombre)`n            print('Nombre eliminado')`n        else:`n            print('Nombre no encontrado')"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Construye un menú para registrar cursos y consultar si un curso ya fue ingresado.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define la estructura de datos a utilizar',
                        '- separa en funciones registrar y consultar',
                        '- verifica el programa con varias opciones seguidas'
                    )
                    Code = "def mostrar_menu():`n    print('1. Registrar curso')`n    print('2. Consultar curso')`n    print('3. Salir')`n`ncursos = []`nopcion = ''`n`nwhile opcion != '3':`n    mostrar_menu()`n    opcion = input('Opción: ')`n    if opcion == '1':`n        cursos.append(input('Curso: '))`n    elif opcion == '2':`n        curso = input('Curso a consultar: ')`n        print('Registrado:', curso in cursos)"
                }
            )
        }
        15 {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Guarda tres nombres de estudiantes en un archivo y luego léelos para mostrarlos numerados.'
                    Guidance = @(
                        'Antes de programar:',
                        '- separa claramente la parte de escritura y la de lectura',
                        '- define el nombre del archivo',
                        '- comprueba que cada línea se recupere correctamente'
                    )
                    Code = "with open('estudiantes.txt', 'w', encoding='utf-8') as archivo:`n    archivo.write('Ana`n')`n    archivo.write('Luis`n')`n    archivo.write('Marta`n')`n`nwith open('estudiantes.txt', 'r', encoding='utf-8') as archivo:`n    for indice, linea in enumerate(archivo, start=1):`n        print(indice, linea.strip())"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Registra productos con su precio en un archivo de texto y luego recupéralos para mostrarlos en pantalla.'
                    Guidance = @(
                        'Antes de programar:',
                        '- define el formato en que guardarás cada producto',
                        '- separa escritura y lectura',
                        '- verifica que los datos recuperados sean legibles'
                    )
                    Code = "with open('productos.txt', 'w', encoding='utf-8') as archivo:`n    archivo.write('cuaderno,5.5`n')`n    archivo.write('lapiz,1.2`n')`n    archivo.write('mochila,45.0`n')`n`nwith open('productos.txt', 'r', encoding='utf-8') as archivo:`n    for linea in archivo:`n        producto, precio = linea.strip().split(',')`n        print(producto, '->', precio)"
                }
            )
        }
        default {
            return @(
                @{
                    Title = '### Ejercicio 2'
                    Text = 'Resuelve un problema guiado adicional aplicando la técnica principal de la sesión.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica entradas, proceso y salida',
                        '- explica la estrategia principal',
                        '- define al menos dos casos de prueba'
                    )
                    Code = "# Resuelve aquí el ejercicio 2"
                },
                @{
                    Title = '### Ejercicio 3'
                    Text = 'Resuelve un segundo problema guiado para reforzar la misma técnica en otro contexto.'
                    Guidance = @(
                        'Antes de programar:',
                        '- identifica entradas, proceso y salida',
                        '- compara este problema con el ejercicio anterior',
                        '- valida la solución con distintos datos'
                    )
                    Code = "# Resuelve aquí el ejercicio 3"
                }
            )
        }
    }
}

function Get-AutonomousPractice {
    param([int]$SessionNumber)

    switch ($SessionNumber) {
        1 { return @('Elabora una ficha similar para dos personas distintas y compara sus tipos de datos.', 'Crea una ficha de producto con nombre, precio y stock.', 'Escribe tres ejemplos propios de variables `str`, `int`, `float` y `bool`.') }
        2 { return @('Calcula el promedio de cinco notas y compáralo con un valor mínimo.', 'Resuelve un problema de descuento y ahorro con porcentajes.', 'Construye dos expresiones lógicas y explica qué resultado producen.') }
        3 { return @('Diseña una condición compuesta para ingreso a biblioteca o laboratorio.', 'Evalúa si un estudiante recibe beneficio según promedio y asistencia.', 'Propón dos casos donde una condición con `or` sea más adecuada que una con `and`.') }
        4 { return @('Clasifica edades o montos en cuatro rangos distintos.', 'Determina el mayor de tres valores incluyendo casos con empate.', 'Crea una tabla de casos límite para verificar una clasificación.') }
        6 { return @('Cuenta cuántos valores cumplen una condición dentro de 8 datos.', 'Acumula gastos semanales y calcula el promedio.', 'Modifica un ciclo `for` para mostrar posición y valor al mismo tiempo.') }
        7 { return @('Suma números hasta recibir un centinela distinto de 0.', 'Valida repetidamente una entrada hasta que cumpla una regla dada.', 'Diseña un caso donde el ciclo se detenga por una condición textual.') }
        8 { return @('Cuenta consonantes o vocales en una palabra o frase.', 'Procesa una lista de cursos y filtra los que cumplan cierta longitud.', 'Convierte una colección de palabras a mayúsculas o minúsculas y muestra el resultado.') }
        9 { return @('Busca un elemento en una lista y reporta su posición.', 'Ordena una lista pequeña sin usar funciones automáticas.', 'Compara el resultado de una lista ya ordenada con otra totalmente invertida.') }
        10 { return @('Calcula el total por fila de una matriz pequeña.', 'Calcula el total por columna en una tabla 3x3.', 'Representa una asistencia o ventas usando filas y columnas y resume la información.') }
        11 { return @('Registra datos académicos en un diccionario y consulta una clave.', 'Actualiza un valor existente y agrega una nueva clave.', 'Prueba qué ocurre cuando consultas una clave inexistente y define cómo responder.') }
        13 { return @('Escribe una función que calcule área o perímetro de una figura.', 'Crea una función booleana que valide una condición simple.', 'Prueba cada función con al menos tres casos distintos.') }
        14 { return @('Amplía un menú con una opción nueva de consulta o eliminación.', 'Separa en funciones el registro y la visualización de datos.', 'Prueba varias secuencias de opciones para validar el flujo del programa.') }
        15 { return @('Guarda nombres o productos en un archivo y recupéralos.', 'Diseña un formato simple para registrar datos por línea.', 'Verifica cómo cambia el archivo después de cada escritura.') }
        default { return @('Resuelve un problema adicional aplicando la técnica principal de la sesión.', 'Modifica uno de los ejercicios vistos para usar datos distintos.', 'Registra en tu cuaderno dos casos de prueba y explica por qué validan la solución.') }
    }
}

function Get-GuidedAnalysis {
    param([int]$SessionNumber)

    switch ($SessionNumber) {
        1 {
            return [ordered]@{
                Understanding = 'se debe leer el nombre, la edad y la carrera de un estudiante para mostrar una ficha resumida con esos datos e indicar si es mayor de edad.'
                Entries = 'ingresan tres datos por teclado: `nombre` como texto, `edad` como número entero y `carrera` como texto.'
                Processes = Join-ResolutionSteps @(
                    'leer nombre con input().'
                    'leer edad con input() y convertirla con int().'
                    'leer carrera con input().'
                    'mostrar la ficha ordenada con etiquetas claras.'
                    'evaluar la condición edad >= 18 para indicar si es mayor de edad.'
                )
                Outputs = 'debe mostrarse una ficha con las etiquetas `Nombre`, `Edad`, `Carrera` y una indicación sobre si es mayor de edad.'
                Tests = Join-ResolutionSteps @(
                    'caso normal: nombre = Ana, edad = 20, carrera = Medicina; debe mostrar la ficha completa y ¿Es mayor de edad?: True.'
                    'caso límite: nombre = Luis, edad = 18, carrera = Derecho; debe seguir mostrando True.'
                    'caso excepcional: si la edad se ingresa vacía, como texto no numérico o con un valor negativo, el programa actual fallará o producirá un dato inválido, así que ese caso sirve para discutir validación posterior.'
                )
            }
        }
        default {
            return [ordered]@{
                Understanding = 'explica con una oración completa cuál es el resultado que debe obtener el programa.'
                Entries = 'enumera cada dato de entrada e indica su tipo de dato esperado.'
                Processes = Join-ResolutionSteps @(
                    'describe la operación, condición, recorrido o función principal que usarás para resolver el problema.'
                    'ordena las acciones principales antes de escribir el código.'
                    'prepara cómo obtendrás el resultado final antes de mostrarlo.'
                )
                Outputs = 'especifica la salida esperada y el formato con que se debe mostrar.'
                Tests = Join-ResolutionSteps @(
                    'caso normal: usa datos habituales para comprobar que el resultado esperado se cumpla.'
                    'caso límite: prueba el valor exacto donde cambia la regla principal.'
                    'caso excepcional: revisa qué sucede con una entrada vacía, inválida o fuera de rango.'
                )
            }
        }
    }
}

function Get-IntroExercise {
    param([int]$SessionNumber)

    switch ($SessionNumber) {
        1 {
            return @{
                Title = '### Ejercicio 1'
                Text = 'Mostrar distintos tipos de salida.'
                Guidance = Get-ResolutionBlock `
                    -Understanding 'queremos comprobar que Python puede mostrar diferentes clases de datos, no solo texto.' `
                    -Entries 'no hay entrada de usuario, pero los datos ya están escritos en el programa y serán procesados para mostrarse.' `
                    -Processes (Join-ResolutionSteps @(
                        'mostrar un texto con print().'
                        'mostrar un entero, un decimal y un valor lógico.'
                        'verificar que cada salida aparezca en pantalla con claridad.'
                    )) `
                    -Outputs 'deben verse cuatro mensajes en pantalla, cada uno con un tipo de dato diferente.' `
                    -Tests (Join-ResolutionSteps @(
                        'caso normal: ejecuta el código tal como está y comprueba que aparecen cuatro salidas distintas.'
                        'caso de variación: cambia el nombre, la edad y el promedio para verificar que la salida se actualiza.'
                        'caso booleano: cambia True por False y verifica que el último mensaje cambie correctamente.'
                    ))
                Code = "print('Estudiante: Ana')`nprint('Edad:', 16)`nprint('Promedio:', 17.8)`nprint('¿Aprobó?:', True)"
            }
        }
        default {
            return $null
        }
    }
}

function New-SessionNotebook {
    param(
        [string]$Filename,
        [string]$Title,
        [string]$Objective,
        [string]$Result,
        [string[]]$Contents,
        [string]$TheoryMarkdown,
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
    }
    elseif ($sessionNumber -le 9) {
        $difficulty = 'Básico - intermedio'
    }
    else {
        $difficulty = 'Intermedio'
    }

    $miniLab = Get-MiniLab -SessionNumber $sessionNumber -Objective $Objective
    $introExercise = Get-IntroExercise -SessionNumber $sessionNumber
    $practiceActivities = Get-PracticeActivities -SessionNumber $sessionNumber
    $autonomousPractice = Get-AutonomousPractice -SessionNumber $sessionNumber
    $guidedAnalysis = Get-GuidedAnalysis -SessionNumber $sessionNumber

    $contentsMd = ($Contents | ForEach-Object { "- $_" }) -join "`n"
    $checklistMd = ($Checklist | ForEach-Object { "- $_" }) -join "`n"
    $autonomousPracticeMd = ((@('## Aprendizaje autónomo', '') + ($autonomousPractice | ForEach-Object { "- $_" }))) -join "`n"
    $theoryMd = if ([string]::IsNullOrWhiteSpace($TheoryMarkdown)) {
        if ($sessionNumber -eq 1) {
            Get-SessionOneTheoryMarkdown
        }
        else {
            Get-SessionTheoryMarkdown -Objective $Objective -Contents $Contents
        }
    }
    else {
        $TheoryMarkdown
    }
    $routeMd = @(
        '## Método o Ruta de trabajo',
        '',
        '1. Comprender el problema: ¿qué se pide?',
        '2. Identificar entradas: ¿qué datos necesito?',
        '3. Diseñar el proceso: ¿qué operaciones o decisiones realizaré?',
        '4. Definir salidas: ¿qué debe mostrar o registrar la solución?',
        '5. Diseñar pruebas: ¿con qué casos comprobaré que funciona?',
        '6. Escribir, ejecutar y corregir el código.',
        '',
        'En cada ejercicio aplicaremos estos pasos antes de programar.'
    ) -join "`n"
    $architectureMd = @(
        '## Arquitectura para resolver ejercicios',
        '',
        '```text',
        'Problema',
        '   |',
        'Entrada -> Proceso -> Salida',
        '   |',
        'Código en Python',
        '```'
    ) -join "`n"
    $miniLabMd = @(
        "### $($miniLab.Title)",
        '',
        $miniLab.Text
    ) -join "`n"
    $practiceSectionMd = @(
        '## Actividad práctica',
        '',
        'La sesión se desarrolla con exploración inicial, ejercicios guiados, ejercicios de aplicación y una tarea tipo competencia.'
    ) -join "`n"
    $guidedTitle = '### Ejercicio 1'
    if ($null -ne $introExercise) {
        $guidedTitle = '### Ejercicio 2'
    }
    $guidedMd = @(
        $guidedTitle,
        '',
        $GuidedText,
        ''
    )
    $guidedMd += Get-ResolutionBlock `
        -Understanding $guidedAnalysis.Understanding `
        -Entries $guidedAnalysis.Entries `
        -Processes $guidedAnalysis.Processes `
        -Outputs $guidedAnalysis.Outputs `
        -Tests $guidedAnalysis.Tests
    $guidedMd = $guidedMd -join "`n"
    $challengeResolutionMd = (Get-ResolutionBlock `
        -Understanding 'redacta con tus palabras qué debe resolver la tarea.' `
        -Entries 'define qué datos ingresan y el tipo que tendrán.' `
        -Processes (Join-ResolutionSteps @(
            'describe la estrategia, fórmula, condición, estructura o algoritmo que piensas aplicar.'
            'ordena las acciones principales antes de escribir el código.'
            'prepara cómo obtendrás el resultado final antes de mostrarlo.'
        )) `
        -Outputs 'indica con claridad qué resultado debe mostrar o registrar la solución.' `
        -Tests (Join-ResolutionSteps @(
            'caso normal: usa datos habituales para comprobar que la solución funcione.'
            'caso límite: prueba el valor exacto donde cambia la regla principal.'
            'caso excepcional: revisa qué ocurre con una entrada vacía, inválida o fuera de rango.'
        ))) -join "`n"
    $challengeMd = @(
        '### Tarea tipo competencia',
        '',
        $ChallengeText,
        '',
        $challengeResolutionMd
    ) -join "`n"

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
        (New-MarkdownCell $theoryMd)
    )

    $cells += @(
        (New-MarkdownCell $routeMd),
        (New-MarkdownCell $architectureMd),
        (New-MarkdownCell $practiceSectionMd),
    (New-MarkdownCell $miniLabMd),
        (New-CodeCell $miniLab.Code)
    )

    if ($null -ne $introExercise) {
        $introExerciseMd = (@(
            $introExercise.Title,
            '',
            $introExercise.Text,
            ''
        ) + $introExercise.Guidance) -join "`n"

        $cells += (New-MarkdownCell $introExerciseMd)
        $cells += (New-CodeCell $introExercise.Code)
    }

    $cells += @(
        (New-MarkdownCell $guidedMd),
        (New-CodeCell $GuidedCode)
    )

    foreach ($practice in $practiceActivities) {
        if ($null -ne $introExercise) {
            if ($practice.Title -eq '### Ejercicio 2') {
                $practiceTitle = '### Ejercicio 3'
            }
            elseif ($practice.Title -eq '### Ejercicio 3') {
                $practiceTitle = '### Ejercicio 4'
            }
            else {
                $practiceTitle = $practice.Title
            }
        }
        else {
            $practiceTitle = $practice.Title
        }

        $practiceLines = @(
            $practiceTitle,
            '',
            $practice.Text,
            ''
        )
        $practiceLines += Convert-PracticeGuidanceToResolutionBlock -Problem $practice.Text -Guidance $practice.Guidance
        $practiceMd = $practiceLines -join "`n"

        $cells += (New-MarkdownCell $practiceMd)
        $cells += (New-CodeCell $practice.Code)
    }

    $cells += @(
        (New-MarkdownCell $challengeMd),
        (New-CodeCell $StarterCode),
        (New-MarkdownCell $autonomousPracticeMd),
        (New-MarkdownCell "## Evaluación de la sesión

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

    $sessionNumber = [int](([regex]::Match($Filename, 'Sesion_(\d+)_')).Groups[1].Value)
    $criteriaMd = ($Criteria | ForEach-Object { "- $_" }) -join "`n"
    $theoryMd = switch ($sessionNumber) {
        5 {
            @(
                '## Base conceptual de la sesión',
                '',
                'Esta evaluación integra la resolución de problemas secuenciales y condicionales. El punto de partida sigue siendo el algoritmo: comprender el enunciado, reconocer los datos de entrada, ordenar el proceso y definir una salida verificable.',
                '',
                '### Conceptos que debes activar',
                '- **Entrada, proceso y salida:** todo problema debe separarse en datos recibidos, operaciones realizadas y resultado mostrado.',
                '- **Variables y tipos de datos:** cada dato debe tener un nombre claro y un tipo adecuado para calcular, comparar o mostrar.',
                '- **Operadores y expresiones:** los cálculos y comparaciones deben respetar precedencia, paréntesis y significado lógico.',
                '- **Decisiones:** las estructuras `if`, `if-else` e `if-elif-else` permiten seleccionar caminos según condiciones.',
                '- **Validación:** antes de clasificar o calcular, conviene controlar rangos, datos imposibles y casos límite.',
                '',
                '### Criterio de resolución',
                'Antes de escribir código, redacta el algoritmo en lenguaje natural o pseudocódigo. Luego implementa la solución y pruébala con un caso normal, un caso límite y un caso inválido.'
            ) -join "`n"
        }
        12 {
            @(
                '## Base conceptual de la sesión',
                '',
                'Esta evaluación integra ciclos y estructuras de datos. La lógica central consiste en procesar varios datos de manera ordenada, conservarlos cuando sea necesario y obtener resultados mediante recorridos, conteos, acumulaciones, búsquedas o consultas.',
                '',
                '### Conceptos que debes activar',
                '- **Repetición definida y condicionada:** `for` se usa cuando se conoce el número de repeticiones; `while` cuando la parada depende de una condición.',
                '- **Contadores y acumuladores:** permiten contar eventos y construir resultados progresivos dentro de un ciclo.',
                '- **Listas y cadenas:** almacenan colecciones que pueden recorrerse, filtrarse, transformarse o analizarse.',
                '- **Búsqueda y ordenación básica:** permiten localizar elementos y reorganizar datos mediante comparaciones.',
                '- **Matrices y diccionarios:** organizan información tabular o clave-valor para facilitar consultas y actualizaciones.',
                '',
                '### Criterio de resolución',
                'Elige la estructura de datos antes de programar. Después define el recorrido, la condición de procesamiento, la salida y los casos de prueba.'
            ) -join "`n"
        }
        16 {
            @(
                '## Base conceptual de la sesión',
                '',
                'La evaluación final exige integrar el curso completo: análisis del problema, estructuras de control, colecciones, funciones y persistencia básica. La solución debe ser correcta, clara y organizada en partes que puedan probarse.',
                '',
                '### Conceptos que debes activar',
                '- **Modularización:** divide el problema en funciones pequeñas con una responsabilidad definida.',
                '- **Parámetros y retorno:** las funciones deben recibir datos, procesarlos y devolver resultados cuando corresponda.',
                '- **Colecciones:** listas, matrices o diccionarios deben elegirse según la forma de organizar y consultar la información.',
                '- **Menús y flujo del programa:** el programa principal coordina opciones, llamadas a funciones, validaciones y salidas.',
                '- **Persistencia:** los archivos de texto permiten guardar y recuperar datos después de cerrar el programa.',
                '',
                '### Criterio de resolución',
                'Diseña primero la arquitectura general: funciones necesarias, datos que administran, formato de archivo y casos de prueba. Luego implementa por partes y verifica cada operación antes de integrar todo.'
            ) -join "`n"
        }
        default {
            @(
                '## Base conceptual de la sesión',
                '',
                'Esta sesión evalúa la aplicación integrada de los conceptos trabajados. Analiza entradas, procesos, salidas y pruebas antes de escribir código.'
            ) -join "`n"
        }
    }

    $cells = @(
        (New-ColabCell $Filename),
        (New-MarkdownCell "# $Title

## Propósito
$Purpose

## Criterios de evaluación
$criteriaMd"),
        (New-MarkdownCell $theoryMd),
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
if (-not $SkipGuide) {
    Write-NotebookFile -Path (Join-Path $root 'Guia_algoritmo_a_codigo.ipynb') -Notebook $guide
}

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

total = precio * cantidad
print('--- Resumen de compra ---')
print('Producto:', producto)
print('Cantidad:', cantidad)
print('Total:', round(total, 2))"; Checklist=@('Identifiqué las entradas antes de programar.','Usé variables con nombres claros.','Elegí tipos de datos adecuados.','Probé al menos dos entradas diferentes.') },
    @{ Filename='Sesion_02_Operadores_Expresiones_Secuencia.ipynb'; Title='Sesión 2: Operadores, expresiones y secuencia de instrucciones'; Objective='Resolver problemas secuenciales usando operadores aritméticos, relacionales y lógicos.'; Result='Programa secuencial que realice cálculos y muestre resultados correctamente.'; Contents=@('operadores aritméticos','operadores relacionales','operadores lógicos','expresiones','secuencia de instrucciones'); GuidedTitle='Ejemplo guiado'; GuidedText='Calcularemos el promedio de tres notas y determinaremos si el estudiante aprueba con una condición simple.'; GuidedCode="nota1 = float(input('Nota 1: '))
nota2 = float(input('Nota 2: '))
nota3 = float(input('Nota 3: '))

promedio = (nota1 + nota2 + nota3) / 3
print('Promedio:', round(promedio, 2))
print('Aprueba:', promedio >= 11)"; ChallengeTitle='Reto aplicado'; ChallengeText='Pide el sueldo base y el porcentaje de bonificación. Luego calcula el sueldo final y muestra si supera un monto de referencia.'; StarterCode="sueldo_base = float(input('Sueldo base: '))
porcentaje_bono = float(input('Porcentaje de bonificación: '))

bono = sueldo_base * porcentaje_bono / 100
sueldo_final = sueldo_base + bono
print('Sueldo final:', round(sueldo_final, 2))
print('¿Supera 2000?:', sueldo_final > 2000)"; Checklist=@('Separé claramente el cálculo principal.','Usé operadores adecuados para cada expresión.','Comprobé el resultado con datos simples.','Entiendo por qué la solución no requiere decisiones múltiples.') },
    @{ Filename='Sesion_03_Decisiones_Simples_Compuestas.ipynb'; Title='Sesión 3: Decisiones simples y compuestas'; Objective='Resolver problemas que requieren evaluar condiciones simples y compuestas.'; Result='Programa que tome decisiones correctas según los datos de entrada.'; Contents=@('if','if-else','condiciones compuestas','validación básica','casos de prueba'); GuidedTitle='Ejemplo guiado'; GuidedText='Determinaremos si una persona accede a un descuento según su edad y si cuenta con carné estudiantil.'; GuidedCode="edad = int(input('Edad: '))
tiene_carne = input('¿Tiene carné estudiantil? (si/no): ').strip().lower()

if edad < 18 or tiene_carne == 'si':
    print('Aplica a descuento.')
else:
    print('No aplica a descuento.')"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita una temperatura y determina si el clima se considera frío, templado o cálido usando decisiones simples y compuestas.'; StarterCode="temperatura = float(input('Temperatura: '))

if temperatura < 15:
    print('Clima frío')
elif temperatura <= 25:
    print('Clima templado')
else:
    print('Clima cálido')"; Checklist=@('Escribí condiciones legibles.','Probé al menos un caso verdadero y uno falso.','Usé operadores lógicos cuando era necesario.','La salida explica claramente la decisión tomada.') },
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

if monto >= 500:
    descuento = 0.20
elif monto >= 200:
    descuento = 0.10
else:
    descuento = 0.05

print('Descuento aplicado:', descuento * 100, '%')
print('Monto final:', round(monto * (1 - descuento), 2))"; Checklist=@('Ordené correctamente las condiciones.','Consideré datos fuera de rango o extremos.','La clasificación no deja casos sin cubrir.','Probé varios escenarios antes de cerrar.') },
    @{ Filename='Sesion_06_Repeticion_Definida_For.ipynb'; Title='Sesión 6: Repetición definida con for'; Objective='Resolver problemas que requieren repetir una acción un número conocido de veces.'; Result='Programa que use for, contadores y acumuladores para procesar varios datos.'; Contents=@('for','range','contadores','acumuladores','sumatorias'); GuidedTitle='Ejemplo guiado'; GuidedText='Contaremos cuántos estudiantes aprueban dentro de un grupo de cinco registros ingresados por teclado.'; GuidedCode="aprobados = 0
for i in range(5):
    nota = float(input(f'Nota {i + 1}: '))
    if nota >= 11:
        aprobados += 1

print('Total de aprobados:', aprobados)"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita 6 números y muestra la suma total y cuántos son pares.'; StarterCode="suma = 0
pares = 0

for i in range(6):
    numero = int(input(f'Número {i + 1}: '))
    suma += numero
    if numero % 2 == 0:
        pares += 1

print('Suma:', suma)
print('Pares:', pares)"; Checklist=@('Usé un contador cuando necesitaba contar casos.','Usé un acumulador cuando necesitaba sumar valores.','El ciclo repite exactamente el número esperado de veces.','Probé la solución con datos pequeños.') },
    @{ Filename='Sesion_07_Repeticion_Condicionada_While.ipynb'; Title='Sesión 7: Repetición condicionada con while'; Objective='Resolver problemas en los que la repetición depende de una condición de parada.'; Result='Programa que use while, centinelas y validación iterativa de datos.'; Contents=@('while','condición de parada','centinelas','validación iterativa','control de ingreso'); GuidedTitle='Ejemplo guiado'; GuidedText='Registraremos ventas hasta que el usuario ingrese 0 como señal de cierre.'; GuidedCode="total = 0
venta = float(input('Venta (0 para terminar): '))

while venta != 0:
    total += venta
    venta = float(input('Venta (0 para terminar): '))

print('Total vendido:', total)"; ChallengeTitle='Reto aplicado'; ChallengeText='Solicita contraseñas hasta que el usuario ingrese una que cumpla longitud mínima y contenga un número.'; StarterCode="contrasena = input('Ingrese contraseña: ')

while True:
    tiene_numero = False
    for caracter in contrasena:
        if caracter.isdigit():
            tiene_numero = True
            break
    if len(contrasena) >= 8 and tiene_numero:
        break
    contrasena = input('Ingrese contraseña: ')

print('Contraseña válida')"; Checklist=@('Definí claramente la condición de parada.','Evité ciclos infinitos.','Validé los datos dentro del proceso iterativo.','La salida refleja correctamente el estado final del ciclo.') },
    @{ Filename='Sesion_08_Listas_Cadenas_Procesamiento_Colecciones.ipynb'; Title='Sesión 8: Listas, cadenas y procesamiento de colecciones'; Objective='Procesar conjuntos de datos usando listas y cadenas en problemas de recorrido y análisis simple.'; Result='Programa que recorra una colección, cuente elementos y transforme información textual.'; Contents=@('listas','cadenas','recorrido de colecciones','conteos','transformación básica de texto'); GuidedTitle='Ejemplo guiado'; GuidedText='Analizaremos una lista de nombres para contar cuántos empiezan con una vocal.'; GuidedCode="nombres = ['Ana', 'Luis', 'Elena', 'Oscar', 'Marta']
vocales = 'aeiou'
contador = 0

for nombre in nombres:
    if nombre[0].lower() in vocales:
        contador += 1

print('Nombres que empiezan con vocal:', contador)"; ChallengeTitle='Reto aplicado'; ChallengeText='Dada una lista de palabras, muestra cuántas tienen más de 5 letras y construye una nueva lista en mayúsculas.'; StarterCode="palabras = ['programacion', 'datos', 'bucle', 'sistema', 'python']
mayusculas = []
contador = 0

for palabra in palabras:
    if len(palabra) > 5:
        contador += 1
    mayusculas.append(palabra.upper())

print('Cantidad con más de 5 letras:', contador)
print('Mayúsculas:', mayusculas)"; Checklist=@('Recorrí correctamente la colección completa.','Usé condiciones para contar casos específicos.','Transformé texto sin perder la información original.','Probé con palabras de distinto tamaño.') },
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

mayor = numeros[0]
for numero in numeros:
    if numero > mayor:
        mayor = numero

for i in range(len(numeros)):
    for j in range(i + 1, len(numeros)):
        if numeros[j] < numeros[i]:
            numeros[i], numeros[j] = numeros[j], numeros[i]

print('Mayor:', mayor)
print('Lista ordenada:', numeros)"; Checklist=@('Distinguí entre buscar y ordenar.','Usé ciclos correctamente para comparar elementos.','No utilicé funciones automáticas de ordenación.','Probé con listas ya ordenadas y desordenadas.') },
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

total_general = 0
for fila in range(len(ventas)):
    total_fila = 0
    for columna in range(len(ventas[fila])):
        total_fila += ventas[fila][columna]
    total_general += total_fila
    print('Fila', fila + 1, total_fila)

print('Total general:', total_general)"; Checklist=@('Identifiqué filas y columnas correctamente.','Usé ciclos anidados cuando fue necesario.','La consulta de posiciones fue clara y precisa.','Probé con matrices pequeñas antes de cerrar.') },
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

nombre = input('Producto a consultar: ')

if nombre in productos:
    print('Precio actual:', productos[nombre])
    nuevo_precio = float(input('Nuevo precio: '))
    productos[nombre] = nuevo_precio
    print('Diccionario actualizado:', productos)
else:
    print('Producto no encontrado')"; Checklist=@('Usé claves adecuadas para identificar cada dato.','Consulté información sin recorrer toda la estructura cuando no era necesario.','Actualicé valores sin perder el resto de los datos.','Probé claves existentes y no existentes.') },
    @{ Filename='Sesion_13_Funciones_Parametros_Retorno_Modularizacion.ipynb'; Title='Sesión 13: Funciones, parámetros, retorno y modularización'; Objective='Dividir un problema en partes reutilizables mediante funciones con parámetros y retorno.'; Result='Programa organizado en funciones claras que resuelvan subproblemas concretos.'; Contents=@('funciones','parámetros','return','modularización','reutilización'); GuidedTitle='Ejemplo guiado'; GuidedText='Crearemos una función para calcular el promedio y otra para decidir el resultado final del estudiante.'; GuidedCode="def calcular_promedio(n1, n2, n3):
    return (n1 + n2 + n3) / 3

def obtener_resultado(promedio):
    if promedio >= 11:
        return 'Aprobado'
    return 'Desaprobado'

promedio = calcular_promedio(15, 12, 14)
print('Promedio:', promedio)
print('Resultado:', obtener_resultado(promedio))"; ChallengeTitle='Reto aplicado'; ChallengeText='Escribe una función que reciba una lista de números y retorne el mayor valor. Luego úsala en un programa principal.'; StarterCode="def mayor_lista(numeros):
    mayor = numeros[0]
    for numero in numeros:
        if numero > mayor:
            mayor = numero
    return mayor

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
opcion = ''

while opcion != '3':
    mostrar_menu()
    opcion = input('Opción: ')
    if opcion == '1':
        nombre = input('Producto: ')
        precio = float(input('Precio: '))
        productos[nombre] = precio
    elif opcion == '2':
        nombre = input('Producto a consultar: ')
        if nombre in productos:
            print('Precio:', productos[nombre])
        else:
            print('Producto no encontrado')"; Checklist=@('El menú organiza claramente las opciones del programa.','Separé tareas del flujo principal en funciones.','La estructura de datos elegida responde al problema.','El programa puede ejecutarse varias veces sin romperse.') },
    @{ Filename='Sesion_15_Persistencia_Basica_Archivos.ipynb'; Title='Sesión 15: Persistencia básica de información'; Objective='Registrar y recuperar información simple usando archivos de texto.'; Result='Programa que escriba datos en un archivo y luego los lea para mostrarlos o procesarlos.'; Contents=@('persistencia','archivos de texto','escritura','lectura','registro y recuperación'); GuidedTitle='Ejemplo guiado'; GuidedText='Guardaremos nombres en un archivo de texto y luego los recuperaremos para mostrarlos en pantalla.'; GuidedCode="with open('nombres.txt', 'w', encoding='utf-8') as archivo:
    archivo.write('Ana\n')
    archivo.write('Luis\n')

with open('nombres.txt', 'r', encoding='utf-8') as archivo:
    for linea in archivo:
        print(linea.strip())"; ChallengeTitle='Reto aplicado'; ChallengeText='Guarda tres productos con su precio en un archivo y luego léelos para mostrarlos en formato de lista.'; StarterCode="with open('productos_persistencia.txt', 'w', encoding='utf-8') as archivo:
    archivo.write('cuaderno,5.5\n')
    archivo.write('lapiz,1.2\n')
    archivo.write('mochila,45.0\n')

with open('productos_persistencia.txt', 'r', encoding='utf-8') as archivo:
    for linea in archivo:
        producto, precio = linea.strip().split(',')
        print('- ', producto, ': ', precio, sep='')"; Checklist=@('Distinguí claramente escritura y lectura de archivos.','Usé rutas y nombres de archivo consistentes.','Verifiqué que la información guardada pueda recuperarse.','El archivo contiene datos legibles y ordenados.') }
)

foreach ($spec in $sessionSpecs) {
    $nb = New-SessionNotebook -Filename $spec.Filename -Title $spec.Title -Objective $spec.Objective -Result $spec.Result -Contents $spec.Contents -TheoryMarkdown $spec.TheoryMarkdown -GuidedTitle $spec.GuidedTitle -GuidedText $spec.GuidedText -GuidedCode $spec.GuidedCode -ChallengeTitle $spec.ChallengeTitle -ChallengeText $spec.ChallengeText -StarterCode $spec.StarterCode -Checklist $spec.Checklist
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


