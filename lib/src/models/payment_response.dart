class PaymentResponse {
  /// Whether the payment was successful
  final bool success;

  /// Response code from Bank Alfalah
  final String? responseCode;

  /// Transaction reference number
  final String? transactionReferenceNumber;

  /// Response message
  final String? message;

  /// Raw response data
  final Map<String, dynamic>? responseData;

  PaymentResponse({
    required this.success,
    this.responseCode,
    this.transactionReferenceNumber,
    this.message,
    this.responseData,
  });

  factory PaymentResponse.fromMap(Map<String, dynamic> map) {
    return PaymentResponse(
      success: map['success'] == 'true' || map['success'] == true,
      responseCode: map['responseCode']?.toString(),
      transactionReferenceNumber: map['transactionReferenceNumber']?.toString(),
      message: map['message']?.toString(),
      responseData: map,
    );
  }

  factory PaymentResponse.error(String message) {
    return PaymentResponse(
      success: false,
      message: message,
    );
  }
}
