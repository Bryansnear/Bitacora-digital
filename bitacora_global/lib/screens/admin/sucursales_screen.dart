import 'package:flutter/material.dart';
import '../../services/bitacora_service.dart';
import '../../models/sucursal.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// CRUD de Sucursales para una institución determinada
class SucursalesScreen extends StatefulWidget {
  final String institucionId;
  final String? institucionNombre;

  const SucursalesScreen({
    super.key,
    required this.institucionId,
    this.institucionNombre,
  });

  @override
  State<SucursalesScreen> createState() => _SucursalesScreenState();
}

class _SucursalesScreenState extends State<SucursalesScreen> {
  final BitacoraService _service = BitacoraService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sucursales - ${widget.institucionNombre ?? ''}'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Sucursal'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Sucursal>>(
        stream: _service.streamSucursales(widget.institucionId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sucursales = snapshot.data!;
          if (sucursales.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('No hay sucursales registradas'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sucursales.length,
            itemBuilder: (context, index) {
              final suc = sucursales[index];
              final activa = suc.bitacoraActualId != null;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: activa ? Colors.green : Colors.grey,
                    child: Icon(
                      activa ? Icons.lock_open : Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    suc.nombre ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estado: ${suc.estado}'),
                      if (suc.latitud != null && suc.longitud != null)
                        Text(
                          'Ubicación: ${suc.latitud!.toStringAsFixed(4)}, ${suc.longitud!.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      Text('Radio: ${suc.radioMetros ?? 100}m',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton(
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Editar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Eliminar',
                              style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _showEditDialog(context, suc);
                          break;
                        case 'delete':
                          _confirmDelete(context, suc);
                          break;
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final nombreController = TextEditingController();
    final latController = TextEditingController();
    final lngController = TextEditingController();
    final radioController = TextEditingController(text: '100');

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Sucursal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la sucursal',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: latController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Latitud (opcional)',
                  prefixIcon: Icon(Icons.my_location),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lngController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Longitud (opcional)',
                  prefixIcon: Icon(Icons.my_location),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: radioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Radio permitido (metros)',
                  prefixIcon: Icon(Icons.radar),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == true && nombreController.text.isNotEmpty) {
      try {
        debugPrint('Creando sucursal: ${nombreController.text.trim()} en institución: ${widget.institucionId}');
        await _service.createSucursal(
          institucionId: widget.institucionId,
          nombre: nombreController.text.trim(),
          latitud: double.tryParse(latController.text),
          longitud: double.tryParse(lngController.text),
          radioMetros: double.tryParse(radioController.text) ?? 100,
        );
        debugPrint('Sucursal creada exitosamente');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sucursal creada'), backgroundColor: Colors.green),
          );
        }
      } catch (e, stackTrace) {
        debugPrint('Error creando sucursal: $e');
        debugPrint('StackTrace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creando sucursal: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } else {
      debugPrint('Dialog result: $result, nombre empty: ${nombreController.text.isEmpty}');
    }
  }

  Future<void> _showEditDialog(BuildContext context, Sucursal suc) async {
    final nombreController = TextEditingController(text: suc.nombre);
    final latController =
        TextEditingController(text: suc.latitud?.toString() ?? '');
    final lngController =
        TextEditingController(text: suc.longitud?.toString() ?? '');
    final radioController =
        TextEditingController(text: (suc.radioMetros ?? 100).toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Sucursal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: latController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  prefixIcon: Icon(Icons.my_location),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lngController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  prefixIcon: Icon(Icons.my_location),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: radioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Radio (metros)',
                  prefixIcon: Icon(Icons.radar),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await _service.updateSucursal(
          id: suc.id,
          nombre: nombreController.text.trim(),
          latitud: double.tryParse(latController.text),
          longitud: double.tryParse(lngController.text),
          radioMetros: double.tryParse(radioController.text) ?? 100,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sucursal actualizada')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, Sucursal suc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Sucursal'),
        content: Text('¿Está seguro de eliminar "${suc.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deleteSucursal(suc.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sucursal eliminada')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
