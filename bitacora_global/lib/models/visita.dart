/// Modelo de Visita para Supabase (tabla normalizada)
class Visita {
  final String? id;
  final String bitacoraId;
  final String nombre;
  final String? cedula;
  final String? motivo;
  final String? pertenencias;
  final DateTime? horaEntrada;
  final DateTime? horaSalida;
  final String? foto;
  final DateTime? createdAt;

  Visita({
    this.id,
    required this.bitacoraId,
    required this.nombre,
    this.cedula,
    this.motivo,
    this.pertenencias,
    this.horaEntrada,
    this.horaSalida,
    this.foto,
    this.createdAt,
  });

  factory Visita.fromJson(Map<String, dynamic> json) {
    return Visita(
      id: json['id'] as String?,
      bitacoraId: json['bitacora_id'] as String,
      nombre: json['nombre'] as String,
      cedula: json['cedula'] as String?,
      motivo: json['motivo'] as String?,
      pertenencias: json['pertenencias'] as String?,
      horaEntrada: _parseDateTime(json['hora_entrada']),
      horaSalida: _parseDateTime(json['hora_salida']),
      foto: json['foto'] as String?,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bitacora_id': bitacoraId,
      'nombre': nombre,
      'cedula': cedula,
      'motivo': motivo,
      'pertenencias': pertenencias,
      'hora_entrada': horaEntrada?.toIso8601String(),
      'hora_salida': horaSalida?.toIso8601String(),
      'foto': foto,
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  Visita copyWith({
    String? id,
    String? bitacoraId,
    String? nombre,
    String? cedula,
    String? motivo,
    String? pertenencias,
    DateTime? horaEntrada,
    DateTime? horaSalida,
    String? foto,
  }) {
    return Visita(
      id: id ?? this.id,
      bitacoraId: bitacoraId ?? this.bitacoraId,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      motivo: motivo ?? this.motivo,
      pertenencias: pertenencias ?? this.pertenencias,
      horaEntrada: horaEntrada ?? this.horaEntrada,
      horaSalida: horaSalida ?? this.horaSalida,
      foto: foto ?? this.foto,
      createdAt: createdAt,
    );
  }

  /// ¿Aún está dentro de la sucursal?
  bool get isInside => horaSalida == null;

  /// Duración de la visita (si ya salió)
  Duration? get duracion {
    if (horaEntrada == null || horaSalida == null) return null;
    return horaSalida!.difference(horaEntrada!);
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
