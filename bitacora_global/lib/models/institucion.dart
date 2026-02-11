/// Modelo de Institución simplificado
/// Sucursales ahora están en tabla separada
class Institucion {
  final String id;
  final String nombre;
  final String? tipo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Institucion({
    required this.id,
    required this.nombre,
    this.tipo,
    this.createdAt,
    this.updatedAt,
  });

  factory Institucion.fromJson(Map<String, dynamic> json) {
    return Institucion(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String?,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'tipo': tipo};
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
