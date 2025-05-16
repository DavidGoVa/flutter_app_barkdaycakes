/*LIBRERIAS A OCUPAR*/
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre Nosotros'),
        backgroundColor: Color(0xFFF6AAAE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'public/img/barkdaycakeslogo.png',
                  height: 120,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'En Barkday Cakes nos dedicamos a consentir a tus peludos en sus momentos más especiales. '
                'Creemos que cada mascota merece celebrar su cumpleaños, adopción o cualquier ocasión importante '
                'con un pastel hecho especialmente para ellos.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                '👩‍⚕Con nosotros quédate tranquila porque nos  avala una  maestría internacional'
                'en nutrición veterinaria para animales de compañía. Y postgrado en nutrición clínica.'
                'Todo lo q usamos está pensado para q los nutra y no les caiga pesado . Las recetas están'
                'balanceadas en nutrientes. No utilizamos nada de harinas,  de lácteos,  polllo, grasas'
                ' o azúcares  añadidas , ni sal o conservadores. '
                'El betún es también a base de agua y verdura  sin grasa  ni azúcar ',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Síguenos en Instagram para ver fotos y videos adorables de nuestros clientes felices: '
                '@barkday_cakes 🐶🎉',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(
                      'https://www.instagram.com/barkday_cakes/',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      throw 'No se pudo abrir $url';
                    }
                  },

                  icon: Icon(Icons.pets),
                  label: Text('Visítanos en Instagram'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
