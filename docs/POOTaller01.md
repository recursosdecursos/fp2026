# Crear proyecto JavaFX + Maven + SQLite en IntelliJ IDEA

## 1. Crear proyecto Maven

Abrir IntelliJ IDEA:

```text
New Project
→ Maven
→ Java 17 o Java 21
→ Create from archetype (desmarcado)
```

Configurar:

```text
GroupId: pe.upeu
ArtifactId: sistema-ventas-poo
```

Finalizar el proyecto.

---

## 2. Estructura inicial del proyecto

```text
sistema-ventas-poo/
│
├── pom.xml
│
└── src/
    └── main/
        ├── java/
        └── resources/
```

---

## 3. Crear paquetes principales

Dentro de:

```text
src/main/java/
```

crear:

```text
app
modelo
controlador
dao
util
```

Dentro de:

```text
src/main/resources/
```

crear:

```text
vista
css
img
```

Crear también una carpeta externa para la base de datos:

```text
data
```

---

## 4. Estructura final recomendada

```text
sistema-ventas-poo/
│
├── pom.xml
│
├── data/
│   └── ventas.db
│
└── src/
    └── main/
        │
        ├── java/
        │   ├── app/
        │   │   └── Main.java
        │   │
        │   ├── modelo/
        │   │   ├── Producto.java
        │   │   ├── Venta.java
        │   │   └── DetalleVenta.java
        │   │
        │   ├── controlador/
        │   │   ├── ProductoController.java
        │   │   └── VentaController.java
        │   │
        │   ├── dao/
        │   │   ├── ConexionSQLite.java
        │   │   ├── ProductoDAO.java
        │   │   └── VentaDAO.java
        │   │
        │   └── util/
        │       ├── AlertUtil.java
        │       └── ValidacionUtil.java
        │
        └── resources/
            ├── vista/
            │   ├── ProductoView.fxml
            │   └── VentaView.fxml
            │
            ├── css/
            │   └── styles.css
            │
            └── img/
                └── logo.png
```

---

## 5. Configurar JavaFX y SQLite en pom.xml

Abrir:

```text
pom.xml
```

Agregar:

```xml
<dependencies>

    <dependency>
        <groupId>org.openjfx</groupId>
        <artifactId>javafx-controls</artifactId>
        <version>21</version>
    </dependency>

    <dependency>
        <groupId>org.openjfx</groupId>
        <artifactId>javafx-fxml</artifactId>
        <version>21</version>
    </dependency>

    <dependency>
        <groupId>org.xerial</groupId>
        <artifactId>sqlite-jdbc</artifactId>
        <version>3.50.3.0</version>
    </dependency>

</dependencies>
```

---

## 6. Configurar plugin JavaFX

Agregar dentro de `pom.xml`:

```xml
<build>
    <plugins>

        <plugin>
            <groupId>org.openjfx</groupId>
            <artifactId>javafx-maven-plugin</artifactId>
            <version>0.0.8</version>

            <configuration>
                <mainClass>
                    app.Main
                </mainClass>
            </configuration>

        </plugin>

    </plugins>
</build>
```

---

## 7. Configurar plugin GraalVM / GluonFX (opcional)

Permite generar ejecutables nativos más adelante.

Agregar dentro de `<plugins>`:

```xml
<plugin>
    <groupId>com.gluonhq</groupId>
    <artifactId>gluonfx-maven-plugin</artifactId>
    <version>1.0.28</version>

    <configuration>
        <mainClass>app.Main</mainClass>

        <reflectionList>
            <list>controlador.ProductoController</list>
            <list>controlador.VentaController</list>
        </reflectionList>

    </configuration>
</plugin>
```

---

## 8. Crear Main.java

Ruta:

```text
src/main/java/app/Main.java
```

Código:

```java
package app;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage stage) throws Exception {

        FXMLLoader loader = new FXMLLoader(
                Main.class.getResource("/vista/VentaView.fxml")
        );

        Scene scene = new Scene(loader.load());

        scene.getStylesheets().add(
                Main.class.getResource("/css/styles.css")
                        .toExternalForm()
        );

        stage.setTitle("Sistema de Ventas");
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}
```

---

## 9. Conexión SQLite recomendada

Ruta:

```text
src/main/java/dao/ConexionSQLite.java
```

Código:

```java
package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionSQLite {

    private static final String URL =
            "jdbc:sqlite:data/ventas.db";

    public static Connection conectar() throws Exception {
        return DriverManager.getConnection(URL);
    }
}
```

---

## 10. Ejecutar proyecto

Desde IntelliJ IDEA:

```text
Run → Main
```

o desde terminal:

```bash
mvn javafx:run
```

---

## 11. Compilar nativo (opcional)

```bash
mvn gluonfx:build
```

Ejecutar nativo:

```bash
mvn gluonfx:nativerun
```

---

# Stack del curso

```text
Java
+ JavaFX
+ MVC
+ DAO
+ SQLite
+ Maven
+ IntelliJ IDEA
+ GraalVM (opcional)
```

---

# Organización conceptual

```text
modelo       → clases y objetos
vista        → interfaces FXML
controlador  → eventos y acciones
dao          → persistencia SQLite
util         → reutilización
resources    → recursos externos
data         → base de datos local
```