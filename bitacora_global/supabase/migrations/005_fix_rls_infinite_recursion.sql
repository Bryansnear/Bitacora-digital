-- =====================================================
-- FIX: Infinite recursion in users RLS policies
-- Crear función SECURITY DEFINER para verificar rol
-- sin pasar por las políticas RLS (evita recursión)
-- =====================================================

-- Función que verifica el rol del usuario actual bypass RLS
CREATE OR REPLACE FUNCTION public.auth_user_role()
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT rol FROM public.users WHERE id = auth.uid();
$$;

-- Función helper: ¿es administrador?
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users WHERE id = auth.uid() AND rol = 'administrador'
  );
$$;

-- Función helper: ¿es admin o jefe de seguridad?
CREATE OR REPLACE FUNCTION public.is_admin_or_jefe()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users WHERE id = auth.uid() AND rol IN ('administrador', 'jefe_seguridad')
  );
$$;

-- Función helper: obtener instituciones del usuario actual
CREATE OR REPLACE FUNCTION public.auth_user_instituciones()
RETURNS UUID[]
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(instituciones, '{}') FROM public.users WHERE id = auth.uid();
$$;

GRANT EXECUTE ON FUNCTION public.auth_user_role() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin_or_jefe() TO authenticated;
GRANT EXECUTE ON FUNCTION public.auth_user_instituciones() TO authenticated;

-- DROP políticas viejas que causan recursión
DROP POLICY IF EXISTS "users_select_own" ON public.users;
DROP POLICY IF EXISTS "users_select_admin" ON public.users;
DROP POLICY IF EXISTS "users_update_own" ON public.users;
DROP POLICY IF EXISTS "users_insert_admin" ON public.users;
DROP POLICY IF EXISTS "users_delete_admin" ON public.users;
DROP POLICY IF EXISTS "instituciones_select_assigned" ON public.instituciones;
DROP POLICY IF EXISTS "instituciones_insert_admin" ON public.instituciones;
DROP POLICY IF EXISTS "instituciones_update_admin" ON public.instituciones;
DROP POLICY IF EXISTS "instituciones_delete_admin" ON public.instituciones;
DROP POLICY IF EXISTS "bitacoras_select" ON public.bitacoras;
DROP POLICY IF EXISTS "bitacoras_insert" ON public.bitacoras;
DROP POLICY IF EXISTS "bitacoras_update" ON public.bitacoras;
DROP POLICY IF EXISTS "bitacoras_delete_admin" ON public.bitacoras;

-- RECREAR sin recursión (usando funciones SECURITY DEFINER)
CREATE POLICY "users_select_own" ON public.users
    FOR SELECT USING (auth.uid() = id OR public.is_admin());

CREATE POLICY "users_update_own" ON public.users
    FOR UPDATE
    USING (auth.uid() = id OR public.is_admin())
    WITH CHECK (auth.uid() = id OR public.is_admin());

CREATE POLICY "users_insert" ON public.users
    FOR INSERT
    WITH CHECK (
        public.is_admin()
        OR NOT EXISTS (SELECT 1 FROM public.users)
        OR auth.uid() = id
    );

CREATE POLICY "users_delete_admin" ON public.users
    FOR DELETE USING (public.is_admin());

CREATE POLICY "instituciones_select" ON public.instituciones
    FOR SELECT USING (id = ANY(public.auth_user_instituciones()) OR public.is_admin());

CREATE POLICY "instituciones_insert_admin" ON public.instituciones
    FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "instituciones_update_admin" ON public.instituciones
    FOR UPDATE USING (public.is_admin());

CREATE POLICY "instituciones_delete_admin" ON public.instituciones
    FOR DELETE USING (public.is_admin());

CREATE POLICY "bitacoras_select" ON public.bitacoras
    FOR SELECT USING (
        institucion_id = ANY(public.auth_user_instituciones()) OR public.is_admin_or_jefe()
    );

CREATE POLICY "bitacoras_insert" ON public.bitacoras
    FOR INSERT WITH CHECK (
        institucion_id = ANY(public.auth_user_instituciones()) OR public.is_admin()
    );

CREATE POLICY "bitacoras_update" ON public.bitacoras
    FOR UPDATE USING (
        institucion_id = ANY(public.auth_user_instituciones()) OR public.is_admin()
    );

CREATE POLICY "bitacoras_delete_admin" ON public.bitacoras
    FOR DELETE USING (public.is_admin());

-- Fix tablas normalizadas
DROP POLICY IF EXISTS "sucursales_select_own_institucion" ON public.sucursales;
DROP POLICY IF EXISTS "sucursales_modify_admin" ON public.sucursales;
DROP POLICY IF EXISTS "novedades_select_own_bit" ON public.novedades;
DROP POLICY IF EXISTS "novedades_insert_own_bit" ON public.novedades;
DROP POLICY IF EXISTS "visitas_select_own_bit" ON public.visitas;
DROP POLICY IF EXISTS "visitas_insert_own_bit" ON public.visitas;
DROP POLICY IF EXISTS "visitas_update_own_bit" ON public.visitas;
DROP POLICY IF EXISTS "vehiculos_select_own_bit" ON public.vehiculos;
DROP POLICY IF EXISTS "vehiculos_insert_own_bit" ON public.vehiculos;
DROP POLICY IF EXISTS "vehiculos_update_own_bit" ON public.vehiculos;
DROP POLICY IF EXISTS "proveedores_visitas_select_own_bit" ON public.proveedores_visitas;
DROP POLICY IF EXISTS "proveedores_visitas_insert_own_bit" ON public.proveedores_visitas;
DROP POLICY IF EXISTS "proveedores_visitas_update_own_bit" ON public.proveedores_visitas;

CREATE POLICY "sucursales_select" ON public.sucursales FOR SELECT USING (true);
CREATE POLICY "sucursales_modify_admin" ON public.sucursales FOR ALL USING (public.is_admin());
CREATE POLICY "novedades_select" ON public.novedades FOR SELECT USING (true);
CREATE POLICY "novedades_insert" ON public.novedades FOR INSERT WITH CHECK (true);
CREATE POLICY "visitas_select" ON public.visitas FOR SELECT USING (true);
CREATE POLICY "visitas_insert" ON public.visitas FOR INSERT WITH CHECK (true);
CREATE POLICY "visitas_update" ON public.visitas FOR UPDATE USING (true);
CREATE POLICY "vehiculos_select" ON public.vehiculos FOR SELECT USING (true);
CREATE POLICY "vehiculos_insert" ON public.vehiculos FOR INSERT WITH CHECK (true);
CREATE POLICY "vehiculos_update" ON public.vehiculos FOR UPDATE USING (true);
CREATE POLICY "proveedores_visitas_select" ON public.proveedores_visitas FOR SELECT USING (true);
CREATE POLICY "proveedores_visitas_insert" ON public.proveedores_visitas FOR INSERT WITH CHECK (true);
CREATE POLICY "proveedores_visitas_update" ON public.proveedores_visitas FOR UPDATE USING (true);

CREATE OR REPLACE FUNCTION public.app_user_can_access_institucion(p_institucion_id UUID)
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT p_institucion_id = ANY(public.auth_user_instituciones()) OR public.is_admin();
$$;
