import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bitacora_provider.dart';
import '../../services/bitacora_service.dart';
import '../../models/bitacora.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla que muestra todas las visitas, vehículos y proveedores
/// con opción de marcar salida
class VisitasAllScreen extends StatefulWidget {
  const VisitasAllScreen({super.key});

  @override
  State<VisitasAllScreen> createState() => _VisitasAllScreenState();
}

class _VisitasAllScreenState extends State<VisitasAllScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BitacoraService _service = BitacoraService();

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
    final provider = context.watch<BitacoraProvider>();
    final bitacoraId = provider.bitacoraActiva?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros del Turno'),
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
      body: bitacoraId == null
          ? const Center(child: Text('No hay bitácora activa'))
          : TabBarView(
              controller: _tabController,
              children: [
                _VisitasListTab(
                    bitacoraId: bitacoraId, service: _service),
                _VehiculosListTab(
                    bitacoraId: bitacoraId, service: _service),
                _ProveedoresListTab(
                    bitacoraId: bitacoraId, service: _service),
              ],
            ),
    );
  }
}

// ============================================================
// Tab de Visitas
// ============================================================
class _VisitasListTab extends StatelessWidget {
  final String bitacoraId;
  final BitacoraService service;

  const _VisitasListTab({required this.bitacoraId, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Bitacora?>(
      stream: service.streamBitacora(bitacoraId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bitacora = snapshot.data;
        final visitas = bitacora?.visitas ?? [];

        if (visitas.isEmpty) {
          return _buildEmptyState('No hay visitas registradas', Icons.person_off);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: visitas.length,
          itemBuilder: (context, index) {
            final v = visitas[index];
            final enSucursal = v.horaSalida == null;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: enSucursal ? Colors.green.shade50 : null,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      enSucursal ? Colors.green : Colors.grey.shade400,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  v.nombre ?? 'Sin nombre',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (v.cedula != null && v.cedula!.isNotEmpty)
                      Text('Cédula: ${v.cedula}'),
                    if (v.motivo != null && v.motivo!.isNotEmpty)
                      Text('Motivo: ${v.motivo}'),
                    if (v.pertenencias != null && v.pertenencias!.isNotEmpty)
                      Text('Pertenencias: ${v.pertenencias}'),
                    Text(
                      'Entrada: ${_formatTime(v.horaEntrada)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (v.horaSalida != null)
                      Text(
                        'Salida: ${_formatTime(v.horaSalida)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: enSucursal
                    ? _MarcarSalidaButton(
                        onPressed: () => _marcarSalida(context, v.id!),
                        label: 'Salida',
                      )
                    : const Icon(Icons.check_circle, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _marcarSalida(BuildContext context, String visitaId) async {
    final confirm = await _confirmDialog(context, 'visita');
    if (confirm != true) return;

    try {
      await service.marcarSalidaVisita(visitaId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salida de visita registrada')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// ============================================================
// Tab de Vehículos
// ============================================================
class _VehiculosListTab extends StatelessWidget {
  final String bitacoraId;
  final BitacoraService service;

  const _VehiculosListTab({required this.bitacoraId, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Bitacora?>(
      stream: service.streamBitacora(bitacoraId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bitacora = snapshot.data;
        final vehiculos = bitacora?.vehiculos ?? [];

        if (vehiculos.isEmpty) {
          return _buildEmptyState(
              'No hay vehículos registrados', Icons.directions_car);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vehiculos.length,
          itemBuilder: (context, index) {
            final v = vehiculos[index];
            final enSucursal = v.horaSalida == null;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: enSucursal ? Colors.blue.shade50 : null,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      enSucursal ? Colors.blue : Colors.grey.shade400,
                  child:
                      const Icon(Icons.directions_car, color: Colors.white),
                ),
                title: Text(
                  v.placa ?? 'Sin placa',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (v.conductor != null && v.conductor!.isNotEmpty)
                      Text('Conductor: ${v.conductor}'),
                    if (v.tipo != null && v.tipo!.isNotEmpty)
                      Text('Tipo: ${v.tipo}'),
                    if (v.motivo != null && v.motivo!.isNotEmpty)
                      Text('Motivo: ${v.motivo}'),
                    Text(
                      'Entrada: ${_formatTime(v.horaEntrada)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (v.horaSalida != null)
                      Text(
                        'Salida: ${_formatTime(v.horaSalida)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: enSucursal
                    ? _MarcarSalidaButton(
                        onPressed: () => _marcarSalida(context, v.id!),
                        label: 'Salida',
                      )
                    : const Icon(Icons.check_circle, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _marcarSalida(BuildContext context, String vehiculoId) async {
    final confirm = await _confirmDialog(context, 'vehículo');
    if (confirm != true) return;

    try {
      await service.marcarSalidaVehiculo(vehiculoId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salida de vehículo registrada')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// ============================================================
// Tab de Proveedores
// ============================================================
class _ProveedoresListTab extends StatelessWidget {
  final String bitacoraId;
  final BitacoraService service;

  const _ProveedoresListTab({required this.bitacoraId, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Bitacora?>(
      stream: service.streamBitacora(bitacoraId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bitacora = snapshot.data;
        final proveedores = bitacora?.proveedores ?? [];

        if (proveedores.isEmpty) {
          return _buildEmptyState(
              'No hay proveedores registrados', Icons.local_shipping);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: proveedores.length,
          itemBuilder: (context, index) {
            final p = proveedores[index];
            final enSucursal = p.horaSalida == null;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: enSucursal ? Colors.orange.shade50 : null,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      enSucursal ? Colors.orange : Colors.grey.shade400,
                  child: const Icon(Icons.local_shipping,
                      color: Colors.white),
                ),
                title: Text(
                  p.nombre ?? 'Sin nombre',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (p.empresa != null && p.empresa!.isNotEmpty)
                      Text('Empresa: ${p.empresa}'),
                    if (p.motivo != null && p.motivo!.isNotEmpty)
                      Text('Motivo: ${p.motivo}'),
                    if (p.pertenencias != null && p.pertenencias!.isNotEmpty)
                      Text('Pertenencias: ${p.pertenencias}'),
                    Text(
                      'Entrada: ${_formatTime(p.horaEntrada)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (p.horaSalida != null)
                      Text(
                        'Salida: ${_formatTime(p.horaSalida)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: enSucursal
                    ? _MarcarSalidaButton(
                        onPressed: () => _marcarSalida(context, p.id!),
                        label: 'Salida',
                      )
                    : const Icon(Icons.check_circle, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _marcarSalida(BuildContext context, String proveedorId) async {
    final confirm = await _confirmDialog(context, 'proveedor');
    if (confirm != true) return;

    try {
      await service.marcarSalidaProveedor(proveedorId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salida de proveedor registrada')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// ============================================================
// Widgets compartidos
// ============================================================

class _MarcarSalidaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _MarcarSalidaButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.exit_to_app, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(80, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

Widget _buildEmptyState(String message, IconData icon) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(message, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
      ],
    ),
  );
}

String _formatTime(DateTime? dt) {
  if (dt == null) return 'N/A';
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

Future<bool?> _confirmDialog(BuildContext context, String tipo) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirmar Salida'),
      content: Text('¿Registrar la salida de este $tipo?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
          child: const Text('Registrar Salida'),
        ),
      ],
    ),
  );
}
