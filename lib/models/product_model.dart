class Producto {
  final String id;
  final String nombre;
  final String precio;
  final String category;
  final String filter1;
  final String filter2;
  final String filter3;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.category,
    required this.filter1,
    required this.filter2,
    required this.filter3,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['ingredient_id'] ?? '',
      nombre: json['ingredient_name'] ?? '',
      precio: json['ingredient_price'] ?? '',
      category: json['category'] ?? '',
      filter1: json['filter1'] ?? '',
      filter2: json['filter2'] ?? '',
      filter3: json['filter3'] ?? '',
    );
  }
}
