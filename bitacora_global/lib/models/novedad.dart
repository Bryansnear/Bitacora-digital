/// Modelo de Novedad para Supabase (tabla normalizada)
class Novedad {
  final String? id;
  final String bitacoraId;
  final String descripcion;
  final String? foto;
  final DateTime? hora;
  final DateTime? createdAt;

  Novedad({
    this.id,
    required this.bitacoraId,
    required this.descripcion,
    this.foto,
    this.hora,
    this.createdAt,
  });

  factory Novedad.fromJson(Map<String, dynamic> json) {
    return Novedad(
      id: json['id'] as String?,
      bitacoraId: json['bitacora_id'] as String,
      descripcion: json['descripcion'] as String,
      foto: json['foto'] as String?,
      hora: _parseDateTime(json['hora']),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bitacora_id': bitacoraId,
      'descripcion': descripcion,
      'foto': foto,
      'hora': hora?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  Novedad copyWith({
    String? id,
    String? bitacoraId,
    String? descripcion,
    String? foto,
    DateTime? hora,
  }) {
    return Novedad(
      id: id ?? this.id,
      bitacoraId: bitacoraId ?? this.bitacoraId,
      descripcion: descripcion ?? this.descripcion,
      foto: foto ?? this.foto,
      hora: hora ?? this.hora,
      createdAt: createdAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
