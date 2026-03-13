import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../device_settings/providers/device_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/device_enums.dart';

class AmbientScreen extends ConsumerWidget {
  const AmbientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceStateAsync = ref.watch(deviceStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Ambiente'),
      ),
      body: deviceStateAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (deviceState) {
          final notifier = ref.read(deviceStateProvider.notifier);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              _ProjectionPreview(
                type: deviceState.currentProjection,
                color: deviceState.projectionColor,
              ),
              const SizedBox(height: 20),

              _SectionLabel('Tipo de proyección'),
              const SizedBox(height: 10),
              _ProjectionGrid(
                selected: deviceState.currentProjection,
                onSelect: (t) => notifier.setProjection(t),
              ),
              const SizedBox(height: 22),

              _SectionLabel('Color de luz'),
              const SizedBox(height: 10),
              _ColorSwatches(
                selected: deviceState.projectionColor,
                onSelect: (c) => notifier.setProjectionColor(c),
              ),
              const SizedBox(height: 22),

              _SectionLabel('Brillo'),
              _SliderRow(
                value: deviceState.lightIntensity,
                label:
                    '${(deviceState.lightIntensity * 100).round()}%',
                onChanged: (v) => notifier.setLightIntensity(v),
              ),
              const SizedBox(height: 14),

              _SectionLabel('Velocidad'),
              _SliderRow(
                value: deviceState.projectionSpeed,
                label:
                    '${(deviceState.projectionSpeed * 100).round()}%',
                onChanged: (v) => notifier.setProjectionSpeed(v),
              ),
              const SizedBox(height: 22),

              _SectionLabel('Sonido'),
              const SizedBox(height: 10),
              _SoundSelector(
                selectedSound: deviceState.currentSound,
                onSelect: (s) => notifier.setSound(s),
              ),
              const SizedBox(height: 14),
              _SectionLabel('Volumen'),
              _SliderRow(
                value: deviceState.soundVolume,
                label: '${(deviceState.soundVolume * 100).round()}%',
                onChanged: (v) => notifier.setSoundVolume(v),
              ),
            ],
          );
        },
      ),
    );
  }
}


class _ProjectionPreview extends StatelessWidget {
  final ProjectionType type;
  final Color color;

  const _ProjectionPreview({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background efecto
          if (type != ProjectionType.none) _buildEffect(type, color),

          // Label
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.surfaceAlt.withValues(alpha: 0.85),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  type == ProjectionType.none
                      ? 'Sin proyección'
                      : type.displayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          // "Vista previa"
          Positioned(
            top: 12, right: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: const Text(
                'Vista previa',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffect(ProjectionType type, Color color) {
    switch (type) {
      case ProjectionType.staticStars:
        return _StarsEffect(color: color);
      case ProjectionType.floatingClouds:
        return _CloudsEffect(color: color);
      case ProjectionType.moon:
        return _MoonEffect(color: color);
      case ProjectionType.aurora:
        return _AuroraEffect();
      case ProjectionType.ocean:
        return _OceanEffect(color: color);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StarsEffect extends StatelessWidget {
  final Color color;
  const _StarsEffect({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarsPainter(color: color),
      size: const Size(double.infinity, 170),
    );
  }
}

class _StarsPainter extends CustomPainter {
  final Color color;
  _StarsPainter({required this.color});

  static const _positions = [
    (0.1, 0.2), (0.25, 0.1), (0.4, 0.3), (0.6, 0.15), (0.75, 0.25),
    (0.9, 0.1), (0.15, 0.5), (0.35, 0.6), (0.55, 0.45), (0.8, 0.55),
    (0.05, 0.75), (0.3, 0.8), (0.5, 0.7), (0.7, 0.85), (0.95, 0.7),
    (0.2, 0.35), (0.65, 0.6), (0.45, 0.15), (0.85, 0.4), (0.12, 0.65),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.85);
    for (int i = 0; i < _positions.length; i++) {
      final (px, py) = _positions[i];
      final radius = (i % 3 == 0) ? 2.5 : (i % 3 == 1) ? 1.5 : 2.0;
      canvas.drawCircle(
          Offset(px * size.width, py * size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => old.color != color;
}

class _CloudsEffect extends StatelessWidget {
  final Color color;
  const _CloudsEffect({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _cloudShape(color, 0.7),
          _cloudShape(color, 1.0),
          _cloudShape(color, 0.6),
        ],
      ),
    );
  }

  Widget _cloudShape(Color color, double scale) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 60,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}

class _MoonEffect extends StatelessWidget {
  final Color color;
  const _MoonEffect({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
      ),
    );
  }
}

class _AuroraEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD3B5E0), // Violeta Hada
            Color(0xFFB8D9F2), // Azul Nube claro
            Color(0xFFF4E7B2), // Amarillo Paja
          ],
        ),
      ),
    );
  }
}

class _OceanEffect extends StatelessWidget {
  final Color color;
  const _OceanEffect({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryLight,
            color.withValues(alpha: 0.15),
          ],
        ),
      ),
    );
  }
}


class _ProjectionGrid extends StatelessWidget {
  final ProjectionType selected;
  final ValueChanged<ProjectionType> onSelect;

  const _ProjectionGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: ProjectionType.values.map((type) {
        final isSelected = selected == type;
        return GestureDetector(
          onTap: () => onSelect(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.15)
                  : AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.borderColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor.withValues(alpha: 0.25)
                        : AppTheme.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _typeInitial(type),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  type.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppTheme.primaryDark
                        : AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _typeInitial(ProjectionType t) {
    switch (t) {
      case ProjectionType.none:           return '—';
      case ProjectionType.staticStars:    return 'E';
      case ProjectionType.floatingClouds: return 'N';
      case ProjectionType.moon:           return 'L';
      case ProjectionType.aurora:         return 'A';
      case ProjectionType.ocean:          return 'O';
    }
  }
}


class _ColorSwatches extends StatelessWidget {
  final Color selected;
  final ValueChanged<Color> onSelect;

  static const _colors = [
    Color(0xFFC4B5FD),
    Color(0xFFFCD34D),
    Color(0xFF5EEAD4),
    Color(0xFFF9A8D4),
    Color(0xFF93C5FD),
    Color(0xFFFDE68A),
    Color(0xFFFFFFFF),
  ];

  const _ColorSwatches({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _colors.map((color) {
        final isSelected = selected.value == color.value;
        return GestureDetector(
          onTap: () => onSelect(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(right: 10),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: isSelected ? 2.5 : 0,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class _SoundSelector extends StatelessWidget {
  final SoundType selectedSound;
  final ValueChanged<SoundType> onSelect;

  const _SoundSelector(
      {required this.selectedSound, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: SoundType.values.map((type) {
          final isSelected = selectedSound == type;
          final isLast = type == SoundType.values.last;
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                title: Text(
                  type.displayName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textPrimary,
                  ),
                ),
                trailing: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                      width: 2,
                    ),
                  ),
                ),
                onTap: () => onSelect(type),
              ),
              if (!isLast)
                Divider(
                    height: 1,
                    color: AppTheme.borderColor,
                    indent: 16,
                    endIndent: 16),
            ],
          );
        }).toList(),
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

class _SliderRow extends StatelessWidget {
  final double value;
  final String label;
  final ValueChanged<double> onChanged;

  const _SliderRow(
      {required this.value,
      required this.label,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 1,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 38,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}