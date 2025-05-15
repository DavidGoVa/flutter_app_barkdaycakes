// stripe_payment.dart
import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:barkdaycakes_app/services/payments/payment_provider.dart';

class StripePayment implements PaymentProvider {
  static const String _stripeSecretKey =
      "sk_test_51ROlKhDI84DN79IOBz4SryXkmnYszgEeb4hZY42ZK3EgPPrA54kGNPU6XzHliyEMBRwVxsYoSGgIvFRaPKuB4RqN00Evat4R28";
  static const String _stripePublishableKey =
      "pk_test_51ROlKhDI84DN79IOIbeviXw4hoth5bmmgiBoc9QHASdFQ7gSaKjf4bFLOUdjywYWzPvM7PUML9RWp69AdUa4Mw8D00Jj424JzW";

  @override
  Future<void> initialize() async {
    Stripe.publishableKey = _stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  @override
  Future<bool> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // 1. Crear PaymentIntent en tu backend
      final paymentIntent = await _createPaymentIntent(amount, currency);

      // 2. Confirmar pago en el cliente
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Barkday Cakes',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      print("Error en Stripe: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
    double amount,
    String currency,
  ) async {
    final response = await http.post(
      Uri.parse(
        'https://darkorchid-lobster-599265.hostingersite.com/API/stripe/create-payment-intent.php',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_stripeSecretKey',
      },
      body: json.encode({
        'amount': (amount * 100).toInt(), // Stripe usa centavos
        'currency': currency.toLowerCase(),
      }),
    );

    return json.decode(response.body);
  }

  @override
  Future<bool> confirmPayment(String paymentIntentId) async {
    // Lógica para confirmar pagos diferidos (opcional)
    return true;
  }
}
