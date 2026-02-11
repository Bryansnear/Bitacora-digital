import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bitacora_provider.dart';
import '../../services/bitacora_service.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// Pantalla para registrar supervisión y relevo de guardia
class SupervisionRelevoScreen extends StatefulWidget {
  const SupervisionRelevoScreen({super.key});

  @override
  State<SupervisionRelevoScreen> createState() =>
      _SupervisionRelevoScreenState();
}

class _SupervisionRelevoScreenState extends State<SupervisionRelevoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BitacoraService _service = BitacoraService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Supervisión y Relevo'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.supervisor_account), text: 'Supervisión'),
            Tab(icon: Icon(Icons.swap_horiz), text: 'Relevo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SupervisionTab(service: _service),
          _RelevoTab(service: _service),
        ],
      ),
    );
  }
}

/// Pestaña de Supervisión
class _SupervisionTab extends StatefulWidget {
  final BitacoraService service;
  const _SupervisionTab({required this.service});

  @override
  State<_SupervisionTab> createState() => _SupervisionTabState();
}

class _SupervisionTabState extends State<_SupervisionTab> {
  final _supervisorController = TextEditingController();
  final _observacionesController = TextEditingController();
  bool _isLoading = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  void _loadExisting() {
    final provider = context.read<BitacoraProvider>();
    final supervision = provider.bitacoraActiva?.supervision;
    if (supervision != null && supervision.isNotEmpty) {
      _supervisorController.text = supervision['supervisor'] ?? '';
      _observacionesController.text = supervision['observaciones'] ?? '';
      setState(() => _saved = true);
    }
  }

  @override
  void dispose() {
    _supervisorController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _guardarSupervision() async {
    final provider = context.read<BitacoraProvider>();
    if (provider.bitacoraActiva == null) return;

    setState(() => _isLoading = true);

    try {
      await widget.service.updateSupervision(
        provider.bitacoraActiva!.id!,
        {
          'supervisor': _supervisorController.text.trim(),
          'observaciones': _observacionesController.text.trim(),
          'hora': DateTime.now().toIso8601String(),
        },
      );

      setState(() => _saved = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Supervisión registrada')),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_saved)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Supervisión registrada',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          Text(
            'Datos de Supervisión',
            style: FlutterFlowTheme.of(context).titleMedium,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _supervisorController,
            decoration: InputDecoration(
              labelText: 'Nombre del Supervisor',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _observacionesController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Observaciones',
              prefixIcon: const Icon(Icons.notes),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _guardarSupervision,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_saved
                  ? 'Actualizar Supervisión'
                  : 'Registrar Supervisión'),
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
    );
  }
}

/// Pestaña de Relevo
class _RelevoTab extends StatefulWidget {
  final BitacoraService service;
  const _RelevoTab({required this.service});

  @override
  State<_RelevoTab> createState() => _RelevoTabState();
}

class _RelevoTabState extends State<_RelevoTab> {
  final _vigilanteRelevoController = TextEditingController();
  final _observacionesController = TextEditingController();
  bool _isLoading = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  void _loadExisting() {
    final provider = context.read<BitacoraProvider>();
    final relevo = provider.bitacoraActiva?.relevo;
    if (relevo != null && relevo.isNotEmpty) {
      _vigilanteRelevoController.text = relevo['vigilante_relevo'] ?? '';
      _observacionesController.text = relevo['observaciones'] ?? '';
      setState(() => _saved = true);
    }
  }

  @override
  void dispose() {
    _vigilanteRelevoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _guardarRelevo() async {
    final provider = context.read<BitacoraProvider>();
    if (provider.bitacoraActiva == null) return;

    setState(() => _isLoading = true);

    try {
      await widget.service.updateRelevo(
        provider.bitacoraActiva!.id!,
        {
          'vigilante_relevo': _vigilanteRelevoController.text.trim(),
          'observaciones': _observacionesController.text.trim(),
          'hora': DateTime.now().toIso8601String(),
        },
      );

      setState(() => _saved = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relevo registrado')),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_saved)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Relevo registrado',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
          Text(
            'Datos de Relevo',
            style: FlutterFlowTheme.of(context).titleMedium,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _vigilanteRelevoController,
            decoration: InputDecoration(
              labelText: 'Nombre del Vigilante de Relevo',
              prefixIcon: const Icon(Icons.swap_horiz),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _observacionesController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Observaciones del Relevo',
              prefixIcon: const Icon(Icons.notes),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _guardarRelevo,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_saved ? 'Actualizar Relevo' : 'Registrar Relevo'),
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
    );
  }
}
