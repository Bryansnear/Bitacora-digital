# Guía de Configuración - Bitácora Digital con Supabase

## Paso 1: Crear Proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com) y crea una cuenta gratuita
2. Crea un nuevo proyecto:
   - **Nombre**: `bitacora-digital`
   - **Password**: (anota esta contraseña, la necesitarás para la base de datos)
   - **Región**: Elige la más cercana (ej: South America - São Paulo)
3. Espera ~2 minutos mientras se crea el proyecto

## Paso 2: Obtener Credenciales

1. Ve a **Settings** → **API**
2. Copia estos valores:
   - **Project URL**: `https://TU_PROYECTO.supabase.co`
   - **Anon public key**: `eyJ...` (la larga)

3. Actualiza `lib/core/supabase_config.dart`:

```dart
static const String supabaseUrl = 'https://TU_PROYECTO.supabase.co';
static const String supabaseAnonKey = 'eyJ...TU_ANON_KEY...';
```

## Paso 3: Ejecutar Migraciones SQL

1. Ve a **SQL Editor** en el dashboard de Supabase
2. Ejecuta los archivos en orden (muy importante el orden):
   - `supabase/migrations/001_initial_schema.sql` - Crea todas las tablas
   - `supabase/migrations/002_rls_policies.sql` - Políticas de seguridad iniciales
   - `supabase/migrations/003_storage.sql` - Configuración de almacenamiento
   - `supabase/migrations/004_backend_rpcs_and_normalization.sql` - Funciones RPC y normalización
   - `supabase/migrations/005_fix_rls_infinite_recursion.sql` - Corrige recursión infinita en RLS
   - `supabase/migrations/006_enable_realtime.sql` - **Habilita actualizaciones en tiempo real**
   - `supabase/migrations/007_fix_sucursales_rls.sql` - Corrige permisos para gestión de sucursales

3. **Importante**: Las migraciones 006 y 007 son críticas para:
   - Permitir que los cambios se reflejen automáticamente sin recargar la página (Firebase-like behavior)
   - Permitir que usuarios asignados a instituciones puedan crear y editar sucursales

## Paso 4: Configurar Autenticación

1. Ve a **Authentication** → **Providers**
2. Habilita **Email** (ya viene habilitado)
3. Para Google Sign-In:
   - Enable Google
   - Configura Client ID y Secret de Google Cloud Console
4. Para Apple Sign-In:
   - Enable Apple
   - Configura según instrucciones de Apple Developer

## Paso 5: Desplegar Edge Functions

```bash
# Instalar Supabase CLI
npm install -g supabase

# Login
supabase login

# Vincular proyecto
supabase link --project-ref TU_PROJECT_REF

# Desplegar functions
supabase functions deploy export-excel
supabase functions deploy calculate-distance
```

## Paso 6: Actualizar pubspec.yaml

Agrega la dependencia de Supabase:

```yaml
dependencies:
  supabase_flutter: ^2.3.0
  http: ^1.2.0
```

Ejecuta:

```bash
flutter pub get
```

## Paso 7: Actualizar main.dart

```dart
import 'package:flutter/material.dart';
import 'core/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase (reemplaza Firebase)
  await SupabaseConfig.initialize();

  runApp(MyApp());
}
```

## Paso 8: Migrar Datos de Firebase (Opcional)

Si tienes datos en Firebase que quieres migrar, usa el script:

```bash
dart run supabase/scripts/migrate_firebase_data.dart
```

---

## Configuración para Móvil

### Android (`android/app/build.gradle`)

```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

### iOS (`ios/Runner/Info.plist`)

Agrega el scheme para deep links:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>io.supabase.bitacora</string>
        </array>
    </dict>
</array>
```

---

## Verificación Rápida

Después de configurar, verifica que todo funciona:

1. **Base de datos**: Ve a Table Editor y verifica que las tablas existan
2. **Auth**: Intenta registrar un usuario de prueba
3. **Storage**: Verifica que los buckets existan
4. **Functions**: En Functions, verifica que estén desplegadas

---

## Problemas Comunes

### "Invalid API key"

- Verifica que copiaste el `anon key` correctamente
- Asegúrate de que no hay espacios extras

### "Permission denied" al crear instituciones o sucursales

- Verifica que ejecutaste TODAS las migraciones en orden, especialmente:
  - `005_fix_rls_infinite_recursion.sql` - Crea las funciones helper necesarias
  - `007_fix_sucursales_rls.sql` - Permite a usuarios crear sucursales
- Para administradores: Verifica que el campo `rol` del usuario sea 'administrador'
- Para otros usuarios: Verifica que el usuario tiene instituciones asignadas en el array `instituciones`
- Consulta para verificar: `SELECT id, email, rol, instituciones FROM users WHERE id = auth.uid();`

### "Function not found"

- Asegúrate de desplegar las functions con `supabase functions deploy`

---

## Funcionalidad en Tiempo Real (Firebase-like)

La aplicación usa **Supabase Realtime** para reflejar cambios automáticamente sin recargar:

### Cómo funciona:

1. La migración `006_enable_realtime.sql` habilita la publicación de cambios para todas las tablas
2. Los servicios usan `stream()` en lugar de `select()` para escuchar cambios en tiempo real:
   ```dart
   // En bitacora_service.dart
   Stream<List<Institucion>> streamInstituciones() {
     return _client
         .from('instituciones')
         .stream(primaryKey: ['id'])
         .order('nombre')
         .map((rows) => rows.map((json) => Institucion.fromJson(json)).toList());
   }
   ```
3. Los widgets usan `StreamBuilder` para actualizarse automáticamente:
   ```dart
   // En instituciones_screen.dart
   StreamBuilder<List<Institucion>>(
     stream: _service.streamInstituciones(),
     builder: (context, snapshot) { ... }
   )
   ```

### Verificar que funciona:

1. Abre la app en dos dispositivos/ventanas
2. Crea una institución o sucursal en una ventana
3. Debe aparecer automáticamente en la otra ventana (sin recargar)

Si no funciona:
- Verifica que ejecutaste la migración `006_enable_realtime.sql`
- En el dashboard de Supabase, ve a **Database** → **Replication** y verifica que las tablas estén en la publicación `supabase_realtime`

---

## Próximos Pasos

1. Configurar el proyecto Supabase
2. Ejecutar TODAS las migraciones en orden (001 a 007)
3. Actualizar las credenciales en el código
4. Crear el primer usuario administrador
5. Probar la autenticación
6. Probar crear instituciones y sucursales
7. Verificar que las actualizaciones en tiempo real funcionan
8. Migrar datos existentes (si aplica)
