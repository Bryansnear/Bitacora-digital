import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/bitacora_provider.dart';
import '../../services/bitacora_service.dart';
import '../../services/storage_service.dart';
import '../../utils/image_utils.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla de apertura - Registro de llegada y apertura de sucursal
class AperturaScreen extends StatefulWidget {
  const AperturaScreen({super.key});

  @override
  State<AperturaScreen> createState() => _AperturaScreenState();
}

class _AperturaScreenState extends State<AperturaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _encargadoController = TextEditingController();
  final _novedadController = TextEditingController();
  final BitacoraService _service = BitacoraService();
  final StorageService _storage = StorageService();

  PickedImageData? _pickedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _encargadoController.dispose();
    _novedadController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    final imageData = await ImageUtils.takePhoto();
    if (imageData != null) {
      setState(() {
        _pickedImage = imageData;
      });
    }
  }

  Future<void> _guardarApertura() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BitacoraProvider>();
    final bitacora = provider.bitacoraActiva;

    if (bitacora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay bitácora activa')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? fotoUrl;

      // Subir foto si se capturó una
      if (_pickedImage != null) {
        fotoUrl = await _storage.uploadBitacoraPhoto(
          bitacoraId: bitacora.id!,
          category: 'apertura',
          file: _pickedImage!.file,
          bytes: _pickedImage!.bytes,
        );
      }

      await _service.registrarApertura(
        bitacoraId: bitacora.id!,
        encargadoApertura: _encargadoController.text.trim(),
        novedadApertura: _novedadController.text.trim().isEmpty
            ? null
            : _novedadController.text.trim(),
        fotoApertura: fotoUrl,
      );

      await provider.recargarBitacora();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apertura registrada')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apertura de Sucursal'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hora actual
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hora de Apertura',
                              style: FlutterFlowTheme.of(context).bodySmall,
                            ),
                            Text(
                              DateTime.now().toString().substring(0, 16),
                              style: FlutterFlowTheme.of(context).titleLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Encargado
                TextFormField(
                  controller: _encargadoController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Encargado',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el nombre del encargado';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Novedad de apertura
                TextFormField(
                  controller: _novedadController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Novedades de Apertura (Opcional)',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.note),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Foto de apertura
                Text(
                  'Foto de Apertura (Evidencia)',
                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: _capturePhoto,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                        image: _pickedImage != null
                            ? DecorationImage(
                                image: MemoryImage(_pickedImage!.bytes),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _pickedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tocar para tomar foto',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
                if (_pickedImage != null)
                  TextButton.icon(
                    onPressed: () => setState(() => _pickedImage = null),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Eliminar foto',
                        style: TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 32),

                // Botón guardar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _guardarApertura,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Registrar Apertura'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
