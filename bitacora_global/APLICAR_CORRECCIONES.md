# 🔧 Guía de Aplicación de Correcciones

## Problema Reportado

El usuario reportó dos problemas principales:
1. **Las instituciones nuevas no aparecen después de crearlas**
2. **El botón "Agregar Sucursal" no funciona** (no hace nada al presionarlo)

## Causas Identificadas

### 1. Missing `.select()` en operaciones de inserción
Sin `.select()`, Supabase no confirma correctamente la inserción y los streams de realtime pueden no detectar el cambio.

### 2. Políticas RLS demasiado restrictivas
La política `sucursales_modify_admin` solo permitía a administradores crear/editar sucursales, bloqueando a usuarios regulares.

## ✅ Correcciones Aplicadas

### Cambios en el Código

#### `lib/services/bitacora_service.dart`

1. **Línea 138-143**: Agregado `.select()` a `createInstitucion()`
   ```dart
   await _client.from('instituciones').insert({
     'nombre': nombre,
     'tipo': tipo,
   }).select();  // ← Agregado
   ```

2. **Línea 160-175**: Agregado `.select()` y campo `estado` a `createSucursal()`
   ```dart
   final data = <String, dynamic>{
     'institucion_id': institucionId,
     'nombre': nombre,
     'estado': 'activa',  // ← Agregado
   };
   // ... resto del código
   await _client.from('sucursales').insert(data).select();  // ← Agregado
   ```

### Nueva Migración de Base de Datos

**Archivo**: `supabase/migrations/007_fix_sucursales_rls.sql`

Esta migración corrige las políticas RLS para permitir que usuarios asignados a instituciones puedan crear y editar sucursales.

## 📋 Pasos para Aplicar las Correcciones

### Paso 1: Actualizar el Código (Ya Hecho en este PR)

El código ya está actualizado en la rama `copilot/delegate-to-cloud-agent`. Simplemente acepta el PR.

### Paso 2: Aplicar la Migración en Supabase

**IMPORTANTE**: Este paso es CRÍTICO para que el botón de "Agregar Sucursal" funcione.

#### Opción A: Desde el Dashboard (Más Fácil)

1. Ve a tu proyecto en [supabase.com](https://supabase.com/dashboard)
2. Click en **SQL Editor** en el menú lateral
3. Click en **New query**
4. Abre el archivo `bitacora_global/supabase/migrations/007_fix_sucursales_rls.sql`
5. Copia y pega todo el contenido en el editor SQL
6. Click en **Run** (o presiona Ctrl+Enter)
7. Deberías ver: ✅ Success. No rows returned

#### Opción B: Usando Supabase CLI

```bash
cd bitacora_global
supabase db push
```

### Paso 3: Verificar que Funciona

#### Prueba 1: Crear Institución
1. Login como administrador
2. Ve a "Gestión de Instituciones"
3. Click en "Nueva Institución"
4. Llena el formulario y guarda
5. ✅ La institución debe aparecer inmediatamente en la lista (sin recargar)

#### Prueba 2: Crear Sucursal
1. Login como administrador
2. Ve a una institución y click en "Sucursales"
3. Click en "Nueva Sucursal"
4. Llena el formulario y guarda
5. ✅ La sucursal debe aparecer inmediatamente en la lista (sin recargar)

#### Prueba 3: Real-time Updates (Opcional pero Cool)
1. Abre la app en dos ventanas/dispositivos diferentes
2. En una ventana, crea una institución o sucursal
3. ✅ Debe aparecer automáticamente en la otra ventana (magia de Firebase-like behavior!)

## 🔍 Solución de Problemas

### "Permission denied" al crear sucursal

**Causa**: No aplicaste la migración 007

**Solución**:
1. Ejecuta la migración como se describe arriba
2. Si ya la ejecutaste, verifica que tu usuario tenga:
   - `rol = 'administrador'` en la tabla `users`, O
   - El UUID de la institución en el array `instituciones` del usuario

**Verificar**:
```sql
-- En SQL Editor de Supabase
SELECT id, email, rol, instituciones 
FROM users 
WHERE id = auth.uid();
```

### Las instituciones/sucursales no aparecen automáticamente

**Causa**: Falta la migración 006 o el realtime no está habilitado

**Solución**:
1. Verifica que ejecutaste TODAS las migraciones (001-007)
2. En Dashboard → Database → Replication, verifica que las tablas estén en `supabase_realtime`
3. Si no están, ejecuta `006_enable_realtime.sql`

### "Function not found: is_admin"

**Causa**: No ejecutaste la migración 005

**Solución**: 
1. Ejecuta las migraciones en orden: 001 → 002 → 003 → 004 → **005** → 006 → 007
2. La migración 005 crea las funciones helper necesarias

## 📚 Documentación Adicional

### Real-time Updates (Cómo Funciona)

La aplicación usa **Supabase Realtime** para actualizaciones automáticas:

1. **Streaming**: Los servicios usan `.stream(primaryKey: ['id'])` en lugar de `.select()`
2. **StreamBuilder**: Los widgets se reconstruyen automáticamente cuando los datos cambian
3. **Publicación**: La migración 006 habilita la publicación de cambios en tiempo real

No necesitas hacer polling ni refrescar manualmente. Los cambios se propagan automáticamente a todos los clientes conectados.

### Políticas RLS Aplicadas

Después de la migración 007:

| Operación | Quién puede hacerla |
|-----------|---------------------|
| Ver sucursales | Todos (policy: `sucursales_select`) |
| Crear sucursal | Admin + usuarios asignados a la institución |
| Editar sucursal | Admin + usuarios asignados a la institución |
| Eliminar sucursal | Solo administradores |

### Asignar Usuarios a Instituciones

Para que un usuario pueda crear sucursales en una institución:

```sql
-- Obtener el UUID de la institución
SELECT id, nombre FROM instituciones;

-- Actualizar el array de instituciones del usuario
UPDATE users 
SET instituciones = instituciones || ARRAY['UUID_DE_LA_INSTITUCION']::UUID[]
WHERE email = 'usuario@ejemplo.com';
```

## ✨ Resultado Final

Después de aplicar estos cambios:

✅ Los administradores pueden crear instituciones y sucursales
✅ Los usuarios asignados a una institución pueden crear sus sucursales
✅ Los cambios aparecen automáticamente sin recargar (Firebase-like)
✅ Los errores se manejan correctamente con mensajes informativos
✅ Las políticas de seguridad (RLS) están correctamente configuradas

## 🆘 ¿Necesitas Ayuda?

Si sigues teniendo problemas:

1. Verifica los logs de Flutter/Dart para ver mensajes de error detallados
2. Revisa `supabase/migrations/README.md` para guía completa de migraciones
3. Verifica `SETUP_SUPABASE.md` para configuración general

## 📝 Notas Técnicas

### ¿Por qué `.select()`?

Sin `.select()`, Supabase ejecuta la inserción pero:
- No retorna confirmación del registro creado
- Los errores pueden ser silenciosos
- Los streams pueden no detectar el cambio inmediatamente

Con `.select()`:
- Confirma que la inserción fue exitosa
- Retorna el registro creado (útil para obtener el ID generado)
- Asegura que los streams detecten el cambio

### ¿Por qué dividir la política "ALL"?

La política anterior:
```sql
CREATE POLICY "sucursales_modify_admin" ON public.sucursales 
FOR ALL USING (public.is_admin());
```

Bloqueaba a todos los no-admins para TODAS las operaciones (INSERT, UPDATE, DELETE).

La nueva estructura:
- **INSERT**: Admin + usuarios asignados ✅
- **UPDATE**: Admin + usuarios asignados ✅
- **DELETE**: Solo admin 🔒 (más seguro)

Esto permite delegar gestión sin comprometer seguridad.
