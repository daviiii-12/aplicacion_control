enum ProjectionType {
  none,
  staticStars,
  floatingClouds
}

enum SoundType {
  none,
  whiteNoise
}

// Extensiones para obtener el texto amigable para la interfaz
extension ProjectionTypeExtension on ProjectionType {
  String get displayName {
    switch (this) {
      case ProjectionType.none:
        return 'Apagado';
      case ProjectionType.staticStars:
        return 'Estrellas Estáticas';
      case ProjectionType.floatingClouds:
        return 'Nubes Flotantes';
    }
  }
}

extension SoundTypeExtension on SoundType {
  String get displayName {
    switch (this) {
      case SoundType.none:
        return 'Apagado';
      case SoundType.whiteNoise:
        return 'Ruido Blanco';
    }
  }
}