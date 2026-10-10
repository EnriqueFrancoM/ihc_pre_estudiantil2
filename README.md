# UniBudget - Presupuesto Estudiantil

App móvil para que estudiantes organicen sus ingresos y gastos.
Esta entrega (Tarea 1) implementa todo el manejo de acceso: registro, inicio y cierre de sesión, recuperación de contraseña, sesión conservada, una ruta pública y una ruta privada ("Mis movimientos").

## Tecnologías

- **App:** Flutter (Dart), probada en el emulador de Android Studio (Pixel 6a)
- **API:** Node.js + Express
- **Base de datos:** PostgreSQL

```
App Flutter  →  API (servidor/)  →  PostgreSQL
```

## Requisitos

- Flutter y Dart
- Android Studio con un emulador Android
- Node.js (v18 o superior)
- PostgreSQL

## Cómo iniciar el proyecto

### 1. Base de datos

En pgAdmin (o `psql`) crea la base y las tablas:

```sql
CREATE DATABASE presupuesto_estudiantil;
```

Conéctate a esa base y ejecuta el contenido de `base_datos/esquema.sql`.

### 2. Servidor (API)

```powershell
cd servidor
copy .env.example .env
```

Abre `servidor/.env` y escribe tu contraseña de PostgreSQL en `DB_PASSWORD`. Luego:

```powershell
npm install
node semilla.js
node servidor.js
```

- `node semilla.js` carga el usuario de prueba (ver más abajo).
- `node servidor.js` deja la API en `http://localhost:3000`. Déjala corriendo.
- Comprobación: abrir `http://localhost:3000/ping` debe mostrar `{"mensaje":"Servidor funcionando"}`.

### 3. App Flutter

Con el emulador de Android encendido, desde la raíz del proyecto:

```powershell
flutter pub get
flutter run
```

La app se conecta a `http://10.0.2.2:3000` (en el emulador, `10.0.2.2` es el `localhost` de la PC). Esta dirección está en `lib/configuracion/constantes.dart`.

## Usuario de prueba (semilla)

| Correo | Contraseña |
|---|---|
| prueba@correo.com | 123456 |

## Recuperación de contraseña

No se envía correo real. Al pedir el código, la app lo muestra en pantalla (6 dígitos, válido 15 minutos).

## Pruebas unitarias

Desde la raíz del proyecto:

```powershell
flutter test
```

Las pruebas están en `test/movimiento_test.dart` y verifican el estado inicial, la transición `pendiente → pagado`, el rechazo de una transición inválida y que los demás datos se conserven.

> Si ya tenías la base creada, ejecuta también la tabla `movimientos` de `base_datos/esquema.sql`.

## Documentación

Decisiones y archivos principales: [`docs/task-01-access.md`](docs/task-01-access.md)