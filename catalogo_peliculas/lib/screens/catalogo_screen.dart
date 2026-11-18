
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'detalle_screen.dart';
import 'administracion_screen.dart';
import '../models/pelicula.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {

  final List<Pelicula> peliculas = [
    Pelicula(
      titulo: 'Avengers: Endgame',
      anio: 2019,
      director: 'Anthony Russo y Joe Russo',
      genero: 'Acción / Ciencia ficción',
      sinopsis: 'Los Vengadores restantes buscan una manera de '
          'revertir las consecuencias del chasquido de Thanos.',
      imagen: 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
    ),
    Pelicula(
      titulo: 'Interstellar',
      anio: 2014,
      director: 'Christopher Nolan',
      genero: 'Ciencia ficción / Drama',
      sinopsis: 'Un grupo de exploradores viaja a través de un '
          'agujero de gusano para encontrar un nuevo hogar '
          'para la humanidad.',
      imagen: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    ),
    Pelicula(
      titulo: 'Spider-Man: No Way Home',
      anio: 2021,
      director: 'Jon Watts',
      genero: 'Acción / Aventura',
      sinopsis: 'Peter Parker busca solucionar las consecuencias '
          'de que el mundo conozca su identidad secreta.',
      imagen: 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
    ),
    Pelicula(
      titulo: 'The Batman',
      anio: 2022,
      director: 'Matt Reeves',
      genero: 'Acción / Crimen',
      sinopsis: 'Batman investiga una serie de crímenes que '
          'revelan la corrupción de Gotham City.',
      imagen: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
    ),
  ];

  bool cargando = false;
  String? error;

  Future<void> obtenerPeliculasAPI() async {
    setState(() {
      cargando = true;
      error = null;
    });

    final cliente = HttpClient();

    try {
      final uri = Uri.parse(
        'https://api.sampleapis.com/movies/animation',
      );

      final solicitud = await cliente.getUrl(uri);
      final respuesta = await solicitud.close();

      if (respuesta.statusCode != 200) {
        throw Exception('Error al consultar la API');
      }

      final contenido = await respuesta.transform(utf8.decoder).join();
      final List datos = jsonDecode(contenido);

      final List<Pelicula> peliculasAPI = datos.map((dato) {
        return Pelicula(
          id: dato['id']?.toString() ?? '',
          titulo: dato['title'] ?? 'Sin título',
          anio: 0,
          director: 'No disponible',
          genero: 'Animación',
          sinopsis: 'Película de animación obtenida desde SampleAPIs.',
          imagen: dato['posterURL'] ?? '',
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        for (final pelicula in peliculasAPI) {
          final existe = peliculas.any(
            (p) => p.titulo == pelicula.titulo,
          );

          if (!existe) {
            peliculas.add(pelicula);
          }
        }
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'No se pudieron cargar las películas de Internet.';
      });
    } finally {
      cliente.close();

      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerPeliculasAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Películas'),
        backgroundColor: const Color(0xFF252545),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar películas',
            onPressed: obtenerPeliculasAPI,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Administrar películas',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdministracionScreen(
                    peliculas: peliculas,
                  ),
                ),
              );

              setState(() {});
            },
          ),
        ],
      ),

      body: Column(
        children: [
          if (cargando)
            const LinearProgressIndicator(),

          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: peliculas.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final pelicula = peliculas[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalleScreen(pelicula: pelicula),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color(0xFF252545),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            pelicula.imagen,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.movie,
                                  size: 60,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            pelicula.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            pelicula.anio == 0
                                ? 'Animación'
                                : pelicula.anio.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

