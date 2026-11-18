
import 'package:flutter/material.dart';
import '../models/pelicula.dart';

class DetalleScreen extends StatelessWidget {
  final Pelicula pelicula;

  const DetalleScreen({
    super.key,
    required this.pelicula,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la película'),
        backgroundColor: const Color(0xFF252545),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              pelicula.imagen,
              height: 350,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: Icon(Icons.movie, size: 80),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula.titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text('Año: ${pelicula.anio}'),
                  const SizedBox(height: 10),

                  Text('Director: ${pelicula.director}'),
                  const SizedBox(height: 10),

                  Text('Género: ${pelicula.genero}'),

                  const SizedBox(height: 25),

                  const Text(
                    'Sinopsis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    pelicula.sinopsis,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
