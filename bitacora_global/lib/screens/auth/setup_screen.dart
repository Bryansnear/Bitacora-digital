import 'package:flutter/material.dart';
import '../../pages/setup_admin_page.dart';

/// Wrapper para la pantalla de setup existente
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reutiliza la página de setup existente
    return const SetupAdminPage();
  }
}
