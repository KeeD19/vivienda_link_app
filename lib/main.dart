import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/Auth_provider.dart';
import './screens/login/Login.dart';
import './screens/home/Home.dart';
import './providers/Orders_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OrdersProvider()),
      // Agrega otros Providers aquí si es necesario
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth Demo',
        home: AuthWrapper(),
      ),
    );
  }
}

// Este widget decide a qué pantalla redirigir según el estado de autenticación
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return HomePage();
    // return authProvider.isAuthenticated
    //     ? HomePage()
    //     : LoginPage(showLoginPage: () {});
  }
}
