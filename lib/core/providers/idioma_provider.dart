import 'package:viamorvedre/core/utils/language_formater.dart';

class IdiomaProvider {
  static IdiomaApp _idiomaActual = IdiomaApp.castellano;

  static IdiomaApp get idioma => _idiomaActual;

  static void setIdioma(IdiomaApp nuevo) {
    _idiomaActual = nuevo;
  }
}
