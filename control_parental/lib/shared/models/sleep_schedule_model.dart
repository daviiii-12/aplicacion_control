import 'package:flutter/material.dart';

class SleepScheduleModel {
  final String id;
  final TimeOfDay startTime;
  final int durationMinutes;
  final bool isActive;

  const SleepScheduleModel({
    required this.id,
    required this.startTime,
    required this.durationMinutes,
    required this.isActive,
  });

  SleepScheduleModel copyWith({
    String? id,
    TimeOfDay? startTime,
    int? durationMinutes,
    bool? isActive,
  }) {
    return SleepScheduleModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isActive: isActive ?? this.isActive,
    );
  }
}