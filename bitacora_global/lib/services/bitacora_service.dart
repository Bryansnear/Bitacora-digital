import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';
import '../models/bitacora.dart';
import '../models/institucion.dart';
import '../models/sucursal.dart';
import '../models/novedad.dart';
import '../models/visita.dart';
import '../models/vehiculo.dart';
import '../models/proveedor_visita.dart';
import '../models/user_profile.dart';

class BitacoraService {
  final _client = Supabase.instance.client;

  Bitacora? _parseBitacoraResponse(dynamic response) {
    if (response == null) return null;
    if (response is Map<String, dynamic>) return Bitacora.fromJson(response);
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map<String, dynamic>) return Bitacora.fromJson(first);
    }
    return null;
  }

  Future<void> _rpcOrThrow(String fn, Map<String, dynamic> params) async {
    await _client.rpc(fn, params: params);
  }

  // ============================================================
  // BITACORAS
  // ============================================================

  /// Stream de una bitacora con relaciones.
  Stream<Bitacora?> streamBitacora(String? bitacoraId) {
    if (bitacoraId == null) return Stream.value(null);

    return _client
        .from('bitacoras')
        .stream(primaryKey: ['id'])
        .eq('id', bitacoraId)
        .limit(1)
        .asyncMap((rows) async {
      if (rows.isEmpty) return null;
      try {
        final hydrated = await getBitacora(bitacoraId);
        return hydrated ?? Bitacora.fromJson(rows.first);
      } catch (e) {
        // Si la consulta con joins falla, usar datos del stream
        return Bitacora.fromJson(rows.first);
      }
    }).handleError((e) {
      debugPrint('⚠️ Error en streamBitacora: $e');
    });
  }

  Future<Bitacora?> getBitacora(String id) async {
    final response = await _client
        .from('bitacoras')
        .select('*, visitas(*), vehiculos(*), novedades(*), proveedores_visitas(*)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Bitacora.fromJson(response);
  }

  Future<Bitacora?> createBitacora(Bitacora bitacora) async {
    final response =
        await _client.from('bitacoras').insert(bitacora.toInsertJson()).select().single();
    return Bitacora.fromJson(response);
  }

  Future<Bitacora?> updateBitacora(String id, Bitacora bitacora) async {
    final response = await _client
        .from('bitacoras')
        .update(bitacora.toJson())
        .eq('id', id)
        .select()
        .maybeSingle();
    if (response == null) return null;
    return Bitacora.fromJson(response);
  }

  Future<void> deleteBitacora(String id) async {
    await _client.from('bitacoras').delete().eq('id', id);
  }

  // ============================================================
  // INSTITUCIONES Y SUCURSALES
  // ============================================================

  Stream<List<Institucion>> streamInstituciones() {
    return _client
        .from('instituciones')
        .stream(primaryKey: ['id'])
        .order('nombre')
        .map((rows) => rows.map((json) => Institucion.fromJson(json)).toList());
  }

  Future<List<Institucion>> getInstitucionesUsuario() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('instituciones')
        .select('*, user_instituciones!inner(user_id)')
        .eq('user_instituciones.user_id', userId);

    return (response as List).map((json) => Institucion.fromJson(json)).toList();
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return;
    await _client.from('users').update(updates).eq('id', userId);
  }

  Stream<List<Sucursal>> streamSucursales(String institucionId) {
    return _client
        .from('sucursales')
        .stream(primaryKey: ['id'])
        .eq('institucion_id', institucionId)
        .order('nombre')
        .map((rows) => rows.map((json) => Sucursal.fromJson(json)).toList());
  }

  Future<Sucursal?> getSucursal(String sucursalId) async {
    final response =
        await _client.from('sucursales').select().eq('id', sucursalId).maybeSingle();
    return response != null ? Sucursal.fromJson(response) : null;
  }

  // ============================================================
  // CRUD INSTITUCIONES
  // ============================================================

  Future<void> createInstitucion(String nombre, String? tipo) async {
    await _client.from('instituciones').insert({
      'nombre': nombre,
      'tipo': tipo,
    }).select();
  }

  Future<void> updateInstitucion(String id, String nombre, String? tipo) async {
    await _client.from('instituciones').update({
      'nombre': nombre,
      'tipo': tipo,
    }).eq('id', id);
  }

  Future<void> deleteInstitucion(String id) async {
    await _client.from('instituciones').delete().eq('id', id);
  }

  // ============================================================
  // CRUD SUCURSALES
  // ============================================================

  Future<void> createSucursal({
    required String institucionId,
    required String nombre,
    double? latitud,
    double? longitud,
    double? radioMetros,
  }) async {
    final data = <String, dynamic>{
      'institucion_id': institucionId,
      'nombre': nombre,
      'estado': 'activa',
    };
    if (latitud != null) data['latitud'] = latitud;
    if (longitud != null) data['longitud'] = longitud;
    if (radioMetros != null) data['radio_metros'] = radioMetros.toInt();
    await _client.from('sucursales').insert(data).select();
  }

  Future<void> updateSucursal({
    required String id,
    required String nombre,
    double? latitud,
    double? longitud,
    double? radioMetros,
  }) async {
    final data = <String, dynamic>{
      'nombre': nombre,
    };
    if (latitud != null) data['latitud'] = latitud;
    if (longitud != null) data['longitud'] = longitud;
    if (radioMetros != null) data['radio_metros'] = radioMetros.toInt();
    await _client.from('sucursales').update(data).eq('id', id);
  }

  Future<void> deleteSucursal(String id) async {
    await _client.from('sucursales').delete().eq('id', id);
  }

  // ============================================================
  // FLUJO DE GUARDIA (RPC BACKEND)
  // ============================================================

  Future<Bitacora?> llegadaVigilante({
    required String institucionId,
    required String sucursalId,
    required String vigilanteId,
  }) async {
    final response = await _client.rpc(
      'rpc_llegada_vigilante',
      params: {
        'p_institucion_id': institucionId,
        'p_sucursal_id': sucursalId,
        'p_vigilante_id': vigilanteId,
      },
    );
    return _parseBitacoraResponse(response);
  }

  Future<void> salidaVigilante({
    required String bitacoraId,
    required String sucursalId,
  }) async {
    await _rpcOrThrow('rpc_salida_vigilante', {
      'p_bitacora_id': bitacoraId,
      'p_sucursal_id': sucursalId,
    });
  }

  Future<void> registrarApertura({
    required String bitacoraId,
    String? encargadoApertura,
    String? novedadApertura,
    String? fotoApertura,
  }) async {
    await _rpcOrThrow('rpc_registrar_apertura', {
      'p_bitacora_id': bitacoraId,
      'p_encargado_apertura': encargadoApertura,
      'p_novedad_apertura': novedadApertura,
      'p_foto_apertura': fotoApertura,
    });
  }

  Future<void> registrarCierre({
    required String bitacoraId,
    String? encargadoCierre,
    String? novedadCierre,
    String? fotoCierre,
  }) async {
    await _rpcOrThrow('rpc_registrar_cierre', {
      'p_bitacora_id': bitacoraId,
      'p_encargado_cierre': encargadoCierre,
      'p_novedad_cierre': novedadCierre,
      'p_foto_cierre': fotoCierre,
    });
  }

  // ============================================================
  // TABLAS RELACIONADAS (RPC BACKEND)
  // ============================================================

  Future<void> addNovedad(Novedad novedad) async {
    await _rpcOrThrow('rpc_registrar_novedad', {
      'p_bitacora_id': novedad.bitacoraId,
      'p_descripcion': novedad.descripcion,
      'p_foto': novedad.foto,
      'p_hora': novedad.hora?.toIso8601String(),
    });
  }

  Future<void> addVisita(Visita visita) async {
    await _rpcOrThrow('rpc_registrar_visita', {
      'p_bitacora_id': visita.bitacoraId,
      'p_nombre': visita.nombre,
      'p_cedula': visita.cedula,
      'p_motivo': visita.motivo,
      'p_pertenencias': visita.pertenencias,
      'p_foto': visita.foto,
      'p_hora_entrada': visita.horaEntrada?.toIso8601String(),
    });
  }

  Future<void> addVehiculo(Vehiculo vehiculo) async {
    await _rpcOrThrow('rpc_registrar_vehiculo', {
      'p_bitacora_id': vehiculo.bitacoraId,
      'p_placa': vehiculo.placa,
      'p_conductor': vehiculo.conductor ?? vehiculo.nombre,
      'p_tipo': vehiculo.tipo,
      'p_nombre': vehiculo.nombre,
      'p_cedula': vehiculo.cedula,
      'p_motivo': vehiculo.motivo,
      'p_foto': vehiculo.foto,
      'p_hora_entrada': vehiculo.horaEntrada?.toIso8601String(),
    });
  }

  Future<void> addProveedorVisita(ProveedorVisita proveedor) async {
    await _rpcOrThrow('rpc_registrar_proveedor_visita', {
      'p_bitacora_id': proveedor.bitacoraId,
      'p_proveedor_id': proveedor.proveedorId,
      'p_nombre': proveedor.nombre,
      'p_empresa': proveedor.empresa,
      'p_motivo': proveedor.motivo,
      'p_pertenencias': proveedor.pertenencias,
      'p_foto': proveedor.foto,
      'p_hora_entrada': proveedor.horaEntrada?.toIso8601String(),
    });
  }

  Stream<List<Novedad>> streamNovedades(String bitacoraId) {
    return _client
        .from('novedades')
        .stream(primaryKey: ['id'])
        .eq('bitacora_id', bitacoraId)
        .order('hora', ascending: false)
        .map((rows) => rows.map((json) => Novedad.fromJson(json)).toList());
  }

  Future<void> addAtm(String bitacoraId, Map<String, dynamic> atmData) async {
    final bitacora = await getBitacora(bitacoraId);
    if (bitacora == null) return;
    final listaAtm = List<dynamic>.from(bitacora.listaAtm)..add(atmData);
    await _client.from('bitacoras').update({'lista_atm': listaAtm}).eq('id', bitacoraId);
  }

  // ============================================================
  // GESTION DE SALIDAS (RPC BACKEND)
  // ============================================================

  Future<void> marcarSalidaVisita(String visitaId) async {
    await _rpcOrThrow('rpc_marcar_salida_visita', {'p_visita_id': visitaId});
  }

  Future<void> marcarSalidaVehiculo(String vehiculoId) async {
    await _rpcOrThrow('rpc_marcar_salida_vehiculo', {'p_vehiculo_id': vehiculoId});
  }

  Future<void> marcarSalidaProveedor(String proveedorId) async {
    await _rpcOrThrow('rpc_marcar_salida_proveedor', {'p_proveedor_id': proveedorId});
  }

  // ============================================================
  // ACTUALIZACIONES PARCIALES
  // ============================================================

  Future<void> updateSupervision(
      String bitacoraId, Map<String, dynamic> supervisionData) async {
    await _client.from('bitacoras').update({'supervision': supervisionData}).eq('id', bitacoraId);
  }

  Future<void> updateRelevo(String bitacoraId, Map<String, dynamic> relevoData) async {
    await _client.from('bitacoras').update({'relevo': relevoData}).eq('id', bitacoraId);
  }

  Stream<List<Bitacora>> streamBitacoras(String sucursalId) {
    return _client
        .from('bitacoras')
        .stream(primaryKey: ['id'])
        .eq('sucursal_id', sucursalId)
        .order('hora_llegada_vigilante', ascending: false)
        .map((rows) => rows.map((json) => Bitacora.fromJson(json)).toList());
  }

  // ============================================================
  // USUARIOS (REALTIME)
  // ============================================================

  /// Stream de todos los usuarios (para pantalla de gestión de usuarios)
  Stream<List<UserProfile>> streamUsers() {
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .order('display_name')
        .map((rows) => rows.map((json) => UserProfile.fromJson(json)).toList());
  }

  /// Stream del perfil de un usuario específico
  Stream<UserProfile?> streamUserProfile(String userId) {
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((rows) {
      if (rows.isEmpty) return null;
      return UserProfile.fromJson(rows.first);
    });
  }

  /// Stream de visitas de una bitácora
  Stream<List<Visita>> streamVisitas(String bitacoraId) {
    return _client
        .from('visitas')
        .stream(primaryKey: ['id'])
        .eq('bitacora_id', bitacoraId)
        .order('hora_entrada', ascending: false)
        .map((rows) => rows.map((json) => Visita.fromJson(json)).toList());
  }

  /// Stream de vehículos de una bitácora
  Stream<List<Vehiculo>> streamVehiculos(String bitacoraId) {
    return _client
        .from('vehiculos')
        .stream(primaryKey: ['id'])
        .eq('bitacora_id', bitacoraId)
        .order('hora_entrada', ascending: false)
        .map((rows) => rows.map((json) => Vehiculo.fromJson(json)).toList());
  }

  /// Stream de proveedores de una bitácora
  Stream<List<ProveedorVisita>> streamProveedores(String bitacoraId) {
    return _client
        .from('proveedores_visitas')
        .stream(primaryKey: ['id'])
        .eq('bitacora_id', bitacoraId)
        .order('hora_entrada', ascending: false)
        .map((rows) =>
            rows.map((json) => ProveedorVisita.fromJson(json)).toList());
  }
}
