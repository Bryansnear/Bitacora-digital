import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/bitacora_provider.dart';
import '../../services/bitacora_service.dart';
import '../../services/storage_service.dart';
import '../../utils/image_utils.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla de cierre de turno
class CierreScreen extends StatefulWidget {
  const CierreScreen({super.key});

  @override
  State<CierreScreen> createState() => _CierreScreenState();
}

class _CierreScreenState extends State<CierreScreen> {
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

  Future<void> _confirmarCierre() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Cierre'),
        content: const Text(
          '¿Está seguro de cerrar el turno? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cerrar Turno'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final provider = context.read<BitacoraProvider>();
    final bitacora = provider.bitacoraActiva;

    if (bitacora == null) return;

    setState(() => _isLoading = true);

    try {
      String? fotoUrl;
      if (_pickedImage != null) {
        fotoUrl = await _storage.uploadBitacoraPhoto(
          bitacoraId: bitacora.id!,
          category: 'cierre',
          file: _pickedImage!.file,
          bytes: _pickedImage!.bytes,
        );
      }

      await _service.registrarCierre(
        bitacoraId: bitacora.id!,
        encargadoCierre: _encargadoController.text.trim().isEmpty
            ? null
            : _encargadoController.text.trim(),
        novedadCierre: _novedadController.text.trim().isEmpty
            ? null
            : _novedadController.text.trim(),
        fotoCierre: fotoUrl,
      );

      // Finalizar turno
      final success = await provider.finalizarTurno();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Turno cerrado exitosamente')),
        );
        context.go('/guardia');
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
    final bitacora = provider.bitacoraActiva;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cierre de Turno'),
        backgroundColor: Colors.red.shade700,
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
                // Resumen del turno
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.summarize, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Resumen del Turno',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  ?.copyWith(color: Colors.red.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildResumenItem(
                          'Sucursal',
                          provider.sucursalActual?.nombre ?? 'N/A',
                        ),
                        _buildResumenItem(
                          'Hora de inicio',
                          bitacora?.fechaHoraApertura
                                  ?.toString()
                                  .substring(0, 16) ??
                              'N/A',
                        ),
                        _buildResumenItem(
                          'Duración',
                          _calcularDuracion(bitacora?.fechaHoraApertura),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Encargado de cierre
                TextFormField(
                  controller: _encargadoController,
                  decoration: InputDecoration(
                    labelText: 'Encargado de Cierre',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Novedad de cierre
                TextFormField(
                  controller: _novedadController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Novedades de Cierre',
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
                // Foto de cierre
                _FotoPreview(
                  image: _pickedImage,
                  onTap: () async {
                    final img = await ImageUtils.takePhoto();
                    if (img != null) setState(() => _pickedImage = img);
                  },
                  onDelete: () => setState(() => _pickedImage = null),
                ),
                const SizedBox(height: 32),

                // Botón de cierre
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _confirmarCierre,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.lock),
                    label: const Text(
                      'Cerrar Turno',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumenItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _calcularDuracion(DateTime? inicio) {
    if (inicio == null) return 'N/A';
    final diff = DateTime.now().difference(inicio);
    final horas = diff.inHours;
    final minutos = diff.inMinutes % 60;
    return '${horas}h ${minutos}m';
  }
}

/// Widget reutilizable para previsualización de foto (copiado de RegistroScreen por simplicidad)
class _FotoPreview extends StatelessWidget {
  final PickedImageData? image;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FotoPreview({
    required this.image,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto de Cierre (Opcional)',
          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
                image: image != null
                    ? DecorationImage(
                        image: MemoryImage(image!.bytes),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: image == null
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
                          'Tocar para tomar foto de evidencia',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
        if (image != null)
          TextButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red, size: 18),
            label: const Text('Eliminar foto',
                style: TextStyle(color: Colors.red, fontSize: 13)),
          ),
      ],
    );
  }
}
