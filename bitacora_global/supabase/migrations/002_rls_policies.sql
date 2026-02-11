-- =====================================================
-- BITÁCORA DIGITAL - Políticas de Seguridad RLS
-- Migración: 002_rls_policies.sql
-- =====================================================

-- Habilitar Row Level Security en todas las tablas
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.instituciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bitacoras ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lista_proveedores ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLÍTICAS PARA: users
-- =====================================================

-- Los usuarios pueden ver su propio perfil
CREATE POLICY "users_select_own" ON public.users
    FOR SELECT
    USING (auth.uid() = id);

-- Los administradores pueden ver todos los usuarios
CREATE POLICY "users_select_admin" ON public.users
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );

-- Los usuarios pueden actualizar su propio perfil
CREATE POLICY "users_update_own" ON public.users
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Solo administradores pueden crear/eliminar usuarios
CREATE POLICY "users_insert_admin" ON public.users
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
        OR NOT EXISTS (SELECT 1 FROM public.users) -- Primer usuario
    );

CREATE POLICY "users_delete_admin" ON public.users
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );

-- =====================================================
-- POLÍTICAS PARA: instituciones
-- =====================================================

-- Usuarios ven instituciones asignadas a ellos
CREATE POLICY "instituciones_select_assigned" ON public.instituciones
    FOR SELECT
    USING (
        id = ANY(
            SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );

-- Solo administradores modifican instituciones
CREATE POLICY "instituciones_insert_admin" ON public.instituciones
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );

CREATE POLICY "instituciones_update_admin" ON public.instituciones
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );

CREATE POLICY "instituciones_delete_admin" ON public.instituciones
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );

-- =====================================================
-- POLÍTICAS PARA: bitacoras
-- =====================================================

-- Usuarios ven bitácoras de instituciones asignadas
CREATE POLICY "bitacoras_select" ON public.bitacoras
    FOR SELECT
    USING (
        institucion_id = ANY(
            SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol IN ('administrador', 'jefe_seguridad')
        )
    );

-- Vigilantes y superiores pueden crear bitácoras
CREATE POLICY "bitacoras_insert" ON public.bitacoras
    FOR INSERT
    WITH CHECK (
        institucion_id = ANY(
            SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid()
        )
    );

-- Vigilantes pueden actualizar bitácoras de sus instituciones
CREATE POLICY "bitacoras_update" ON public.bitacoras
    FOR UPDATE
    USING (
        institucion_id = ANY(
            SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid()
        )
    );

-- Solo administradores pueden eliminar bitácoras
CREATE POLICY "bitacoras_delete_admin" ON public.bitacoras
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );

-- =====================================================
-- POLÍTICAS PARA: lista_proveedores
-- =====================================================

-- Todos pueden ver proveedores (catálogo público)
CREATE POLICY "lista_proveedores_select" ON public.lista_proveedores
    FOR SELECT
    USING (true);

-- Solo administradores modifican proveedores
CREATE POLICY "lista_proveedores_modify_admin" ON public.lista_proveedores
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() AND u.rol = 'administrador'
        )
    );
