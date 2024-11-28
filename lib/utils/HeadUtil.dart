import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Auth_provider.dart';
import '../providers/Notification_Provider.dart';
import '../screens/home/Home.dart';
import '../screens/login/Login.dart';
import '../screens/notifications/Notificaciones.dart';
import '../screens/onboarding/onboarding_screen.dart';
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
  // late String _identificador;
  @override
  void initState() {
    super.initState();
    loadData();
    // notificationProvider.getNotificaciones();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Aquí puedes mostrar una notificación, dialog o snack bar
      loadData();
    });
  }

  Future<void> loadData() async {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.getTypeUser();
    if (authProvider.typeUser == 3) {
      // _identificador = "Cliente";
      notificationProvider.getNotificaciones("Cliente");
    } else {
      // _identificador = "Proveedor";
      notificationProvider.getNotificaciones("Proveedor");
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Alinea el contenido a la izquierda
        children: [
          Transform.scale(
            scale: 2.0, // Ajusta el valor para cambiar el tamaño
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10), // Espaciado entre el logo y el texto
          const Text(
            'EXCLUSIFY',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: AppColors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificacionesPage()),
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
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Material(
                    color: Colors.transparent, // Fondo transparente
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7, // 70% del ancho
                      height: MediaQuery.of(context).size.height, // 100% del alto
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor, // Fondo azul
                        borderRadius: BorderRadius.circular(8), // Bordes redondeados opcionales
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                          ),
                          ListTile(
                            leading: const Icon(Icons.home, color: AppColors.white),
                            title: const Text('Home', style: TextStyle(color: AppColors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.person_outline, color: AppColors.white),
                            title: const Text('Perfil', style: TextStyle(color: AppColors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PerfilView()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout, color: AppColors.white),
                            title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.white)),
                            onTap: () {
                              authProvider.logout();
                              if (authProvider.successMessage == "Cerrado") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage(showLoginPage: () {})),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
      backgroundColor: AppColors.backgroundColor,
      automaticallyImplyLeading: false,
    );
  }
}
