
import 'dart:convert';
import 'dart:io';

class PeliculasApi {

  static Future<List<Map<String, dynamic>>> obtenerPeliculas() async {
    final cliente = HttpClient();

    try {
      final url = Uri.parse(
        'https://api.sampleapis.com/movies/animation',
      );

      final solicitud = await cliente.getUrl(url);
      final respuesta = await solicitud.close();

      if (respuesta.statusCode == 200) {
        final contenido = await respuesta.transform(utf8.decoder).join();

        final datos = jsonDecode(contenido) as List;

        return datos
            .map((pelicula) => Map<String, dynamic>.from(pelicula))
            .toList();
      } else {
        throw Exception('Error al consultar las películas');
      }
    } finally {
      cliente.close();
    }
  }
}
