import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/sleep_stats_model.dart';
import '../data/stats_repository.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository();
});

// Este provider maneja automáticamente los estados de carga, éxito y error
final weeklyStatsProvider = FutureProvider<List<SleepStatsModel>>((ref) async {
  final repository = ref.watch(statsRepositoryProvider);
  return repository.getWeeklyStats();
});