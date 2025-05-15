import 'dart:convert';
import 'package:http/http.dart';
import '../models/product_model.dart';

class ApiService {
  static const String url =
      'https://darkorchid-lobster-599265.hostingersite.com/API/traerProductosapp.php';

  static Future<List<Producto>> fetchProductos() async {
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }
}
