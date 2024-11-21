import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/Auth_provider.dart';
import './screens/home/Home.dart';
import './providers/Orders_provider.dart';
import 'providers/Notification_Provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'env.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notificación abierta desde segundo plano: ${message.data}');
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('Notificación recibida al iniciar: ${message.data}');
    }
  });
  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // Solicita permisos para iOS
    messaging.requestPermission();
  }

  Future<void> _checkUserStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.verifySesion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return authProvider.userValidate > 0 ? const HomePage() : const OnBoardingScreen();
      },
    );
  }
}
