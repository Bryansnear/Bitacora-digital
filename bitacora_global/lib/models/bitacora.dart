import 'visita.dart';
import 'vehiculo.dart';
import 'novedad.dart';
import 'proveedor_visita.dart';

/// Modelo de Bitácora actualizado para esquema normalizado
/// Ya no contiene JSONB arrays - los registros están en tablas separadas
class Bitacora {
  final String? id;
  final String? institucionId;
  final String? sucursalId; // FK a tabla sucursales

  // Datos de apertura
  final String? vigilanteAperturaId; // FK a users
  final String? vigilanteApertura; // Nombre (legacy/cache)
  final DateTime? fechaHoraApertura;
  final String? encargadoApertura;
  final String? encargadoDesalarmado;
  final String? fotoApertura;
  final String? novedadApertura;

  // Datos de cierre
  final String? vigilanteCierreId; // FK a users
  final String? vigilanteCierre; // Nombre (legacy/cache)
  final DateTime? fechaHoraCierre;
  final String? encargadoCierre;
  final String? encargadoAlarmado;
  final String? novedadCierre;
  final String? novedadCierreTotal;
  final String? fotoCierre;

  // Horarios específicos
  final DateTime? horaLlegadaVigilante;
  final DateTime? horaSalidaVigilante;
  final DateTime? horaLlegadaCajeros;
  final DateTime? horaLlegadaOficinas;
  final DateTime? horaAtencionPublicoCajeros;
  final DateTime? horaAperturaTotal;
  final DateTime? horaCierreTotal;

  // Supervisión y relevo (JSONB por ser objetos únicos, no listas)
  final Map<String, dynamic> supervision;
  final Map<String, dynamic> relevo;
  final List<dynamic> listaAtm;

  // Listas relacionadas (pueden venir pobladas vía join)
  final List<Visita> visitas;
  final List<Vehiculo> vehiculos;
  final List<Novedad> novedades;
  final List<ProveedorVisita> proveedores;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Bitacora({
    this.id,
    this.institucionId,
    this.sucursalId,
    this.vigilanteAperturaId,
    this.vigilanteApertura,
    this.fechaHoraApertura,
    this.encargadoApertura,
    this.encargadoDesalarmado,
    this.fotoApertura,
    this.novedadApertura,
    this.vigilanteCierreId,
    this.vigilanteCierre,
    this.fechaHoraCierre,
    this.encargadoCierre,
    this.encargadoAlarmado,
    this.novedadCierre,
    this.novedadCierreTotal,
    this.fotoCierre,
    this.horaLlegadaVigilante,
    this.horaSalidaVigilante,
    this.horaLlegadaCajeros,
    this.horaLlegadaOficinas,
    this.horaAtencionPublicoCajeros,
    this.horaAperturaTotal,
    this.horaCierreTotal,
    this.supervision = const {},
    this.relevo = const {},
    this.listaAtm = const [],
    this.visitas = const [],
    this.vehiculos = const [],
    this.novedades = const [],
    this.proveedores = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Bitacora.fromJson(Map<String, dynamic> json) {
    return Bitacora(
      id: json['id'] as String?,
      institucionId: json['institucion_id'] as String?,
      sucursalId: (json['sucursal_id'] ?? json['sucursal']) as String?,
      vigilanteAperturaId: json['vigilante_apertura_id'] as String?,
      vigilanteApertura: json['vigilante_apertura'] as String?,
      fechaHoraApertura: _parseDateTime(json['fecha_hora_apertura']),
      encargadoApertura: json['encargado_apertura'] as String?,
      encargadoDesalarmado: json['encargado_desalarmado'] as String?,
      fotoApertura: json['foto_apertura'] as String?,
      novedadApertura: json['novedad_apertura'] as String?,
      vigilanteCierreId: json['vigilante_cierre_id'] as String?,
      vigilanteCierre: json['vigilante_cierre'] as String?,
      fechaHoraCierre: _parseDateTime(json['fecha_hora_cierre']),
      encargadoCierre: json['encargado_cierre'] as String?,
      encargadoAlarmado: json['encargado_alarmado'] as String?,
      novedadCierre: json['novedad_cierre'] as String?,
      novedadCierreTotal: json['novedad_cierre_total'] as String?,
      fotoCierre: json['foto_cierre'] as String?,
      horaLlegadaVigilante: _parseDateTime(json['hora_llegada_vigilante']),
      horaSalidaVigilante: _parseDateTime(json['hora_salida_vigilante']),
      horaLlegadaCajeros: _parseDateTime(json['hora_llegada_cajeros']),
      horaLlegadaOficinas: _parseDateTime(json['hora_llegada_oficinas']),
      horaAtencionPublicoCajeros: _parseDateTime(
        json['hora_atencion_publico_cajeros'],
      ),
      horaAperturaTotal: _parseDateTime(json['hora_apertura_total']),
      horaCierreTotal: _parseDateTime(json['hora_cierre_total']),
      supervision: json['supervision'] as Map<String, dynamic>? ?? {},
      relevo: json['relevo'] as Map<String, dynamic>? ?? {},
      listaAtm: json['lista_atm'] as List<dynamic>? ?? [],
      visitas:
          (json['visitas'] as List?)?.map((v) => Visita.fromJson(v)).toList() ??
              [],
      vehiculos: (json['vehiculos'] as List?)
              ?.map((v) => Vehiculo.fromJson(v))
              .toList() ??
          [],
      novedades: (json['novedades'] as List?)
              ?.map((v) => Novedad.fromJson(v))
              .toList() ??
          [],
      proveedores:
          ((json['proveedores'] ?? json['proveedores_visitas']) as List?)
              ?.map((v) => ProveedorVisita.fromJson(v))
              .toList() ??
          [],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'institucion_id': institucionId,
      'sucursal_id': sucursalId,
      'vigilante_apertura_id': vigilanteAperturaId,
      'vigilante_apertura': vigilanteApertura,
      'fecha_hora_apertura': fechaHoraApertura?.toIso8601String(),
      'encargado_apertura': encargadoApertura,
      'encargado_desalarmado': encargadoDesalarmado,
      'foto_apertura': fotoApertura,
      'novedad_apertura': novedadApertura,
      'vigilante_cierre_id': vigilanteCierreId,
      'vigilante_cierre': vigilanteCierre,
      'fecha_hora_cierre': fechaHoraCierre?.toIso8601String(),
      'encargado_cierre': encargadoCierre,
      'encargado_alarmado': encargadoAlarmado,
      'novedad_cierre': novedadCierre,
      'novedad_cierre_total': novedadCierreTotal,
      'foto_cierre': fotoCierre,
      'hora_llegada_vigilante': horaLlegadaVigilante?.toIso8601String(),
      'hora_salida_vigilante': horaSalidaVigilante?.toIso8601String(),
      'hora_llegada_cajeros': horaLlegadaCajeros?.toIso8601String(),
      'hora_llegada_oficinas': horaLlegadaOficinas?.toIso8601String(),
      'hora_atencion_publico_cajeros':
          horaAtencionPublicoCajeros?.toIso8601String(),
      'hora_apertura_total': horaAperturaTotal?.toIso8601String(),
      'hora_cierre_total': horaCierreTotal?.toIso8601String(),
      'supervision': supervision,
      'relevo': relevo,
      'lista_atm': listaAtm,
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  Bitacora copyWith({
    String? id,
    String? institucionId,
    String? sucursalId,
    String? vigilanteAperturaId,
    String? vigilanteApertura,
    DateTime? fechaHoraApertura,
    String? encargadoApertura,
    String? encargadoDesalarmado,
    String? fotoApertura,
    String? novedadApertura,
    String? vigilanteCierreId,
    String? vigilanteCierre,
    DateTime? fechaHoraCierre,
    String? encargadoCierre,
    String? encargadoAlarmado,
    String? novedadCierre,
    String? novedadCierreTotal,
    String? fotoCierre,
    DateTime? horaLlegadaVigilante,
    DateTime? horaSalidaVigilante,
    DateTime? horaLlegadaCajeros,
    DateTime? horaLlegadaOficinas,
    DateTime? horaAtencionPublicoCajeros,
    DateTime? horaAperturaTotal,
    DateTime? horaCierreTotal,
    Map<String, dynamic>? supervision,
    Map<String, dynamic>? relevo,
    List<Visita>? visitas,
    List<Vehiculo>? vehiculos,
    List<Novedad>? novedades,
    List<ProveedorVisita>? proveedores,
  }) {
    return Bitacora(
      id: id ?? this.id,
      institucionId: institucionId ?? this.institucionId,
      sucursalId: sucursalId ?? this.sucursalId,
      vigilanteAperturaId: vigilanteAperturaId ?? this.vigilanteAperturaId,
      vigilanteApertura: vigilanteApertura ?? this.vigilanteApertura,
      fechaHoraApertura: fechaHoraApertura ?? this.fechaHoraApertura,
      encargadoApertura: encargadoApertura ?? this.encargadoApertura,
      encargadoDesalarmado: encargadoDesalarmado ?? this.encargadoDesalarmado,
      fotoApertura: fotoApertura ?? this.fotoApertura,
      novedadApertura: novedadApertura ?? this.novedadApertura,
      vigilanteCierreId: vigilanteCierreId ?? this.vigilanteCierreId,
      vigilanteCierre: vigilanteCierre ?? this.vigilanteCierre,
      fechaHoraCierre: fechaHoraCierre ?? this.fechaHoraCierre,
      encargadoCierre: encargadoCierre ?? this.encargadoCierre,
      encargadoAlarmado: encargadoAlarmado ?? this.encargadoAlarmado,
      novedadCierre: novedadCierre ?? this.novedadCierre,
      novedadCierreTotal: novedadCierreTotal ?? this.novedadCierreTotal,
      fotoCierre: fotoCierre ?? this.fotoCierre,
      horaLlegadaVigilante: horaLlegadaVigilante ?? this.horaLlegadaVigilante,
      horaSalidaVigilante: horaSalidaVigilante ?? this.horaSalidaVigilante,
      horaLlegadaCajeros: horaLlegadaCajeros ?? this.horaLlegadaCajeros,
      horaLlegadaOficinas: horaLlegadaOficinas ?? this.horaLlegadaOficinas,
      horaAtencionPublicoCajeros:
          horaAtencionPublicoCajeros ?? this.horaAtencionPublicoCajeros,
      horaAperturaTotal: horaAperturaTotal ?? this.horaAperturaTotal,
      horaCierreTotal: horaCierreTotal ?? this.horaCierreTotal,
      supervision: supervision ?? this.supervision,
      relevo: relevo ?? this.relevo,
      visitas: visitas ?? this.visitas,
      vehiculos: vehiculos ?? this.vehiculos,
      novedades: novedades ?? this.novedades,
      proveedores: proveedores ?? this.proveedores,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// ¿La bitácora está abierta (sin hora de salida)?
  bool get isOpen => horaSalidaVigilante == null;

  /// Estado como string
  String get estado => isOpen ? 'Abierto' : 'Cerrado';

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
