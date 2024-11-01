import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/Auth_provider.dart';
import './screens/login/Login.dart';
import './screens/home/Home.dart';
import './providers/Orders_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Demo',
      home: AuthWrapper(),
    );
  }
}

// Este widget decide a qué pantalla redirigir según el estado de autenticación
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.verifySesion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.userValidate != 0
        ? const HomePage()
        : const OnBoardingScreen();
    // : LoginPage(showLoginPage: () {});
  }
}
