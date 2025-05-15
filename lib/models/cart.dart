import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(
    String productName,
    int quantity,
    String id,
    double precio, { // <-- Añadido aquí
    Map<String, dynamic>? extraData,
  }) {
    final index = _items.indexWhere((item) => item['id'] == id);

    if (index >= 0) {
      _items[index]['cantidad'] = quantity;
      if (extraData != null) {
        _items[index]['extraData'] = extraData;
      }
    } else {
      _items.add({
        'nombre': productName,
        'cantidad': quantity,
        'id': id,
        'precio': precio, // <-- Guardar el precio
        'extraData': extraData ?? {},
      });
    }
    notifyListeners();
  }

  void removeItem(String productName) {
    _items.removeWhere((item) => item['nombre'] == productName);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item['cantidad'] * item['precio'];
    }

    return total;
  }
}
