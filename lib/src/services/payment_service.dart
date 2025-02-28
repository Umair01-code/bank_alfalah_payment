import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/payment_config.dart';
import '../models/payment_request.dart';
import '../models/payment_response.dart';
import '../models/payment_result.dart';
import '../ui/payment_screen.dart';
import '../utils/constant.dart';
import 'hash_service.dart';

class BankAlfalahPaymentService {
  final BankAlfalahConfig _config;
  final HashService _hashService;

  BankAlfalahPaymentService({
    required BankAlfalahConfig config,
  })  : _config = config,
        _hashService = HashService(
          firstKey: config.firstKey,
          secondKey: config.secondKey,
        );

  /// Initiates the payment process
  ///
  /// [request] Payment request details
  /// [context] BuildContext for showing the payment screen
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

      // Generate hash for the request
      final requestHash = _hashService.generateHash(data);
      data[BankAlfalahConstants.requestHashKey] = requestHash;

      // Make the initial API call
      final response = await http.post(
        Uri.parse(
            '${BankAlfalahConstants.paymentBaseUrl}${BankAlfalahConstants.paymentEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      // Check for HTTP errors
      if (response.statusCode != 200) {
        if (_config.debugMode) {
          print('HTTP Error: ${response.statusCode}, ${response.body}');
        }
        return PaymentResult.error('HTTP Error: ${response.statusCode}');
      }

      // Parse response
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Check for API errors
      if (responseData['success'] != 'true' &&
          responseData['success'] != true) {
        if (_config.debugMode) {
          print('API Error: ${responseData['message']}');
        }
        return PaymentResult.error(responseData['message'] ?? 'Unknown error');
      }

      // Show payment screen and wait for result
      final completer = Completer<PaymentResult>();

      // Prepare data for WebView
      final webViewData = {
        BankAlfalahConstants.authTokenKey: responseData['AuthToken'].toString(),
        BankAlfalahConstants.requestHashKey: '',
        BankAlfalahConstants.channelIdKey: _config.channelId,
        BankAlfalahConstants.currencyKey: BankAlfalahConstants.defaultCurrency,
        BankAlfalahConstants.isBinKey: BankAlfalahConstants.defaultIsBin,
        BankAlfalahConstants.returnUrlKey: _config.returnUrl,
        BankAlfalahConstants.merchantIdKey: _config.merchantId,
        BankAlfalahConstants.storeIdKey: _config.storeId,
        BankAlfalahConstants.merchantHashKey: _config.merchantHash,
        BankAlfalahConstants.merchantUsernameKey: _config.merchantUsername,
        BankAlfalahConstants.merchantPasswordKey: _config.merchantPassword,
        BankAlfalahConstants.transactionTypeIdKey:
            BankAlfalahConstants.defaultTransactionTypeId,
        BankAlfalahConstants.transactionReferenceNumberKey: transactionRefNo,
        BankAlfalahConstants.transactionAmountKey: request.amount,
      };

      // Generate hash for WebView data
      final webViewHash = _hashService.generateHash(webViewData);
      webViewData[BankAlfalahConstants.requestHashKey] = webViewHash;

      // Show payment screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            data: webViewData,
            baseUrl: BankAlfalahConstants.paymentBaseUrl,
            onResult: (result) {
              completer.complete(result);
              Navigator.of(context).pop();
            },
            debugMode: _config.debugMode,
          ),
        ),
      );

      return await completer.future;
    } catch (e) {
      if (_config.debugMode) {
        print('Exception: $e');
      }
      return PaymentResult.error('Payment initialization failed: $e');
    }
  }
}
