class PaymentRequest {
  /// Amount to be charged
  final String amount;

  /// Order ID or any unique identifier for this transaction
  final String? orderId;

  /// Customer name (optional)
  final String? customerName;

  /// Customer email (optional)
  final String? customerEmail;

  /// Customer phone (optional)
  final String? customerPhone;

  /// Any additional data to be passed (optional)
  final Map<String, dynamic>? additionalData;

  PaymentRequest({
    required this.amount,
    this.orderId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.additionalData,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      if (orderId != null) 'orderId': orderId,
      if (customerName != null) 'customerName': customerName,
      if (customerEmail != null) 'customerEmail': customerEmail,
      if (customerPhone != null) 'customerPhone': customerPhone,
      if (additionalData != null) ...additionalData!,
    };
  }
}
