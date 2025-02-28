import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/payment_config.dart';
import '../models/payment_request.dart';
import '../models/payment_result.dart';
import '../ui/payment_screen.dart';
import '../utils/constant.dart';
import 'hash_service.dart';

/// Service for handling Bank Alfalah payment operations.
///
/// This service manages the entire payment lifecycle, from initialization
/// to processing the final response from the payment gateway.
class BankAlfalahPaymentService {
  final BankAlfalahConfig _config;
  final HashService _hashService;

  /// Creates a new payment service with the provided configuration.
  ///
  /// [config] contains all the necessary credentials and settings for
  /// connecting to Bank Alfalah's payment gateway.
  BankAlfalahPaymentService({
    required BankAlfalahConfig config,
  })  : _config = config,
        _hashService = HashService(
          firstKey: config.firstKey,
          secondKey: config.secondKey,
        );

  /// Initiates the payment process.
  ///
  /// [request] contains the payment details such as amount and order ID.
  /// [context] is required to show the payment WebView screen.
  ///
  /// Returns a [PaymentResult] indicating the outcome of the payment process.
  Future<PaymentResult> initiatePayment({
    required PaymentRequest request,
    required BuildContext context,
  }) async {
    try {
      // Generate a unique transaction reference number
      final uuid = Uuid();
      final transactionRefNo = uuid.v4();

      // Prepare initial request data
      final Map<String, dynamic> data = {
        BankAlfalahConstants.channelIdKey: _config.channelId,
        BankAlfalahConstants.isRedirectionRequestKey:
            BankAlfalahConstants.defaultIsRedirectionRequest,
        BankAlfalahConstants.merchantHashKey: _config.merchantHash,
        BankAlfalahConstants.merchantIdKey: _config.merchantId,
        BankAlfalahConstants.merchantPasswordKey: _config.merchantPassword,
        BankAlfalahConstants.merchantUsernameKey: _config.merchantUsername,
        BankAlfalahConstants.returnUrlKey: _config.returnUrl,
        BankAlfalahConstants.storeIdKey: _config.storeId,
        BankAlfalahConstants.transactionReferenceNumberKey: transactionRefNo,
        BankAlfalahConstants.requestVerificationTokenKey: '',
      };

      // Add request hash
      final requestHash = _hashService.generateHash(data);
      data[BankAlfalahConstants.requestHashKey] = requestHash;

      if (_config.debugMode) {
        print('Bank Alfalah Payment - Request Data: $data');
      }

      // Show payment screen
      final completer = Completer<PaymentResult>();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            data: data,
            baseUrl: BankAlfalahConstants.paymentBaseUrl,
            onResult: (result) {
              Navigator.pop(context);
              completer.complete(result);
            },
          ),
        ),
      );

      return completer.future;
    } catch (e, stackTrace) {
      if (_config.debugMode) {
        print('Bank Alfalah Payment - Error: $e');
        print('Stack trace: $stackTrace');
      }
      return PaymentResult.error(
          'An unexpected error occurred: ${e.toString()}');
    }
  }
}
