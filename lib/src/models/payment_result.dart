import 'package:bank_alfalah_payment/src/models/payment_response.dart';

enum PaymentStatus {
  success,
  failed,
  cancelled,
  unknown,
}

class PaymentResult {
  /// Status of the payment
  final PaymentStatus status;

  /// Response from Bank Alfalah
  final PaymentResponse? response;

  /// Error message if any
  final String? errorMessage;

  PaymentResult({
    required this.status,
    this.response,
    this.errorMessage,
  });

  factory PaymentResult.success(PaymentResponse response) {
    return PaymentResult(
      status: PaymentStatus.success,
      response: response,
    );
  }

  factory PaymentResult.failed(PaymentResponse response) {
    return PaymentResult(
      status: PaymentStatus.failed,
      response: response,
    );
  }

  factory PaymentResult.cancelled() {
    return PaymentResult(
      status: PaymentStatus.cancelled,
    );
  }

  factory PaymentResult.error(String message) {
    return PaymentResult(
      status: PaymentStatus.unknown,
      errorMessage: message,
    );
  }

  bool get isSuccess => status == PaymentStatus.success;
}
