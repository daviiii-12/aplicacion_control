import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/sleep_schedule_model.dart';

final schedulesProvider = StateNotifierProvider<SchedulesNotifier, List<SleepScheduleModel>>((ref) {
  return SchedulesNotifier();
});

class SchedulesNotifier extends StateNotifier<List<SleepScheduleModel>> {
  SchedulesNotifier() : super([
    // Rutina de ejemplo por defecto para el MVP
    const SleepScheduleModel(
      id: '1',
      startTime: TimeOfDay(hour: 20, minute: 0), // 8:00 PM
      durationMinutes: 600, // 10 horas
      isActive: true,
    ),
  ]);

  void toggleSchedule(String id) {
    state = state.map((schedule) {
      if (schedule.id == id) {
        return schedule.copyWith(isActive: !schedule.isActive);
      }
      return schedule;
    }).toList();
  }

  void addSchedule(SleepScheduleModel newSchedule) {
    state = [...state, newSchedule];
  }

  void deleteSchedule(String id) {
    state = state.where((schedule) => schedule.id != id).toList();
  }
}