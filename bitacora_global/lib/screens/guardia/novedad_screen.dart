import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bitacora_provider.dart';
import '../../services/bitacora_service.dart';
import '../../services/storage_service.dart';
import '../../utils/image_utils.dart';
import '../../models/novedad.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla para registrar novedades
class NovedadScreen extends StatefulWidget {
  const NovedadScreen({super.key});

  @override
  State<NovedadScreen> createState() => _NovedadScreenState();
}

class _NovedadScreenState extends State<NovedadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final BitacoraService _service = BitacoraService();
  final StorageService _storage = StorageService();

  PickedImageData? _pickedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _descripcionController.dispose();
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

  Future<void> _guardarNovedad() async {
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
          category: 'novedad',
          file: _pickedImage!.file,
          bytes: _pickedImage!.bytes,
        );
      }

      final novedad = Novedad(
        bitacoraId: bitacora.id!,
        descripcion: _descripcionController.text,
        hora: DateTime.now(),
        foto: fotoUrl,
      );

      await _service.addNovedad(novedad);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Novedad registrada')),
        );
        _descripcionController.clear();
        setState(() {
          _pickedImage = null;
        });
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
    final provider = context.watch<BitacoraProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Novedad'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Formulario
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info de la bitácora
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                provider.sucursalActual?.nombre ?? 'Sucursal',
                                style: FlutterFlowTheme.of(context).titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Descripción
                      TextFormField(
                        controller: _descripcionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Descripción de la Novedad',
                          alignLabelWithHint: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 80),
                            child: Icon(Icons.description),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese la descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Foto de novedad
                      Text(
                        'Foto de la Novedad (Opcional)',
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
                            height: 180,
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
                                        size: 40,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tocar para tomar foto',
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
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

                      const SizedBox(height: 24),

                      // Botón guardar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _guardarNovedad,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Guardar Novedad'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Lista de novedades recientes
            if (provider.bitacoraActiva != null)
              _buildNovedadesRecientes(provider.bitacoraActiva!.id!),
          ],
        ),
      ),
    );
  }

  Widget _buildNovedadesRecientes(String bitacoraId) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Novedades del turno',
              style: FlutterFlowTheme.of(context).titleSmall,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Novedad>>(
              stream: _service.streamNovedades(bitacoraId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final novedades = snapshot.data!;
                if (novedades.isEmpty) {
                  return const Center(
                    child: Text('Sin novedades registradas'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: novedades.length,
                  itemBuilder: (context, index) {
                    final novedad = novedades[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.warning_amber,
                          color: FlutterFlowTheme.of(context).warning,
                        ),
                        title: Text(
                          novedad.descripcion ?? 'Sin descripción',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          novedad.hora?.toString().substring(11, 16) ?? '',
                        ),
                        trailing: novedad.foto != null
                            ? const Icon(Icons.image)
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
