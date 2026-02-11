/// Modelo de proveedor del catálogo (lista_proveedores)
class Proveedor {
  final String? id;
  final String nombre;
  final String? telefono;
  final String? imagen;
  final DateTime? createdAt;

  Proveedor({
    this.id,
    required this.nombre,
    this.telefono,
    this.imagen,
    this.createdAt,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'] as String?,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String?,
      imagen: json['imagen'] as String?,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'imagen': imagen,
    };
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
