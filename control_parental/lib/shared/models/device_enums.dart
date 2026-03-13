enum ProjectionType {
  none,
  staticStars,
  floatingClouds,
  moon,
  aurora,
  ocean,
}

enum SoundType {
  none,
  whiteNoise,
  rainSound,
  oceanWaves,
}

extension ProjectionTypeExtension on ProjectionType {
  String get displayName {
    switch (this) {
      case ProjectionType.none:           return 'Sin proyección';
      case ProjectionType.staticStars:    return 'Estrellas';
      case ProjectionType.floatingClouds: return 'Nubes';
      case ProjectionType.moon:           return 'Luna';
      case ProjectionType.aurora:         return 'Aurora';
      case ProjectionType.ocean:          return 'Océano';
    }
  }

  String get description {
    switch (this) {
      case ProjectionType.none:           return 'Luz apagada';
      case ProjectionType.staticStars:    return 'Cielo estrellado estático';
      case ProjectionType.floatingClouds: return 'Nubes en movimiento suave';
      case ProjectionType.moon:           return 'Luna llena tenue';
      case ProjectionType.aurora:         return 'Colores de aurora boreal';
      case ProjectionType.ocean:          return 'Olas nocturnas calmantes';
    }
  }
}

extension SoundTypeExtension on SoundType {
  String get displayName {
    switch (this) {
      case SoundType.none:        return 'Sin sonido';
      case SoundType.whiteNoise:  return 'Ruido blanco';
      case SoundType.rainSound:   return 'Lluvia suave';
      case SoundType.oceanWaves:  return 'Olas del mar';
    }
  }
}