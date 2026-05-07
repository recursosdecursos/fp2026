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
        '## Resolución guiada aplicada',
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

function Get-PracticeActivities {
    param([int]$SessionNumber)

    switch ($SessionNumber) {
        1 {
            return @(
                @{
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                    Title = '## Ejercicio 2'
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
                    Title = '## Ejercicio 3'
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
                Title = '## Ejercicio 1'
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
        "## $($miniLab.Title)",
        '',
        $miniLab.Text
    ) -join "`n"
    $guidedTitle = '## Ejercicio 1'
    if ($null -ne $introExercise) {
        $guidedTitle = '## Ejercicio 2'
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
        '## Tarea tipo competencia',
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
        (New-MarkdownCell $routeMd),
        (New-MarkdownCell $architectureMd),
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
            if ($practice.Title -eq '## Ejercicio 2') {
                $practiceTitle = '## Ejercicio 3'
            }
            elseif ($practice.Title -eq '## Ejercicio 3') {
                $practiceTitle = '## Ejercicio 4'
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


