-- =====================================================
-- BITÁCORA DIGITAL - Configuración de Storage
-- Migración: 003_storage.sql
-- =====================================================

-- Crear bucket para fotos de bitácora
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'bitacora-fotos',
    'bitacora-fotos',
    false,
    5242880, -- 5MB máximo
    ARRAY['image/jpeg', 'image/png', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- Crear bucket para fotos de usuarios
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'user-avatars',
    'user-avatars',
    true, -- Público para mostrar avatares
    2097152, -- 2MB máximo
    ARRAY['image/jpeg', 'image/png', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- POLÍTICAS DE STORAGE
-- =====================================================

-- Política para bitacora-fotos: usuarios autenticados pueden subir
CREATE POLICY "bitacora_fotos_insert" ON storage.objects
    FOR INSERT
    WITH CHECK (
        bucket_id = 'bitacora-fotos' 
        AND auth.role() = 'authenticated'
    );

-- Política para bitacora-fotos: usuarios pueden ver fotos de sus instituciones
CREATE POLICY "bitacora_fotos_select" ON storage.objects
    FOR SELECT
    USING (
        bucket_id = 'bitacora-fotos' 
        AND auth.role() = 'authenticated'
    );

-- Política para user-avatars: cualquiera puede ver (público)
CREATE POLICY "user_avatars_select" ON storage.objects
    FOR SELECT
    USING (bucket_id = 'user-avatars');

-- Política para user-avatars: usuarios suben su propio avatar
CREATE POLICY "user_avatars_insert" ON storage.objects
    FOR INSERT
    WITH CHECK (
        bucket_id = 'user-avatars' 
        AND auth.role() = 'authenticated'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Política para user-avatars: usuarios actualizan/eliminan su propio avatar
CREATE POLICY "user_avatars_update" ON storage.objects
    FOR UPDATE
    USING (
        bucket_id = 'user-avatars' 
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

CREATE POLICY "user_avatars_delete" ON storage.objects
    FOR DELETE
    USING (
        bucket_id = 'user-avatars' 
        AND (storage.foldername(name))[1] = auth.uid()::text
    );
