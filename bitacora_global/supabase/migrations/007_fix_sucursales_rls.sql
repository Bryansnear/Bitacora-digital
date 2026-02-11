-- ============================================================
-- FIX: Sucursales RLS policies
-- Issue: The current policy only allows admins to modify sucursales
-- Solution: Allow users with access to an institution to manage its sucursales
-- ============================================================

-- Drop the existing restrictive policy
DROP POLICY IF EXISTS "sucursales_modify_admin" ON public.sucursales;

-- Create separate policies for insert, update, and delete
-- Allow admins and users assigned to the parent institution to manage sucursales

-- INSERT: Admins or users assigned to the institution can create sucursales
CREATE POLICY "sucursales_insert" ON public.sucursales
    FOR INSERT
    WITH CHECK (
        public.is_admin()
        OR EXISTS (
            SELECT 1 FROM public.instituciones i
            WHERE i.id = institucion_id
            AND i.id = ANY(public.auth_user_instituciones())
        )
    );

-- UPDATE: Admins or users assigned to the institution can update sucursales
CREATE POLICY "sucursales_update" ON public.sucursales
    FOR UPDATE
    USING (
        public.is_admin()
        OR EXISTS (
            SELECT 1 FROM public.instituciones i
            WHERE i.id = institucion_id
            AND i.id = ANY(public.auth_user_instituciones())
        )
    );

-- DELETE: Only admins can delete sucursales
CREATE POLICY "sucursales_delete_admin" ON public.sucursales
    FOR DELETE
    USING (public.is_admin());
