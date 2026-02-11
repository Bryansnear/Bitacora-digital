import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/bitacora_service.dart';
import '../../models/user_profile.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

/// CRUD de Vigilantes/Usuarios para administradores
/// Usa Supabase Realtime para reflejar cambios automáticamente
class VigilantesScreen extends StatefulWidget {
  const VigilantesScreen({super.key});

  @override
  State<VigilantesScreen> createState() => _VigilantesScreenState();
}

class _VigilantesScreenState extends State<VigilantesScreen> {
  final _client = Supabase.instance.client;
  final _service = BitacoraService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo Usuario'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<UserProfile>>(
        stream: _service.streamUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 64,
                      color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('No hay usuarios registrados'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserCard(user);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(UserProfile user) {
    Color rolColor;
    switch (user.rol) {
      case 'administrador':
        rolColor = Colors.red;
        break;
      case 'jefe_seguridad':
        rolColor = Colors.orange;
        break;
      default:
        rolColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rolColor,
          backgroundImage:
              user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
          child: user.photoUrl == null
              ? Text(
                  user.displayName?.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(color: Colors.white),
                )
              : null,
        ),
        title: Text(
          user.displayName ?? 'Sin nombre',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email ?? ''),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: rolColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatRol(user.rol),
                style: TextStyle(color: rolColor, fontSize: 12),
              ),
            ),
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
              value: 'role',
              child: ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Cambiar Rol'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'instituciones',
              child: ListTile(
                leading: Icon(Icons.business),
                title: Text('Asignar Instituciones'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditDialog(context, user);
                break;
              case 'role':
                _showRoleDialog(context, user);
                break;
              case 'instituciones':
                _showInstitucionesDialog(context, user);
                break;
            }
          },
        ),
      ),
    );
  }

  String _formatRol(String? rol) {
    switch (rol) {
      case 'administrador':
        return 'Administrador';
      case 'jefe_seguridad':
        return 'Jefe de Seguridad';
      case 'vigilante':
        return 'Vigilante';
      default:
        return rol ?? 'Sin rol';
    }
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nombreController = TextEditingController();
    final cedulaController = TextEditingController();
    String selectedRol = 'vigilante';

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Nuevo Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cedulaController,
                  decoration: const InputDecoration(
                    labelText: 'Cédula',
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRol,
                  decoration: const InputDecoration(
                    labelText: 'Rol',
                    prefixIcon: Icon(Icons.admin_panel_settings),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'vigilante', child: Text('Vigilante')),
                    DropdownMenuItem(
                        value: 'jefe_seguridad',
                        child: Text('Jefe de Seguridad')),
                    DropdownMenuItem(
                        value: 'administrador',
                        child: Text('Administrador')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setDialogState(() => selectedRol = v);
                    }
                  },
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
      ),
    );

    if (result == true && emailController.text.isNotEmpty) {
      try {
        // Crear usuario via admin API o signup
        final response = await _client.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
          data: {
            'display_name': nombreController.text.trim(),
          },
        );

        // Actualizar perfil con rol y cédula
        if (response.user != null) {
          await _client.from('users').update({
            'rol': selectedRol,
            'cedula': cedulaController.text.trim(),
            'display_name': nombreController.text.trim(),
          }).eq('id', response.user!.id);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario creado')),
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

  Future<void> _showEditDialog(BuildContext context, UserProfile user) async {
    final nombreController =
        TextEditingController(text: user.displayName);
    final cedulaController = TextEditingController(text: user.cedula);
    final phoneController = TextEditingController(text: user.phoneNumber);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
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
        await _client.from('users').update({
          'display_name': nombreController.text.trim(),
          'cedula': cedulaController.text.trim(),
          'phone_number': phoneController.text.trim(),
        }).eq('id', user.id!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario actualizado')),
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

  Future<void> _showRoleDialog(BuildContext context, UserProfile user) async {
    String? selectedRol = user.rol;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Cambiar rol de ${user.displayName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Vigilante'),
                value: 'vigilante',
                groupValue: selectedRol,
                onChanged: (v) => setDialogState(() => selectedRol = v),
              ),
              RadioListTile<String>(
                title: const Text('Jefe de Seguridad'),
                value: 'jefe_seguridad',
                groupValue: selectedRol,
                onChanged: (v) => setDialogState(() => selectedRol = v),
              ),
              RadioListTile<String>(
                title: const Text('Administrador'),
                value: 'administrador',
                groupValue: selectedRol,
                onChanged: (v) => setDialogState(() => selectedRol = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, selectedRol),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    if (result != null && result != user.rol) {
      try {
        await _client
            .from('users')
            .update({'rol': result}).eq('id', user.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rol actualizado a ${_formatRol(result)}')),
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

  Future<void> _showInstitucionesDialog(
      BuildContext context, UserProfile user) async {
    // Obtener todas las instituciones
    final response = await _client
        .from('instituciones')
        .select('id, nombre')
        .order('nombre');

    final instituciones = (response as List)
        .map((e) => {'id': e['id'] as String, 'nombre': e['nombre'] as String})
        .toList();

    final assigned = Set<String>.from(user.instituciones ?? []);

    if (!mounted) return;

    final result = await showDialog<Set<String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Instituciones de ${user.displayName}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: instituciones.map((inst) {
                final id = inst['id']!;
                return CheckboxListTile(
                  title: Text(inst['nombre']!),
                  value: assigned.contains(id),
                  onChanged: (checked) {
                    setDialogState(() {
                      if (checked == true) {
                        assigned.add(id);
                      } else {
                        assigned.remove(id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, assigned),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      try {
        await _client.from('users').update({
          'instituciones': result.toList(),
        }).eq('id', user.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Instituciones asignadas')),
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
