-- ============================================================
-- Habilitar Supabase Realtime para tablas principales
-- Esto permite que los cambios se reflejen automáticamente
-- en la aplicación sin necesidad de recargar.
-- ============================================================

-- Agregar tablas a la publicación de Realtime de Supabase
-- (supabase_realtime es la publicación por defecto)

-- Primero eliminar la publicación existente y recrearla con todas las tablas
DROP PUBLICATION IF EXISTS supabase_realtime;

CREATE PUBLICATION supabase_realtime FOR TABLE
  public.users,
  public.instituciones,
  public.sucursales,
  public.bitacoras,
  public.visitas,
  public.vehiculos,
  public.novedades,
  public.proveedores_visitas,
  public.lista_proveedores;

-- Nota: Si alguna tabla no existe, elimínala de la lista anterior.
-- Las tablas deben existir antes de ejecutar esta migración.
