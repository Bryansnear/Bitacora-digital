/// Modelo de Vehiculo para Supabase (tabla normalizada)
class Vehiculo {
  final String? id;
  final String bitacoraId;
  final String placa;
  final String? conductor;
  final String? tipo;
  final String? nombre;
  final String? cedula;
  final String? motivo;
  final DateTime? horaEntrada;
  final DateTime? horaSalida;
  final String? foto;
  final DateTime? createdAt;

  Vehiculo({
    this.id,
    required this.bitacoraId,
    required this.placa,
    this.conductor,
    this.tipo,
    this.nombre,
    this.cedula,
    this.motivo,
    this.horaEntrada,
    this.horaSalida,
    this.foto,
    this.createdAt,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'] as String?,
      bitacoraId: json['bitacora_id'] as String,
      placa: json['placa'] as String,
      conductor: json['conductor'] as String?,
      tipo: json['tipo'] as String?,
      nombre: json['nombre'] as String?,
      cedula: json['cedula'] as String?,
      motivo: json['motivo'] as String?,
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
      'placa': placa,
      'conductor': conductor,
      'tipo': tipo,
      'nombre': nombre,
      'cedula': cedula,
      'motivo': motivo,
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

  Vehiculo copyWith({
    String? id,
    String? bitacoraId,
    String? placa,
    String? conductor,
    String? tipo,
    String? nombre,
    String? cedula,
    String? motivo,
    DateTime? horaEntrada,
    DateTime? horaSalida,
    String? foto,
  }) {
    return Vehiculo(
      id: id ?? this.id,
      bitacoraId: bitacoraId ?? this.bitacoraId,
      placa: placa ?? this.placa,
      conductor: conductor ?? this.conductor,
      tipo: tipo ?? this.tipo,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      motivo: motivo ?? this.motivo,
      horaEntrada: horaEntrada ?? this.horaEntrada,
      horaSalida: horaSalida ?? this.horaSalida,
      foto: foto ?? this.foto,
      createdAt: createdAt,
    );
  }

  /// ¿Aún está dentro?
  bool get isInside => horaSalida == null;

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
