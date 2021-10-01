import 'package:flutter/foundation.dart';

enum Local {
  UFSC,
  S_Ilha,
  N_Ilha,
  Centro,
  Continente,
}

extension selectedLocalExtension on Local {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case Local.UFSC:
        return 'UFSC';
      case Local.S_Ilha:
        return 'Sul da ilha';
      case Local.N_Ilha:
        return 'Norte da ilha';
      case Local.Centro:
        return 'Centro';
      case Local.Continente:
        return 'Continente';
      default:
        return 'UFSC';
    }
  }
}
