import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../device_settings/providers/device_provider.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceStateAsync = ref.watch(deviceStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: deviceStateAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (err, _) =>
            Center(child: Text('Error: $err')),
        data: (deviceState) {
          final notifier = ref.read(deviceStateProvider.notifier);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              const _SectionLabel('Dispositivo'),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _InfoRow(label: 'Nombre', value: 'Lucita'),
                _InfoRow(label: 'Conexión', value: 'WiFi · Conectado',
                    valueColor: AppTheme.successColor),
                _InfoRow(label: 'Versión firmware', value: '1.2.4'),
              ]),
              const SizedBox(height: 22),

              const _SectionLabel('Iluminación'),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _SliderRow(
                  label: 'Intensidad de luz',
                  valueLabel:
                      '${(deviceState.lightIntensity * 100).round()}%',
                  value: deviceState.lightIntensity,
                  onChanged: (v) => notifier.setLightIntensity(v),
                ),
              ]),
              const SizedBox(height: 22),

              const _SectionLabel('Automatización'),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _SwitchRow(
                  label: 'Apagado gradual',
                  subtitle: 'La luz y el sonido disminuirán lentamente',
                  value: deviceState.isGradualDimmingActive,
                  onChanged: (_) => notifier.toggleGradualDimming(),
                ),
                Divider(height: 1, color: AppTheme.borderColor),
                _SwitchRow(
                  label: 'Sensor de movimiento',
                  subtitle: 'Se activa si el niño se despierta',
                  value: deviceState.isMotionSensorActive,
                  onChanged: (_) => notifier.toggleMotionSensor(),
                ),
                Divider(height: 1, color: AppTheme.borderColor),
                _SwitchRow(
                  label: 'Notificaciones',
                  subtitle: 'Alertas de rutina y sueño',
                  value: deviceState.isNotificationsActive,
                  onChanged: (_) => notifier.toggleNotifications(),
                ),
              ]),
              const SizedBox(height: 22),

              const _SectionLabel('Perfil del niño'),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _InfoRow(label: 'Nombre', value: 'Lucía'),
                _InfoRow(label: 'Edad', value: '4 años'),
              ]),
              const SizedBox(height: 22),

              const _SectionLabel('Aplicación'),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _InfoRow(label: 'Versión', value: '1.0.0'),
                _InfoRow(label: 'Idioma', value: 'Español'),
              ]),
            ],
          );
        },
      ),
    );
  }
}


class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppTheme.textSecondary)),
        ],
      ),
    );
  }
}


class _SwitchRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}


class _SliderRow extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double value;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
              Text(valueLabel,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark)),
            ],
          ),
          Slider(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}


class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}