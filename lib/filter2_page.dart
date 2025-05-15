import 'package:barkdaycakes_app/carrito_page.dart';
import 'package:barkdaycakes_app/filter3_page.dart';
import 'package:barkdaycakes_app/producto_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';

class Filter2Page extends StatelessWidget {
  final String nombreCategoria;
  final String filter1;

  Filter2Page({required this.nombreCategoria, required this.filter1});

  final Map<String, String> filter2Names = {
    'chico': 'Chico',
    'globo': 'Globos',
    'especial': 'Especial',
    'gato': 'Para gato',
    'grande': 'Grande',
    'inflable': 'Inflables',
    'mediano': 'Mediano',
    'metalico': 'Cortinas metálicas',
    'micro': 'Micro',
    'mini': 'Mini',
    'perro': 'Para perro',
    'personalizable': 'Personalizable',
    'sencillo': 'Sencillo',
    'temporada': 'De temporada',
    'xg': 'Extra grande',
  };

  final Map<String, String> filter2Images = {
    'micro': 'public/img/filter2/micro.png',
    'mini': 'public/img/filter2/mini.png',
    'chico': 'public/img/filter2/chico.png',
    'mediano': 'public/img/filter2/mediano.png',
    'grande': 'public/img/filter2/grande.png',
    'xg': 'public/img/filter2/xg.png',
    'globo': 'public/img/filter2/globo.png',
    'especial': 'public/img/filter2/especial.png',
    'gato': 'public/img/filter2/gato.png',
    'inflable': 'public/img/filter2/inflable.png',
    'metalico': 'public/img/filter2/metalico.png',
    'perro': 'public/img/filter2/perro.png',
    'personalizable': 'public/img/filter2/personalizable.png',
    'sencillo': 'public/img/filter2/sencillo.png',
    'temporada': 'public/img/filter2/temporada.png',
  };

  // Orden deseado de las categorías
  final List<String> desiredOrder = [
    /*tamaños pastel*/
    'micro',
    'mini',
    'chico',
    'mediano',
    'grande',
    'xg',
    /*gorrito*/
    'sencillo',
    'especial',
    /*letrero*/
    'inflable',
    'metalico',
    'globo',
    /*bandana*/
    'perro',
    'gato',
    'personalizable',
    'temporada',
  ];

  @override
  Widget build(BuildContext context) {
    final productosProvider = Provider.of<ProductosProvider>(context);
    final productos = productosProvider.productos;

    // Filtrar productos de esta categoría
    final productosDeCategoriaFilter2 =
        productos
            .where(
              (p) =>
                  p.category.toLowerCase() == nombreCategoria.toLowerCase() &&
                  p.filter1.toLowerCase() == filter1.toLowerCase(),
            )
            .toList();

    // Filtrar productos sin filter1 (productos que se mostrarán directamente)
    final productosSinFilter2 =
        productosDeCategoriaFilter2
            .where((p) => p.filter2.trim().isEmpty)
            .toList();

    // Obtener filter1 únicos (para los botones)
    final filter2s =
        productosDeCategoriaFilter2
            .where((p) => p.filter2.trim().isNotEmpty)
            .map((p) => p.filter2)
            .toSet()
            .toList();

    filter2s.sort((a, b) {
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
        title: Text('Filtro 2', style: TextStyle(color: Colors.white)),
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
              ...productosSinFilter2.map(
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
                itemCount: filter2s.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final filter2 = filter2s[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => Filter3Page(
                                nombreCategoria: nombreCategoria,
                                filter1: filter1,
                                filter2: filter2,
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
                                filter2Images[filter2.toLowerCase()] ??
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
                              filter2Names[filter2.toLowerCase()] ?? filter2,
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
