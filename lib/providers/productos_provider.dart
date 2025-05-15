import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductosProvider with ChangeNotifier {
  List<Producto> _productos = [];

  List<Producto> get productos => _productos;

  Future<void> cargarProductos() async {
    _productos = await ApiService.fetchProductos();
    notifyListeners();
  }
}
