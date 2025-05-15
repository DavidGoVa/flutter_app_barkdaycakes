import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  final String privacyText = '''
Aviso de Privacidad

En Barkday Cakes®, con domicilio en Calle Bahia de Sta. Barbara 116, Verónica Anzúres, Miguel Hidalgo, 11300 Ciudad de México, CDMX y en Av Sonora 147-Local - A, Hipódromo, Cuauhtémoc, 06100 Ciudad de México, CDMX, estamos comprometidos con la protección de sus datos personales, conforme a lo dispuesto en la Ley Federal de Protección de Datos Personales en Posesión de los Particulares.

Finalidad del tratamiento de datos:
Los datos personales que recabamos (como nombre, teléfono, correo electrónico y datos relacionados con su mascota) serán utilizados exclusivamente para:
- Confirmar pedidos y entregas.
- Enviar promociones y ofertas especiales.
- Brindar atención personalizada.
- Cumplir con obligaciones legales.

Uso de datos sensibles:
No recabamos ni tratamos datos personales sensibles.

Transferencia de datos:
No compartimos sus datos personales con terceros, salvo cuando sea necesario para cumplir con obligaciones legales o requerimientos de autoridades competentes.

Derechos ARCO:
Usted tiene derecho a acceder, rectificar, cancelar u oponerse (ARCO) al tratamiento de sus datos personales. Para ejercer estos derechos, puede comunicarse al correo: barkdaycake@gmail.com o al teléfono: +52 5540559333.

Cambios al aviso:
Nos reservamos el derecho de modificar este aviso de privacidad. Cualquier cambio será publicado en nuestra página web o directamente en nuestro establecimiento.

Fecha de última actualización: 07-05-2025
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aviso de Privacidad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            privacyText,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
