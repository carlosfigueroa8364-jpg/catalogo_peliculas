
import 'package:flutter/material.dart';
import '../models/pelicula.dart';

class AdministracionScreen extends StatefulWidget {
  final List<Pelicula> peliculas;

  const AdministracionScreen({
    super.key,
    required this.peliculas,
  });

  @override
  State<AdministracionScreen> createState() =>
      _AdministracionScreenState();
}

class _AdministracionScreenState
    extends State<AdministracionScreen> {

  final tituloController = TextEditingController();
  final anioController = TextEditingController();
  final directorController = TextEditingController();
  final generoController = TextEditingController();
  final sinopsisController = TextEditingController();
  final imagenController = TextEditingController();

  void agregarPelicula() {
    if (tituloController.text.isEmpty ||
        anioController.text.isEmpty ||
        directorController.text.isEmpty ||
        generoController.text.isEmpty ||
        sinopsisController.text.isEmpty ||
        imagenController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos'),
        ),
      );
      return;
    }

    final anio = int.tryParse(anioController.text);

    if (anio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un año válido'),
        ),
      );
      return;
    }

    setState(() {
      widget.peliculas.add(
        Pelicula(
          titulo: tituloController.text.trim(),
          anio: anio,
          director: directorController.text.trim(),
          genero: generoController.text.trim(),
          sinopsis: sinopsisController.text.trim(),
          imagen: imagenController.text.trim(),
        ),
      );
    });

    tituloController.clear();
    anioController.clear();
    directorController.clear();
    generoController.clear();
    sinopsisController.clear();
    imagenController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Película agregada correctamente'),
      ),
    );
  }

  void eliminarPelicula(int index) {
    final nombre = widget.peliculas[index].titulo;

    setState(() {
      widget.peliculas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nombre fue eliminada'),
      ),
    );
  }

  Widget campoTexto(
    String etiqueta,
    TextEditingController controller, {
    int maxLineas = 1,
    TextInputType tipo = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLineas,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: const Color(0xFF252545),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tituloController.dispose();
    anioController.dispose();
    directorController.dispose();
    generoController.dispose();
    sinopsisController.dispose();
    imagenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar películas'),
        backgroundColor: const Color(0xFF252545),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agregar nueva película',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            campoTexto('Título', tituloController),

            campoTexto(
              'Año de estreno',
              anioController,
              tipo: TextInputType.number,
            ),

            campoTexto('Director', directorController),

            campoTexto('Género', generoController),

            campoTexto(
              'Sinopsis',
              sinopsisController,
              maxLineas: 4,
            ),

            campoTexto(
              'URL de la imagen',
              imagenController,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: agregarPelicula,
                icon: const Icon(Icons.add),
                label: const Text('Agregar película'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ),

            const SizedBox(height: 35),

            const Text(
              'Películas registradas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (widget.peliculas.isEmpty)
              const Text('No hay películas registradas'),

            ...widget.peliculas.asMap().entries.map((entry) {
              final index = entry.key;
              final pelicula = entry.value;

              return Card(
                color: const Color(0xFF252545),
                child: ListTile(
                  title: Text(pelicula.titulo),
                  subtitle: Text('${pelicula.anio}'),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => eliminarPelicula(index),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
