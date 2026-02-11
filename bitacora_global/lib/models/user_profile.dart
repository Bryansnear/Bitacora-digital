/// Modelo de perfil de usuario para Supabase
class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? cedula;
  final String rol; // 'administrador', 'jefe_seguridad', 'vigilante'
  final List<String> instituciones;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.cedula,
    this.rol = 'vigilante',
    this.instituciones = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      photoUrl: json['photo_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      cedula: json['cedula'] as String?,
      rol: json['rol'] as String? ?? 'vigilante',
      instituciones: _parseStringList(json['instituciones']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'cedula': cedula,
      'rol': rol,
      'instituciones': instituciones,
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? cedula,
    String? rol,
    List<String>? instituciones,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cedula: cedula ?? this.cedula,
      rol: rol ?? this.rol,
      instituciones: instituciones ?? this.instituciones,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// ¿Es administrador?
  bool get isAdmin => rol == 'administrador';

  /// ¿Es jefe de seguridad?
  bool get isJefeSeguridad => rol == 'jefe_seguridad';

  /// ¿Es vigilante?
  bool get isVigilante => rol == 'vigilante';

  /// Nombre para mostrar (email si no hay nombre)
  String get nombreDisplay => displayName ?? email;

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
