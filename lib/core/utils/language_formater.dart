enum IdiomaApp { castellano, valenciano }

String formatearNombreRuta(String nombreOriginal, IdiomaApp idioma) {
  String nombreLimpio = nombreOriginal;

  if (nombreLimpio.contains('_')) {
    nombreLimpio = nombreLimpio.substring(nombreLimpio.indexOf('_') + 1);
  }

  switch (idioma) {
    case IdiomaApp.castellano:
      nombreLimpio = nombreLimpio
          .replaceAll('València', 'Valencia')
          .replaceAll('Sagunt', 'Sagunto') // 1º Cambiamos Sagunt por Sagunto
          .replaceAll(
            'Port de Sagunto',
            'Puerto de Sagunto',
          ) // 2º Ahora buscamos "Port de Sagunto"
          .replaceAll(
            RegExp(r'\(nocturn\)', caseSensitive: false),
            '(Nocturno)',
          )
          .replaceAll(' per ', ' por ')
          .replaceAll('fins a', 'hasta')
          .replaceAll('fins', 'hasta')
          .replaceAll('Platges', 'Playas')
          .replaceAll('Platja', 'Playa');
      break;

    case IdiomaApp.valenciano:
      nombreLimpio = nombreLimpio.replaceAll(
        RegExp(r'\(nocturn\)', caseSensitive: false),
        '(Nocturn)',
      );
      break;
  }

  return nombreLimpio.trim();
}
