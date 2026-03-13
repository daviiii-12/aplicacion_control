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
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: deviceStateAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
          error: (err, _) => Center(
            child: Text('Error: $err',
                style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          data: (deviceState) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'DreamDome',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryDark,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          'Buenas noches, Lucía',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('L',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryDark,
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                _StreakCard(),
                const SizedBox(height: 16),

                _DeviceHeroCard(
                  isOn: deviceState.isDeviceOn,
                  projection: deviceState.currentProjection,
                  sound: deviceState.currentSound,
                  onToggle: () =>
                      ref.read(deviceStateProvider.notifier).togglePower(),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.stars_rounded,
                        label: 'Proyección',
                        value: deviceState.currentProjection.displayName,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.music_note_rounded,
                        label: 'Sonido',
                        value: deviceState.currentSound.displayName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.nightlight_round,
                        label: 'Rutina hoy',
                        value: '8:00 PM',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.bedtime_rounded,
                        label: 'Última noche',
                        value: '9.5 horas',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class _StreakCard extends StatelessWidget {
  final List<String> _days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D48A)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.local_fire_department_rounded,
                      color: Color(0xFFD48A00), size: 26),
                  SizedBox(width: 6),
                  Text(
                    '7',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accentDark,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const Text(
                'días de racha perfecta',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: List.generate(_days.length, (i) {
              return Container(
                margin: const EdgeInsets.only(left: 5),
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFD48A00),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _days[i],
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}


class _DeviceHeroCard extends StatelessWidget {
  final bool isOn;
  final ProjectionType projection;
  final SoundType sound;
  final VoidCallback onToggle;

  const _DeviceHeroCard({
    required this.isOn,
    required this.projection,
    required this.sound,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOn ? AppTheme.successColor : AppTheme.borderColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isOn ? 'Encendido' : 'Apagado',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isOn ? AppTheme.successColor : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: isOn ? AppTheme.primaryLight : AppTheme.surfaceAlt,
              shape: BoxShape.circle,
              border: Border.all(
                color: isOn ? AppTheme.primaryColor : AppTheme.borderColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                isOn ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                size: 42,
                color: isOn ? AppTheme.primaryDark : AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'Mi DreamDome',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isOn
                ? '${projection.displayName} · ${sound.displayName}'
                : 'Listo para la rutina de sueño',
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isOn ? AppTheme.errorColor : AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isOn ? 'Apagar DreamDome' : 'Encender DreamDome',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 22),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}