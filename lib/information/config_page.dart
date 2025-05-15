import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuración')),
      body: Center(
        child: Text('Página de Configuración', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
