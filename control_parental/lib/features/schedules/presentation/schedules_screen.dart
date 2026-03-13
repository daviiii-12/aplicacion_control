import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/schedules_provider.dart';
import '../../../shared/models/sleep_schedule_model.dart';
import '../../../core/theme/app_theme.dart';

class SchedulesScreen extends ConsumerWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(schedulesProvider);
    final notifier = ref.read(schedulesProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Rutinas de Sueño'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, notifier),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          if (schedules.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'No hay rutinas programadas',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 15),
                ),
              ),
            )
          else ...[
            _SectionLabel('Mis rutinas'),
            const SizedBox(height: 10),
            ...schedules.map((schedule) => _ScheduleCard(
                  schedule: schedule,
                  onToggle: () => notifier.toggleSchedule(schedule.id),
                  onDelete: () => notifier.deleteSchedule(schedule.id),
                  onEdit: () => _showEditDialog(context, notifier, schedule),
                )),
          ],

          const SizedBox(height: 24),
          _SectionLabel('Recomendaciones de expertos'),
          const SizedBox(height: 10),

          _RecommendationCard(
            title: 'Rutina AAP — 3 a 5 años',
            subtitle: '8:00 PM · 10 a 11 horas',
            description:
                'Inicio calmado con luz tenue y sonido suave 30 min antes de dormir. Recomendado por la Academia Americana de Pediatría.',
            onApply: () {
              notifier.addSchedule(SleepScheduleModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                startTime: const TimeOfDay(hour: 20, minute: 0),
                durationMinutes: 630,
                isActive: true,
              ));
              _showSnack(context, 'Rutina AAP añadida');
            },
          ),

          _RecommendationCard(
            title: 'Siesta + Noche — 12 a 18 meses',
            subtitle: '1:00 PM + 7:30 PM',
            description:
                'Combina siesta vespertina de 90 min con rutina nocturna de 11 horas. Ayuda a regular el ritmo circadiano.',
            onApply: () {
              notifier.addSchedule(SleepScheduleModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                startTime: const TimeOfDay(hour: 19, minute: 30),
                durationMinutes: 660,
                isActive: true,
              ));
              _showSnack(context, 'Rutina siesta + noche añadida');
            },
          ),

          _RecommendationCard(
            title: 'Apagado Gradual',
            subtitle: '8:30 PM · Transición de 60 min',
            description:
                'Reduce luz y sonido progresivamente en 60 minutos. Ideal para niños con dificultad para conciliar el sueño.',
            onApply: () {
              notifier.addSchedule(SleepScheduleModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                startTime: const TimeOfDay(hour: 20, minute: 30),
                durationMinutes: 600,
                isActive: true,
              ));
              _showSnack(context, 'Rutina gradual añadida');
            },
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAddDialog(BuildContext context, SchedulesNotifier notifier) {
    final newSchedule = SleepScheduleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: const TimeOfDay(hour: 20, minute: 0),
      durationMinutes: 600,
      isActive: true,
    );
    notifier.addSchedule(newSchedule);
    _showSnack(context, 'Nueva rutina añadida');
  }

  void _showEditDialog(BuildContext context, SchedulesNotifier notifier,
      SleepScheduleModel schedule) {
    _showSnack(context, 'Editor de rutina próximamente');
  }
}


class _ScheduleCard extends StatelessWidget {
  final SleepScheduleModel schedule;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ScheduleCard({
    required this.schedule,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final endHour =
        (schedule.startTime.hour + schedule.durationMinutes ~/ 60) % 24;
    final endMinute =
        (schedule.startTime.minute + schedule.durationMinutes % 60) % 60;
    final endTime = TimeOfDay(hour: endHour, minute: endMinute);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: schedule.isActive
              ? AppTheme.primaryColor.withValues(alpha: 0.4)
              : AppTheme.borderColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.startTime.format(context),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hasta las ${endTime.format(context)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: schedule.isActive,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: AppTheme.borderColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duración: ${schedule.durationMinutes ~/ 60}h ${schedule.durationMinutes % 60}m',
                style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text('Editar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                          )),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text('Eliminar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.redAccent,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final VoidCallback onApply;

  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onApply,
              style: TextButton.styleFrom(
                backgroundColor:
                    AppTheme.primaryColor.withValues(alpha: 0.15),
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: AppTheme.primaryColor.withValues(alpha: 0.35)),
                ),
              ),
              child: const Text(
                'Aplicar esta rutina',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito'),
              ),
            ),
          ),
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