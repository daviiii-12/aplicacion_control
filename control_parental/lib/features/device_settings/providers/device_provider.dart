import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/device_state_model.dart';
import '../../../shared/models/device_enums.dart';


class DeviceRepository {
  Future<DeviceStateModel> fetchCurrentState() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DeviceStateModel.initial();
  }

  Future<void> sendPowerCommand(bool isOn) async =>
      Future.delayed(const Duration(milliseconds: 100));

  Future<void> updateLightIntensity(double intensity) async =>
      Future.delayed(const Duration(milliseconds: 50));

  Future<void> setProjection(ProjectionType type) async =>
      Future.delayed(const Duration(milliseconds: 50));

  Future<void> setSound(SoundType type) async =>
      Future.delayed(const Duration(milliseconds: 50));

  Future<void> setProjectionColor(Color color) async =>
      Future.delayed(const Duration(milliseconds: 50));

  Future<void> setProjectionSpeed(double speed) async =>
      Future.delayed(const Duration(milliseconds: 50));

  Future<void> setSoundVolume(double volume) async =>
      Future.delayed(const Duration(milliseconds: 50));

  Future<void> toggleSetting() async =>
      Future.delayed(const Duration(milliseconds: 50));
}



final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepository();
});

final deviceStateProvider =
    StateNotifierProvider<DeviceStateNotifier, AsyncValue<DeviceStateModel>>(
  (ref) {
    final repository = ref.watch(deviceRepositoryProvider);
    return DeviceStateNotifier(repository);
  },
);



class DeviceStateNotifier
    extends StateNotifier<AsyncValue<DeviceStateModel>> {
  final DeviceRepository _repository;

  DeviceStateNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initializeDevice();
  }

  Future<void> _initializeDevice() async {
    try {
      final initialState = await _repository.fetchCurrentState();
      state = AsyncValue.data(initialState);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  DeviceStateModel get _current => state.value!;

  Future<void> togglePower() async {
    if (state is! AsyncData) return;
    final newVal = !_current.isDeviceOn;
    state = AsyncValue.data(_current.copyWith(isDeviceOn: newVal));
    await _repository.sendPowerCommand(newVal);
  }

  Future<void> setLightIntensity(double intensity) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(_current.copyWith(lightIntensity: intensity));
    await _repository.updateLightIntensity(intensity);
  }

  Future<void> setProjection(ProjectionType type) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(_current.copyWith(currentProjection: type));
    await _repository.setProjection(type);
  }

  Future<void> setSound(SoundType type) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(_current.copyWith(currentSound: type));
    await _repository.setSound(type);
  }

  Future<void> setProjectionColor(Color color) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(_current.copyWith(projectionColor: color));
    await _repository.setProjectionColor(color);
  }

  Future<void> setProjectionSpeed(double speed) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(_current.copyWith(projectionSpeed: speed));
    await _repository.setProjectionSpeed(speed);
  }

  Future<void> setSoundVolume(double volume) async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(_current.copyWith(soundVolume: volume));
    await _repository.setSoundVolume(volume);
  }

  Future<void> toggleGradualDimming() async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(
        _current.copyWith(isGradualDimmingActive: !_current.isGradualDimmingActive));
    await _repository.toggleSetting();
  }

  Future<void> toggleMotionSensor() async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(
        _current.copyWith(isMotionSensorActive: !_current.isMotionSensorActive));
    await _repository.toggleSetting();
  }

  Future<void> toggleNotifications() async {
    if (state is! AsyncData) return;
    state = AsyncValue.data(
        _current.copyWith(isNotificationsActive: !_current.isNotificationsActive));
    await _repository.toggleSetting();
  }
}