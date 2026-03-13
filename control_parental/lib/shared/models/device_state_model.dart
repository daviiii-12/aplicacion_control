import 'device_enums.dart';

class DeviceStateModel {
  final bool isDeviceOn;
  final ProjectionType currentProjection;
  final SoundType currentSound;
  final double lightIntensity; // Rango de 0.0 a 1.0
  final bool isGradualDimmingActive;
  final bool isMotionSensorActive;

  const DeviceStateModel({
    required this.isDeviceOn,
    required this.currentProjection,
    required this.currentSound,
    required this.lightIntensity,
    required this.isGradualDimmingActive,
    required this.isMotionSensorActive,
  });

  // Método esencial para Riverpod: permite crear una copia del estado 
  // modificando solo los valores necesarios, manteniendo la inmutabilidad.
  DeviceStateModel copyWith({
    bool? isDeviceOn,
    ProjectionType? currentProjection,
    SoundType? currentSound,
    double? lightIntensity,
    bool? isGradualDimmingActive,
    bool? isMotionSensorActive,
  }) {
    return DeviceStateModel(
      isDeviceOn: isDeviceOn ?? this.isDeviceOn,
      currentProjection: currentProjection ?? this.currentProjection,
      currentSound: currentSound ?? this.currentSound,
      lightIntensity: lightIntensity ?? this.lightIntensity,
      isGradualDimmingActive: isGradualDimmingActive ?? this.isGradualDimmingActive,
      isMotionSensorActive: isMotionSensorActive ?? this.isMotionSensorActive,
    );
  }

  // Estado inicial por defecto (Mock)
  factory DeviceStateModel.initial() {
    return const DeviceStateModel(
      isDeviceOn: false,
      currentProjection: ProjectionType.none,
      currentSound: SoundType.none,
      lightIntensity: 0.5,
      isGradualDimmingActive: false,
      isMotionSensorActive: true,
    );
  }
}