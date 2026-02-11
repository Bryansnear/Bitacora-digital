import 'package:flutter/material.dart';
import '../../services/bitacora_service.dart';
import '../../models/bitacora.dart';
import '../../models/novedad.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla de detalle de bitácora para administradores
class BitacoraDetailScreen extends StatefulWidget {
  final String bitacoraId;

  const BitacoraDetailScreen({
    super.key,
    required this.bitacoraId,
  });

  @override
  State<BitacoraDetailScreen> createState() => _BitacoraDetailScreenState();
}

class _BitacoraDetailScreenState extends State<BitacoraDetailScreen>
    with SingleTickerProviderStateMixin {
  final BitacoraService _service = BitacoraService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Detalle de Bitácora'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Visitas'),
            Tab(text: 'Novedades'),
            Tab(text: 'Vehículos'),
          ],
        ),
      ),
      body: StreamBuilder<Bitacora?>(
        stream: _service.streamBitacora(widget.bitacoraId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bitacora = snapshot.data;
          if (bitacora == null) {
            return const Center(child: Text('Bitácora no encontrada'));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildGeneralTab(bitacora),
              _buildVisitasTab(bitacora),
              _buildNovedadesTab(),
              _buildVehiculosTab(bitacora),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGeneralTab(Bitacora bitacora) {
    final b = bitacora;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    b.isOpen ? Icons.lock_open : Icons.lock,
                    color: b.isOpen ? Colors.green : Colors.grey,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado',
                        style: FlutterFlowTheme.of(context).bodySmall,
                      ),
                      Text(
                        b.estado,
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Apertura
          _buildSeccion(
            'Apertura',
            Icons.lock_open,
            Colors.green,
            [
              _buildDato('Hora', b.fechaHoraApertura?.toString() ?? 'N/A'),
              _buildDato('Vigilante', b.vigilanteApertura ?? 'N/A'),
              _buildDato('Encargado', b.encargadoApertura ?? 'N/A'),
              _buildDato('Novedad', b.novedadApertura ?? 'Sin novedad'),
            ],
          ),
          const SizedBox(height: 16),

          // Cierre
          if (b.fechaHoraCierre != null)
            _buildSeccion(
              'Cierre',
              Icons.lock,
              Colors.red,
              [
                _buildDato('Hora', b.fechaHoraCierre?.toString() ?? 'N/A'),
                _buildDato('Vigilante', b.vigilanteCierre ?? 'N/A'),
                _buildDato('Encargado', b.encargadoCierre ?? 'N/A'),
                _buildDato('Novedad', b.novedadCierre ?? 'Sin novedad'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSeccion(
    String titulo,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: FlutterFlowTheme.of(context).titleMedium?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDato(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitasTab(Bitacora bitacora) {
    final visitas = bitacora.visitas;
    if (visitas.isEmpty) {
      return const Center(child: Text('Sin visitas registradas'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: visitas.length,
      itemBuilder: (context, index) {
        final v = visitas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(v.nombre ?? 'Sin nombre'),
            subtitle: Text(v.motivo ?? ''),
            trailing: Text(
              v.horaEntrada?.toString().substring(11, 16) ?? '',
            ),
          ),
        );
      },
    );
  }

  Widget _buildNovedadesTab() {
    return StreamBuilder<List<Novedad>>(
      stream: _service.streamNovedades(widget.bitacoraId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final novedades = snapshot.data!;
        if (novedades.isEmpty) {
          return const Center(child: Text('Sin novedades'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: novedades.length,
          itemBuilder: (context, index) {
            final n = novedades[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.warning, color: Colors.white),
                ),
                title: Text(n.descripcion ?? 'Sin descripción'),
                subtitle: Text(n.hora?.toString().substring(11, 16) ?? ''),
                trailing: n.foto != null ? const Icon(Icons.image) : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVehiculosTab(Bitacora bitacora) {
    final vehiculos = bitacora.vehiculos;
    if (vehiculos.isEmpty) {
      return const Center(child: Text('Sin vehículos registrados'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehiculos.length,
      itemBuilder: (context, index) {
        final v = vehiculos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.directions_car)),
            title: Text(v.placa ?? 'Sin placa'),
            subtitle: Text(v.conductor ?? ''),
            trailing: Text(
              v.horaEntrada?.toString().substring(11, 16) ?? '',
            ),
          ),
        );
      },
    );
  }
}
