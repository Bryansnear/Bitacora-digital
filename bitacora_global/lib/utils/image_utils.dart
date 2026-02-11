import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Utilidades para manejo de imágenes
class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  /// Captura una foto usando la cámara
  /// Retorna un objeto con File (móvil) y/o Uint8List (web)
  static Future<PickedImageData?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );

      if (photo == null) return null;

      final bytes = await photo.readAsBytes();

      return PickedImageData(
        file: kIsWeb ? null : File(photo.path),
        bytes: bytes,
        name: photo.name,
      );
    } catch (e) {
      debugPrint('Error capturando foto: $e');
      return null;
    }
  }

  /// Selecciona una imagen de la galería
  static Future<PickedImageData?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );

      if (image == null) return null;

      final bytes = await image.readAsBytes();

      return PickedImageData(
        file: kIsWeb ? null : File(image.path),
        bytes: bytes,
        name: image.name,
      );
    } catch (e) {
      debugPrint('Error seleccionando imagen: $e');
      return null;
    }
  }
}

/// Clase contenedora para la imagen capturada
class PickedImageData {
  final File? file;
  final Uint8List bytes;
  final String name;

  PickedImageData({
    this.file,
    required this.bytes,
    required this.name,
  });
}
