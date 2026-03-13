import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/device_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/device_enums.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceStateAsync = ref.watch(deviceStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes del Dispositivo'),
      ),
      body: deviceStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (deviceState) {
          final notifier = ref.read(deviceStateProvider.notifier);
          
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              _SectionTitle(title: 'Iluminación'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Intensidad de luz'),
                          Text('${(deviceState.lightIntensity * 100).toInt()}%'),
                        ],
                      ),
                      Slider(
                        value: deviceState.lightIntensity,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) => notifier.setLightIntensity(value),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _SectionTitle(title: 'Proyección'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: ProjectionType.values.map((type) {
                    final isSelected = deviceState.currentProjection == type;
                    return ListTile(
                      title: Text(type.displayName),
                      trailing: Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                      ),
                      onTap: () => notifier.setProjection(type),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              _SectionTitle(title: 'Sonido Relajante'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: SoundType.values.map((type) {
                    final isSelected = deviceState.currentSound == type;
                    return ListTile(
                      title: Text(type.displayName),
                      trailing: Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                      ),
                      onTap: () => notifier.setSound(type),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              _SectionTitle(title: 'Automatización'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Apagado Gradual'),
                      subtitle: const Text('La luz y el sonido disminuirán lentamente'),
                      value: deviceState.isGradualDimmingActive,
                      activeThumbColor: AppTheme.primaryColor, // <-- Solucionado
                      onChanged: (_) => notifier.toggleGradualDimming(),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Encendido por Movimiento'),
                      subtitle: const Text('Se activa si el niño se despierta'),
                      value: deviceState.isMotionSensorActive,
                      activeThumbColor: AppTheme.primaryColor, // <-- Solucionado
                      onChanged: (_) => notifier.toggleMotionSensor(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
      ),
    );
  }
}