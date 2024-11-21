import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Auth_provider.dart';
import '../providers/Notification_Provider.dart';
import '../screens/home/Home.dart';
import '../screens/notifications/Notificaciones.dart';
import '../screens/perfil/PerfilView.dart';
import 'Colors_Utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HeadUtil extends StatefulWidget implements PreferredSizeWidget {
  const HeadUtil({Key? key}) : super(key: key);

  @override
  _HeadUtilState createState() => _HeadUtilState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeadUtilState extends State<HeadUtil> {
  @override
  void initState() {
    super.initState();
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.getNotificaciones();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido en el encabezado: ${message.notification?.title}');
      notificationProvider.getNotificaciones();
      // Aquí puedes mostrar una notificación, dialog o snack bar
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return AppBar(
      title: const Text(
        'EXCLUSIFY',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.blueSecondColor,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: AppColors.blueSecondColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificacionesPage()),
                );
              },
            ),
            notificationProvider.totalNotificaciones > 0
                ? Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationProvider.totalNotificaciones.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : const Center(),
          ],
        ),
        // Menú de opciones
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
      automaticallyImplyLeading: false,
    );
  }

  void _onMenuOptionSelected(BuildContext context, String option) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    switch (option) {
      case 'Cerrar sesión':
        authProvider.logout();
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
}
