import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Center(
        child: Text('Bienvenido a tu Perfil', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
