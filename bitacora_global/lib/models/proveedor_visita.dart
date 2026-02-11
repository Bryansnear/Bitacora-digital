/// Modelo de ProveedorVisita para Supabase (tabla normalizada)
/// Representa la visita de un proveedor a una sucursal en un día específico
class ProveedorVisita {
  final String? id;
  final String bitacoraId;
  final String? proveedorId; // FK opcional a lista_proveedores
  final String nombre;
  final String? empresa;
  final String? motivo;
  final String? pertenencias;
  final DateTime? horaEntrada;
  final DateTime? horaSalida;
  final String? foto;
  final DateTime? createdAt;

  ProveedorVisita({
    this.id,
    required this.bitacoraId,
    this.proveedorId,
    required this.nombre,
    this.empresa,
    this.motivo,
    this.pertenencias,
    this.horaEntrada,
    this.horaSalida,
    this.foto,
    this.createdAt,
  });

  factory ProveedorVisita.fromJson(Map<String, dynamic> json) {
    return ProveedorVisita(
      id: json['id'] as String?,
      bitacoraId: json['bitacora_id'] as String,
      proveedorId: json['proveedor_id'] as String?,
      nombre: json['nombre'] as String,
      empresa: json['empresa'] as String?,
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
      'proveedor_id': proveedorId,
      'nombre': nombre,
      'empresa': empresa,
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

  ProveedorVisita copyWith({
    String? id,
    String? bitacoraId,
    String? proveedorId,
    String? nombre,
    String? empresa,
    String? motivo,
    String? pertenencias,
    DateTime? horaEntrada,
    DateTime? horaSalida,
    String? foto,
  }) {
    return ProveedorVisita(
      id: id ?? this.id,
      bitacoraId: bitacoraId ?? this.bitacoraId,
      proveedorId: proveedorId ?? this.proveedorId,
      nombre: nombre ?? this.nombre,
      empresa: empresa ?? this.empresa,
      motivo: motivo ?? this.motivo,
      pertenencias: pertenencias ?? this.pertenencias,
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
