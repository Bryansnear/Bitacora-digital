import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bitacora_provider.dart';
import '../../services/bitacora_service.dart';
import '../../services/storage_service.dart';
import '../../utils/image_utils.dart';
import '../../models/visita.dart';
import '../../models/vehiculo.dart';
import '../../models/proveedor_visita.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla para registrar visitas, vehículos y proveedores
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BitacoraService _service = BitacoraService();
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Visitas'),
            Tab(icon: Icon(Icons.directions_car), text: 'Vehículos'),
            Tab(icon: Icon(Icons.local_shipping), text: 'Proveedores'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _VisitasTab(service: _service, storage: _storage),
          _VehiculosTab(service: _service, storage: _storage),
          _ProveedoresTab(service: _service, storage: _storage),
        ],
      ),
    );
  }
}

/// Widget reutilizable para previsualización de foto
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
          'Foto (Opcional)',
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
                          'Tocar para tomar foto',
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

/// Tab de Visitas
class _VisitasTab extends StatefulWidget {
  final BitacoraService service;
  final StorageService storage;
  const _VisitasTab({required this.service, required this.storage});

  @override
  State<_VisitasTab> createState() => _VisitasTabState();
}

class _VisitasTabState extends State<_VisitasTab> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _motivoController = TextEditingController();
  final _pertenenciasController = TextEditingController();
  PickedImageData? _pickedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _motivoController.dispose();
    _pertenenciasController.dispose();
    super.dispose();
  }

  Future<void> _registrarVisita() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BitacoraProvider>();
    if (provider.bitacoraActiva == null) return;

    setState(() => _isLoading = true);

    try {
      String? fotoUrl;
      if (_pickedImage != null) {
        fotoUrl = await widget.storage.uploadBitacoraPhoto(
          bitacoraId: provider.bitacoraActiva!.id!,
          category: 'visita',
          file: _pickedImage!.file,
          bytes: _pickedImage!.bytes,
        );
      }

      final visita = Visita(
        bitacoraId: provider.bitacoraActiva!.id!,
        nombre: _nombreController.text,
        cedula: _cedulaController.text,
        motivo: _motivoController.text,
        pertenencias: _pertenenciasController.text.isNotEmpty
            ? _pertenenciasController.text
            : null,
        horaEntrada: DateTime.now(),
        foto: fotoUrl,
      );

      await widget.service.addVisita(visita);

      _nombreController.clear();
      _cedulaController.clear();
      _motivoController.clear();
      _pertenenciasController.clear();
      setState(() => _pickedImage = null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visita registrada')),
        );
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del Visitante',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cedulaController,
              decoration: InputDecoration(
                labelText: 'Cédula',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _motivoController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Motivo de la Visita',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pertenenciasController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Pertenencias (Opcional)',
                prefixIcon: const Icon(Icons.inventory_2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Laptop, mochila, herramientas...',
              ),
            ),
            const SizedBox(height: 16),
            _FotoPreview(
              image: _pickedImage,
              onTap: () async {
                final img = await ImageUtils.takePhoto();
                if (img != null) setState(() => _pickedImage = img);
              },
              onDelete: () => setState(() => _pickedImage = null),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _registrarVisita,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Registrar Entrada'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
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
    );
  }
}

/// Tab de Vehículos
class _VehiculosTab extends StatefulWidget {
  final BitacoraService service;
  final StorageService storage;
  const _VehiculosTab({required this.service, required this.storage});

  @override
  State<_VehiculosTab> createState() => _VehiculosTabState();
}

class _VehiculosTabState extends State<_VehiculosTab> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _conductorController = TextEditingController();
  final _tipoController = TextEditingController();
  PickedImageData? _pickedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _placaController.dispose();
    _conductorController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  Future<void> _registrarVehiculo() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BitacoraProvider>();
    if (provider.bitacoraActiva == null) return;

    setState(() => _isLoading = true);

    try {
      String? fotoUrl;
      if (_pickedImage != null) {
        fotoUrl = await widget.storage.uploadBitacoraPhoto(
          bitacoraId: provider.bitacoraActiva!.id!,
          category: 'vehiculo',
          file: _pickedImage!.file,
          bytes: _pickedImage!.bytes,
        );
      }

      final vehiculo = Vehiculo(
        bitacoraId: provider.bitacoraActiva!.id!,
        placa: _placaController.text,
        conductor: _conductorController.text,
        tipo: _tipoController.text,
        horaEntrada: DateTime.now(),
        foto: fotoUrl,
      );

      await widget.service.addVehiculo(vehiculo);

      _placaController.clear();
      _conductorController.clear();
      _tipoController.clear();
      setState(() => _pickedImage = null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo registrado')),
        );
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _placaController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Placa del Vehículo',
                prefixIcon: const Icon(Icons.directions_car),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _conductorController,
              decoration: InputDecoration(
                labelText: 'Nombre del Conductor',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tipoController,
              decoration: InputDecoration(
                labelText: 'Tipo de Vehículo',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _FotoPreview(
              image: _pickedImage,
              onTap: () async {
                final img = await ImageUtils.takePhoto();
                if (img != null) setState(() => _pickedImage = img);
              },
              onDelete: () => setState(() => _pickedImage = null),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _registrarVehiculo,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Registrar Vehículo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
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
    );
  }
}

/// Tab de Proveedores
class _ProveedoresTab extends StatefulWidget {
  final BitacoraService service;
  final StorageService storage;
  const _ProveedoresTab({required this.service, required this.storage});

  @override
  State<_ProveedoresTab> createState() => _ProveedoresTabState();
}

class _ProveedoresTabState extends State<_ProveedoresTab> {
  final _formKey = GlobalKey<FormState>();
  final _empresaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _motivoController = TextEditingController();
  PickedImageData? _pickedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _empresaController.dispose();
    _nombreController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _registrarProveedor() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BitacoraProvider>();
    if (provider.bitacoraActiva == null) return;

    setState(() => _isLoading = true);

    try {
      String? fotoUrl;
      if (_pickedImage != null) {
        fotoUrl = await widget.storage.uploadBitacoraPhoto(
          bitacoraId: provider.bitacoraActiva!.id!,
          category: 'proveedor',
          file: _pickedImage!.file,
          bytes: _pickedImage!.bytes,
        );
      }

      final proveedor = ProveedorVisita(
        bitacoraId: provider.bitacoraActiva!.id!,
        empresa: _empresaController.text,
        nombre: _nombreController.text,
        motivo: _motivoController.text,
        horaEntrada: DateTime.now(),
        foto: fotoUrl,
      );

      await widget.service.addProveedorVisita(proveedor);

      _empresaController.clear();
      _nombreController.clear();
      _motivoController.clear();
      setState(() => _pickedImage = null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proveedor registrado')),
        );
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _empresaController,
              decoration: InputDecoration(
                labelText: 'Empresa',
                prefixIcon: const Icon(Icons.business),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del Representante',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _motivoController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Motivo de la Visita',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _FotoPreview(
              image: _pickedImage,
              onTap: () async {
                final img = await ImageUtils.takePhoto();
                if (img != null) setState(() => _pickedImage = img);
              },
              onDelete: () => setState(() => _pickedImage = null),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _registrarProveedor,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Registrar Proveedor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
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
    );
  }
}
