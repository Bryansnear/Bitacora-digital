-- =====================================================
-- BITÁCORA DIGITAL - Esquema Inicial PostgreSQL
-- Migración: 001_initial_schema.sql
-- =====================================================

-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLA: users (Usuarios del sistema)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    display_name TEXT,
    photo_url TEXT,
    phone_number TEXT,
    cedula TEXT,
    rol TEXT DEFAULT 'vigilante' CHECK (rol IN ('administrador', 'jefe_seguridad', 'vigilante')),
    instituciones UUID[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para búsquedas frecuentes
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_rol ON public.users(rol);

-- =====================================================
-- TABLA: instituciones (Bancos, empresas, etc.)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.instituciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    tipo TEXT,
    -- Sucursales como JSONB array con estructura compleja
    -- Cada sucursal: { estado, sucursalCiudad, foto, ubicacion, idSucursal, proveedores, etc. }
    sucursales JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_instituciones_nombre ON public.instituciones(nombre);

-- =====================================================
-- TABLA: bitacoras (Registro diario de operaciones)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.bitacoras (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    institucion_id UUID NOT NULL REFERENCES public.instituciones(id) ON DELETE CASCADE,
    
    -- Información de la sucursal
    sucursal TEXT,
    
    -- Datos de apertura
    vigilante_apertura TEXT,
    fecha_hora_apertura TIMESTAMPTZ,
    encargado_apertura TEXT,
    encargado_desalarmado TEXT,
    foto_apertura TEXT,
    novedad_apertura TEXT,
    
    -- Datos de cierre
    vigilante_cierre TEXT,
    fecha_hora_cierre TIMESTAMPTZ,
    encargado_cierre TEXT,
    encargado_alarmado TEXT,
    novedad_cierre TEXT,
    novedad_cierre_total TEXT,
    
    -- Horarios específicos
    hora_llegada_vigilante TIMESTAMPTZ,
    hora_salida_vigilante TIMESTAMPTZ,
    hora_llegada_cajeros TIMESTAMPTZ,
    hora_llegada_oficinas TIMESTAMPTZ,
    hora_atencion_publico_cajeros TIMESTAMPTZ,
    hora_apertura_total TIMESTAMPTZ,
    hora_cierre_total TIMESTAMPTZ,
    
    -- Listas de registros (JSONB para flexibilidad)
    -- Visitas: [{ nombre, cedula, motivo, hora_entrada, hora_salida, foto }]
    visitas JSONB DEFAULT '[]',
    
    -- Novedades: [{ tipo, descripcion, foto, fecha_hora }]
    novedades JSONB DEFAULT '[]',
    
    -- Vehículos: [{ placa, tipo, conductor, hora_entrada, hora_salida, foto }]
    vehiculos JSONB DEFAULT '[]',
    
    -- Proveedores: [{ nombre, empresa, motivo, hora_entrada, hora_salida, foto }]
    proveedores JSONB DEFAULT '[]',
    
    -- ATMs: [{ id, estado, billetes, hora_revision }]
    lista_atm JSONB DEFAULT '[]',
    
    -- Supervisión: { supervisor, hora, observaciones }
    supervision JSONB DEFAULT '{}',
    
    -- Relevo: { vigilante_entrante, vigilante_saliente, hora, observaciones }
    relevo JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para consultas frecuentes
CREATE INDEX idx_bitacoras_institucion ON public.bitacoras(institucion_id);
CREATE INDEX idx_bitacoras_sucursal ON public.bitacoras(sucursal);
CREATE INDEX idx_bitacoras_fecha ON public.bitacoras(fecha_hora_apertura);
CREATE INDEX idx_bitacoras_vigilante ON public.bitacoras(vigilante_apertura);

-- =====================================================
-- TABLA: lista_proveedores (Catálogo de proveedores)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.lista_proveedores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    telefono TEXT,
    imagen TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_lista_proveedores_nombre ON public.lista_proveedores(nombre);

-- =====================================================
-- FUNCIÓN: Actualizar timestamp automáticamente
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_instituciones_updated_at
    BEFORE UPDATE ON public.instituciones
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bitacoras_updated_at
    BEFORE UPDATE ON public.bitacoras
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNCIÓN: Crear usuario al registrarse (Auth Hook)
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, display_name, photo_url)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.raw_user_meta_data->>'full_name'),
        NEW.raw_user_meta_data->>'avatar_url'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para crear perfil automáticamente
CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
