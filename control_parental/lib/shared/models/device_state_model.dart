import 'package:flutter/material.dart';
import 'device_enums.dart';

class DeviceStateModel {
  final bool isDeviceOn;
  final ProjectionType currentProjection;
  final SoundType currentSound;
  final double lightIntensity;       // 0.0 a 1.0
  final double projectionSpeed;      // 0.0 a 1.0 — velocidad de animación
  final Color projectionColor;       // color de tinte de la proyección
  final double soundVolume;          // 0.0 a 1.0
  final bool isGradualDimmingActive;
  final bool isMotionSensorActive;
  final bool isNotificationsActive;

  const DeviceStateModel({
    required this.isDeviceOn,
    required this.currentProjection,
    required this.currentSound,
    required this.lightIntensity,
    required this.projectionSpeed,
    required this.projectionColor,
    required this.soundVolume,
    required this.isGradualDimmingActive,
    required this.isMotionSensorActive,
    required this.isNotificationsActive,
  });

  DeviceStateModel copyWith({
    bool? isDeviceOn,
    ProjectionType? currentProjection,
    SoundType? currentSound,
    double? lightIntensity,
    double? projectionSpeed,
    Color? projectionColor,
    double? soundVolume,
    bool? isGradualDimmingActive,
    bool? isMotionSensorActive,
    bool? isNotificationsActive,
  }) {
    return DeviceStateModel(
      isDeviceOn: isDeviceOn ?? this.isDeviceOn,
      currentProjection: currentProjection ?? this.currentProjection,
      currentSound: currentSound ?? this.currentSound,
      lightIntensity: lightIntensity ?? this.lightIntensity,
      projectionSpeed: projectionSpeed ?? this.projectionSpeed,
      projectionColor: projectionColor ?? this.projectionColor,
      soundVolume: soundVolume ?? this.soundVolume,
      isGradualDimmingActive: isGradualDimmingActive ?? this.isGradualDimmingActive,
      isMotionSensorActive: isMotionSensorActive ?? this.isMotionSensorActive,
      isNotificationsActive: isNotificationsActive ?? this.isNotificationsActive,
    );
  }

  factory DeviceStateModel.initial() {
    return DeviceStateModel(
      isDeviceOn: false,
      currentProjection: ProjectionType.none,
      currentSound: SoundType.none,
      lightIntensity: 0.5,
      projectionSpeed: 0.4,
      projectionColor: const Color(0xFFC4B5FD),
      soundVolume: 0.55,
      isGradualDimmingActive: false,
      isMotionSensorActive: true,
      isNotificationsActive: true,
    );
  }
}