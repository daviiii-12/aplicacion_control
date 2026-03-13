import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/device_state_model.dart';
import '../../../shared/models/device_enums.dart';
import '../data/device_repository.dart';

// Proveedor del repositorio para inyección de dependencias
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepository();
});

// Proveedor principal del estado del dispositivo
final deviceStateProvider = StateNotifierProvider<DeviceStateNotifier, AsyncValue<DeviceStateModel>>((ref) {
  final repository = ref.watch(deviceRepositoryProvider);
  return DeviceStateNotifier(repository);
});

class DeviceStateNotifier extends StateNotifier<AsyncValue<DeviceStateModel>> {
  final DeviceRepository _repository;

  DeviceStateNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initializeDevice();
  }

  // Carga el estado inicial simulando la conexión al hardware
  Future<void> _initializeDevice() async {
    try {
      final initialState = await _repository.fetchCurrentState();
      state = AsyncValue.data(initialState);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> togglePower() async {
    if (state is! AsyncData) return;
    final currentState = state.value!;
    
    final newState = !currentState.isDeviceOn;
    // Actualizamos la UI inmediatamente (optimistic update)
    state = AsyncValue.data(currentState.copyWith(isDeviceOn: newState));
    
    // Enviamos el comando al hardware real (simulado)
    await _repository.sendPowerCommand(newState);
  }

  Future<void> setLightIntensity(double intensity) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(state.value!.copyWith(lightIntensity: intensity));
    await _repository.updateLightIntensity(intensity);
  }

  Future<void> setProjection(ProjectionType type) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(state.value!.copyWith(currentProjection: type));
    await _repository.setProjection(type);
  }

  Future<void> setSound(SoundType type) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(state.value!.copyWith(currentSound: type));
    await _repository.setSound(type);
  }

  Future<void> toggleGradualDimming() async {
    if (state is! AsyncData) return;
    final newValue = !state.value!.isGradualDimmingActive;
    state = AsyncValue.data(state.value!.copyWith(isGradualDimmingActive: newValue));
    await _repository.toggleSensorOrDimming();
  }

  Future<void> toggleMotionSensor() async {
    if (state is! AsyncData) return;
    final newValue = !state.value!.isMotionSensorActive;
    state = AsyncValue.data(state.value!.copyWith(isMotionSensorActive: newValue));
    await _repository.toggleSensorOrDimming();
  }
}