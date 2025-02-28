# Bank Alfalah Payment Package for Flutter

A Flutter package that simplifies the integration of Bank Alfalah's payment gateway into Flutter applications. This package handles the entire payment flow, from initialization to processing the final response.


## Features
- Simple API for payment initialization
- Secure hash generation for request authentication
- WebView management for payment flow
- Comprehensive callback system for payment results
- Error handling with descriptive messages
- Timeout handling for payment requests

## Getting Started


### Installation

Add this to your package's `pubspec.yaml` file:
`dependencies:
  bank_alfalah_payment: ^0.0.1`

### Prerequisites

Before using this package, you need to obtain the following credentials from Bank Alfalah:
- Merchant ID
- Merchant Password
- Merchant Username
- Merchant Hash
- Store ID
- First Key (for hash generation)
- Second Key (for hash generation)
- Return URL
  
Contact Bank Alfalah's support team to obtain these credentials for your application.


## Usage

### Basic Implementation

```dart
import 'package:bank_alfalah_payment/bank_alfalah_payment.dart';
import 'package:flutter/material.dart';

// Initialize the payment service
final paymentService = BankAlfalahPaymentService(
  config: BankAlfalahConfig(
    merchantId: 'YOUR_MERCHANT_ID',
    merchantPassword: 'YOUR_MERCHANT_PASSWORD',
    merchantUsername: 'YOUR_MERCHANT_USERNAME',
    merchantHash: 'YOUR_MERCHANT_HASH',
    storeId: 'YOUR_STORE_ID',
    returnUrl: 'YOUR_RETURN_URL',
    firstKey: 'YOUR_FIRST_KEY',
    secondKey: 'YOUR_SECOND_KEY',
    debugMode: true, // Set to false in production
  ),
);

// Create a payment request
final request = PaymentRequest(
  amount: '1000.00', // Amount in PKR
  orderId: 'ORDER-123', // Your unique order ID
  customerName: 'John Doe', // Optional
  customerEmail: 'john@example.com', // Optional
  customerPhone: '03001234567', // Optional
);

// Initiate payment
final result = await paymentService.initiatePayment(
  request: request,
  context: context,
);

// Handle the result
if (result.isSuccess) {
  print('Payment successful!');
  print('Transaction Reference: ${result.response?.transactionReferenceNumber}');
} else {
  print('Payment failed: ${result.errorMessage}');
}
```

### Complete Example

Here's a complete example showing how to implement the payment flow in a Flutter application:

```dart
import 'package:flutter/material.dart';
import 'package:bank_alfalah_payment/bank_alfalah_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Alfalah Payment Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController();
  String _paymentResult = '';

  // Create payment service instance
  late final BankAlfalahPaymentService _paymentService;

  @override
  void initState() {
    super.initState();

    // Initialize payment service with configuration
    _paymentService = BankAlfalahPaymentService(
      config: BankAlfalahConfig(
        merchantId: 'YOUR_MERCHANT_ID',
        merchantPassword: 'YOUR_MERCHANT_PASSWORD',
        merchantUsername: 'YOUR_MERCHANT_USERNAME',
        merchantHash: 'YOUR_MERCHANT_HASH',
        storeId: 'YOUR_STORE_ID',
        returnUrl: 'YOUR_RETURN_URL',
        firstKey: 'YOUR_FIRST_KEY',
        secondKey: 'YOUR_SECOND_KEY',
        debugMode: true,
      ),
    );
  }

  Future<void> _initiatePayment() async {
    if (_amountController.text.isEmpty) {
      setState(() {
        _paymentResult = 'Please enter an amount';
      });
      return;
    }

    final amount = _amountController.text;

    // Create payment request
    final request = PaymentRequest(
      amount: amount,
      orderId: 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
    );

    // Initiate payment
    final result = await _paymentService.initiatePayment(
      request: request,
      context: context,
    );

    // Handle result
    setState(() {
      if (result.isSuccess) {
        _paymentResult = 'Payment Successful!';
      } else {
        _paymentResult =
            'Payment Failed: ${result.errorMessage ?? result.response?.message ?? 'Unknown error'}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Alfalah Payment Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount in PKR',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initiatePayment,
              child: const Text('Pay Now'),
            ),
            const SizedBox(height: 20),
            if (_paymentResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                color: _paymentResult.contains('Successful')
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: Text(_paymentResult),
              ),
          ],
        ),
      ),
    );
  }
}
```

## Advanced Usage

### Handling Payment Results


The `initiatePayment` method returns a `PaymentResult` object that contains information about the payment outcome:
```dart
final result = await paymentService.initiatePayment(
  request: request,
  context: context,
);

switch (result.status) {
  case PaymentStatus.success:
    // Payment was successful
    print('Payment successful!');
    print('Transaction Reference: ${result.response?.transactionReferenceNumber}');
    break;
  case PaymentStatus.failed:
    // Payment failed
    print('Payment failed: ${result.response?.message}');
    break;
  case PaymentStatus.cancelled:
    // User cancelled the payment
    print('Payment was cancelled by the user');
    break;
  case PaymentStatus.unknown:
    // An error occurred
    print('An error occurred: ${result.errorMessage}');
    break;
}```


### Additional Request Parameters

You can pass additional parameters to the payment gateway using the `additionalData` field:
final request = PaymentRequest(
  amount: '1000.00',
  orderId: 'ORDER-123',
  additionalData: {
    'custom_field1': 'value1',
    'custom_field2': 'value2',
  },
);

### Debug Mode

Enable debug mode in the configuration to see detailed logs:

When debug mode is enabled, the package will print detailed logs about:
- Request data sent to Bank Alfalah
- WebView navigation events
- Error messages and stack traces


## Troubleshooting

### Common Issues


### 1.Hash Generation Errors:
    - Ensure that the first and second keys provided by Bank Alfalah are correct.
    - Check that you're using the correct merchant credentials.
### 2. WebView Navigation Issues:
    - Make sure your return URL is properly configured and accessible.
    - Verify that the device has internet connectivity.
### 3. Payment Failures:
    - Check the response message for details about why the payment failed.
    - Verify that the amount is in the correct format (e.g., '1000.00').
### 4. Timeout Errors:
    - The payment process will timeout after 3 minutes if no response is received.
    - Check your internet connection and try again.
## Testing
It's recommended to test the integration thoroughly before going to production:
- Use test credentials provided by Bank Alfalah for development.
- Test various payment scenarios (success, failure, cancellation).
- Test with different amount values and order IDs.


## API Reference

### BankAlfalahConfig

Configuration for Bank Alfalah payment gateway.

BankAlfalahConfig({
  required String merchantId,
  required String merchantPassword,
  required String merchantUsername,
  required String merchantHash,
  required String storeId,
  required String returnUrl,
  required String firstKey,
  required String secondKey,
  String channelId = '1001',
  bool debugMode = false,
})

### PaymentRequest

Request model for initiating a payment.
```dart
PaymentRequest({
  required String amount,
  String? orderId,
  String? customerName,
  String? customerEmail,
  String? customerPhone,
  Map<String, dynamic>? additionalData,
})
```

### PaymentResult

Result of a payment operation.
```dart
// Success result
PaymentResult.success(PaymentResponse response)

// Failed result
PaymentResult.failed(PaymentResponse response)

// Cancelled result
PaymentResult.cancelled()

// Error result
PaymentResult.error(String message)
```


