
class Pelicula {
  String id;
  String titulo;
  int anio;
  String director;
  String genero;
  String sinopsis;
  String imagen;

  Pelicula({
    this.id = '',
    required this.titulo,
    required this.anio,
    required this.director,
    required this.genero,
    required this.sinopsis,
    required this.imagen,
  });
}
