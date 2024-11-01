import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Auth_provider.dart';
import '../screens/home/Home.dart';
import '../screens/perfil/PerfilView.dart';
import 'Colors_Utils.dart';

class HeadUtil extends StatelessWidget implements PreferredSizeWidget {
  const HeadUtil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Vivienda Link',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.blueSecondColor,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.menu,
            color: AppColors.blueSecondColor,
          ),
          onSelected: (String option) => _onMenuOptionSelected(context, option),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'Home',
              child: Text('Home'),
            ),
            const PopupMenuItem(
              value: 'Perfil',
              child: Text('Perfil'),
            ),
            const PopupMenuItem(
              value: 'Cerrar sesión',
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ],
      backgroundColor: AppColors.backgroundColor,
    );
  }

  void _onMenuOptionSelected(BuildContext context, String option) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    switch (option) {
      case 'Cerrar sesión':
        authProvider.logout();
        break;
      case 'Configuración':
        print("Configuración");
        break;
      case 'Home':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 'Perfil':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilView()),
        );
        break;
    }
  }

  // Implementación requerida por PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
