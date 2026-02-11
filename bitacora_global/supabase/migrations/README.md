# Database Migrations

Este directorio contiene las migraciones SQL para configurar la base de datos de Bitácora Digital en Supabase.

## ⚠️ IMPORTANTE: Ejecutar en Orden

Las migraciones DEBEN ejecutarse en el orden indicado. Cada una depende de las anteriores.

## Lista de Migraciones

### 001_initial_schema.sql
**Propósito**: Crea la estructura inicial de la base de datos
- Tabla `users` con roles (administrador, jefe_seguridad, vigilante)
- Tabla `instituciones` (bancos, empresas, etc.)
- Tabla `bitacoras` (registros de guardias)
- Tablas relacionadas: `visitas`, `vehiculos`, `novedades`, `proveedores_visitas`, `lista_proveedores`

**Ejecutar primero**: ✅

---

### 002_rls_policies.sql
**Propósito**: Políticas de seguridad Row Level Security (RLS) iniciales
- Define quién puede ver/crear/editar cada registro
- Administradores tienen acceso completo
- Usuarios solo ven instituciones asignadas a ellos
- Vigilantes solo ven bitácoras de sus instituciones

**Ejecutar después de**: 001

---

### 003_storage.sql
**Propósito**: Configuración del almacenamiento de archivos
- Buckets para fotos de bitácoras
- Políticas de acceso a archivos
- Límites de tamaño y tipos permitidos

**Ejecutar después de**: 002

---

### 004_backend_rpcs_and_normalization.sql
**Propósito**: Funciones RPC y normalización de datos
- Crea tabla `sucursales` normalizada (separada de instituciones)
- Funciones RPC para flujos complejos:
  - `rpc_llegada_vigilante` - Registrar inicio de guardia
  - `rpc_salida_vigilante` - Registrar salida de guardia
  - `rpc_registrar_apertura` - Apertura de sucursal
  - `rpc_registrar_cierre` - Cierre de sucursal
- Migración de datos de JSONB a tablas normalizadas

**Ejecutar después de**: 003

---

### 005_fix_rls_infinite_recursion.sql
**Propósito**: Corrige recursión infinita en políticas RLS
- Crea funciones helper `SECURITY DEFINER`:
  - `is_admin()` - Verifica si el usuario es administrador
  - `is_admin_or_jefe()` - Verifica si es admin o jefe de seguridad
  - `auth_user_instituciones()` - Obtiene instituciones del usuario
- Recrea todas las políticas RLS usando estas funciones
- Habilita RLS en tablas normalizadas (sucursales, novedades, visitas, etc.)

**Ejecutar después de**: 004

**⚠️ Crítica**: Sin esta migración, las políticas RLS pueden causar recursión infinita y bloquear toda la base de datos.

---

### 006_enable_realtime.sql
**Propósito**: Habilita actualizaciones en tiempo real (Firebase-like)
- Agrega todas las tablas a la publicación `supabase_realtime`
- Permite que los cambios en la base de datos se reflejen automáticamente en la aplicación
- No es necesario recargar la página para ver nuevos registros

**Ejecutar después de**: 005

**✨ Funcionalidad clave**: Después de esta migración, cuando un usuario crea una institución o sucursal, todos los usuarios conectados verán el cambio inmediatamente.

---

### 007_fix_sucursales_rls.sql
**Propósito**: Corrige permisos para gestión de sucursales
- **Problema corregido**: La política anterior solo permitía a administradores modificar sucursales
- **Solución**: Permite a usuarios asignados a una institución crear/editar sus sucursales
- Divide la política "ALL" en políticas separadas:
  - `sucursales_insert` - Admins y usuarios asignados pueden crear
  - `sucursales_update` - Admins y usuarios asignados pueden editar
  - `sucursales_delete_admin` - Solo admins pueden eliminar

**Ejecutar después de**: 006

**🐛 Bug fix**: Sin esta migración, el botón "Nueva Sucursal" no funciona para usuarios no-admin.

---

## Cómo Ejecutar las Migraciones

### Opción 1: Desde el Dashboard de Supabase (Recomendado)

1. Ve a tu proyecto en [supabase.com](https://supabase.com)
2. Click en **SQL Editor** en el menú lateral
3. Click en **New query**
4. Copia y pega el contenido de `001_initial_schema.sql`
5. Click en **Run** (o presiona Ctrl+Enter)
6. Repite para cada archivo en orden: 002, 003, 004, 005, 006, 007

### Opción 2: Usando Supabase CLI

```bash
# Instalar CLI
npm install -g supabase

# Login
supabase login

# Vincular tu proyecto
supabase link --project-ref TU_PROJECT_REF

# Ejecutar todas las migraciones
supabase db push
```

---

## Verificar que las Migraciones se Ejecutaron Correctamente

### 1. Verificar Tablas
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

Deberías ver: `users`, `instituciones`, `sucursales`, `bitacoras`, `visitas`, `vehiculos`, `novedades`, `proveedores_visitas`, `lista_proveedores`

### 2. Verificar Funciones Helper
```sql
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name LIKE '%admin%' OR routine_name LIKE '%auth%';
```

Deberías ver: `is_admin`, `is_admin_or_jefe`, `auth_user_instituciones`, `auth_user_role`

### 3. Verificar Realtime
Ve a **Database** → **Replication** y verifica que `supabase_realtime` incluye todas las tablas.

### 4. Verificar Políticas RLS
```sql
SELECT tablename, policyname 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;
```

---

## Solución de Problemas

### Error: "relation does not exist"
- Ejecutaste las migraciones fuera de orden
- Solución: Ejecuta todas las migraciones desde el inicio en orden

### Error: "policy already exists"
- Estás intentando ejecutar una migración por segunda vez
- Solución: Las migraciones incluyen `DROP POLICY IF EXISTS`, deberían ser idempotentes

### Error: "infinite recursion detected"
- No ejecutaste la migración 005
- Solución: Ejecuta `005_fix_rls_infinite_recursion.sql`

### Los cambios no se reflejan en tiempo real
- No ejecutaste la migración 006
- Solución: Ejecuta `006_enable_realtime.sql`
- Verifica en Dashboard → Database → Replication

### No puedo crear sucursales (botón no funciona)
- No ejecutaste la migración 007
- O tu usuario no es admin ni está asignado a la institución
- Solución: Ejecuta `007_fix_sucursales_rls.sql`
- Verifica: `SELECT rol, instituciones FROM users WHERE id = auth.uid();`

---

## Crear el Primer Usuario Administrador

Después de ejecutar todas las migraciones, crea el primer usuario:

```sql
-- En SQL Editor
INSERT INTO public.users (id, email, rol, instituciones, nombre, apellido)
VALUES (
  (SELECT id FROM auth.users WHERE email = 'tu-email@ejemplo.com' LIMIT 1),
  'tu-email@ejemplo.com',
  'administrador',
  '{}',
  'Admin',
  'Principal'
);
```

O regístrate en la app y luego actualiza el rol:

```sql
UPDATE public.users 
SET rol = 'administrador' 
WHERE email = 'tu-email@ejemplo.com';
```
