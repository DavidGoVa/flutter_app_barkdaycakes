import 'package:barkdaycakes_app/carrito_page.dart';
import 'package:barkdaycakes_app/filter1_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/productos_provider.dart';

class MenuPage extends StatelessWidget {
  final Map<String, String> categoryNames = {
    'pastel': 'Pasteles',
    'brownie': 'Brownies',
    'articulo': 'Artículos',
    'cupcake': 'Cupcakes',
    'paquete': 'Paquetes',
    'treat': 'Treats y Galletas',
  };

  // Orden deseado de las categorías
  final List<String> desiredOrder = [
    'pastel',
    'cupcake',
    'treat',
    'brownie',
    'paquete',
    'articulo',
  ];

  @override
  Widget build(BuildContext context) {
    final productosProvider = Provider.of<ProductosProvider>(context);
    final productos = productosProvider.productos;

    // Obtener categorías únicas
    final categorias = productos.map((p) => p.category).toSet().toList();

    // Ordenar según el orden deseado
    final orderedCategories =
        desiredOrder
            .where(
              (category) => categorias.any(
                (c) => c.toLowerCase() == category.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      backgroundColor: Color(0xFFF6AAAE),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6AAAE),
        elevation: 0,
        title: Text('Menú', style: TextStyle(color: Colors.white)),
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
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: orderedCategories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final categoria = orderedCategories[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Filter1Page(nombreCategoria: categoria),
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
                        'public/img/categories/${categoria.toLowerCase()}.png',
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
                      categoryNames[categoria.toLowerCase()] ?? categoria,
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
    );
  }
}
