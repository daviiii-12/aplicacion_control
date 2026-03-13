import '../../../shared/models/sleep_stats_model.dart';

class StatsRepository {
  Future<List<SleepStatsModel>> getWeeklyStats() async {
    // Simulamos la carga desde una base de datos local
    await Future.delayed(const Duration(milliseconds: 500));
    
    final DateTime today = DateTime.now();
    
    // Generamos datos simulados para los últimos 7 días
    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      // Valores aleatorios coherentes para simular el comportamiento
      final double hours = 8.0 + (index % 3) * 1.5; 
      final int usage = 45 + (index * 10);
      
      return SleepStatsModel(
        date: date,
        hoursSlept: hours,
        deviceUsageMinutes: usage,
        routineCompleted: index % 4 != 0, // Falló la rutina 1 de cada 4 días
      );
    });
  }
}