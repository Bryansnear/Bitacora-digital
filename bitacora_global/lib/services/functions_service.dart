import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../core/supabase_config.dart';

/// Servicio para llamar a las Edge Functions de Supabase
class FunctionsService {
  /// URL base de las functions
  String get _functionsUrl => '${SupabaseConfig.supabaseUrl}/functions/v1';

  /// Headers con autenticación
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${SupabaseConfig.currentSession?.accessToken ?? SupabaseConfig.supabaseAnonKey}',
  };

  /// Exportar bitácoras a Excel
  /// Llama a la Edge Function y retorna los bytes del archivo
  Future<Uint8List> exportBitacoraToExcel({
    required DateTime fecha,
    required String institucionId,
  }) async {
    final response = await http.post(
      Uri.parse('$_functionsUrl/export-excel'),
      headers: _headers,
      body: jsonEncode({
        'fecha': fecha.toIso8601String().split('T')[0],
        'institucion_id': institucionId,
      }),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else if (response.statusCode == 404) {
      throw Exception('No hay registros para la fecha seleccionada');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al generar Excel');
    }
  }

  /// Calcular distancia entre dos puntos
  Future<DistanceResult> calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) async {
    final response = await http.post(
      Uri.parse('$_functionsUrl/calculate-distance'),
      headers: _headers,
      body: jsonEncode({
        'lat1': lat1,
        'lng1': lng1,
        'lat2': lat2,
        'lng2': lng2,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DistanceResult.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al calcular distancia');
    }
  }

  /// Descargar archivo Excel (para web)
  void downloadExcelWeb(Uint8List bytes, String filename) {
    if (!kIsWeb) return;

    // ignore: avoid_web_libraries_in_flutter
    // Se usa universal_html en el proyecto
    // Esta función debería implementarse con universal_html como en el código original
  }
}

/// Resultado del cálculo de distancia
class DistanceResult {
  final double distanceMeters;
  final double distanceKm;
  final bool isWithinRange;
  final double maxRangeMeters;

  DistanceResult({
    required this.distanceMeters,
    required this.distanceKm,
    required this.isWithinRange,
    required this.maxRangeMeters,
  });

  factory DistanceResult.fromJson(Map<String, dynamic> json) {
    return DistanceResult(
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      isWithinRange: json['isWithinRange'] as bool,
      maxRangeMeters: (json['maxRangeMeters'] as num).toDouble(),
    );
  }
}
