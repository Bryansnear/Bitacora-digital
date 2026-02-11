import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bitacora_provider.dart';
import '../../services/bitacora_service.dart';
import '../../models/institucion.dart';
import '../../models/sucursal.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla principal del guardia - Selección de sucursal e inicio de turno
class HomeGuardiaScreen extends StatefulWidget {
  const HomeGuardiaScreen({super.key});

  @override
  State<HomeGuardiaScreen> createState() => _HomeGuardiaScreenState();
}

class _HomeGuardiaScreenState extends State<HomeGuardiaScreen> {
  final BitacoraService _service = BitacoraService();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bitacoraProvider = context.watch<BitacoraProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora Digital'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
        actions: [
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        child: Text(
                          user?.displayName?.substring(0, 1).toUpperCase() ??
                              'U',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenido,',
                              style: FlutterFlowTheme.of(context).bodySmall,
                            ),
                            Text(
                              user?.displayName ?? 'Usuario',
                              style: FlutterFlowTheme.of(context).headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Si hay bitácora activa, mostrar acciones de turno
              if (bitacoraProvider.tieneBitacoraActiva) ...[
                _buildTurnoActivoCard(bitacoraProvider),
              ] else ...[
                // Selector de institución/sucursal
                _buildSelectorInstitucion(),
                const SizedBox(height: 16),
                if (bitacoraProvider.institucionActual != null)
                  _buildSelectorSucursal(
                      bitacoraProvider.institucionActual!.id!),
              ],

              const Spacer(),

              // Botón de acción principal
              if (bitacoraProvider.sucursalActual != null &&
                  !bitacoraProvider.tieneBitacoraActiva)
                _buildIniciarTurnoButton(authProvider, bitacoraProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTurnoActivoCard(BitacoraProvider provider) {
    final bitacora = provider.bitacoraActiva!;

    return Card(
      color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Turno Activo',
                  style: FlutterFlowTheme.of(context).titleMedium?.copyWith(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Sucursal: ${provider.sucursalActual?.nombre ?? "N/A"}'),
            Text(
              'Inicio: ${bitacora.fechaHoraApertura?.toString().substring(0, 16) ?? "N/A"}',
            ),
            const SizedBox(height: 16),

            // Acciones rápidas
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickAction(
                  icon: Icons.door_front_door,
                  label: 'Apertura',
                  onTap: () => context.push('/guardia/apertura'),
                ),
                _buildQuickAction(
                  icon: Icons.person_add,
                  label: 'Registro',
                  onTap: () => context.push('/guardia/registro'),
                ),
                _buildQuickAction(
                  icon: Icons.warning_amber,
                  label: 'Novedad',
                  onTap: () => context.push('/guardia/novedad'),
                ),
                _buildQuickAction(
                  icon: Icons.list_alt,
                  label: 'Visitas',
                  onTap: () => context.push('/guardia/visitasall'),
                ),
                _buildQuickAction(
                  icon: Icons.supervisor_account,
                  label: 'Supervisión',
                  onTap: () => context.push('/guardia/supervision'),
                ),
                _buildQuickAction(
                  icon: Icons.lock_clock,
                  label: 'Cierre',
                  onTap: () => context.push('/guardia/cierre'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorInstitucion() {
    return StreamBuilder<List<Institucion>>(
      stream: _service.streamInstituciones(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final instituciones = snapshot.data!;
        final provider = context.read<BitacoraProvider>();

        return DropdownButtonFormField<Institucion>(
          decoration: InputDecoration(
            labelText: 'Seleccione Institución',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.business),
          ),
          value: provider.institucionActual,
          items: instituciones.map((inst) {
            return DropdownMenuItem(
              value: inst,
              child: Text(inst.nombre ?? 'Sin nombre'),
            );
          }).toList(),
          onChanged: (inst) {
            if (inst != null) {
              provider.setInstitucion(inst);
            }
          },
        );
      },
    );
  }

  Widget _buildSelectorSucursal(String institucionId) {
    return StreamBuilder<List<Sucursal>>(
      stream: _service.streamSucursales(institucionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final sucursales = snapshot.data!;
        final provider = context.read<BitacoraProvider>();

        return DropdownButtonFormField<Sucursal>(
          decoration: InputDecoration(
            labelText: 'Seleccione Sucursal',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.location_on),
          ),
          value: provider.sucursalActual,
          items: sucursales.map((suc) {
            return DropdownMenuItem(
              value: suc,
              child: Text(suc.nombre ?? 'Sin nombre'),
            );
          }).toList(),
          onChanged: (suc) async {
            if (suc != null) {
              await provider.setSucursal(suc);
            }
          },
        );
      },
    );
  }

  Widget _buildIniciarTurnoButton(
    AuthProvider authProvider,
    BitacoraProvider bitacoraProvider,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: bitacoraProvider.isLoading
            ? null
            : () async {
                final success = await bitacoraProvider.iniciarTurno(
                  authProvider.currentUser!.id!,
                );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Turno iniciado exitosamente')),
                  );
                }
              },
        icon: bitacoraProvider.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.play_arrow),
        label: const Text('Iniciar Turno'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
