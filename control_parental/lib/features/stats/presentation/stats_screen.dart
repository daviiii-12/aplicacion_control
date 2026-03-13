import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/stats_provider.dart';
import '../../../shared/models/sleep_stats_model.dart';
import '../../../core/theme/app_theme.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedRange = 7; // 7, 30, 90

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(weeklyStatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: statsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (err, _) =>
            Center(child: Text('Error al cargar datos: $err')),
        data: (statsData) {
          if (statsData.isEmpty) {
            return const Center(
                child: Text('No hay datos disponibles aún.',
                    style: TextStyle(color: AppTheme.textSecondary)));
          }

          final avgHours = statsData
                  .map((e) => e.hoursSlept)
                  .reduce((a, b) => a + b) /
              statsData.length;
          final completedCount =
              statsData.where((e) => e.routineCompleted).length;
          final avgUsage = statsData
                  .map((e) => e.deviceUsageMinutes)
                  .reduce((a, b) => a + b) ~/
              statsData.length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Row(
                children: [
                  _RangePill(
                      label: '7 días',
                      selected: _selectedRange == 7,
                      onTap: () => setState(() => _selectedRange = 7)),
                  const SizedBox(width: 8),
                  _RangePill(
                      label: '30 días',
                      selected: _selectedRange == 30,
                      onTap: () => setState(() => _selectedRange = 30)),
                  const SizedBox(width: 8),
                  _RangePill(
                      label: '3 meses',
                      selected: _selectedRange == 90,
                      onTap: () => setState(() => _selectedRange = 90)),
                ],
              ),
              const SizedBox(height: 18),

              _ChartCard(statsData: statsData),
              const SizedBox(height: 18),

              const _SectionLabel('Resumen'),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.6,
                children: [
                  _StatTile(
                    value: '${avgHours.toStringAsFixed(1)}h',
                    label: 'Promedio por noche',
                    valueColor: AppTheme.primaryDark,
                  ),
                  _StatTile(
                    value: '7',
                    label: 'Racha actual',
                    valueColor: AppTheme.accentDark,
                  ),
                  _StatTile(
                    value: '$completedCount/${statsData.length}',
                    label: 'Rutinas completadas',
                    valueColor: AppTheme.successColor,
                  ),
                  _StatTile(
                    value: '${avgUsage}m',
                    label: 'Uso de Lunita',
                    valueColor: AppTheme.complementary,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              const _SectionLabel('Consistencia de horario'),
              const SizedBox(height: 10),
              _ConsistencyCard(statsData: statsData),
              const SizedBox(height: 18),

              const _SectionLabel('Hora de inicio promedio'),
              const SizedBox(height: 10),
              _BedtimeCard(),
            ],
          );
        },
      ),
    );
  }
}


class _ChartCard extends StatelessWidget {
  final List<SleepStatsModel> statsData;
  const _ChartCard({required this.statsData});

  static const _dayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horas de sueño',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 12,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: AppTheme.surfaceAlt,
                    getTooltipItem: (group, _, rod, __) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)}h',
                        const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= statsData.length) {
                          return const SizedBox.shrink();
                        }
                        final isToday = i == statsData.length - 1;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _dayLabels[i % 7],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isToday
                                  ? AppTheme.accentDark
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppTheme.borderColor,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: statsData.asMap().entries.map((entry) {
                  final i = entry.key;
                  final stat = entry.value;
                  final isToday = i == statsData.length - 1;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: stat.hoursSlept,
                        color: isToday
                            ? AppTheme.accentDark
                            : AppTheme.primaryColor,
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 12,
                          color: AppTheme.surfaceAlt.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendDot(color: AppTheme.primaryColor, label: 'Noche'),
              const SizedBox(width: 14),
              _LegendDot(color: AppTheme.accentDark, label: 'Hoy'),
              const Spacer(),
              const Text(
                'Meta: 9–11h',
                style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}


class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatTile(
      {required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}


class _ConsistencyCard extends StatelessWidget {
  final List<SleepStatsModel> statsData;
  const _ConsistencyCard({required this.statsData});

  @override
  Widget build(BuildContext context) {
    final completed = statsData.where((e) => e.routineCompleted).length;
    final total = statsData.length;
    final ratio = completed / total;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Noches en horario ideal',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: AppTheme.successColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  ratio >= 0.8 ? 'Excelente' : ratio >= 0.6 ? 'Bien' : 'Regular',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.successColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          
          Row(
            children: List.generate(total, (i) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < total - 1 ? 5 : 0),
                  height: 8,
                  decoration: BoxDecoration(
                    color: statsData[i].routineCompleted
                        ? AppTheme.successColor
                        : AppTheme.surfaceAlt,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            '$completed de $total noches en horario',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


class _BedtimeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '8:12',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.accentDark,
                  height: 1,
                ),
              ),
              Text(
                'PM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Meta: 8:00 PM',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Variación promedio: ±12 min',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _RangePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangePill(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor.withValues(alpha: 0.3)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : AppTheme.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? AppTheme.primaryDark : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}