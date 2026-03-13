class SleepStatsModel {
  final DateTime date;
  final double hoursSlept;
  final int deviceUsageMinutes;
  final bool routineCompleted;

  const SleepStatsModel({
    required this.date,
    required this.hoursSlept,
    required this.deviceUsageMinutes,
    required this.routineCompleted,
  });
}