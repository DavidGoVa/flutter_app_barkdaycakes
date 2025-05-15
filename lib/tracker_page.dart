import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackerPage extends StatefulWidget {
  final String? sellId;
  TrackerPage({this.sellId});
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  final _ticketController = TextEditingController();
  Map<String, dynamic>? _pedidoData;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.sellId != null && widget.sellId!.isNotEmpty) {
      _ticketController.text = widget.sellId!;
      _buscarPedido();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trackear orden"),
        backgroundColor: Color(0xFFF6AAAE),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("1. Introduce el número de tu ticket", style: sectionTitleStyle),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ticketController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Número de ticket",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading ? null : _buscarPedido,
            child: Text("Buscar pedido"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF6AAAE),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          if (_loading) Center(child: CircularProgressIndicator()),

          if (_error != null)
            Text(_error!, style: TextStyle(color: Colors.red)),

          if (_pedidoData != null) _construirResumenPedido(_pedidoData!),
        ],
      ),
    );
  }

  Future<void> _buscarPedido() async {
    final idPedido = _ticketController.text.trim();
    if (idPedido.isEmpty) {
      setState(() => _error = "Por favor ingresa un número de ticket válido.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _pedidoData = null;
    });

    try {
      final data = await _traerPedidoAPI(idPedido);
      setState(() => _pedidoData = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<Map<String, dynamic>> _traerPedidoAPI(String idPedido) async {
    final orderData = {"sell_id": idPedido};

    final response = await http.post(
      Uri.parse(
        'https://darkorchid-lobster-599265.hostingersite.com/API/traerOrdenTracker.php',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderData),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) {
        return {"detalles": decoded};
      } else {
        throw Exception("No se encontró el pedido.");
      }
    } else {
      throw Exception('Error del servidor: ${response.body}');
    }
  }

  Widget _construirResumenPedido(Map<String, dynamic> data) {
    final detalles = data["detalles"] as List<dynamic>;
    if (detalles.isEmpty) return Text("No hay productos en este pedido.");

    final pedido = detalles[0]; // Info general del pedido
    final productos = detalles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("2. Resumen del pedido", style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text("Sucursal: ${pedido['selled_at_branch']}"),
        Text("Hora de venta: ${pedido['selled_at_time']}"),
        Text("Método de pago: ${pedido['sell_payment']}"),
        Text("Total: \$${pedido['sell_amount']}"),
        Text("Estatus: ${pedido['sell_status']}"),
        const SizedBox(height: 16),
        Text("Productos:", style: sectionTitleStyle),
        const SizedBox(height: 8),
        ...productos.map(
          (item) => Card(
            child: ListTile(
              title: Text(item['ingredient_name']),
              subtitle: Text("Cantidad: ${item['selled_quantity']}"),
              trailing: Text(
                "\$${double.parse(item['selled_product_price'].toString()) * int.parse(item['selled_quantity'].toString())}",
              ),
            ),
          ),
        ),
        if (pedido["sell_note"] != null &&
            pedido["sell_note"].toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text("Nota: ${pedido["sell_note"]}"),
          ),
      ],
    );
  }

  TextStyle get sectionTitleStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blue[800],
  );

  @override
  void dispose() {
    _ticketController.dispose();
    super.dispose();
  }
}
