import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barkdaycakes_app/models/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart' as stripeF;

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String metodoEntrega = "Recoger en tienda";
  String sucursal = "Anzures";
  DateTime? fechaRecoleccion;
  String nombreCliente = '';
  String telefonoCliente = '';
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Finalizar Compra"),
        backgroundColor: Color(0xFFF6AAAE),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Resumen del pedido
            Text("1. RESUMEN DE TU PEDIDO", style: sectionTitleStyle),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    for (var item in cartItems)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${item['nombre']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ), // espacio entre nombre y cantidad
                            Text(
                              "x${item['cantidad']}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOTAL",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$${cart.totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.pink[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Método de entrega
            const SizedBox(height: 20),
            Text(
              "2. ¿CÓMO QUIERES RECIBIR TU PEDIDO?",
              style: sectionTitleStyle,
            ),
            DropdownButtonFormField<String>(
              value: metodoEntrega,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items:
                  ["Recoger en tienda", "Mandar paquetería"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (val) => setState(() => metodoEntrega = val!),
            ),

            // Sucursal (solo si es recoger en tienda)
            if (metodoEntrega == "Recoger en tienda") ...[
              const SizedBox(height: 20),
              Text("3. SELECCIONA SUCURSAL", style: sectionTitleStyle),
              DropdownButtonFormField<String>(
                value: sucursal,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items:
                    ["Anzures", "Condesa"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => sucursal = val!),
              ),
            ],

            // Fecha de recolección
            if (metodoEntrega == "Recoger en tienda") ...[
              const SizedBox(height: 20),
              Text("4. FECHA DE RECOLECCIÓN", style: sectionTitleStyle),
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      fechaRecoleccion = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fechaRecoleccion != null
                            ? "${fechaRecoleccion!.day}/${fechaRecoleccion!.month}/${fechaRecoleccion!.year}"
                            : "Selecciona una fecha",
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ],

            // Datos del cliente
            const SizedBox(height: 20),
            Text("5. DATOS DEL CLIENTE", style: sectionTitleStyle),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Nombre completo",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
              onSaved: (value) => nombreCliente = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Teléfono de contacto",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu teléfono';
                }
                if (value.length < 10) {
                  return 'El teléfono debe tener al menos 10 dígitos';
                }
                return null;
              },
              onSaved: (value) => telefonoCliente = value!,
            ),

            // Mapa de ubicación
            if (metodoEntrega == "Recoger en tienda") ...[
              const SizedBox(height: 20),
              Text("UBICACIÓN DE LA SUCURSAL", style: sectionTitleStyle),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      sucursal == "Anzures"
                          ? "https://maps.googleapis.com/maps/api/staticmap?center=Calle+Bahia+de+Sta.+Bárbara+116,CDMX&zoom=15&size=600x300&markers=color:red%7CCalle+Bahia+de+Sta.+Bárbara+116,CDMX"
                          : "https://maps.googleapis.com/maps/api/staticmap?center=Av.+Sonora+147,CDMX&zoom=15&size=600x300&markers=color:blue%7CAv.+Sonora+147,CDMX",
                    ),
                  ),
                ),
              ),
            ],

            // Botón de pago
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : () => _procesarPago(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "PAGAR (Stripe)",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _procesarPago(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (metodoEntrega == "Recoger en tienda" && fechaRecoleccion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor selecciona una fecha de recolección'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1. Crear el PaymentIntent en tu backend
      final paymentIntent = await _crearPaymentIntent(context);
      final clientSecret = paymentIntent['client_secret'];

      if (clientSecret == null) {
        throw Exception('No se pudo obtener el client_secret de Stripe');
      }

      // 2. Iniciar el flujo de pago con Stripe
      await stripeF.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripeF.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Barkday Cakes',
        ),
      );

      // 3. Mostrar el PaymentSheet
      await stripeF.Stripe.instance.presentPaymentSheet();

      // 4. Si el pago es exitoso, registrar la orden
      final orderResponse = await _registrarOrdenEnAPI(context);

      // 5. Confirmar al usuario y limpiar el carrito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pago exitoso. Orden registrada (#${orderResponse['order_id']})',
          ),
        ),
      );

      Provider.of<Cart>(context, listen: false).clearCart();
      Navigator.popUntil(context, ModalRoute.withName('/menu'));
    } on stripeF.StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pago cancelado o fallido: ${e.error.localizedMessage}',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _registrarOrdenEnAPI(
    BuildContext context,
  ) async {
    final cart = Provider.of<Cart>(context, listen: false);

    // Prepara la nota con los detalles de recolección
    String sellNote = "Método de entrega: $metodoEntrega\n";
    if (metodoEntrega == "Recoger en tienda") {
      sellNote += "Sucursal: $sucursal\n";
      sellNote +=
          "Fecha de recolección: ${fechaRecoleccion!.toLocal().toString()}";
    }

    // Prepara los items en el formato requerido
    List<Map<String, dynamic>> items =
        cart.items.map((item) {
          return {
            "identificador": item['id'],
            "cantidad": item['cantidad'],
            "precio": item['precio'],
          };
        }).toList();

    // Prepara los datos de la orden
    final orderData = {
      "sell_seller": "jgome329",
      "sell_status": "Ordenado",
      "sell_amount": cart.totalPrice.toString(),
      "selled_through": "app",
      "selled_to": 57,
      "selled_at_branch":
          sucursal == "Anzures"
              ? 3
              : 1, // Asume 3 para Anzures, ajusta según necesites
      "sell_note": sellNote,
      "order_due_date":
          metodoEntrega == "Recoger en tienda"
              ? fechaRecoleccion!.toIso8601String()
              : DateTime.now().add(Duration(days: 1)).toIso8601String(),
      "selled_at_time": DateTime.now().toIso8601String(),
      "is_order": "si",
      "selled_product": items,
    };

    // Envía la orden a tu API
    final response = await http.post(
      Uri.parse(
        'https://darkorchid-lobster-599265.hostingersite.com/API/registrarOrdenApp.php',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar la orden: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _crearPaymentIntent(BuildContext context) async {
    final cart = Provider.of<Cart>(context, listen: false);
    final url = Uri.parse(
      'https://darkorchid-lobster-599265.hostingersite.com/API/stripe/create-payment-intent.php',
    ); // Asegúrate de que esta URL sea pública

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': (cart.totalPrice * 100).toInt()}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear PaymentIntent: ${response.body}');
    }
  }

  TextStyle get sectionTitleStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blue[800],
  );
}
