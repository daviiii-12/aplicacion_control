import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/schedules_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/sleep_schedule_model.dart';

class SchedulesScreen extends ConsumerWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(schedulesProvider);
    final notifier = ref.read(schedulesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinas de Sueño'),
      ),
      body: schedules.isEmpty
          ? Center(
              child: Text(
                'No hay rutinas programadas.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return _ScheduleCard(
                  schedule: schedule,
                  onToggle: () => notifier.toggleSchedule(schedule.id),
                  onDelete: () => notifier.deleteSchedule(schedule.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _showAddScheduleDialog(context, notifier),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context, SchedulesNotifier notifier) {
    final newSchedule = SleepScheduleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: const TimeOfDay(hour: 19, minute: 30),
      durationMinutes: 660, // 11 horas
      isActive: true,
    );
    notifier.addSchedule(newSchedule);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rutina de ejemplo añadida')),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final SleepScheduleModel schedule;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ScheduleCard({
    required this.schedule,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final endHour = (schedule.startTime.hour + (schedule.durationMinutes ~/ 60)) % 24;
    final endMinute = (schedule.startTime.minute + (schedule.durationMinutes % 60)) % 60;
    final endTime = TimeOfDay(hour: endHour, minute: endMinute);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inicio: ${schedule.startTime.format(context)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fin aproximado: ${endTime.format(context)}',
                      style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                Switch(
                  value: schedule.isActive,
                  activeThumbColor: AppTheme.primaryColor, // <-- Solucionado
                  onChanged: (_) => onToggle(),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duración: ${schedule.durationMinutes ~/ 60}h ${schedule.durationMinutes % 60}m',
                  style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}