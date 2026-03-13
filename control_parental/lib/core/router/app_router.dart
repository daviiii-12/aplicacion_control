import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/device_settings/presentation/settings_screen.dart';
import '../../features/schedules/presentation/schedules_screen.dart'; // Importamos la nueva pantalla
import '../../shared/widgets/main_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(child: DashboardScreen()),
        ),
        GoRoute(
          path: '/schedules', // Nueva ruta para horarios
          pageBuilder: (context, state) => const NoTransitionPage(child: SchedulesScreen()),
        ),
        GoRoute(
          path: '/stats',
          pageBuilder: (context, state) => const NoTransitionPage(child: StatsScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),
  ],
);