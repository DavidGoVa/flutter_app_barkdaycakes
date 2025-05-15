import 'package:barkdaycakes_app/carrito_page.dart';
import 'package:barkdaycakes_app/models/cart.dart';
import 'package:barkdaycakes_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductoDetallePage extends StatefulWidget {
  final Producto idProducto;
  ProductoDetallePage({required this.idProducto});

  @override
  State<ProductoDetallePage> createState() => _ProductoDetallePageState();
}

class _ProductoDetallePageState extends State<ProductoDetallePage> {
  late String filtro1;
  late String filtro2;
  late String filtro3;
  late int cantidad;
  late String metodoEntrega;
  late String sucursal;
  late double subtotal;

  String nombrePerro = '';
  String edadPerro = '';
  String? colorSeleccionado;
  String? modeloSeleccionado;

  final List<String> coloresDisponibles = [
    'Blanco',
    'Rosa',
    'Azul',
    'Lila',
    'Morado',
    'Cafe',
    'Amarillo',
    'Naranja',
    'Verde',
  ];

  final List<String> modelosDisponibles = [
    'PIA',
    'CARLOTA',
    'CLÁSICO',
    'VIDA',
    'CLASICO HUELLA',
    'KALA',
    'COAT',
    'PLAYBALL',
    'HUELLITAS 3D',
    'HUESITOS',
    'COAT CORAZÓN',
    'ROCKSTAR',
    'FIORE',
    'ROMUALDA',
    'ATTIRE',
    'NAKED',
  ];

  @override
  void initState() {
    super.initState();
    filtro1 = widget.idProducto.filter1;
    filtro2 = widget.idProducto.filter2;
    filtro3 = widget.idProducto.filter3;
    cantidad = 1;
    metodoEntrega = "Recoger en tienda";
    sucursal = "Anzures";
    subtotal = double.parse(widget.idProducto.precio) * cantidad;
  }

  bool get esPastel => widget.idProducto.category.toLowerCase() == 'pastel';

  void actualizarSubtotal() {
    setState(() {
      subtotal = double.parse(widget.idProducto.precio) * cantidad;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Revisa tu producto"),
        backgroundColor: Color(0xFFF6AAAE),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("1. CARACTERISTICAS", style: sectionTitleStyle),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  Center(
                    child: Text(
                      widget.idProducto.nombre,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filtros
                  if (filtro1.isNotEmpty) ...[
                    _buildInfoRow("Filtro 1", filtro1),
                    const Divider(),
                  ],
                  if (filtro2.isNotEmpty) ...[
                    _buildInfoRow("Filtro 2", filtro2),
                    const Divider(),
                  ],
                  if (filtro3.isNotEmpty) ...[
                    _buildInfoRow("Filtro 3", filtro3),
                  ],
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text("Cantidad", style: sectionTitleStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (cantidad > 1) {
                    setState(() {
                      cantidad--;
                      actualizarSubtotal();
                    });
                  }
                },
                icon: Icon(Icons.remove),
              ),
              Text('$cantidad', style: TextStyle(fontSize: 18)),
              IconButton(
                onPressed: () {
                  setState(() {
                    cantidad++;
                    actualizarSubtotal();
                  });
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              "Subtotal: \$${subtotal.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          if (esPastel) ...[
            const SizedBox(height: 20),
            Text("Información del cumpleañero 🐶", style: sectionTitleStyle),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: "Nombre del perrito",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => nombrePerro = val),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "¿Cuántos años cumple?",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => edadPerro = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Color del pastel",
                border: OutlineInputBorder(),
              ),
              value: colorSeleccionado,
              items:
                  coloresDisponibles
                      .map(
                        (color) =>
                            DropdownMenuItem(value: color, child: Text(color)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => colorSeleccionado = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Modelo del pastel",
                border: OutlineInputBorder(),
              ),
              value: modeloSeleccionado,
              items:
                  modelosDisponibles
                      .map(
                        (modelo) => DropdownMenuItem(
                          value: modelo,
                          child: Text(modelo),
                        ),
                      )
                      .toList(),
              onChanged: (val) => setState(() => modeloSeleccionado = val),
            ),
            const SizedBox(height: 16),

            // Mostrar imagen según modelo seleccionado
            if (modeloSeleccionado != null)
              Center(
                child: Image.asset(
                  'public/img/pastelmodels/${modeloSeleccionado!.toLowerCase().replaceAll(" ", "").replaceAll("á", "a").replaceAll("é", "e").replaceAll("í", "i").replaceAll("ó", "o").replaceAll("ú", "u")}.jpg',
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      'Imagen no disponible',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              ),
          ],

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (esPastel) {
                if (nombrePerro.isEmpty ||
                    edadPerro.isEmpty ||
                    colorSeleccionado == null ||
                    modeloSeleccionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Por favor, completa todos los datos del pastel 🎂',
                      ),
                    ),
                  );
                  return;
                }
              }

              Map<String, dynamic>? extraData;
              if (esPastel) {
                extraData = {
                  'nombrePerro': nombrePerro,
                  'edadPerro': edadPerro,
                  'color': colorSeleccionado,
                  'modelo': modeloSeleccionado,
                };
              }

              final cart = Provider.of<Cart>(context, listen: false);
              cart.addItem(
                widget.idProducto.nombre,
                cantidad,
                widget.idProducto.id,
                double.parse(widget.idProducto.precio),
                extraData: extraData,
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => CarritoPage()),
                ModalRoute.withName('/menu'),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "AGREGAR AL CARRITO",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get sectionTitleStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blue[800],
  );
}

Widget _buildInfoRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.label, color: Colors.green),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    ],
  );
}
