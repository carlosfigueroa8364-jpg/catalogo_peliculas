
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_peliculas/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente',
      (WidgetTester tester) async {

    await tester.pumpWidget(const MiAplicacion());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
