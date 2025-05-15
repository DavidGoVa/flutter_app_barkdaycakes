import 'package:barkdaycakes_app/carrito_page.dart';
import 'package:barkdaycakes_app/filter2_page.dart';
import 'package:barkdaycakes_app/producto_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';

class Filter1Page extends StatelessWidget {
  final String nombreCategoria;

  Filter1Page({required this.nombreCategoria});

  final Map<String, String> filter1Names = {
    'bandana': 'Bandanas',
    'globo': 'Globos',
    'gorrito': 'Gorritos de fiesta',
    'hidrolizado': 'Hidrolizado',
    'higado avena': 'Hígado avena',
    'hogar': 'Hogar',
    'juguete': 'Juguetes',
    'letrero': 'Decoración de fiesta',
    'manzana zanahoria': 'Manzana zanahoria con crema de cacahuate',
    'meatloaf': 'Meatloaf veggies',
    'otro': 'Otros',
    'pastel cupcake': 'Pastel de cupcakes',
    'pavo betabel': 'Pavo con betabel',
    'platano': 'Plátano con crema de cacahuate',
    'salmon atun': 'Salmón atún',
    'temporada': 'De temporada',
    'tocino camote': 'Tocino con camote',
    'vestimenta': 'Clothing',
  };

  final Map<String, String> filter1Images = {
    'bandana': 'public/img/filter1/bandana.jpeg',
    'globo': 'public/img/filter1/globo.jpeg',
    'gorrito': 'public/img/filter1/gorrito.jpeg',
    'hidrolizado': 'public/img/filter1/hidrolizado.png',
    /*pendiente*/
    'higado avena': 'public/img/filter1/higadoavena.png',
    'hogar': 'public/img/filter1/hogar.png',
    /*pendiente*/
    'juguete': 'public/img/filter1/juguete.png',
    /*pendiente*/
    'letrero': 'public/img/filter1/letrero.png',
    /*pendiente*/
    'manzana zanahoria': 'public/img/filter1/manzanazanahoria.png',
    /*pendiente*/
    'meatloaf': 'public/img/filter1/meatloaf.png',
    'otro': 'public/img/filter1/otro.png' /*pendiente*/,
    'pastel cupcake': 'public/img/filter1/pastelcupcake.png',
    /*pendiente*/
    'pavo betabel': 'public/img/filter1/pavobetabel.png',
    /*pendiente*/
    'platano': 'public/img/filter1/platano.png',
    /*pendiente*/
    'salmon atun': 'public/img/filter1/salmonatun.png',
    /*pendiente*/
    'temporada': 'public/img/filter1/temporada.png',
    /*pendiente*/
    'tocino camote': 'public/img/filter1/tocinocamote.png',
    'vestimenta': 'public/img/filter1/vestimenta.jpg' /*pendiente*/,
  };

  // Orden deseado de las categorías
  final List<String> desiredOrder = [
    /*articulo*/
    'bandana',
    'gorrito',
    'juguete',
    'globo',
    'letrero',
    'hogar',
    'vestimenta',
    /*pastel*/
    'meatloaf',
    'tocino camote',
    'pavo betabel',
    'salmon atun',
    'higado avena',
    'hidrolizado',
    'pastel cupcake',
    'platano',
    'manzana zanahoria',
    'temporada',
    'otro',
  ];

  @override
  Widget build(BuildContext context) {
    final productosProvider = Provider.of<ProductosProvider>(context);
    final productos = productosProvider.productos;

    // Filtrar productos de esta categoría
    final productosDeCategoria =
        productos
            .where(
              (p) => p.category.toLowerCase() == nombreCategoria.toLowerCase(),
            )
            .toList();

    // Filtrar productos sin filter1 (productos que se mostrarán directamente)
    final productosSinFilter1 =
        productosDeCategoria.where((p) => p.filter1.trim().isEmpty).toList();

    // Obtener filter1 únicos (para los botones)
    final filter1s =
        productosDeCategoria
            .where((p) => p.filter1.trim().isNotEmpty)
            .map((p) => p.filter1)
            .toSet()
            .toList();

    filter1s.sort((a, b) {
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
        title: Text('Filtro 1', style: TextStyle(color: Colors.white)),
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
              ...productosSinFilter1.map(
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
                itemCount: filter1s.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final filter1 = filter1s[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => Filter2Page(
                                nombreCategoria: nombreCategoria,
                                filter1: filter1,
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
                                filter1Images[filter1.toLowerCase()] ??
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
                              filter1Names[filter1.toLowerCase()] ?? filter1,
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
