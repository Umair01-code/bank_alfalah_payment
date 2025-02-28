// File: lib/src/ui/payment_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/payment_response.dart';
import '../models/payment_result.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String baseUrl;
  final Function(PaymentResult) onResult;
  final bool debugMode;

  const PaymentScreen({
    Key? key,
    required this.data,
    required this.baseUrl,
    required this.onResult,
    this.debugMode = false,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (widget.debugMode) {
              print('Page started loading: $url');
            }
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            if (widget.debugMode) {
              print('Page finished loading: $url');
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (widget.debugMode) {
              print('Web resource error: ${error.description}');
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            // Check for success URL
            if (url.containsIgnoreCase(BankAlfalahConstants.successCode)) {
              // Handle success
              final response = PaymentResponse(
                success: true,
                responseCode: BankAlfalahConstants.successCode,
                message: 'Payment Successful',
              );
              widget.onResult(PaymentResult.success(response));
              return NavigationDecision.prevent;
            }
            // Check for failure URL
            else if (url.containsIgnoreCase(BankAlfalahConstants.failureCode)) {
              // Handle failure
              final response = PaymentResponse(
                success: false,
                responseCode: BankAlfalahConstants.failureCode,
                message: 'Payment Failed',
              );
              widget.onResult(PaymentResult.failed(response));
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    // Load HTML form to submit payment request
    _loadPaymentForm();
  }

  void _loadPaymentForm() {
    // Create HTML form with hidden inputs for all parameters
    final htmlInputs = widget.data.entries.map((entry) {
      return '<input id="${entry.key}" name="${entry.key}" type="hidden" value="${entry.value}">';
    }).join('\n');

    // Full HTML form with auto-submit
    final html = '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Payment</title>
        <script>
          document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('PaymentRedirectionForm').submit();
          });
        </script>
        <style>
          .loader {
            border: 8px solid #f3f3f3;
            border-radius: 50%;
            border-top: 8px solid #3498db;
            width: 60px;
            height: 60px;
            animation: spin 2s linear infinite; /* Safari */
            animation: spin 2s linear infinite;
          }
          
          @-webkit-keyframes spin {
            0% { -webkit-transform: rotate(0deg); }
            100% { -webkit-transform: rotate(360deg); }
          }
          
          @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
          }
        </style>
      </head>
      <body onload="document.getElementById('PaymentRedirectionForm').submit();">
        <div class="loader"></div>
        <form action="${widget.baseUrl}/SSO/SSO/SSO" id="PaymentRedirectionForm" method="post">
          $htmlInputs
          <div class="buttonDiv">
            <button type="submit" class="loader btn btn-custom-four btn-danger clsBtn" style="display: none;">
              Processing...
            </button>
          </div>
        </form>
      </body>
      </html>
    ''';

    // Load the HTML string into WebView
    _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onResult(PaymentResult.cancelled());
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
