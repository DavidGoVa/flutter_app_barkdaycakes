import 'package:barkdaycakes_app/carrito_page.dart';
import 'package:barkdaycakes_app/productos_showable_page.dart';
import 'package:barkdaycakes_app/producto_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';

class Filter3Page extends StatelessWidget {
  final String nombreCategoria;
  final String filter1;
  final String filter2;

  Filter3Page({
    required this.nombreCategoria,
    required this.filter1,
    required this.filter2,
  });

  final Map<String, String> filter3Names = {
    'ch': 'Chico',
    'g': 'Grande',
    'huella': 'Huella',
    'hueso': 'Hueso',
    'm': 'Mediano',
    'mi': 'Mini',
    'redondo': 'Redondo',
    'xch': 'Extra chico',
    'xg': 'Extra grande',
    'xxch': 'Extra extra chico',
  };

  final Map<String, String> filter3Images = {
    'ch': 'public/img/filter3/chico.png', // Ícono de tamaño pequeño
    'g': 'public/img/filter3/grande.png', // Ícono de tamaño grande
    'huella': 'public/img/filter3/huella.png', // Imagen de huella de perro
    'hueso': 'public/img/filter3/hueso.png', // Imagen de hueso para perro
    'm': 'public/img/filter3/mediano.png', // Ícono de tamaño mediano
    'mi': 'public/img/filter3/mini.png', // Ícono de tamaño mini
    'redondo': 'public/img/filter3/redondo.png', // Forma circular
    'xch': 'public/img/filter3/xchico.png', // Ícono tamaño extra chico
    'xg': 'public/img/filter3/xgrande.png', // Ícono tamaño extra grande
    'xxch': 'public/img/filter3/xxchico.png', // Ícono tamaño extra extra chico
  };

  // Orden deseado de las categorías
  final List<String> desiredOrder = [
    /*forma pastel*/
    'hueso',
    'huella',
    'redondo',
    /*tamaño bandana y gorito*/
    'xxch',
    'xch',
    'mi',
    'ch',
    'm',
    'g',
    'xg',
  ];

  @override
  Widget build(BuildContext context) {
    final productosProvider = Provider.of<ProductosProvider>(context);
    final productos = productosProvider.productos;

    // Filtrar productos de esta categoría
    final productosDeCategoriaFilter3 =
        productos
            .where(
              (p) =>
                  p.category.toLowerCase() == nombreCategoria.toLowerCase() &&
                  p.filter1.toLowerCase() == filter1.toLowerCase() &&
                  p.filter2.toLowerCase() == filter2.toLowerCase(),
            )
            .toList();

    // Filtrar productos sin filter1 (productos que se mostrarán directamente)
    final productosSinFilter3 =
        productosDeCategoriaFilter3
            .where((p) => p.filter3.trim().isEmpty)
            .toList();

    // Obtener filter1 únicos (para los botones)
    final filter3s =
        productosDeCategoriaFilter3
            .where((p) => p.filter3.trim().isNotEmpty)
            .map((p) => p.filter3)
            .toSet()
            .toList();

    filter3s.sort((a, b) {
      final indexA = desiredOrder.indexOf(a.toLowerCase());
      final indexB = desiredOrder.indexOf(b.toLowerCase());
      return (indexA == -1 ? 999 : indexA).compareTo(
        indexB == -1 ? 999 : indexB,
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFFF6AAAE),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6AAAE),
        elevation: 0,
        title: Text('Filtro 3', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Navegar a la página del carrito
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarritoPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Productos individuales sin filter1
              ...productosSinFilter3.map(
                (producto) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProductoDetallePage(idProducto: producto),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(producto.nombre),
                      subtitle: Text('\$${producto.precio}'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),

              // Botones por filter1
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filter3s.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final filter3 = filter3s[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ProductosShowablePage(
                                nombreCategoria: nombreCategoria,
                                filter1: filter1,
                                filter2: filter2,
                                filter3: filter3,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.asset(
                                filter3Images[filter3.toLowerCase()] ??
                                    'public/img/default.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(Icons.broken_image, size: 50),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              filter3Names[filter3.toLowerCase()] ?? filter3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
