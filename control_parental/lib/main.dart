import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/schedules/presentation/schedules_screen.dart';
import 'features/ambient/presentation/ambient_screen.dart';
import 'features/stats/presentation/stats_screen.dart';
import 'features/device_settings/presentation/settings_screen.dart';

void main() {
  runApp(const ProviderScope(child: LunitaApp()));
}

class LunitaApp extends StatelessWidget {
  const LunitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DreamDome',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  static const _screens = [
    DashboardScreen(),
    SchedulesScreen(),
    AmbientScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  static const _labels = [
    'Inicio',
    'Rutinas',
    'Ambiente',
    'Stats',
    'Ajustes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _LunitaNavBar(
        currentIndex: _currentIndex,
        labels: _labels,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─── Custom Nav Bar ───────────────────────────────────────────────────────────

class _LunitaNavBar extends StatelessWidget {
  final int currentIndex;
  final List<String> labels;
  final ValueChanged<int> onTap;

  const _LunitaNavBar({
    required this.currentIndex,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(labels.length, (i) {
              final isActive = currentIndex == i;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.primaryColor.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}