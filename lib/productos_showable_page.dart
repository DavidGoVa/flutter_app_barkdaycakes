import 'package:barkdaycakes_app/carrito_page.dart';
import 'package:barkdaycakes_app/producto_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';

class ProductosShowablePage extends StatelessWidget {
  final String nombreCategoria;
  final String filter1;
  final String filter2;
  final String filter3;

  ProductosShowablePage({
    required this.nombreCategoria,
    required this.filter1,
    required this.filter2,
    required this.filter3,
  });

  @override
  Widget build(BuildContext context) {
    final productosProvider = Provider.of<ProductosProvider>(context);
    final productos = productosProvider.productos;

    // Filtrar productos de esta categoría
    final productosresultantes =
        productos
            .where(
              (p) =>
                  p.category.toLowerCase() == nombreCategoria.toLowerCase() &&
                  p.filter1.toLowerCase() == filter1.toLowerCase() &&
                  p.filter2.toLowerCase() == filter2.toLowerCase() &&
                  p.filter3.toLowerCase() == filter3.toLowerCase(),
            )
            .toList();

    return Scaffold(
      backgroundColor: Color(0xFFF6AAAE),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6AAAE),
        elevation: 0,
        title: Text('Productos', style: TextStyle(color: Colors.white)),
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
              ...productosresultantes.map(
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
            ],
          ),
        ),
      ),
    );
  }
}
