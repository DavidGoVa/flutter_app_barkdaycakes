abstract class PaymentProvider {
  Future<bool> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  });

  Future<void> initialize();
  Future<bool> confirmPayment(String paymentIntentId);
}
