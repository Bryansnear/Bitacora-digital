/// Modelo de Sucursal para Supabase (tabla normalizada)
class Sucursal {
  final String id;
  final String institucionId;
  final String nombre;
  final String estado; // 'Abierto', 'Cerrado'
  final String? foto;
  final double? latitud;
  final double? longitud;
  final int radioMetros;
  final String? bitacoraActualId;
  final String? vigilanteActualId;
  final DateTime? horaEstado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Sucursal({
    required this.id,
    required this.institucionId,
    required this.nombre,
    this.estado = 'Cerrado',
    this.foto,
    this.latitud,
    this.longitud,
    this.radioMetros = 100,
    this.bitacoraActualId,
    this.vigilanteActualId,
    this.horaEstado,
    this.createdAt,
    this.updatedAt,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as String,
      institucionId: json['institucion_id'] as String,
      nombre: json['nombre'] as String,
      estado: json['estado'] as String? ?? 'Cerrado',
      foto: json['foto'] as String?,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      radioMetros: json['radio_metros'] as int? ?? 100,
      bitacoraActualId: json['bitacora_actual_id'] as String?,
      vigilanteActualId: json['vigilante_actual_id'] as String?,
      horaEstado: _parseDateTime(json['hora_estado']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'institucion_id': institucionId,
      'nombre': nombre,
      'estado': estado,
      'foto': foto,
      'latitud': latitud,
      'longitud': longitud,
      'radio_metros': radioMetros,
      'bitacora_actual_id': bitacoraActualId,
      'vigilante_actual_id': vigilanteActualId,
      'hora_estado': horaEstado?.toIso8601String(),
    };
  }

  /// Para insertar (sin id)
  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  Sucursal copyWith({
    String? id,
    String? institucionId,
    String? nombre,
    String? estado,
    String? foto,
    double? latitud,
    double? longitud,
    int? radioMetros,
    String? bitacoraActualId,
    String? vigilanteActualId,
    DateTime? horaEstado,
  }) {
    return Sucursal(
      id: id ?? this.id,
      institucionId: institucionId ?? this.institucionId,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
      foto: foto ?? this.foto,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      radioMetros: radioMetros ?? this.radioMetros,
      bitacoraActualId: bitacoraActualId ?? this.bitacoraActualId,
      vigilanteActualId: vigilanteActualId ?? this.vigilanteActualId,
      horaEstado: horaEstado ?? this.horaEstado,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// ¿La sucursal está abierta?
  bool get isOpen => estado == 'Abierto';

  /// ¿Tiene ubicación configurada?
  bool get hasLocation => latitud != null && longitud != null;

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
