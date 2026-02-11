import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';

/// Servicio para subir y gestionar archivos en Supabase Storage
class StorageService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Bucket principal
  static const String bucketBitacoras = 'bitacora-fotos';

  /// Subir imagen (soporta File en móvil y Uint8List en Web/Desk)
  Future<String?> uploadImage({
    required String path,
    File? file,
    Uint8List? bytes,
  }) async {
    try {
      if (file != null) {
        await _client.storage.from(bucketBitacoras).upload(
              path,
              file,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else if (bytes != null) {
        await _client.storage.from(bucketBitacoras).uploadBinary(
              path,
              bytes,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else {
        throw Exception('Debe proporcionar un archivo o bytes');
      }

      // Retornar URL pública
      return _client.storage.from(bucketBitacoras).getPublicUrl(path);
    } catch (e) {
      debugPrint('Error en StorageService.uploadImage: $e');
      return null;
    }
  }

  /// Helper para subir fotos de bitácora organizadas por ID
  Future<String?> uploadBitacoraPhoto({
    required String bitacoraId,
    required String category, // 'apertura', 'novedad', 'visita', etc.
    File? file,
    Uint8List? bytes,
  }) async {
    final fileName = '${category}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '$bitacoraId/$fileName';

    return uploadImage(path: path, file: file, bytes: bytes);
  }

  /// Eliminar archivo
  Future<void> deleteFile(String path) async {
    try {
      await _client.storage.from(bucketBitacoras).remove([path]);
    } catch (e) {
      debugPrint('Error eliminando archivo: $e');
    }
  }
}
