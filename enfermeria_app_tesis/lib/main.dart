import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'servicios/deep_link_service.dart';
import 'pantallas/auth/nueva_password_screen.dart';
import 'pantallas/auth/confirmar_codigo_screen.dart';
import 'pantallas/auth/ingresar_codigo_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DeepLinkService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey<NavigatorState>();
    _listenToDeepLinks();
  }

  void _listenToDeepLinks() {
    DeepLinkService.deepLinkStream?.listen((uri) {
      print("Deep linkl detectado: $uri");

      Future.delayed(const Duration(milliseconds: 500), () {
        final context = _navigatorKey.currentContext;
        if (context != null) {
          DeepLinkService.handleDeepLink(context, uri.toString());
        }
      });
    });
  }

  @override
  void dispose() {
    DeepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enfermería APP',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      supportedLocales: const[
        Locale('es', 'ES'),
        Locale('en', 'US')
      ],
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      routes: {
        ...AppRoutes.routes,
        '/nueva-password': (context) => const NuevaPasswordScreen(),
        '/confirmar-codigo': (context) => const ConfirmarCodigoScreen(),
        '/ingresar-codigo': (context) => const IngresarCodigoScreen(),
      },
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
