import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer, // Un tono suave del primario
      child: Text(
        "Hola Mundo",
        style: TextStyle(
          color: Theme.of(
            context,
          ).colorScheme.onPrimaryContainer, // El texto que contrasta
        ),
      ),
    );
  }
}
