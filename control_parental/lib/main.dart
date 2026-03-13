import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importación necesaria para el idioma
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén listos antes de ejecutar código asíncrono
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Inicializa los datos de fecha para español
  await initializeDateFormatting('es', null); 

  runApp(
    const ProviderScope(
      child: SleepDomeApp(),
    ),
  );
}

class SleepDomeApp extends StatelessWidget {
  const SleepDomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Control Parental Domo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
