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
2. Ejecuta los archivos en orden:
   - `supabase/migrations/001_initial_schema.sql`
   - `supabase/migrations/002_rls_policies.sql`
   - `supabase/migrations/003_storage.sql`

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

### "Permission denied"

- Las políticas RLS pueden estar bloqueando
- Verifica que el usuario tiene las instituciones asignadas

### "Function not found"

- Asegúrate de desplegar las functions con `supabase functions deploy`

---

## Próximos Pasos

1. Configurar el proyecto Supabase
2. Ejecutar las migraciones
3. Actualizar las credenciales en el código
4. Probar la autenticación
5. Migrar datos existentes (si aplica)
