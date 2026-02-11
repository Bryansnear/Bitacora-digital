# Bitácora Digital — Estado de Migración Firebase → Supabase

## Proyecto Supabase

| Campo | Valor |
|-------|-------|
| **Project ID** | `daldtoaoqaxyiqgkfoin` |
| **URL** | `https://daldtoaoqaxyiqgkfoin.supabase.co` |
| **Región** | us-east-2 |
| **Estado** | ACTIVE_HEALTHY |

---

## ✅ Completado

### 1. Base de datos (SQL Migrations)

Se aplicaron 4 migraciones al proyecto Supabase:

| Migración | Contenido |
|-----------|-----------|
| `001_initial_schema` | Tablas `users`, `instituciones`, `bitacoras`, `lista_proveedores` + triggers + auth hook |
| `002_rls_policies` | Políticas RLS para las 4 tablas iniciales |
| `003_storage` | Buckets `bitacora-fotos` (privado, 5MB) y `user-avatars` (público, 2MB) + políticas |
| `004_backend_rpcs_and_normalization` | Tablas `sucursales`, `novedades`, `visitas`, `vehiculos`, `proveedores_visitas` + 11 RPCs + RLS |

**9 tablas** con RLS habilitado, **11 RPCs**, **2 buckets** de storage.

### 2. Configuración Dart

- `lib/core/supabase_config.dart` — Actualizado con URL y anon key del nuevo proyecto.

### 3. Pantallas nuevas (Supabase puro)

| Pantalla | Ruta | Descripción |
|----------|------|-------------|
| `LoginScreen` | `/login` | Login con email/contraseña vía Supabase Auth |
| `ForgotPasswordScreen` | `/forgot-password` | Recuperación de contraseña (`resetPasswordForEmail`) |
| `SetupScreen` | `/setup` | Configuración inicial del proyecto |
| `HomeGuardiaScreen` | `/guardia` | Pantalla principal del guardia con 6 acciones rápidas |
| `AperturaScreen` | `/guardia/apertura` | Registro de apertura de turno |
| `RegistroScreen` | `/guardia/registro` | Registro de visitas (con pertenencias), vehículos y proveedores |
| `NovedadScreen` | `/guardia/novedad` | Registro de novedades |
| `CierreScreen` | `/guardia/cierre` | Cierre de turno |
| `VisitasAllScreen` | `/guardia/visitasall` | Listado de visitas/vehículos/proveedores con "marcar salida" |
| `SupervisionRelevoScreen` | `/guardia/supervision` | Registro de supervisión y relevo de guardia |
| `DashboardScreen` | `/admin` | Panel administrativo con vista de instituciones y bitácoras |
| `BitacoraDetailScreen` | `/admin/bitacora/:id` | Detalle completo de una bitácora |
| `InstitucionesScreen` | `/admin/instituciones` | CRUD de instituciones |
| `SucursalesScreen` | `/admin/sucursales/:id` | CRUD de sucursales por institución |
| `VigilantesScreen` | `/admin/vigilantes` | Gestión de usuarios (crear, editar, cambiar rol, asignar instituciones) |
| `ProfileScreen` | `/perfil` | Perfil del usuario |

### 4. Servicios (capa de datos)

| Servicio | Métodos |
|----------|---------|
| `BitacoraService` | 33 métodos — streams, CRUD bitácoras, RPCs de flujo de guardia, CRUD instituciones, CRUD sucursales, gestión de salidas, supervisión/relevo |
| `StorageService` | Upload de fotos a Supabase Storage |
| `AuthService` | Autenticación con Supabase Auth |
| `FunctionsService` | Invocación de Edge Functions |

### 5. Providers (estado)

| Provider | Función |
|----------|---------|
| `AuthProvider` | Estado de autenticación, login/logout, perfil de usuario |
| `BitacoraProvider` | Estado del turno activo (institución, sucursal, bitácora) |

### 6. Router (`app_router.dart`)

GoRouter configurado con 16 rutas, redirección automática según autenticación y rol.

---

## ⏳ Pendiente

### Alta prioridad

1. **Migrar las ~30 pantallas FlutterFlow antiguas** (`lib/pages/`, `lib/inicio/`, `lib/cruds/`, `lib/consolidadoo/`)
   - Estas pantallas aún importan `backend/backend.dart` (Firestore) y `auth/firebase_auth/auth_util.dart`
   - Cada una debe migrarse a usar `BitacoraService` + `AuthProvider` en lugar de Firebase

2. **Limpiar `flutter_flow_util.dart`**
   - Línea 3: `import 'package:cloud_firestore/cloud_firestore.dart'`
   - Línea 31-32: `export 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference, FirebaseFirestore`
   - Solo se puede limpiar cuando ninguna pantalla antigua lo necesite

3. **Eliminar paquetes Firebase de `pubspec.yaml`** (18 paquetes)
   - `cloud_firestore`, `cloud_functions`, `firebase_auth`, `firebase_core`, `firebase_performance`, `firebase_storage` (+ sus `_platform_interface` y `_web`)
   - Bloqueado hasta que todas las pantallas antiguas estén migradas

### Media prioridad

4. **Eliminar directorios Firebase**
   - `lib/backend/` — Queries Firestore, records, structs, Firebase Storage wrapper
   - `lib/auth/firebase_auth/` — 9 archivos de autenticación Firebase
   - `firebase/` (raíz) — Config Firebase, rules, Cloud Functions

5. **Migrar `lib/flutter_flow/upload_data.dart`**
   - Importa `auth/firebase_auth/auth_util.dart` — cambiar a Supabase auth

6. **Migrar `lib/flutter_flow/nav/nav.dart` y `serialization_util.dart`**
   - Importan `backend/backend.dart` y `schema/enums`

7. **Refactorizar `FFAppState` (`app_state.dart`)**
   - Clase con naming FlutterFlow, usada por ~30 archivos vía `context.watch<FFAppState>()`
   - Renombrar a `AppState` o integrar en los providers existentes

### Baja prioridad

8. **Eliminar `google_sign_in`** de pubspec si ya no se usa Google Sign-In
9. **Probar en dispositivo** — Verificar flujo completo: login → selección → turno → registros → cierre
10. **Edge Functions** — Desplegar funciones serverless si se necesitan (notificaciones push, reportes PDF, etc.)
11. **Data migration** — Si hay datos existentes en Firestore, migrarlos al nuevo proyecto Supabase

---

## Arquitectura actual

```
lib/
├── core/               ← Supabase config, router, initializer (LIMPIO)
├── models/             ← Modelos Dart puros (LIMPIO)
├── providers/          ← AuthProvider, BitacoraProvider (LIMPIO)
├── services/           ← BitacoraService, StorageService, etc. (LIMPIO)
├── screens/            ← 16 pantallas nuevas Supabase (LIMPIO)
│   ├── auth/           ← login, setup, forgot_password
│   ├── guardia/        ← home, apertura, registro, novedad, cierre, visitasall, supervision
│   ├── admin/          ← dashboard, bitacora_detail, instituciones, sucursales, vigilantes
│   └── shared/         ← profile
├── data/               ← structs.dart (reemplazo de backend/schema/structs)
├── utils/              ← Utilidades (image_utils, etc.)
├── widgets/            ← Widgets compartidos
│
├── flutter_flow/       ← Utilidades FlutterFlow (theme, widgets, animations) — MANTENER
├── pages/              ← Pantallas antiguas FlutterFlow — MIGRAR O ELIMINAR
├── inicio/             ← Pantallas antiguas FlutterFlow — MIGRAR O ELIMINAR
├── cruds/              ← Pantallas antiguas FlutterFlow — MIGRAR O ELIMINAR
├── consolidadoo/       ← Pantallas antiguas FlutterFlow — MIGRAR O ELIMINAR
├── components/         ← Componentes FlutterFlow — MIGRAR O ELIMINAR
├── backend/            ← Firebase/Firestore — ELIMINAR cuando sea posible
└── auth/firebase_auth/ ← Firebase Auth — ELIMINAR cuando sea posible
```

---

*Última actualización: 10 de febrero 2026*

## Actualizacion 11 de febrero de 2026 (listo para prueba)

- Corregida navegacion post-setup: `lib/pages/setup_admin_page.dart` ya no envia a `'/inicio'` (ruta legacy), ahora usa `context.go('/')`.
- Alineado `routePath` de `SetupAdminPage` a `'/setup'`.
- Alineado `AppInitializer.initialRoute` a rutas actuales del router (`'/setup'`, `'/'`, `'/login'`).
- Validado que el flujo activo (`lib/core`, `lib/screens`, `lib/providers`, `lib/services`) no importa Firebase/Firestore.

### Bloqueador operativo detectado en este entorno

- La CLI de Flutter no esta disponible en PATH (`flutter` no se reconoce), por lo que no fue posible ejecutar `flutter analyze` ni `flutter run` aqui.

### Comando sugerido para prueba en maquina con Flutter configurado

```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

*Ultima actualizacion efectiva: 11 de febrero 2026*
