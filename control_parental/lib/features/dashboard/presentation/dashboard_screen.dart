import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../device_settings/providers/device_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/device_enums.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceStateAsync = ref.watch(deviceStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Domo de Sueño'),
      ),
      body: deviceStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (deviceState) {
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const Text(
                'Estado del Dispositivo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 20),
              
              Card(
                elevation: 4,
                // <-- Cambiado a withValues(alpha: ...)
                shadowColor: AppTheme.primaryColor.withValues(alpha: 0.2), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  child: Column(
                    children: [
                      Icon(
                        deviceState.isDeviceOn ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                        size: 64,
                        color: deviceState.isDeviceOn ? Colors.amber : AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        deviceState.isDeviceOn ? 'Encendido' : 'Apagado',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => ref.read(deviceStateProvider.notifier).togglePower(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deviceState.isDeviceOn ? AppTheme.textSecondary : AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(deviceState.isDeviceOn ? 'Apagar Domo' : 'Encender Domo', style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(child: _StatusCard(title: 'Proyección', value: deviceState.currentProjection.displayName, icon: Icons.stars_rounded)),
                  const SizedBox(width: 16),
                  Expanded(child: _StatusCard(title: 'Sonido', value: deviceState.currentSound.displayName, icon: Icons.music_note_rounded)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatusCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }
}