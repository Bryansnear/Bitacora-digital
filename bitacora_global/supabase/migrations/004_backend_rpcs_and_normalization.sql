-- =====================================================
-- BITACORA DIGITAL - Backend-first RPC + esquema normalizado
-- Migracion: 004_backend_rpcs_and_normalization.sql
-- =====================================================

-- -----------------------------------------------------
-- Normalizacion basica (compatibilidad con modelos actuales)
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS public.sucursales (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  institucion_id UUID NOT NULL REFERENCES public.instituciones(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  estado TEXT NOT NULL DEFAULT 'Cerrado',
  foto TEXT,
  latitud DOUBLE PRECISION,
  longitud DOUBLE PRECISION,
  radio_metros INTEGER NOT NULL DEFAULT 100,
  bitacora_actual_id UUID REFERENCES public.bitacoras(id) ON DELETE SET NULL,
  vigilante_actual_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  hora_estado TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.bitacoras
  ADD COLUMN IF NOT EXISTS sucursal_id UUID REFERENCES public.sucursales(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS vigilante_apertura_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS vigilante_cierre_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS foto_cierre TEXT;

CREATE TABLE IF NOT EXISTS public.novedades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bitacora_id UUID NOT NULL REFERENCES public.bitacoras(id) ON DELETE CASCADE,
  descripcion TEXT NOT NULL,
  foto TEXT,
  hora TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.visitas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bitacora_id UUID NOT NULL REFERENCES public.bitacoras(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  cedula TEXT,
  motivo TEXT,
  pertenencias TEXT,
  hora_entrada TIMESTAMPTZ DEFAULT NOW(),
  hora_salida TIMESTAMPTZ,
  foto TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.vehiculos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bitacora_id UUID NOT NULL REFERENCES public.bitacoras(id) ON DELETE CASCADE,
  placa TEXT NOT NULL,
  conductor TEXT,
  tipo TEXT,
  nombre TEXT,
  cedula TEXT,
  motivo TEXT,
  hora_entrada TIMESTAMPTZ DEFAULT NOW(),
  hora_salida TIMESTAMPTZ,
  foto TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.proveedores_visitas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bitacora_id UUID NOT NULL REFERENCES public.bitacoras(id) ON DELETE CASCADE,
  proveedor_id UUID REFERENCES public.lista_proveedores(id) ON DELETE SET NULL,
  nombre TEXT NOT NULL,
  empresa TEXT,
  motivo TEXT,
  pertenencias TEXT,
  hora_entrada TIMESTAMPTZ DEFAULT NOW(),
  hora_salida TIMESTAMPTZ,
  foto TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sucursales_institucion ON public.sucursales(institucion_id);
CREATE INDEX IF NOT EXISTS idx_sucursales_bitacora_actual ON public.sucursales(bitacora_actual_id);
CREATE INDEX IF NOT EXISTS idx_novedades_bitacora ON public.novedades(bitacora_id);
CREATE INDEX IF NOT EXISTS idx_visitas_bitacora ON public.visitas(bitacora_id);
CREATE INDEX IF NOT EXISTS idx_vehiculos_bitacora ON public.vehiculos(bitacora_id);
CREATE INDEX IF NOT EXISTS idx_proveedores_visitas_bitacora ON public.proveedores_visitas(bitacora_id);

-- -----------------------------------------------------
-- RLS para tablas normalizadas
-- -----------------------------------------------------

ALTER TABLE public.sucursales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.novedades ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.visitas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehiculos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.proveedores_visitas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS sucursales_select_assigned ON public.sucursales;
CREATE POLICY sucursales_select_assigned ON public.sucursales
FOR SELECT USING (
  institucion_id = ANY(SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid())
  OR EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid() AND u.rol IN ('administrador', 'jefe_seguridad')
  )
);

DROP POLICY IF EXISTS sucursales_update_assigned ON public.sucursales;
CREATE POLICY sucursales_update_assigned ON public.sucursales
FOR UPDATE USING (
  institucion_id = ANY(SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid())
);

DROP POLICY IF EXISTS novedades_select_assigned ON public.novedades;
CREATE POLICY novedades_select_assigned ON public.novedades
FOR SELECT USING (
  EXISTS (
    SELECT 1
    FROM public.bitacoras b
    WHERE b.id = novedades.bitacora_id
      AND (
        b.institucion_id = ANY(SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid())
        OR EXISTS (
          SELECT 1 FROM public.users u
          WHERE u.id = auth.uid() AND u.rol IN ('administrador', 'jefe_seguridad')
        )
      )
  )
);

DROP POLICY IF EXISTS novedades_insert_assigned ON public.novedades;
CREATE POLICY novedades_insert_assigned ON public.novedades
FOR INSERT WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.bitacoras b
    WHERE b.id = novedades.bitacora_id
      AND b.institucion_id = ANY(SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid())
  )
);

DROP POLICY IF EXISTS visitas_select_assigned ON public.visitas;
CREATE POLICY visitas_select_assigned ON public.visitas
FOR SELECT USING (
  EXISTS (
    SELECT 1
    FROM public.bitacoras b
    WHERE b.id = visitas.bitacora_id
      AND (
        b.institucion_id = ANY(SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid())
        OR EXISTS (
          SELECT 1 FROM public.users u
          WHERE u.id = auth.uid() AND u.rol IN ('administrador', 'jefe_seguridad')
        )
      )
  )
);

DROP POLICY IF EXISTS vehiculos_select_assigned ON public.vehiculos;
CREATE POLICY vehiculos_select_assigned ON public.vehiculos
FOR SELECT USING (
  EXISTS (
    SELECT 1
    FROM public.bitacoras b
    WHERE b.id = vehiculos.bitacora_id
      AND (
        b.institucion_id = ANY(SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid())
        OR EXISTS (
          SELECT 1 FROM public.users u
          WHERE u.id = auth.uid() AND u.rol IN ('administrador', 'jefe_seguridad')
        )
      )
  )
);

DROP POLICY IF EXISTS proveedores_visitas_select_assigned ON public.proveedores_visitas;
CREATE POLICY proveedores_visitas_select_assigned ON public.proveedores_visitas
FOR SELECT USING (
  EXISTS (
    SELECT 1
    FROM public.bitacoras b
    WHERE b.id = proveedores_visitas.bitacora_id
      AND (
        b.institucion_id = ANY(SELECT unnest(instituciones) FROM public.users WHERE id = auth.uid())
        OR EXISTS (
          SELECT 1 FROM public.users u
          WHERE u.id = auth.uid() AND u.rol IN ('administrador', 'jefe_seguridad')
        )
      )
  )
);

-- -----------------------------------------------------
-- Helper de permisos para RPC
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION public.app_user_can_access_institucion(p_institucion_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.users u
    WHERE u.id = auth.uid()
      AND (
        p_institucion_id = ANY(u.instituciones)
        OR u.rol IN ('administrador', 'jefe_seguridad')
      )
  );
$$;

-- -----------------------------------------------------
-- RPCs de negocio (backend-first)
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION public.rpc_llegada_vigilante(
  p_institucion_id UUID,
  p_sucursal_id UUID,
  p_vigilante_id UUID
)
RETURNS SETOF public.bitacoras
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_bitacora public.bitacoras%ROWTYPE;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'No autenticado';
  END IF;

  IF NOT public.app_user_can_access_institucion(p_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la institucion';
  END IF;

  INSERT INTO public.bitacoras (
    institucion_id,
    sucursal_id,
    vigilante_apertura_id,
    vigilante_apertura,
    fecha_hora_apertura,
    hora_llegada_vigilante
  )
  VALUES (
    p_institucion_id,
    p_sucursal_id,
    p_vigilante_id,
    p_vigilante_id::text,
    NOW(),
    NOW()
  )
  RETURNING * INTO v_bitacora;

  UPDATE public.sucursales
  SET bitacora_actual_id = v_bitacora.id,
      vigilante_actual_id = p_vigilante_id,
      estado = 'Abierto',
      hora_estado = NOW(),
      updated_at = NOW()
  WHERE id = p_sucursal_id
    AND institucion_id = p_institucion_id;

  RETURN QUERY SELECT * FROM public.bitacoras WHERE id = v_bitacora.id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_salida_vigilante(
  p_bitacora_id UUID,
  p_sucursal_id UUID
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.bitacoras b
  WHERE b.id = p_bitacora_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Bitacora no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la bitacora';
  END IF;

  UPDATE public.bitacoras
  SET fecha_hora_cierre = COALESCE(fecha_hora_cierre, NOW()),
      hora_salida_vigilante = COALESCE(hora_salida_vigilante, NOW()),
      updated_at = NOW()
  WHERE id = p_bitacora_id;

  UPDATE public.sucursales
  SET bitacora_actual_id = NULL,
      vigilante_actual_id = NULL,
      estado = 'Cerrado',
      hora_estado = NOW(),
      updated_at = NOW()
  WHERE id = p_sucursal_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_registrar_apertura(
  p_bitacora_id UUID,
  p_encargado_apertura TEXT DEFAULT NULL,
  p_novedad_apertura TEXT DEFAULT NULL,
  p_foto_apertura TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.bitacoras b
  WHERE b.id = p_bitacora_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Bitacora no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la bitacora';
  END IF;

  UPDATE public.bitacoras
  SET encargado_apertura = COALESCE(NULLIF(p_encargado_apertura, ''), encargado_apertura),
      novedad_apertura = COALESCE(NULLIF(p_novedad_apertura, ''), novedad_apertura),
      foto_apertura = COALESCE(NULLIF(p_foto_apertura, ''), foto_apertura),
      fecha_hora_apertura = COALESCE(fecha_hora_apertura, NOW()),
      updated_at = NOW()
  WHERE id = p_bitacora_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_registrar_cierre(
  p_bitacora_id UUID,
  p_encargado_cierre TEXT DEFAULT NULL,
  p_novedad_cierre TEXT DEFAULT NULL,
  p_foto_cierre TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.bitacoras b
  WHERE b.id = p_bitacora_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Bitacora no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la bitacora';
  END IF;

  UPDATE public.bitacoras
  SET encargado_cierre = COALESCE(NULLIF(p_encargado_cierre, ''), encargado_cierre),
      novedad_cierre = COALESCE(NULLIF(p_novedad_cierre, ''), novedad_cierre),
      foto_cierre = COALESCE(NULLIF(p_foto_cierre, ''), foto_cierre),
      fecha_hora_cierre = COALESCE(fecha_hora_cierre, NOW()),
      updated_at = NOW()
  WHERE id = p_bitacora_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_registrar_novedad(
  p_bitacora_id UUID,
  p_descripcion TEXT,
  p_foto TEXT DEFAULT NULL,
  p_hora TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
  v_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.bitacoras b
  WHERE b.id = p_bitacora_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Bitacora no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la bitacora';
  END IF;

  INSERT INTO public.novedades(bitacora_id, descripcion, foto, hora)
  VALUES (p_bitacora_id, p_descripcion, p_foto, COALESCE(p_hora, NOW()))
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_registrar_visita(
  p_bitacora_id UUID,
  p_nombre TEXT,
  p_cedula TEXT DEFAULT NULL,
  p_motivo TEXT DEFAULT NULL,
  p_pertenencias TEXT DEFAULT NULL,
  p_foto TEXT DEFAULT NULL,
  p_hora_entrada TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
  v_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.bitacoras b
  WHERE b.id = p_bitacora_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Bitacora no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la bitacora';
  END IF;

  INSERT INTO public.visitas(
    bitacora_id, nombre, cedula, motivo, pertenencias, foto, hora_entrada
  )
  VALUES (
    p_bitacora_id, p_nombre, p_cedula, p_motivo, p_pertenencias, p_foto, COALESCE(p_hora_entrada, NOW())
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_registrar_vehiculo(
  p_bitacora_id UUID,
  p_placa TEXT,
  p_conductor TEXT DEFAULT NULL,
  p_tipo TEXT DEFAULT NULL,
  p_nombre TEXT DEFAULT NULL,
  p_cedula TEXT DEFAULT NULL,
  p_motivo TEXT DEFAULT NULL,
  p_foto TEXT DEFAULT NULL,
  p_hora_entrada TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
  v_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.bitacoras b
  WHERE b.id = p_bitacora_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Bitacora no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la bitacora';
  END IF;

  INSERT INTO public.vehiculos(
    bitacora_id, placa, conductor, tipo, nombre, cedula, motivo, foto, hora_entrada
  )
  VALUES (
    p_bitacora_id, p_placa, p_conductor, p_tipo, p_nombre, p_cedula, p_motivo, p_foto, COALESCE(p_hora_entrada, NOW())
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_registrar_proveedor_visita(
  p_bitacora_id UUID,
  p_proveedor_id UUID DEFAULT NULL,
  p_nombre TEXT DEFAULT '',
  p_empresa TEXT DEFAULT NULL,
  p_motivo TEXT DEFAULT NULL,
  p_pertenencias TEXT DEFAULT NULL,
  p_foto TEXT DEFAULT NULL,
  p_hora_entrada TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
  v_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.bitacoras b
  WHERE b.id = p_bitacora_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Bitacora no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la bitacora';
  END IF;

  INSERT INTO public.proveedores_visitas(
    bitacora_id, proveedor_id, nombre, empresa, motivo, pertenencias, foto, hora_entrada
  )
  VALUES (
    p_bitacora_id,
    p_proveedor_id,
    COALESCE(NULLIF(p_nombre, ''), 'Proveedor'),
    p_empresa,
    p_motivo,
    p_pertenencias,
    p_foto,
    COALESCE(p_hora_entrada, NOW())
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_marcar_salida_visita(p_visita_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.visitas v
  JOIN public.bitacoras b ON b.id = v.bitacora_id
  WHERE v.id = p_visita_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Visita no encontrada';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre la visita';
  END IF;

  UPDATE public.visitas
  SET hora_salida = COALESCE(hora_salida, NOW())
  WHERE id = p_visita_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_marcar_salida_vehiculo(p_vehiculo_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.vehiculos v
  JOIN public.bitacoras b ON b.id = v.bitacora_id
  WHERE v.id = p_vehiculo_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Vehiculo no encontrado';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre el vehiculo';
  END IF;

  UPDATE public.vehiculos
  SET hora_salida = COALESCE(hora_salida, NOW())
  WHERE id = p_vehiculo_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_marcar_salida_proveedor(p_proveedor_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_institucion_id UUID;
BEGIN
  SELECT b.institucion_id INTO v_institucion_id
  FROM public.proveedores_visitas v
  JOIN public.bitacoras b ON b.id = v.bitacora_id
  WHERE v.id = p_proveedor_id;

  IF v_institucion_id IS NULL THEN
    RAISE EXCEPTION 'Proveedor visita no encontrado';
  END IF;

  IF NOT public.app_user_can_access_institucion(v_institucion_id) THEN
    RAISE EXCEPTION 'Sin permisos sobre proveedor visita';
  END IF;

  UPDATE public.proveedores_visitas
  SET hora_salida = COALESCE(hora_salida, NOW())
  WHERE id = p_proveedor_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.rpc_llegada_vigilante(UUID, UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_salida_vigilante(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_registrar_apertura(UUID, TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_registrar_cierre(UUID, TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_registrar_novedad(UUID, TEXT, TEXT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_registrar_visita(UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_registrar_vehiculo(UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_registrar_proveedor_visita(UUID, UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_marcar_salida_visita(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_marcar_salida_vehiculo(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_marcar_salida_proveedor(UUID) TO authenticated;
