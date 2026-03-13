import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/stats_provider.dart';
import '../../../core/theme/app_theme.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(weeklyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Sueño'),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error al cargar datos: $err')),
        data: (statsData) {
          if (statsData.isEmpty) {
            return const Center(child: Text('No hay datos disponibles aún.'));
          }

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const Text(
                'Últimos 7 días',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              Card(
                elevation: 4,
                shadowColor: AppTheme.primaryColor.withValues(alpha: 0.1), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 12,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 && value.toInt() < statsData.length) {
                                  final date = statsData[value.toInt()].date;
                                  // Solicitamos el formato en español ('es')
                                  final dayName = DateFormat('E', 'es').format(date);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(dayName.substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: statsData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stat = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: stat.hoursSlept,
                                color: AppTheme.primaryColor,
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 12,
                                  color: AppTheme.secondaryColor.withValues(alpha: 0.3), 
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Resumen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _SummaryTile(
                title: 'Promedio de sueño',
                value: '${(statsData.map((e) => e.hoursSlept).reduce((a, b) => a + b) / statsData.length).toStringAsFixed(1)} h',
                icon: Icons.access_time_filled,
              ),
              const SizedBox(height: 10),
              _SummaryTile(
                title: 'Rutinas completadas',
                value: '${statsData.where((e) => e.routineCompleted).length} de ${statsData.length}',
                icon: Icons.check_circle_rounded,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryTile({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.backgroundColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary))),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}