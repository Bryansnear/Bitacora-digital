import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../services/bitacora_service.dart';
import '../../models/institucion.dart';
import '../../models/sucursal.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Dashboard de administración
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BitacoraService _service = BitacoraService();
  Institucion? _institucionSeleccionada;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.business),
            tooltip: 'Gestionar Instituciones',
            onPressed: () => context.push('/admin/instituciones'),
          ),
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Gestionar Usuarios',
            onPressed: () => context.push('/admin/vigilantes'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/perfil'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            // En móvil: si hay institución seleccionada, mostrar sucursales; si no, mostrar lista
            if (_institucionSeleccionada != null) {
              return Column(
                children: [
                  // Barra de navegación para volver a la lista
                  Container(
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              _institucionSeleccionada = null;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            _institucionSeleccionada?.nombre ?? '',
                            style: FlutterFlowTheme.of(context).titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildSucursalesContent(_institucionSeleccionada!.id!),
                  ),
                ],
              );
            } else {
              return _buildInstitucionesList();
            }
          }

          // En desktop/tablet: layout de dos paneles
          return Row(
            children: [
              // Sidebar de instituciones
              Container(
                width: 280,
                color: Colors.grey.shade100,
                child: _buildInstitucionesList(),
              ),
              // Contenido principal
              Expanded(
                child: _institucionSeleccionada == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seleccione una institución',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : _buildSucursalesContent(_institucionSeleccionada!.id!),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInstitucionesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Instituciones',
            style: FlutterFlowTheme.of(context).titleMedium,
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Institucion>>(
            stream: _service.streamInstituciones(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final instituciones = snapshot.data!;
              if (instituciones.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay instituciones',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Usa el botón de Instituciones en la barra superior para crear una',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: instituciones.length,
                itemBuilder: (context, index) {
                  final inst = instituciones[index];
                  final isSelected = _institucionSeleccionada?.id == inst.id;

                  return ListTile(
                    selected: isSelected,
                    selectedTileColor:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? FlutterFlowTheme.of(context).primary
                          : Colors.grey,
                      child: Text(
                        inst.nombre?.substring(0, 1).toUpperCase() ?? '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(inst.nombre ?? 'Sin nombre'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      setState(() {
                        _institucionSeleccionada = inst;
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSucursalesContent(String institucionId) {
    return _buildSucursalesGrid(institucionId);
  }

  Widget _buildSucursalesGrid(String institucionId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Sucursales de ${_institucionSeleccionada?.nombre}',
                style: FlutterFlowTheme.of(context).titleLarge,
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Agregar nueva sucursal
                },
                icon: const Icon(Icons.add),
                label: const Text('Nueva Sucursal'),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Sucursal>>(
            stream: _service.streamSucursales(institucionId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final sucursales = snapshot.data!;
              if (sucursales.isEmpty) {
                return const Center(
                  child: Text('No hay sucursales registradas'),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 900
                        ? 3
                        : constraints.maxWidth > 500
                            ? 2
                            : 1;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: sucursales.length,
                      itemBuilder: (context, index) {
                        final sucursal = sucursales[index];
                        return _buildSucursalCard(sucursal);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSucursalCard(Sucursal sucursal) {
    final activa = sucursal.bitacoraActualId != null;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (sucursal.bitacoraActualId != null) {
            context.push('/admin/bitacora/${sucursal.bitacoraActualId}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sucursal.nombre ?? 'Sin nombre',
                      style: FlutterFlowTheme.of(context).titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: activa ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activa ? 'Activa' : 'Inactiva',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Estado: ${sucursal.estado}',
                style: FlutterFlowTheme.of(context).bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Ver historial
                    },
                    child: const Text('Historial'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
